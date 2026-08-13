ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}
local HasAlreadyEnteredMarker = false
local CurrentQuestLocation = nil
local MenuOpen = false
local Peds = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(10)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
    TriggerServerEvent("QuestSystem:InitializePlayer")
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    PlayerData.gang = gang
end)


RegisterNetEvent('QuestSystem:AddCoin')
AddEventHandler('QuestSystem:AddCoin', function(coin)
    TriggerServerEvent(Config.AddCoinTrigger, coin)
end)



RegisterNetEvent('QuestSystem:trigquest')
AddEventHandler('QuestSystem:trigquest', function(name)
	
	if string.lower(name) == 'onduty' then
		TriggerServerEvent('quest-police:onduty')
        TriggerServerEvent('quest-sheriff:onduty')
        TriggerServerEvent('quest-metropolitan:onduty')
        TriggerServerEvent('quest-ambulance:onduty')
        TriggerServerEvent('quest-mechanic:onduty')
	elseif string.lower(name) == 'acceptrob' then
		TriggerServerEvent('quest-police:acceptrob')
        TriggerServerEvent('quest-sheriff:acceptrob')
        TriggerServerEvent('quest-metropolitan:acceptrob')
    elseif string.lower(name) == 'accrequest' then
		TriggerServerEvent('quest-ambulance:acceptreq')
    elseif string.lower(name) == 'accrequestmc' then
		TriggerServerEvent('quest-mechanic:acceptreq')
	end
end)