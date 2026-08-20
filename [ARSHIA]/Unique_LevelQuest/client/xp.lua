local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    Citizen.Wait(1000)
    TriggerServerEvent('XP_System:setMyDecor')
end)

RegisterNetEvent('XP_System:SetDecor')
AddEventHandler('XP_System:SetDecor', function(rank)
    rank = tonumber(rank) or 1
    if rank < 1 then rank = 1 end
    DecorSetInt(PlayerPedId(), 'rank', rank)
end)
