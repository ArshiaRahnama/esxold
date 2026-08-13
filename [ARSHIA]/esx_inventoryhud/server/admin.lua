-- ============================================================
-- esx_inventoryhud / server / admin.lua
--
-- Backs modules/admin/client/main.lua exactly as written --
-- event names below match that file precisely (it was NOT
-- modified). Requires the "inventory.admin" ACE permission
-- (configurable via Config.AdminInventoryAce).
-- ============================================================

if ESX == nil then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    while ESX == nil do
        Citizen.Wait(0)
    end
end

local function hasAdminPermission(src)
    return IsPlayerAceAllowed(src, Config.AdminInventoryAce or 'inventory.admin')
end

-- modules/admin calls: ESX.TriggerServerEvent('inventory:admin:get', target, data.data)
-- meaning: take `data.data` (an item/weapon the admin dropped INTO the
-- target's panel while it was open) FROM the target and GIVE it to the admin.
RegisterServerEvent('inventory:admin:get')
AddEventHandler('inventory:admin:get', function(targetId, data)
    local src = source
    if not hasAdminPermission(src) then return end
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(targetId)
    if not xPlayer or not xTarget or not data or not data.name then return end

    if data.isWeapon then
        local weapon = xTarget.getWeapon(data.name)
        if not weapon then return end
        xTarget.removeWeapon(data.name)
        xPlayer.addWeapon(data.name, weapon.ammo or 0)
        return
    end

    local item = xTarget.getInventoryItem(data.name)
    local count = math.min(data.count or 1, item and item.count or 0)
    if count < 1 then return end

    xTarget.removeInventoryItem(data.name, count)
    xPlayer.addInventoryItem(data.name, count)
end)

-- modules/admin calls: ESX.TriggerServerEvent('inventory:admin:put', target, data.data)
-- meaning: the admin dropped `data.data` FROM their own inventory INTO
-- the target's panel -- give it to the target.
RegisterServerEvent('inventory:admin:put')
AddEventHandler('inventory:admin:put', function(targetId, data)
    local src = source
    if not hasAdminPermission(src) then return end
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(targetId)
    if not xPlayer or not xTarget or not data or not data.name then return end

    if data.isWeapon then
        local weapon = xPlayer.getWeapon(data.name)
        if not weapon then return end
        xPlayer.removeWeapon(data.name)
        xTarget.addWeapon(data.name, weapon.ammo or 0)
        return
    end

    local item = xPlayer.getInventoryItem(data.name)
    local count = math.min(data.count or 1, item and item.count or 0)
    if count < 1 then return end

    xPlayer.removeInventoryItem(data.name, count)
    xTarget.addInventoryItem(data.name, count)
end)

-- modules/admin calls: ESX.TriggerServerCallback('inventory:getOfflinePlayerInventory', cb, target)
-- `target` there is whatever identifier the admin UI passed in -- if the
-- player is online we just use their live data, otherwise read from `users`.
ESX.RegisterServerCallback('inventory:getOfflinePlayerInventory', function(source, cb, target)
    if not hasAdminPermission(source) then
        cb({ items = {}, weapons = {} })
        return
    end

    local xTarget = ESX.GetPlayerFromId(target)
    if xTarget then
        cb({ items = xTarget.inventory, weapons = xTarget.loadout })
        return
    end

    exports.oxmysql:fetch('SELECT inventory, loadout FROM users WHERE identifier = @identifier', {
        ['@identifier'] = target
    }, function(result)
        if not result or not result[1] then
            cb({ items = {}, weapons = {} })
            return
        end
        local ok1, items = pcall(json.decode, result[1].inventory or '[]')
        local ok2, weapons = pcall(json.decode, result[1].loadout or '[]')
        cb({
            items = ok1 and items or {},
            weapons = ok2 and weapons or {}
        })
    end)
end)
