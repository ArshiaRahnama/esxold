

if ESX == nil then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    while ESX == nil do
        Citizen.Wait(0)
    end
end

CreateThread(function()
    exports.litesql:execute([[
        CREATE TABLE IF NOT EXISTS `bag_inventories` (
            `bag_id` INT NOT NULL PRIMARY KEY,
            `items` LONGTEXT NOT NULL DEFAULT ('[]'),
            `slots` INT NOT NULL DEFAULT 41
        )
    ]], {})
end)

CreateThread(function()
    for i = 1, (Config.MaxBagId or 300) do
        TriggerEvent('esx:CreateItem', 'kif_' .. i, 'Kif ' .. i, -1, false, true)
        ESX.RegisterUsableItem('kif_' .. i, function(playerId)
            TriggerClientEvent('inventory-bag:openBag', playerId, i, Config.DefaultBagMaxWeight or 8000)
        end)
    end
end)

local function stableBagId(str)
    local hash = 5381
    for i = 1, #str do
        hash = (hash * 33 + string.byte(str, i)) % 2147483647
    end
    return hash
end

CreateThread(function()
    if type(configBag) ~= 'table' then return end
    for bagType, def in pairs(configBag) do
        TriggerEvent('esx:CreateItem', bagType, def.label or bagType, def.limit or 1, false, true)
        ESX.RegisterUsableItem(bagType, function(playerId)
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if not xPlayer then return end
            local bagId = stableBagId(xPlayer.identifier .. '_' .. bagType)
            TriggerClientEvent('inventory-bag:openBag', playerId, bagId, def.maxWeight or 50)
        end)
    end
end)

local function loadBag(bagId, cb)
    exports.litesql:fetch('SELECT items, slots FROM bag_inventories WHERE bag_id = @id', {
        ['@id'] = bagId
    }, function(result)
        if result and result[1] then
            local ok, items = pcall(json.decode, result[1].items or '[]')
            cb(ok and items or {}, result[1].slots or 41)
        else
            exports.litesql:execute('INSERT INTO bag_inventories (bag_id, items, slots) VALUES (@id, @items, @slots)', {
                ['@id'] = bagId,
                ['@items'] = '[]',
                ['@slots'] = 41
            })
            cb({}, 41)
        end
    end)
end

local function saveBag(bagId, items)
    exports.litesql:execute('UPDATE bag_inventories SET items = @items WHERE bag_id = @id', {
        ['@id'] = bagId,
        ['@items'] = json.encode(items)
    })
end

ESX.RegisterServerCallback('inventory-bag:getInventory', function(source, cb, bagId)
    loadBag(bagId, function(items)
        cb(items)
    end)
end)

RegisterServerEvent('inventory-bag:updateSlot')
AddEventHandler('inventory-bag:updateSlot', function(bagId, data)
    if not data or not data.name then return end
    loadBag(bagId, function(items)
        for _, entry in ipairs(items) do
            if entry.name == data.name then
                entry.slot = data.droppedTo or data.slot
            end
        end
        saveBag(bagId, items)
    end)
end)

RegisterServerEvent('inventory-bag:put')
AddEventHandler('inventory-bag:put', function(bagId, data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or not data or not data.name then return end

    local item = xPlayer.getInventoryItem(data.name)
    local count = math.min(data.count or 1, item and item.count or 0)
    if count < 1 then return end

    xPlayer.removeInventoryItem(data.name, count)

    loadBag(bagId, function(items, slots)
        local found = false
        for _, entry in ipairs(items) do
            if entry.name == data.name then
                entry.count = entry.count + count
                found = true
                break
            end
        end
        if not found then
            table.insert(items, { name = data.name, count = count, slot = data.droppedTo })
        end
        saveBag(bagId, items)
    end)
end)

RegisterServerEvent('inventory-bag:get')
AddEventHandler('inventory-bag:get', function(bagId, data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or not data or not data.name then return end

    loadBag(bagId, function(items)
        for i, entry in ipairs(items) do
            if entry.name == data.name then
                local count = math.min(data.count or entry.count, entry.count)
                if count < 1 then return end
                if not xPlayer.canCarryItem(data.name, count) then
                    TriggerClientEvent('esx:showNotification', src, 'Vazn Zaiad Ast !')
                    return
                end

                entry.count = entry.count - count
                if entry.count <= 0 then
                    table.remove(items, i)
                end
                saveBag(bagId, items)
                xPlayer.addInventoryItem(data.name, count)
                return
            end
        end
    end)
end)
