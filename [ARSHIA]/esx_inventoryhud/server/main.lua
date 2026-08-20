

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
while ESX == nil do
    Citizen.Wait(0)
end

local droppedItems = {}
local nextDropId = 1

local function getDistance(a, b)
    return #(vector3(a.x, a.y, a.z) - vector3(b.x, b.y, b.z))
end

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

ESX.RegisterServerCallback('inventory:core:getPlayerInventory', function(source, cb, targetId)
    if not IsPlayerAceAllowed(source, Config.AdminInventoryAce or 'inventory.admin') then
        cb(nil)
        return
    end
    local xTarget = ESX.GetPlayerFromId(targetId)
    if not xTarget then cb(nil) return end
    cb({ items = xTarget.inventory, weapons = xTarget.loadout })
end)

local equippedWeapons = {}

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
