

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

WeaponSerials = {}

CreateThread(function()
    Wait(500)
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

local SERIAL_CHARS = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'

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

EquippedSerialCache = {}

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
                WeaponSerials[serial].ammo = weapon.ammo
            end
        end
    end
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    if not xPlayer or not xPlayer.addWeapon or xPlayer.__weaponSerialPatched then return end
    xPlayer.__weaponSerialPatched = true







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



    xPlayer.__originalAddWeapon = originalAddWeapon
    xPlayer.__originalRemoveWeapon = originalRemoveWeapon

    xPlayer.addWeapon = function(weaponNamex, ammo)
        local weaponName = string.upper(weaponNamex)
        local alreadyEquipped = xPlayer.hasWeapon(weaponName)

        if not alreadyEquipped then

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



            local serial = MintWeaponSerial(weaponName, xPlayer.identifier, ammo, {}, true)
            GiveCarriedWeaponSerial(xPlayer, serial)
        end
    end

    xPlayer.removeWeapon = function(weaponNamex, ammo)
        local weaponName = string.upper(weaponNamex)
        local _, weapon = xPlayer.getWeapon(weaponName)
        local serial = weapon and weapon.serial

        originalRemoveWeapon(weaponName, ammo)





        if serial and WeaponSerials[serial] then
            WeaponSerials[serial].status = 'unowned'
            WeaponSerials[serial].owner_identifier = nil
            SaveWeaponSerial(serial)
        end
        ClearEquippedSerial(xPlayer.identifier, weaponName)
    end
end)
