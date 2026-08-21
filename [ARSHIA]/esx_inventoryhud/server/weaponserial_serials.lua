-- ============================================================
-- unique_weaponserial / server / serials.lua
--
-- Every weapon anyone ever receives through the normal ESX API
-- (xPlayer.addWeapon -- what every weapon shop / starter pack / admin
-- give command already calls) gets a unique serial minted for it here.
-- This file owns the DB table and the in-memory cache; server/main.lua
-- builds the inventory-item / equip-swap / drop layer on top of it.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.Async.execute([[
    CREATE TABLE IF NOT EXISTS `weapon_serials` (
        `serial` VARCHAR(12) NOT NULL,
        `weapon` VARCHAR(50) NOT NULL,
        `owner_identifier` VARCHAR(60) DEFAULT NULL,
        `registered_identifier` VARCHAR(60) DEFAULT NULL,
        `ammo` INT NOT NULL DEFAULT 0,
        `components` TEXT NOT NULL DEFAULT '[]',
        `status` VARCHAR(20) NOT NULL DEFAULT 'unowned',
        `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (`serial`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
]])

-- serial -> { weapon, owner_identifier, registered_identifier, ammo, components, status }
WeaponSerials = {}

CreateThread(function()
    Wait(500) -- give the CREATE TABLE above time to finish on a fresh DB
    local rows = MySQL.Sync.fetchAll('SELECT * FROM weapon_serials', {})
    for _, row in ipairs(rows or {}) do
        WeaponSerials[row.serial] = {
            weapon = row.weapon,
            owner_identifier = row.owner_identifier,
            registered_identifier = row.registered_identifier,
            ammo = row.ammo,
            components = json.decode(row.components or '[]') or {},
            status = row.status,
        }
    end
    print(('[unique_weaponserial] loaded %d known weapon serials'):format(#rows))
end)

local SERIAL_CHARS = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789' -- no 0/O/1/I, avoids confusion when read aloud/typed by police

local function GenerateSerial()
    local serial
    repeat
        local parts = {}
        for i = 1, 8 do
            local idx = math.random(1, #SERIAL_CHARS)
            parts[i] = SERIAL_CHARS:sub(idx, idx)
        end
        serial = table.concat(parts)
    until WeaponSerials[serial] == nil
    return serial
end

-- Creates a brand new serial for a weapon that's about to be handed to
-- identifier for the first time. legal=true tags identifier as the
-- weapon's permanent "registered_identifier" (who it was legally issued
-- to), which -- unlike owner_identifier -- never changes even if the
-- weapon later ends up with someone else.
function MintWeaponSerial(weaponName, identifier, ammo, components, legal)
    local serial = GenerateSerial()
    WeaponSerials[serial] = {
        weapon = weaponName,
        owner_identifier = identifier,
        registered_identifier = legal and identifier or nil,
        ammo = ammo or 0,
        components = components or {},
        status = 'unowned',
    }
    MySQL.Async.execute(
        'INSERT INTO weapon_serials (serial, weapon, owner_identifier, registered_identifier, ammo, components, status) VALUES (@serial, @weapon, @owner, @registered, @ammo, @components, @status)',
        {
            ['@serial'] = serial,
            ['@weapon'] = weaponName,
            ['@owner'] = identifier,
            ['@registered'] = legal and identifier or nil,
            ['@ammo'] = ammo or 0,
            ['@components'] = json.encode(components or {}),
            ['@status'] = 'unowned',
        }
    )
    return serial
end

function SaveWeaponSerial(serial)
    local data = WeaponSerials[serial]
    if not data then return end
    MySQL.Async.execute(
        'UPDATE weapon_serials SET owner_identifier = @owner, ammo = @ammo, components = @components, status = @status WHERE serial = @serial',
        {
            ['@serial'] = serial,
            ['@owner'] = data.owner_identifier,
            ['@ammo'] = data.ammo,
            ['@components'] = json.encode(data.components or {}),
            ['@status'] = data.status,
        }
    )
end

function GetWeaponSerial(serial)
    return WeaponSerials[serial]
end

-- ============================================================
-- The actual patch: every xPlayer gets its OWN addWeapon/removeWeapon
-- wrapped the moment it's created. essentialmode fires 'esx:playerLoaded'
-- as a plain server-side TriggerEvent carrying the live player object
-- (server/player/login.lua), so this runs once per player, before
-- anything else has a chance to call addWeapon on them.
-- ============================================================
-- ============================================================
-- essentialmode's OWN client loop re-sends the ENTIRE loadout array
-- (rebuilt from live ped state) any time ammo changes -- i.e. on
-- basically every shot fired -- and its server handler for
-- 'updateLoadout' does a wholesale 'Users[Source].set("loadout", ...)'
-- overwrite. That fresh array has no idea .serial fields exist, so
-- without this, every gunshot would silently erase which serial is
-- equipped. EquippedSerialCache is the durable source of truth this
-- resource keeps for "this player's currently equipped weapon of type
-- X is serial Y" -- both the addWeapon patch above and
-- server/main.lua's EquipWeaponSerial update it, and the handler below
-- re-applies it every time essentialmode's own handler has already run
-- (this resource is ensured after essentialmode, so registration -- and
-- therefore execution -- order is guaranteed).
-- ============================================================
EquippedSerialCache = {} -- identifier -> { [weaponName] = serial }

function SetEquippedSerial(identifier, weaponName, serial)
    EquippedSerialCache[identifier] = EquippedSerialCache[identifier] or {}
    EquippedSerialCache[identifier][weaponName] = serial
end

function ClearEquippedSerial(identifier, weaponName)
    if EquippedSerialCache[identifier] then
        EquippedSerialCache[identifier][weaponName] = nil
    end
end

AddEventHandler('updateLoadout', function(loadout)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    local cache = EquippedSerialCache[xPlayer.identifier]
    if not cache then return end

    for _, weapon in ipairs(xPlayer.loadout or {}) do
        local serial = cache[weapon.name]
        if serial then
            weapon.serial = serial
            if WeaponSerials[serial] then
                WeaponSerials[serial].ammo = weapon.ammo -- keep the live ammo count fresh in memory; persisted on the next real status change (equip/holster/drop)
            end
        end
    end
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    if not xPlayer or not xPlayer.addWeapon or xPlayer.__weaponSerialPatched then return end
    xPlayer.__weaponSerialPatched = true

    -- the player's loadout was just loaded from the DB and may already
    -- carry .serial fields from a previous session (they get persisted
    -- for free since essentialmode just json.encodes the whole loadout
    -- table on logout/save) -- seed the cache from them NOW, before the
    -- very first ammo-triggered updateLoadout sync has a chance to wipe
    -- them out again.
    for _, weapon in ipairs(xPlayer.loadout or {}) do
        if weapon.serial then
            SetEquippedSerial(xPlayer.identifier, weapon.name, weapon.serial)
            if WeaponSerials[weapon.serial] then
                WeaponSerials[weapon.serial].status = 'equipped'
                WeaponSerials[weapon.serial].owner_identifier = xPlayer.identifier
            end
        end
    end

    local originalAddWeapon = xPlayer.addWeapon
    local originalRemoveWeapon = xPlayer.removeWeapon

    -- exposed so server/main.lua's holster/equip-swap logic can call the
    -- REAL native give/remove without re-triggering serial minting/clearing
    xPlayer.__originalAddWeapon = originalAddWeapon
    xPlayer.__originalRemoveWeapon = originalRemoveWeapon

    xPlayer.addWeapon = function(weaponNamex, ammo)
        local weaponName = string.upper(weaponNamex)
        local alreadyEquipped = xPlayer.hasWeapon(weaponName)

        if not alreadyEquipped then
            -- same as vanilla: becomes the equipped weapon of this type
            originalAddWeapon(weaponName, ammo)
            local loadoutNum = xPlayer.getWeapon(weaponName)
            if loadoutNum then
                local serial = MintWeaponSerial(weaponName, xPlayer.identifier, ammo, {}, true)
                xPlayer.loadout[loadoutNum].serial = serial
                WeaponSerials[serial].status = 'equipped'
                SetEquippedSerial(xPlayer.identifier, weaponName, serial)
                SaveWeaponSerial(serial)
            end
        else
            -- a weapon of this type is already equipped -- this is a NEW
            -- copy, so it becomes a separate carried spare instead of
            -- silently doing nothing (the old behaviour)
            local serial = MintWeaponSerial(weaponName, xPlayer.identifier, ammo, {}, true)
            GiveCarriedWeaponSerial(xPlayer, serial)
        end
    end

    xPlayer.removeWeapon = function(weaponNamex, ammo)
        local weaponName = string.upper(weaponNamex)
        local _, weapon = xPlayer.getWeapon(weaponName)
        local serial = weapon and weapon.serial

        originalRemoveWeapon(weaponName, ammo)

        -- generic removal (sold back, taken by admin, death penalty, ...)
        -- -- keep the serial's history but free it up; NOT the same as
        -- 'destroyed', which only unique_weaponserial's own drop/pickup
        -- and any future evidence-locker feature should set explicitly
        if serial and WeaponSerials[serial] then
            WeaponSerials[serial].status = 'unowned'
            WeaponSerials[serial].owner_identifier = nil
            SaveWeaponSerial(serial)
        end
        ClearEquippedSerial(xPlayer.identifier, weaponName)
    end
end)
