
if ESX == nil then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    while ESX == nil do
        Citizen.Wait(0)
    end
end

CreateThread(function()
    exports.litesql:execute([[
        CREATE TABLE IF NOT EXISTS `player_worn_clothes` (
            `identifier` VARCHAR(64) NOT NULL PRIMARY KEY,
            `worn` LONGTEXT NOT NULL DEFAULT ('{}')
        )
    ]], {})
    exports.litesql:execute([[
        CREATE TABLE IF NOT EXISTS `player_clothe_packs` (
            `pack_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
            `identifier` VARCHAR(64) NOT NULL,
            `label` VARCHAR(64) NOT NULL,
            `contents` LONGTEXT NOT NULL DEFAULT ('{}')
        )
    ]], {})
end)

local function getClotheType(itemName)
    -- 'clothe_<type>_<drawable>_<texture>' -> type
    return itemName:match('^clothe_([a-z]+)_%d+_%d+$')
end

local function loadWorn(identifier, cb)
    exports.litesql:fetch('SELECT worn FROM player_worn_clothes WHERE identifier = @id', {
        ['@id'] = identifier
    }, function(result)
        if result and result[1] then
            local ok, worn = pcall(json.decode, result[1].worn or '{}')
            cb(ok and worn or {})
        else
            exports.litesql:execute('INSERT INTO player_worn_clothes (identifier, worn) VALUES (@id, @worn)', {
                ['@id'] = identifier,
                ['@worn'] = '{}'
            })
            cb({})
        end
    end)
end

local function saveWorn(identifier, worn)
    exports.litesql:execute('UPDATE player_worn_clothes SET worn = @worn WHERE identifier = @id', {
        ['@id'] = identifier,
        ['@worn'] = json.encode(worn)
    })
end

-- fetch what's currently worn (used on inventory open + on spawn to
-- re-apply appearance)
ESX.RegisterServerCallback('sun-clothe:getWorn', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then cb({}) return end
    loadWorn(xPlayer.identifier, cb)
end)

-- equip/unequip one type. itemName == nil means "take off this type".
-- Always re-validates ownership server-side before accepting it.
RegisterServerEvent('sun-clothe:setWorn')
AddEventHandler('sun-clothe:setWorn', function(clotheType, itemName)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or not clotheType then return end

    if itemName then
        local matchedType = getClotheType(itemName)
        if matchedType ~= clotheType then return end
        local item = xPlayer.getInventoryItem(itemName)
        if not item or item.count < 1 then return end
    end

    loadWorn(xPlayer.identifier, function(worn)
        if itemName then
            worn[clotheType] = itemName
        else
            worn[clotheType] = nil
        end
        saveWorn(xPlayer.identifier, worn)
    end)
end)

-- ------------------------------------------------------------
-- Packs: a named preset bundling everything currently worn.
-- Each pack is a real, usable ESX item ('pack_<id>').
-- ------------------------------------------------------------
RegisterServerEvent('sun-clothe:createPack')
AddEventHandler('sun-clothe:createPack', function(label)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or not label or label == '' then return end

    loadWorn(xPlayer.identifier, function(worn)
        if not next(worn) then
            TriggerClientEvent('esx:showNotification', src, 'Hich Lebasi Pushide Nashode !')
            return
        end

        exports.litesql:insert('INSERT INTO player_clothe_packs (identifier, label, contents) VALUES (@id, @label, @contents)', {
            ['@id'] = xPlayer.identifier,
            ['@label'] = label,
            ['@contents'] = json.encode(worn)
        }, function(packId)
            if not packId then return end
            local itemName = 'pack_' .. packId
            TriggerEvent('esx:CreateItem', itemName, label, -1, false, true)
            ESX.RegisterUsableItem(itemName, function(playerId)
                local usingPlayer = ESX.GetPlayerFromId(playerId)
                if not usingPlayer then return end
                usingPlayer.removeInventoryItem(itemName, 1)

                exports.litesql:fetch('SELECT contents FROM player_clothe_packs WHERE pack_id = @pid', {
                    ['@pid'] = packId
                }, function(result)
                    if not result or not result[1] then return end
                    local ok, contents = pcall(json.decode, result[1].contents or '{}')
                    if not ok then return end

                    loadWorn(usingPlayer.identifier, function(worn)
                        for clotheType, wornItemName in pairs(contents) do
                            -- only re-equip pieces the player still actually owns
                            local item = usingPlayer.getInventoryItem(wornItemName)
                            if item and item.count > 0 then
                                worn[clotheType] = wornItemName
                            end
                        end
                        saveWorn(usingPlayer.identifier, worn)
                        TriggerClientEvent('sun-clothe:appearanceUpdated', playerId, worn)
                    end)
                end)
            end)

            xPlayer.addInventoryItem(itemName, 1)
            TriggerClientEvent('esx:showNotification', src, 'Pack Sakhte Shod !')
        end)
    end)
end)

-- so packs a player already owns from a previous session still work
-- after a resource restart (usable-item registration is in-memory only)
CreateThread(function()
    Citizen.Wait(2000)
    exports.litesql:fetch('SELECT pack_id, label FROM player_clothe_packs', {}, function(result)
        if not result then return end
        for _, row in ipairs(result) do
            local itemName = 'pack_' .. row.pack_id
            TriggerEvent('esx:CreateItem', itemName, row.label or itemName, -1, false, true)
            ESX.RegisterUsableItem(itemName, function(playerId)
                local usingPlayer = ESX.GetPlayerFromId(playerId)
                if not usingPlayer then return end
                usingPlayer.removeInventoryItem(itemName, 1)

                exports.litesql:fetch('SELECT contents FROM player_clothe_packs WHERE pack_id = @pid', {
                    ['@pid'] = row.pack_id
                }, function(res2)
                    if not res2 or not res2[1] then return end
                    local ok, contents = pcall(json.decode, res2[1].contents or '{}')
                    if not ok then return end

                    loadWorn(usingPlayer.identifier, function(worn)
                        for clotheType, wornItemName in pairs(contents) do
                            local item = usingPlayer.getInventoryItem(wornItemName)
                            if item and item.count > 0 then
                                worn[clotheType] = wornItemName
                            end
                        end
                        saveWorn(usingPlayer.identifier, worn)
                        TriggerClientEvent('sun-clothe:appearanceUpdated', playerId, worn)
                    end)
                end)
            end)
        end
    end)
end)

ESX.RegisterServerCallback('sun-clothe:getPackLabels', function(source, cb, packIds)
    if not packIds or #packIds == 0 then cb({}) return end
    local placeholders = {}
    local params = {}
    for i, id in ipairs(packIds) do
        placeholders[i] = '@p' .. i
        params['@p' .. i] = id
    end
    exports.litesql:fetch('SELECT pack_id, label FROM player_clothe_packs WHERE pack_id IN (' .. table.concat(placeholders, ',') .. ')', params, function(result)
        local labels = {}
        for _, row in ipairs(result or {}) do
            labels[row.pack_id] = row.label
        end
        cb(labels)
    end)
end)
