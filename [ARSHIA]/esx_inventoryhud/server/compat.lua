
-- ============================================================

if ESX == nil then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    while ESX == nil do
        Citizen.Wait(0)
    end
end

local function trunkPut(src, xPlayer, plate, data)
    TriggerEvent('esx_trunk:getSharedDataStore', plate, function(store)
        local item = xPlayer.getInventoryItem(data.name)
        local count = math.min(data.count or 1, item and item.count or 0)
        if count < 1 then return end

        xPlayer.removeInventoryItem(data.name, count)

        local coffre = store.get('coffre') or {}
        local found = false
        for i = 1, #coffre do
            if coffre[i].name == data.name then
                coffre[i].count = coffre[i].count + count
                found = true
                break
            end
        end
        if not found then
            table.insert(coffre, { name = data.name, count = count, label = ESX.GetItemLabel(data.name) })
        end
        store.set('coffre', coffre)
    end)
end

local function trunkGet(src, xPlayer, plate, data)
    TriggerEvent('esx_trunk:getSharedDataStore', plate, function(store)
        local coffre = store.get('coffre') or {}
        for i = 1, #coffre do
            if coffre[i].name == data.name then
                local count = math.min(data.count or coffre[i].count, coffre[i].count)
                if count < 1 then return end
                if not xPlayer.canCarryItem(data.name, count) then
                    TriggerClientEvent('esx:showNotification', src, 'Vazn Zaiad Ast !')
                    return
                end

                coffre[i].count = coffre[i].count - count
                if coffre[i].count <= 0 then
                    table.remove(coffre, i)
                end
                store.set('coffre', coffre)
                xPlayer.addInventoryItem(data.name, count)
                return
            end
        end
    end)
end

RegisterServerEvent('esx_inventoryhud:put')
AddEventHandler('esx_inventoryhud:put', function(kind, key, data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or not data or not data.name then return end

    if kind == 'trunk' and key then
        trunkPut(src, xPlayer, key, data)
    else
        TriggerClientEvent('esx:showNotification', src, 'In Bakhsh Hanuz Support Nemishe (' .. tostring(kind) .. ')')
    end
end)

RegisterServerEvent('esx_inventoryhud:get')
AddEventHandler('esx_inventoryhud:get', function(kind, key, data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or not data or not data.name then return end

    if kind == 'trunk' and key then
        trunkGet(src, xPlayer, key, data)
    else
        TriggerClientEvent('esx:showNotification', src, 'In Bakhsh Hanuz Support Nemishe (' .. tostring(kind) .. ')')
    end
end)
