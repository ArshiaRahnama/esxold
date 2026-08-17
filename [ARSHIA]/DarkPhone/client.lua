local ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('DarkPhone:OpenMenu')
AddEventHandler('DarkPhone:OpenMenu', function()
	ESX.UI.Menu.CloseAll()
    local elements = {}
    table.insert(elements, {label = "Gerogan Giri", value = 'Hostage'})
    table.insert(elements, {label = "Shorooe Pursuit", value = 'Pursuit'})
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'DarkPhone_Menu', {
		title    = 'Dark Phone Menu',
		align    = 'left',
		elements = elements
	}, function(data, menu)
		menu.close()
		local action = data.current.value
		if action == "Hostage" then
            local coords = GetEntityCoords(PlayerPedId()) 
            TriggerServerEvent("DarkPhone:StartHostage",coords)
        elseif  action == "Pursuit" then
            local coords = GetEntityCoords(PlayerPedId()) 
            TriggerServerEvent("DarkPhone:StartPursuit",coords)
        end
	end, function(data, menu)
		menu.close()
	end)
end)

-- ==================================== Hostage ===========================================

local hostageblip = nil
RegisterNetEvent('DarkPhone:killBlipHostage')
AddEventHandler('DarkPhone:killBlipHostage', function()
	RemoveBlip(hostageblip)
    hostageblip = nil
end)

RegisterNetEvent('DarkPhone:setBlipHostage')
AddEventHandler('DarkPhone:setBlipHostage', function(position)
    hostageblip = AddBlipForCoord(position.x, position.y, position.z)
	SetBlipSprite(hostageblip, 161)
	SetBlipScale(hostageblip, 0.7)
	SetBlipColour(hostageblip, 15)

	PulseBlip(hostageblip)
end)

RegisterNetEvent('DarkPhone:CheckDistance')
AddEventHandler('DarkPhone:CheckDistance', function(coords)
    local canceled = false
    local timer = Config.Hostage.SuccessTime * 1000
    Citizen.CreateThread(function()
        while timer > 0 do
            Citizen.Wait(1000)
            local playerPos = GetEntityCoords(PlayerPedId(), true)
            local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, coords.x, coords.y, coords.z)
            if distance > Config.Hostage.CancelDistance then
                canceled = true
                TriggerServerEvent("DarkPhone:CancelHostage")
                timer = 0
            end
            timer = timer - 1000
        end
        if not canceled then
            TriggerServerEvent("DarkPhone:SuccessHostage")
        end
    end)
end)

-- ==================================== Pursuit ===========================================

local PursuitBlip = nil

RegisterNetEvent('DarkPhone:setBlipPursuit')
AddEventHandler('DarkPhone:setBlipPursuit', function(position,id)
    PursuitBlip = AddBlipForCoord(position.x, position.y, position.z)
	SetBlipSprite(PursuitBlip, 225)
	SetBlipScale(PursuitBlip, 0.7)
	SetBlipColour(PursuitBlip, 1)
	PulseBlip(PursuitBlip)
    -- SetBlipFlashTimer(PursuitBlip, 5000)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName('Pursuit Car')
	EndTextCommandSetBlipName(PursuitBlip)
    while PursuitBlip do
        Citizen.Wait(2000)
        ESX.TriggerServerCallback('DarkPhone:getcoord', function(coords)
            if coords ~= nil then
                SetBlipCoords(PursuitBlip,coords)
            else
                RemoveBlip(PursuitBlip)
                PursuitBlip = nil
            end
        end,id)
    end
end)

RegisterNetEvent('DarkPhone:killBlipPursuit')
AddEventHandler('DarkPhone:killBlipPursuit', function()
	RemoveBlip(PursuitBlip)
    PursuitBlip = nil
end)

RegisterNetEvent('DarkPhone:StartProgressBar')
AddEventHandler('DarkPhone:StartProgressBar', function()
    TriggerEvent('mythic_progbar:client:progress', {
        name = 'Pursuit',
        duration = Config.Pursuit.SuccessTime * 1000,
        label = 'Pursuit',
        useWhileDead = false,
        canCancel = false,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = false,
        }
    }, function(status)
        if not status then
            TriggerServerEvent('DarkPhone:SuccessPursuit')
        end
    end)
end)