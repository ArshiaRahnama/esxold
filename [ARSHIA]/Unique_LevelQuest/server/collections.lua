

ESX.RegisterServerCallback("HUD_Menu:GetVehicles", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb({}) end

    MySQL.Async.fetchAll('SELECT plate, vehicle FROM owned_vehicles WHERE owner = @owner', {
        ['@owner'] = xPlayer.identifier
    }, function(result)
        local vehicles = {}
        for i = 1, #result do
            local ok, decoded = pcall(json.decode, result[i].vehicle)
            table.insert(vehicles, {
                plate = result[i].plate,
                model = ok and decoded and decoded.model or nil,
            })
        end
        cb(vehicles)
    end)
end)

ESX.RegisterServerCallback("HUD_Menu:GetHouses", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb({}) end

    MySQL.Async.fetchAll([[
        SELECT op.name, p.label
        FROM owned_properties op
        LEFT JOIN properties p ON p.name = op.name
        WHERE op.owner = @owner
    ]], {
        ['@owner'] = xPlayer.identifier
    }, function(result)
        local houses = {}
        for i = 1, #result do
            table.insert(houses, {
                name = result[i].label or result[i].name,
            })
        end
        cb(houses)
    end)
end)
