ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("unique_rent:pay")
AddEventHandler("unique_rent:pay", function(amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local Money = xPlayer.money 
    
    if Money >= amount then
        xPlayer.removeMoney(amount) 
        TriggerClientEvent("esx:showNotification", source, "You paid ~g~" .. amount .. "~w~$ to rent the vehicle.")
    else
        TriggerClientEvent("esx:showNotification", source, "You don't have enough money.")
    end
end)

ESX.RegisterServerCallback("unique_rent:check", function(source, cb, amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local Money = xPlayer.money 
    
    if Money >= amount then
        cb(true)
    else
        cb(false)
        TriggerClientEvent("esx:showNotification", source, "You don't have enough money.")
    end
end)


-- function FindVehicleByPlate(plate)
RegisterServerEvent('unique_rent:deleteveh')
AddEventHandler('unique_rent:deleteveh', function(plate)
    local allVehicles = GetGamePool('CVehicle')

    for _, vehicle in ipairs(allVehicles) do
        local vehiclePlate = GetVehicleNumberPlateText(vehicle) 
        if vehiclePlate == plate then 
            DeleteEntity(vehicle)
            return vehicle 
        end
    end
    return nil 
end)
   
-- end


RegisterCommand('rrr', function(source, args)




end)