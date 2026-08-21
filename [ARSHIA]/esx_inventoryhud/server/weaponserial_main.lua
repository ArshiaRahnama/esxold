-- ============================================================
-- unique_weaponserial / server / main.lua
--
-- Builds the "carryable spare weapon" layer on top of serials.lua:
--   - a carried (non-equipped) copy of a weapon is a normal inventory
--     item named 'wpn_<serial>'
--   - "using" that item from the inventory equips it, holstering
--     whatever was equipped for that weapon type back into its own
--     'wpn_<serial>' item (native GTA only allows ONE instance of a
--     given weapon type in the wheel at a time -- that's an engine
--     limit, not something this system can bypass)
--   - dropping the equipped weapon holsters it, then hands off to
--     esx_inventoryhud's OWN existing, already-working ground
--     drop/pickup system (server/main.lua there:
--     'inventory:core:throwItem' / 'inventory:core:pickupThrown').
--     Because the item name IS the serial, picking it back up
--     preserves it automatically -- no separate pickup system needed.
-- ============================================================

local RegisteredWeaponItems = {} -- itemName -> true, avoids re-firing esx:CreateItem every time

local function weaponItemName(weaponName, serial)
    return 'wpn_' .. weaponName:gsub('^WEAPON_', ''):lower() .. '_' .. serial
end

local function weaponItemLabel(weaponName, serial)
    return (ESX.GetWeaponLabel(weaponName) or weaponName) .. ' #' .. serial
end

function EquipWeaponSerial(playerId, serial) -- forward-declared usable-item handler, defined below

    local xPlayer = ESX.GetPlayerFromId(playerId)
    local data = xPlayer and GetWeaponSerial(serial)
    if not xPlayer or not data then return end

    if data.status ~= 'carried' or data.owner_identifier ~= xPlayer.identifier then
        TriggerClientEvent('esx:showNotification', playerId, '~r~In aslahe mal to nist ya toye jibet nist')
        return
    end

    xPlayer.removeInventoryItem(weaponItemName(data.weapon, serial), 1)

    -- holster whatever's currently equipped of the SAME weapon type
    local _, currentWeapon = xPlayer.getWeapon(data.weapon)
    if currentWeapon and currentWeapon.serial then
        local oldSerial = currentWeapon.serial
        xPlayer.__originalRemoveWeapon(data.weapon)
        if WeaponSerials[oldSerial] then
            GiveCarriedWeaponSerial(xPlayer, oldSerial)
        end
    end

    -- equip the selected serial using its OWN stored ammo, bypassing the
    -- patched addWeapon (which would mint a brand new serial otherwise)
    xPlayer.__originalAddWeapon(data.weapon, data.ammo)
    local loadoutNum = xPlayer.getWeapon(data.weapon)
    if loadoutNum then
        xPlayer.loadout[loadoutNum].serial = serial
        SetEquippedSerial(xPlayer.identifier, data.weapon, serial)
        for _, component in ipairs(data.components or {}) do
            xPlayer.addWeaponComponent(data.weapon, component)
        end
    end

    data.status = 'equipped'
    data.owner_identifier = xPlayer.identifier
    SaveWeaponSerial(serial)
end

-- Turns an already-minted serial into a carried inventory item. Used
-- both for brand new spare purchases (serials.lua) and for holstering
-- a weapon that's being swapped out of the equipped slot.
function GiveCarriedWeaponSerial(xPlayer, serial)
    local data = WeaponSerials[serial]
    if not data then return end

    local itemName = weaponItemName(data.weapon, serial)
    if not RegisteredWeaponItems[itemName] then
        if ESX.Items[itemName] == nil then
            TriggerEvent('esx:CreateItem', itemName, weaponItemLabel(data.weapon, serial), 1, false, true)
        end
        ESX.RegisterUsableItem(itemName, function(playerId)
            EquipWeaponSerial(playerId, serial)
        end)
        RegisteredWeaponItems[itemName] = true
    end

    xPlayer.addInventoryItem(itemName, 1)
    data.status = 'carried'
    data.owner_identifier = xPlayer.identifier
    SaveWeaponSerial(serial)
end

-- re-register usable-item handlers for every serial that's currently
-- sitting as a carried item, in case this resource restarted --
-- ESX.UsableItemsCallbacks resets on restart but the DB rows/inventory
-- items don't
CreateThread(function()
    Wait(1000)
    for serial, data in pairs(WeaponSerials) do
        if data.status == 'carried' then
            local itemName = weaponItemName(data.weapon, serial)
            if ESX.Items[itemName] == nil then
                TriggerEvent('esx:CreateItem', itemName, weaponItemLabel(data.weapon, serial), 1, false, true)
            end
            ESX.RegisterUsableItem(itemName, function(playerId)
                EquipWeaponSerial(playerId, serial)
            end)
            RegisteredWeaponItems[itemName] = true
        end
    end
end)

-- ============================================================
-- Drop the currently equipped weapon: holster it into a carried item,
-- then hand off to esx_inventoryhud's own existing ground-drop system
-- for that exact item -- see the big comment at the top of this file.
-- ============================================================
RegisterServerEvent('unique_weaponserial:holsterForDrop')
AddEventHandler('unique_weaponserial:holsterForDrop', function(weaponName)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local _, weapon = xPlayer.getWeapon(string.upper(weaponName))
    if not weapon or not weapon.serial then
        TriggerClientEvent('esx:showNotification', src, '~r~In aslahe ro nadari')
        return
    end

    local serial = weapon.serial
    xPlayer.__originalRemoveWeapon(string.upper(weaponName))
    ClearEquippedSerial(xPlayer.identifier, string.upper(weaponName))
    if WeaponSerials[serial] then
        GiveCarriedWeaponSerial(xPlayer, serial)
        TriggerClientEvent('unique_weaponserial:doThrow', src, weaponItemName(weaponName, serial))
    end
end)

-- ============================================================
-- Police / MDT serial lookup. Standalone command for now -- exposed
-- as a plain function too (GetWeaponSerial, from serials.lua) so a
-- real MDT resource can call it directly once you point me at one.
-- ============================================================
-- Matches this server's real `jobs` table (database.sql) -- 'government'
-- isn't an actual job here, replaced with the real law-enforcement/
-- intelligence jobs that exist: police, sheriff, mt, cia, cid, doa, marshal
local PoliceJobs = { police = true, sheriff = true, mt = true, cia = true, cid = true, doa = true, marshal = true }

RegisterCommand('checkserial', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    if not PoliceJobs[xPlayer.job.name] then
        TriggerClientEvent('esx:showNotification', source, '~r~In dastur faghat baraye police hast')
        return
    end

    local serial = args[1] and args[1]:upper()
    local data = serial and GetWeaponSerial(serial)
    if not data then
        TriggerClientEvent('esx:showNotification', source, '~r~Serial peida nashod')
        return
    end

    local holderName = 'Nashenas'
    if data.owner_identifier then
        local holderPlayer = ESX.GetPlayerFromIdentifier(data.owner_identifier)
        if holderPlayer then
            holderName = holderPlayer.name or holderName
        end
    end

    local registeredName = data.registered_identifier and data.registered_identifier or 'Sabt Nashode (Ghayr Ghanooni)'

    TriggerClientEvent('chat:addMessage', source, {
        args = { '^3[Serial Check]', ('Aslahe: %s\nVaziat: %s\nDarande: %s (identifier: %s)\nSabt shode be: %s'):format(
            ESX.GetWeaponLabel(data.weapon) or data.weapon,
            data.status,
            holderName, data.owner_identifier or 'nadare',
            registeredName
        ) }
    })
end, false)
