

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
while ESX == nil do
    Citizen.Wait(0)
end

local droppedItems = {} -- [id] = { name, count, coords, expireAt }
local nextDropId = 1

local function getDistance(a, b)
    return #(vector3(a.x, a.y, a.z) - vector3(b.x, b.y, b.z))
end

-- ------------------------------------------------------------
-- Throw / drop item on the ground
-- ------------------------------------------------------------
RegisterServerEvent('inventory:core:throwItem')
AddEventHandler('inventory:core:throwItem', function(itemName, count, coords)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or not itemName or not count or count < 1 then return end

    local item = xPlayer.getInventoryItem(itemName)
    if not item or item.count < count then return end

    xPlayer.removeInventoryItem(itemName, count)

    local id = nextDropId
    nextDropId = nextDropId + 1
    droppedItems[id] = {
        name = itemName,
        count = count,
        coords = coords,
        droppedBy = src,
        expireAt = os.time() + (Config.DroppedItemLifetime or 600)
    }

    TriggerClientEvent('inventory:core:spawnDrop', -1, id, itemName, coords)
end)

RegisterServerEvent('inventory:core:pickupThrown')
AddEventHandler('inventory:core:pickupThrown', function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local drop = droppedItems[id]
    if not xPlayer or not drop then return end

    if getDistance(GetEntityCoords(GetPlayerPed(src)), drop.coords) > 3.0 then
        return
    end

    if not xPlayer.canCarryItem(drop.name, drop.count) then
        TriggerClientEvent('esx:showNotification', src, 'Vazn Zaiad Ast !')
        return
    end

    xPlayer.addInventoryItem(drop.name, drop.count)
    droppedItems[id] = nil
    TriggerClientEvent('inventory:core:removeDrop', -1, id)
end)

-- periodic cleanup of old dropped items
CreateThread(function()
    while true do
        Wait(60000)
        local now = os.time()
        for id, drop in pairs(droppedItems) do
            if now >= drop.expireAt then
                droppedItems[id] = nil
                TriggerClientEvent('inventory:core:removeDrop', -1, id)
            end
        end
    end
end)

-- ------------------------------------------------------------
-- Give item to a nearby player (server-validated)
-- ------------------------------------------------------------
RegisterServerEvent('inventory:core:giveItem')
AddEventHandler('inventory:core:giveItem', function(targetId, itemName, count)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(targetId)
    if not xPlayer or not xTarget or not itemName or not count or count < 1 then return end
    if src == targetId then return end

    local srcPed = GetPlayerPed(src)
    local dstPed = GetPlayerPed(targetId)
    if getDistance(GetEntityCoords(srcPed), GetEntityCoords(dstPed)) > (Config.GiveItemMaxDistance or 3.0) then
        TriggerClientEvent('esx:showNotification', src, 'Fasele Ziad Ast !')
        return
    end

    local item = xPlayer.getInventoryItem(itemName)
    if not item or item.count < count then
        TriggerClientEvent('esx:showNotification', src, 'Item Kafi Nist !')
        return
    end

    if not xTarget.canCarryItem(itemName, count) then
        TriggerClientEvent('esx:showNotification', src, 'Taraf Nemitavanad Hamle Konad !')
        return
    end

    xPlayer.removeInventoryItem(itemName, count)
    xTarget.addInventoryItem(itemName, count)

    TriggerClientEvent('esx:showNotification', src, 'Ba Movafaghiat Dade Shod !')
    TriggerClientEvent('esx:showNotification', targetId, 'Item Daryaft Shod !')
end)

RegisterServerEvent('inventory:core:giveWeapon')
AddEventHandler('inventory:core:giveWeapon', function(targetId, weaponName)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(targetId)
    if not xPlayer or not xTarget or not weaponName then return end
    if src == targetId then return end

    local srcPed = GetPlayerPed(src)
    local dstPed = GetPlayerPed(targetId)
    if getDistance(GetEntityCoords(srcPed), GetEntityCoords(dstPed)) > (Config.GiveItemMaxDistance or 3.0) then
        TriggerClientEvent('esx:showNotification', src, 'Fasele Ziad Ast !')
        return
    end

    local weapon = xPlayer.getWeapon(weaponName)
    if not weapon then return end

    xPlayer.removeWeapon(weaponName)
    xTarget.addWeapon(weaponName, weapon.ammo or 0)

    TriggerClientEvent('esx:showNotification', src, 'Ba Movafaghiat Dade Shod !')
    TriggerClientEvent('esx:showNotification', targetId, 'Selah Daryaft Shod !')
end)

