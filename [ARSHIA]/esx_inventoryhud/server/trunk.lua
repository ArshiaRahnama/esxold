

if ESX == nil then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    while ESX == nil do
        Citizen.Wait(0)
    end
end

CreateThread(function()
    exports.litesql:execute([[
        CREATE TABLE IF NOT EXISTS `trunk_inventories` (
            `plate` VARCHAR(32) NOT NULL,
            `glove_box` TINYINT(1) NOT NULL DEFAULT 0,
            `items` LONGTEXT NOT NULL DEFAULT ('[]'),
            `weapons` LONGTEXT NOT NULL DEFAULT ('[]'),
            PRIMARY KEY (`plate`, `glove_box`)
        )
    ]], {})
end)

local function loadTrunk(plate, gloveBox, cb)
    exports.litesql:fetch('SELECT items, weapons FROM trunk_inventories WHERE plate = @plate AND glove_box = @gb', {
        ['@plate'] = plate,
        ['@gb'] = gloveBox and 1 or 0
    }, function(result)
        if result and result[1] then
            local ok1, items = pcall(json.decode, result[1].items or '[]')
            local ok2, weapons = pcall(json.decode, result[1].weapons or '[]')
            cb(ok1 and items or {}, ok2 and weapons or {})
        else
            exports.litesql:execute('INSERT INTO trunk_inventories (plate, glove_box, items, weapons) VALUES (@plate, @gb, @items, @weapons)', {
                ['@plate'] = plate,
                ['@gb'] = gloveBox and 1 or 0,
                ['@items'] = '[]',
                ['@weapons'] = '[]'
            })
            cb({}, {})
        end
    end)
end

local function saveTrunk(plate, gloveBox, items, weapons)
    exports.litesql:execute('UPDATE trunk_inventories SET items = @items, weapons = @weapons WHERE plate = @plate AND glove_box = @gb', {
        ['@plate'] = plate,
        ['@gb'] = gloveBox and 1 or 0,
        ['@items'] = json.encode(items),
        ['@weapons'] = json.encode(weapons)
    })
end

ESX.RegisterServerCallback('inventory-trunk:getVehicleTrunk', function(source, cb, plate, gloveBox)
    loadTrunk(plate, gloveBox, function(items, weapons)
        cb({ items = items, weapons = weapons })
    end)
end)

RegisterServerEvent('inventory-trunk:updateSlot')
AddEventHandler('inventory-trunk:updateSlot', function(plate, data)
    if not data or not data.name then return end
    loadTrunk(plate, data.gloveBox, function(items, weapons)
        local list = data.ammo ~= nil and weapons or items
        for _, entry in ipairs(list) do
            if entry.name == data.name then
                entry.slot = data.droppedTo or data.slot
            end
        end
        saveTrunk(plate, data.gloveBox, items, weapons)
    end)
end)

-- move item/weapon FROM the player's main inventory INTO the trunk/glovebox
RegisterServerEvent('inventory-trunk:put')
AddEventHandler('inventory-trunk:put', function(plate, data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or not data or not data.name then return end

    loadTrunk(plate, data.gloveBox, function(items, weapons)
        if data.ammo ~= nil then
            local weapon = xPlayer.getWeapon(data.name)
            if not weapon then return end
            xPlayer.removeWeapon(data.name)
            table.insert(weapons, { name = data.name, ammo = weapon.ammo or 0, components = weapon.components, tintIndex = weapon.tintIndex, slot = data.droppedTo })
        else
            local item = xPlayer.getInventoryItem(data.name)
            local count = math.min(data.count or 1, item and item.count or 0)
            if count < 1 then return end
            xPlayer.removeInventoryItem(data.name, count)

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
        end
        saveTrunk(plate, data.gloveBox, items, weapons)
    end)
end)

-- move item/weapon FROM the trunk/glovebox INTO the player's main inventory
RegisterServerEvent('inventory-trunk:get')
AddEventHandler('inventory-trunk:get', function(plate, data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or not data or not data.name then return end

    loadTrunk(plate, data.gloveBox, function(items, weapons)
        if data.ammo ~= nil then
            for i, entry in ipairs(weapons) do
                if entry.name == data.name then
                    table.remove(weapons, i)
                    saveTrunk(plate, data.gloveBox, items, weapons)
                    xPlayer.addWeapon(entry.name, entry.ammo or 0)
                    return
                end
            end
        else
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
                    saveTrunk(plate, data.gloveBox, items, weapons)
                    xPlayer.addInventoryItem(data.name, count)
                    return
                end
            end
        end
    end)
end)
