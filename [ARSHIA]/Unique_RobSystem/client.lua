local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
local blipRobbery ={}
local RobsBlip ={}
local ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)    

Citizen.CreateThread(function()
    for name,things in pairs(Config.Robs) do
        RobsBlip[name] = AddBlipForCoord(things.position.x, things.position.y, things.position.z)

        SetBlipSprite (RobsBlip[name], Config.RobTypes[Config.Robs[name].type].blipsprite)
        SetBlipDisplay(RobsBlip[name], 4)
        SetBlipScale  (RobsBlip[name], 0.8)
        SetBlipColour (RobsBlip[name], 2)
        SetBlipAsShortRange(RobsBlip[name], true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Robs[name].type)
        EndTextCommandSetBlipName(RobsBlip[name])
    end
end)

Citizen.CreateThread(function()
	while true do
        for name,things in pairs(Config.Robs) do
            if Config.Robs[name].available then
                SetBlipColour (RobsBlip[name], 2)
            else
                SetBlipColour (RobsBlip[name], 1)
            end
        end
		Citizen.Wait(1000)
	end
end)


RegisterNetEvent('Morphy_RobSystem:SetMarker')
AddEventHandler('Morphy_RobSystem:SetMarker', function (name, state)
    Config.Robs[name].available = state
end)

RegisterNetEvent('Morphy_RobSystem:killBlip')
AddEventHandler('Morphy_RobSystem:killBlip', function(name)
	RemoveBlip(blipRobbery[name])
    blipRobbery[name] = nil
end)

RegisterNetEvent('Morphy_RobSystem:setBlip')
AddEventHandler('Morphy_RobSystem:setBlip', function(name,position)

    blipRobbery[name] = AddBlipForCoord(position.x, position.y, position.z)
	SetBlipSprite(blipRobbery[name], 161)
	SetBlipScale(blipRobbery[name], 2.0)
	SetBlipColour(blipRobbery[name], 15)

	PulseBlip(blipRobbery[name])
end)

RegisterNetEvent('Morphy_RobSystem:StartProgressBar')
AddEventHandler('Morphy_RobSystem:StartProgressBar', function(name,RobberyCode)
    local timer = Config.RobTypes[Config.Robs[name].type].successtime * 1000
    Citizen.CreateThread(function()
        while timer > 0 do
            Citizen.Wait(1000)
            local playerPos = GetEntityCoords(PlayerPedId(), true)
            local robpos = Config.Robs[name].position
            local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, robpos.x, robpos.y, robpos.z)
            if distance > Config.RobTypes[Config.Robs[name].type].cancelDistance then
                TriggerEvent("mythic_progbar:client:cancel")
                timer = 0
                TriggerServerEvent('Morphy_RobSystem:robberyCancel', name)
            end
            timer = timer - 1000
        end
    end)
	TriggerEvent('mythic_progbar:client:progress', {
        name = 'Robbery',
        duration = Config.RobTypes[Config.Robs[name].type].successtime * 1000,
        label = 'Robbery',
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
            TriggerServerEvent('Morphy_RobSystem:robberySuccess', name,RobberyCode)
        end
    end)
end)

RegisterNetEvent('Morphy_RobSystem:StartHack')
AddEventHandler('Morphy_RobSystem:StartHack', function(robname,hacktype)
    if hacktype == 1 then
        exports['ps-ui']:VarHack(function(success)
            if success then
                TriggerServerEvent('Morphy_RobSystem:robberyStarted', robname)
            else
                TriggerServerEvent('Morphy_RobSystem:robberyHackFail', robname)
            end
        end, 5, 20)  -- Number of Blocks, Time in seconds
    elseif hacktype == 2 then
        exports['ps-ui']:Scrambler(function(success)
            if success then
                TriggerServerEvent('Morphy_RobSystem:robberyStarted', robname)
            else
                TriggerServerEvent('Morphy_RobSystem:robberyHackFail', robname)
            end
        end, "alphanumeric", 30, 0)  -- Type options: alphabet, numeric, alphanumeric, greek, braille, runes; Time in seconds; Mirrored options: 0, 1, 2
    else
        TriggerServerEvent('Morphy_RobSystem:robberyStarted', robname)
    end
    
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local playerPos = GetEntityCoords(PlayerPedId(), true)

		for k,v in pairs(Config.Robs) do
			local robpos = v.position
			local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, robpos.x, robpos.y, robpos.z)

			if distance < Config.Marker.DrawDistance then
                if v.available then
                    DrawMarker(Config.Marker.Type, robpos.x, robpos.y, robpos.z , 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, true, 2, false, false, false, false)
                else
                    DrawMarker(Config.Marker.Type, robpos.x, robpos.y, robpos.z , 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, 255, 0, 0, Config.Marker.a, false, true, 2, false, false, false, false)
                end
                if distance < 0.5 then
                    ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ To ~o~Rob~s~ ~b~'..v.nameofrob..'~s~')

                    if IsControlJustReleased(0, Keys['E']) then
                        if IsPedArmed(PlayerPedId(), 4) then
                            TriggerServerEvent('Morphy_RobSystem:robberyNeeds', k)
                        else
                            ESX.ShowNotification("Shoma Aslahe Dar Dast Nadarid !",'error')
                        end
                    end
                end
			end
		end
	end
end)

