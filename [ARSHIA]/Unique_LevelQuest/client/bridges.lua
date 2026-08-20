

local ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local onDutyJobs = {
    police       = 'quest-police:onduty',
    sheriff      = 'quest-sheriff:onduty',
    metropolitan = 'quest-metropolitan:onduty',
    ambulance    = 'quest-ambulance:onduty',
    mechanic     = 'quest-mechanic:onduty',
    taxi         = 'quest-taxi:onduty',
}

RegisterNetEvent('esx:givesalary')
AddEventHandler('esx:givesalary', function()
    if not ESX then return end
    local playerData = ESX.GetPlayerData()
    local job = playerData and playerData.job and playerData.job.name
    local trig = job and onDutyJobs[job]
    if trig then
        TriggerServerEvent(trig)
    end
    if job and Config.TrackedJobs[job] then
        TriggerServerEvent('skill-track:tick')
    end
end)

RegisterNetEvent('esx_ambulancejob:acceptreq')
AddEventHandler('esx_ambulancejob:acceptreq', function()
    TriggerServerEvent('quest-ambulance:acceptreq')
end)

RegisterNetEvent('esx_mechanicjob:acceptreq')
AddEventHandler('esx_mechanicjob:acceptreq', function()
    TriggerServerEvent('quest-mechanic:acceptreq')
end)

RegisterNetEvent('esx_taxijob:acceptreq')
AddEventHandler('esx_taxijob:acceptreq', function()
    TriggerServerEvent('quest-taxi:acceptreq')
end)
