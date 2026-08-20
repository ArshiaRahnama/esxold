ESX = nil

CreateThread(function()
    MySQL.Async.execute("CREATE TABLE IF NOT EXISTS uwumarket(id int AUTO_INCREMENT, name varchar(100), amount int DEFAULT 1, weight varchar(10) DEFAULT '0', price varchar(10), owner varchar(100), identifier varchar(200), PRIMARY KEY(id))", {},
    function()
        MySQL.Async.fetchAll('SELECT * FROM uwumarket', {}, function(result)
            itens_market = result
        end)
    end)

    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(100)
    end
end)

function getIdentifier(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        return xPlayer.identifier
    end
end

function getName(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        return xPlayer.name:gsub("_", " ")
    end
end

function getBankMoney(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        return xPlayer.bank
    end
end

function addBankMoney(identifier, value)
    local xPlayer = ESX.GetPlayerFromIdentifier(identifier)

    if xPlayer then
        xPlayer.addBank(value)
    else
        local result = MySQL.Sync.fetchAll('SELECT bank FROM users WHERE identifier = @identifier', {
            ["@identifier"] = identifier
        })
        if result[1] ~= nil then
            local account = json.decode(result[1].bank)
            account = account + value
            MySQL.Sync.execute("UPDATE users SET bank = @bank WHERE identifier = @identifier",{
                ["@identifier"] = identifier,
                ["@bank"] = (account)
            })
        end
    end
end

function removeBankMoney(source, value)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        xPlayer.removeBank(value)
    end
end

function canCarryItem(source, item, amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
		local xItem = xPlayer.getInventoryItem(item)
        return (xItem.count + amount <= xItem.limit)
    end
end

function getInventory(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        return xPlayer.inventory
    end
end

function addInventoryItem(source, item, amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        xPlayer.addInventoryItem(item, amount)
    end
end

function removeInventoryItem(source, item, amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        xPlayer.removeInventoryItem(item, amount)
    end
end

function filterInventory(source)
    local inventory = getInventory(source)
    local itens_filter = {}

    for i,k in pairs(inventory) do
        for j,c in pairs(list_products) do
            if k.label == c.label then
                k.name = c.label

                table.insert(itens_filter, {
                    name = c.label,
                    amount = k.count,
                    weight = k.weight
                })
            end
        end
    end

    return itens_filter
end

function getItemByLabel(source, label)
    local inventory = getInventory(source)

    for i,k in pairs(inventory) do
        if k.label == label then
            return k
        end
    end
end

function getFilterItemByLabel(label)
    for i,k in pairs(list_products) do
        if k.label == label then
            return k
        end
    end
end