

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
-- TEMPORARY DIAGNOSTIC (remove once useItem is confirmed fixed):
-- listens to the SAME event essentialmode's core esx:useItem handler
-- does, just to print what actually arrives server-side and whether
-- the item is owned + registered as usable, without touching
-- essentialmode itself.
-- ============================================================
AddEventHandler('esx:useItem', function(itemName)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local item = xPlayer and xPlayer.getInventoryItem(itemName)
    print(('[DEBUG-SERVER] esx:useItem received itemName=%s owned_count=%s registered_in_ESX_Items=%s'):format(
        tostring(itemName),
        tostring(item and item.count),
        tostring(ESX.Items[itemName] ~= nil)
    ))
end)
