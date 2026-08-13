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
	Citizen.Wait(3000)
	ESX.TriggerServerCallback('esx_spectate:getPlayerData', function(xPlayer)
        while not xPlayer do
            Citizen.Wait(10)
        end
        if xPlayer.rank == 0 then rank = 1 else rank = xPlayer.rank end
		print("Set Decor Shodam RoYe "..rank)
	    DecorSetInt(PlayerPedId(),'rank', rank)
    end,GetPlayerServerId(PlayerId()))
end)