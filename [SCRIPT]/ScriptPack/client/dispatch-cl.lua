ESX = nil
local PlayerData              = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('esx_dispatch:assignBadge')
AddEventHandler('esx_dispatch:assignBadge',function(label)
   if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "mt" or PlayerData.job.name == "fbi" or PlayerData.job.name == "cid" or PlayerData.job.name == "cia" or PlayerData.job.name == "marshal" or PlayerData.job.name == "judge" or PlayerData.job.name == "doa" then
        local id = PlayerId()
        TriggerServerEvent('esx_idoverhead:modifyLabel', id, label)
   end
end)