

if ESX == nil then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    while ESX == nil do
        Citizen.Wait(0)
    end
end

CreateThread(function()
    exports.litesql:execute([[
        CREATE TABLE IF NOT EXISTS `public_inventories` (
            `name` VARCHAR(64) NOT NULL PRIMARY KEY,
            `items` LONGTEXT NOT NULL DEFAULT ('[]')
        )
    ]], {})
end)

local function loadPublic(name, cb)
    exports.litesql:fetch('SELECT items FROM public_inventories WHERE name = @name', {
        ['@name'] = name
    }, function(result)
        if result and result[1] then
            local ok, items = pcall(json.decode, result[1].items or '[]')
            cb(ok and items or {})
        else
            exports.litesql:execute('INSERT INTO public_inventories (name, items) VALUES (@name, @items)', {
                ['@name'] = name,
                ['@items'] = '[]'
            })
            cb({})
        end
    end)
end

local function savePublic(name, items)
    exports.litesql:execute('UPDATE public_inventories SET items = @items WHERE name = @name', {
        ['@name'] = name,
        ['@items'] = json.encode(items)
    })
end

ESX.RegisterServerCallback('inventory-public:getInventory', function(source, cb, name, owner)
    if owner == 'delete' then
        cb({})
        return
    end
    loadPublic(name, cb)
end)

RegisterServerEvent('inventory-public:updateSlot')
AddEventHandler('inventory-public:updateSlot', function(name, data)
    if not data or not data.name then return end
    loadPublic(name, function(items)
        for _, entry in ipairs(items) do
            if entry.name == data.name then
                entry.slot = data.droppedTo or data.slot
            end
        end
        savePublic(name, items)
    end)
end)

RegisterServerEvent('inventory-public:put')
AddEventHandler('inventory-public:put', function(name, data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or not data or not data.name then return end

    local item = xPlayer.getInventoryItem(data.name)
    local count = math.min(data.count or 1, item and item.count or 0)
    if count < 1 then return end

    xPlayer.removeInventoryItem(data.name, count)

    if name:find('^recycle:') then

        return
    end

    loadPublic(name, function(items)
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
        savePublic(name, items)
    end)
end)

RegisterServerEvent('inventory-public:get')
AddEventHandler('inventory-public:get', function(name, data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or not data or not data.name then return end
    if name:find('^recycle:') then return end

    loadPublic(name, function(items)
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
                savePublic(name, items)
                xPlayer.addInventoryItem(data.name, count)
                return
            end
        end
    end)
end)