-- Admin online/offline inventory viewing helpers (used by
-- modules/admin) live in server/admin.lua, matching the exact
-- event names that module already sends.

-- used by client/core.lua's openOtherPlayerInventory (online case)
ESX.RegisterServerCallback('inventory:core:getPlayerInventory', function(source, cb, targetId)
    if not IsPlayerAceAllowed(source, Config.AdminInventoryAce or 'inventory.admin') then
        cb(nil)
        return
    end
    local xTarget = ESX.GetPlayerFromId(targetId)
    if not xTarget then cb(nil) return end
    cb({ items = xTarget.inventory, weapons = xTarget.loadout })
end)

-- ============================================================
-- Weapon equip toggle: server-authoritative "which weapons are
-- actually drawable" state, capped at Config.WeaponSlots count.
-- In-memory only per session (mirrors usedClothe's pattern in
-- Unique_clothe) -- on relog/spawn the client re-asks via
-- inventory:getEquippedWeapons and starts clean, so nothing carries
-- over incorrectly, and this never touches essentialmode's own
-- weapon storage/DB at all.
-- ============================================================
local equippedWeapons = {} -- [source] = { [weaponName] = true }

local function ownsWeapon(xPlayer, weaponName)
    return xPlayer.getWeapon(weaponName) ~= nil
end

local function equippedCount(set)
    local n = 0
    for _ in pairs(set) do n = n + 1 end
    return n
end

RegisterServerEvent('inventory:toggleWeaponEquip')
AddEventHandler('inventory:toggleWeaponEquip', function(weaponName)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or not weaponName then return end
    if not ownsWeapon(xPlayer, weaponName) then return end

    equippedWeapons[src] = equippedWeapons[src] or {}
    local set = equippedWeapons[src]

    if set[weaponName] then
        set[weaponName] = nil
    else
        local maxSlots = (Config.WeaponSlots and #Config.WeaponSlots) or 3
        if equippedCount(set) >= maxSlots then
            -- unequip whichever one was equipped first (oldest) to make room
            local oldest = nil
            for name in pairs(set) do oldest = name break end
            if oldest then set[oldest] = nil end
        end
        set[weaponName] = true
    end

    TriggerClientEvent('inventory:weaponEquipChanged', src, set)
end)

ESX.RegisterServerCallback('inventory:getEquippedWeapons', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then cb({}) return end

    equippedWeapons[source] = equippedWeapons[source] or {}
    local set = equippedWeapons[source]

    -- drop anything the player no longer actually owns (sold/dropped/etc)
    for weaponName in pairs(set) do
        if not ownsWeapon(xPlayer, weaponName) then
            set[weaponName] = nil
        end
    end

    cb(set)
end)

AddEventHandler('playerDropped', function()
    equippedWeapons[source] = nil
end)

-- ============================================================
-- Real slot persistence for both items AND weapons. essentialmode's
-- inventory/loadout entries have no slot field at all by default
-- (confirmed: self.inventory[i]/self.loadout[i] are just flat
-- {name,count,...} tables looked up by name, not by position) --
-- this adds a 'slot' key directly onto each entry's own table.
-- essentialmode saves self.inventory via json.encode(self.inventory)
-- (see server/main.lua's SaveUser), so an extra key on each item just
-- rides along in that same JSON blob -- no schema change, nothing
-- else that only reads .name/.count is affected.
-- ============================================================

local function findEntry(xPlayer, name, isWeapon)
    local list = isWeapon and xPlayer.loadout or xPlayer.inventory
    for i = 1, #list do
        if list[i].name == name then return list[i] end
    end
    return nil
end

RegisterServerEvent('inventory:core:swapItemSlots')
AddEventHandler('inventory:core:swapItemSlots', function(fromName, fromIsWeapon, toName, toIsWeapon, targetSlot)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or not fromName then return end

    local fromEntry = findEntry(xPlayer, fromName, fromIsWeapon)
    if not fromEntry then return end

    local oldSlot = fromEntry.slot
    fromEntry.slot = targetSlot

    if toName and toName ~= fromName then
        local toEntry = findEntry(xPlayer, toName, toIsWeapon)
        if toEntry then
            toEntry.slot = oldSlot
        end
    end

    TriggerClientEvent('inventory:core:refreshInventory', src)
end)
