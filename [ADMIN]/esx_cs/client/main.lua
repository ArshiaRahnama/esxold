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

ESX = nil
INPUT_CONTEXT = 51

local isSentenced = false
local communityServiceFinished = false
local actionsRemaining = 0
local availableActions = {}
local disable_actions = false
local _reason = 0

local vassoumodel = "prop_tool_broom"
local vassour_net = nil

local spatulamodel = "bkr_prop_coke_spatula_04"
local spatula_net = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end
end)


Citizen.CreateThread(function()
	Citizen.Wait(60000)
	TriggerServerEvent('esx_communityGGservice:checkIfSentenced')
end)


function FillActionTable(last_action)

	while #availableActions < 5 do

		local service_does_not_exist = true

		local random_selection = Config.ServiceLocations[math.random(1,#Config.ServiceLocations)]

		for i = 1, #availableActions do
			if random_selection.coords.x == availableActions[i].coords.x and random_selection.coords.y == availableActions[i].coords.y and random_selection.coords.z == availableActions[i].coords.z then

				service_does_not_exist = false

			end
		end

		if last_action ~= nil and random_selection.coords.x == last_action.coords.x and random_selection.coords.y == last_action.coords.y and random_selection.coords.z == last_action.coords.z then
			service_does_not_exist = false
		end

		if service_does_not_exist then
			table.insert(availableActions, random_selection)
		end

	end

end


RegisterNetEvent('esx_communityGGservice:inCommunityService')
AddEventHandler('esx_communityGGservice:inCommunityService', function(actions_remaining)
	local playerPed = PlayerPedId()

	if isSentenced then
		return
	end

	actionsRemaining = actions_remaining

	FillActionTable()
	ApplyPrisonerSkin()
	ESX.Game.Teleport(playerPed, Config.ServiceLocation)
	isSentenced = true
	communityServiceFinished = false

	while actionsRemaining > 0 and communityServiceFinished ~= true do


		if IsPedInAnyVehicle(playerPed, false) then
			ClearPedTasksImmediately(playerPed)
		end

		Citizen.Wait(1000)

		if #(GetEntityCoords(playerPed) - vector3(Config.ServiceLocation.x, Config.ServiceLocation.y, Config.ServiceLocation.z)) > 45 then
			ESX.Game.Teleport(playerPed, Config.ServiceLocation)
			lib.notify({ position = 'center-right', title = '', description = _U('escape_attempt'), type = 'error', duration = 3000 })
			TriggerServerEvent('esx_communityGGservice:extendService')
			actionsRemaining = actionsRemaining + Config.ServiceExtensionOnEscape
		end

	end

	TriggerServerEvent('esx_communityGGservice:finishCommunityService', -1)
	ESX.Game.Teleport(playerPed, Config.ReleaseLocation)
	isSentenced = false

	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)
end)

RegisterNetEvent('esx_communityGGservice:inCommunityService_reason')
AddEventHandler('esx_communityGGservice:inCommunityService_reason', function(reason)
	_reason = reason

end)


RegisterNetEvent('esx_communityGGservice:finishCommunityService')
AddEventHandler('esx_communityGGservice:finishCommunityService', function(source)
	communityServiceFinished = true
	isSentenced = false
	actionsRemaining = 0
end)



Citizen.CreateThread(function()
	while true do
		:: start_over ::
		Citizen.Wait(1)

		if actionsRemaining > 0 and isSentenced then
			draw2dText("Punishment : ~g~"..ESX.Math.Round(actionsRemaining), { 0.460, 0.930 } )
			draw2dText( "Punishment Reason : ~r~".._reason, { 0.460, 0.960 } )
			DrawAvailableActions()
			DisableViolentActions()
			local pCoords    = GetEntityCoords(PlayerPedId())

			for i = 1, #availableActions do
				local distance = #(pCoords - availableActions[i].coords)

				if distance < 1.5 then
					DisplayHelpText("Dokme ~INPUT_CONTEXT~ Jahat Anjam Kar")


					if(IsControlJustReleased(1, 38))then
						tmp_action = availableActions[i]
						RemoveAction(tmp_action)
						FillActionTable(tmp_action)
						disable_actions = true

						TriggerServerEvent('esx_communityGGservice:completeService')
						actionsRemaining = actionsRemaining - 1

						if (tmp_action.type == "cleaning") then
							local cSCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
							local vassouspawn = CreateObject(GetHashKey(vassoumodel), cSCoords.x, cSCoords.y, cSCoords.z, 1, 1, 1)
							local netid = ObjToNet(vassouspawn)

							ESX.Streaming.RequestAnimDict("amb@world_human_janitor@male@idle_a", function()
									TaskPlayAnim(PlayerPedId(), "amb@world_human_janitor@male@idle_a", "idle_a", 8.0, -8.0, -1, 0, 0, false, false, false)
									AttachEntityToEntity(vassouspawn,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422),-0.005,0.0,0.0,360.0,360.0,0.0,1,1,0,1,0,1)
									vassour_net = netid
								end)

								ESX.SetTimeout(10000, function()
									disable_actions = false
									DetachEntity(NetToObj(vassour_net), 1, 1)
									DeleteEntity(NetToObj(vassour_net))
									vassour_net = nil
									ClearPedTasks(PlayerPedId())
								end)

						end

						if (tmp_action.type == "gardening") then
							local cSCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
							local spatulaspawn = CreateObject(GetHashKey(spatulamodel), cSCoords.x, cSCoords.y, cSCoords.z, 1, 1, 1)
							local netid = ObjToNet(spatulaspawn)
							
							TaskStartScenarioInPlace(PlayerPedId(), "world_human_gardener_plant", 0, false)
							AttachEntityToEntity(vassouspawn,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422),-0.005,0.0,0.0,360.0,360.0,0.0,1,1,0,1,0,1)
							spatula_net = netid

							ESX.SetTimeout(14000, function()
								disable_actions = false
								DetachEntity(NetToObj(spatula_net), 1, 1)
								DeleteEntity(NetToObj(spatula_net))
								spatula_net = nil
								ClearPedTasks(PlayerPedId())
							end)
						end

						goto start_over
					end
				end
			end
		else
			Citizen.Wait(100)
		end
	end
end)


function RemoveAction(action)

	local action_pos = -1

	for i=1, #availableActions do
		if action.coords.x == availableActions[i].coords.x and action.coords.y == availableActions[i].coords.y and action.coords.z == availableActions[i].coords.z then
			action_pos = i
		end
	end

	if action_pos ~= -1 then
		table.remove(availableActions, action_pos)
	else
		--print("User tried to remove an unavailable action")
	end

end


function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end


function DrawAvailableActions()

	for i = 1, #availableActions do
--{ r = 50, g = 50, b = 204 }
		--DrawMarker(21, Config.ServiceLocations[i].coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 100, false, true, 2, true, false, false, true)
		DrawMarker(21, availableActions[i].coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 50, 50, 204, 100, false, true, 2, true, false, false, false)

		--DrawMarker(20, Config.ServiceLocations[i].coords, -1, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 162, 250, 80, true, true, 2, 0, 0, 0, 0)
	end

end


function DisableViolentActions()

	local playerPed = PlayerPedId()

	if disable_actions == true then
		DisableAllControlActions(0)
		EnableControlAction(0, Keys['N'], true)
	end

	--RemoveAllPedWeapons(playerPed, true)

	DisableControlAction(2, 37, true) -- disable weapon wheel (Tab)
	DisablePlayerFiring(playerPed,true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
    DisableControlAction(0, 106, true) -- Disable in-game mouse controls
    DisableControlAction(0, 140, true)
	DisableControlAction(0, 141, true)
	DisableControlAction(0, 142, true)
	DisableControlAction(0, 170, true)
	DisableControlAction(2, 24, true) -- Attack
	DisableControlAction(2, 257, true) -- Attack 2
	DisableControlAction(2, 25, true) -- Aim
	DisableControlAction(2, 263, true) -- Melee Attack 1
	DisableControlAction(2, Keys['~'], true) -- HandsUP
	DisableControlAction(2, Keys['X'], true) -- HandsUP
	DisableControlAction(2, Keys['ESC'], true)
	DisableControlAction(2, Keys['F6'], true)
	DisableControlAction(2, Keys['ENTER'], true)
	DisableControlAction(2, Keys['LEFTSHIFT'], true) -- HandsUP
	DisableControlAction(2, Keys['R'], true) -- Reload
	DisableControlAction(2, Keys['TOP'], true) -- Open phone (not needed?)
	DisableControlAction(2, Keys['TAB'], true) -- weapon
	DisableControlAction(2, Keys['SPACE'], true) -- Jump
	DisableControlAction(2, Keys['Q'], true) -- Cover
	DisableControlAction(0, Keys['PAGEUP'], true) -- vehicle
	DisableControlAction(0, Keys['K'], true) --lebas
	DisableControlAction(2, Keys['TAB'], true) -- Select Weapon
	DisableControlAction(2, Keys['F'], true) -- Also 'enter'?
	DisableControlAction(2, Keys['F1'], true) -- Disable phone
	DisableControlAction(2, Keys['F2'], true) -- Inventory
	DisableControlAction(2, Keys['F3'], true) -- Animations
	DisableControlAction(2, Keys['F5'], true)
	DisableControlAction(2, Keys['F8'], true)
	DisableControlAction(2, Keys['H'], true)
	DisableControlAction(2, Keys['M'], true)
	DisableControlAction(2, Keys['V'], true) -- Disable changing view
	DisableControlAction(2, Keys['P'], true) -- Disable pause screen
	DisableControlAction(2, 59, true) -- Disable steering in vehicle
	DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth
	DisableControlAction(0, 47, true)  -- Disable weapon
	DisableControlAction(0, 264, true) -- Disable melee
	DisableControlAction(0, 257, true) -- Disable melee
	DisableControlAction(0, 140, true) -- Disable melee
	DisableControlAction(0, 141, true) -- Disable melee
	DisableControlAction(0, 142, true) -- Disable melee
	DisableControlAction(0, 143, true) -- Disable melee
	DisableControlAction(0, 19, true) -- Disable melee
	DisableControlAction(0, 75, true)  -- Disable exit vehicle
	DisableControlAction(27, 75, true) -- Disable exit vehicle
	DisableControlAction(0, 27, true) -- Disable exit vehicle
	DisableControlAction(0, 142, true) -- MeleeAttackAlternate
	DisableControlAction(0, 24,  true) -- Shoot 
	DisableControlAction(0, 92,  true) -- Shoot in car
	DisableControlAction(0, 75,  true) -- Leave Vehicle
	SetPlayerCanDoDriveBy(playerPed, false)
	SetCurrentPedWeapon(playerPed,GetHashKey("WEAPON_UNARMED"),true)

	if IsDisabledControlJustPressed(2, 37) then --if Tab is pressed, send error message
		SetCurrentPedWeapon(playerPed,GetHashKey("WEAPON_UNARMED"),true) -- if tab is pressed it will set them to unarmed (this is to cover the vehicle glitch until I sort that all out)
	end

	if IsDisabledControlJustPressed(0, 106) then --if LeftClick is pressed, send error message
		SetCurrentPedWeapon(playerPed,GetHashKey("WEAPON_UNARMED"),true) -- If they click it will set them to unarmed
	end
		

end


function ApplyPrisonerSkin()

	local playerPed = PlayerPedId()

	if DoesEntityExist(playerPed) then

		Citizen.CreateThread(function()

			TriggerEvent('skinchanger:getSkin', function(skin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['prison_wear'].male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['prison_wear'].female)
				end
			end)

			SetPedArmour(playerPed, 0)
			ClearPedBloodDamage(playerPed)
			ResetPedVisibleDamage(playerPed)
			ClearPedLastWeaponDamage(playerPed)
			ResetPedMovementClipset(playerPed, 0)

		end)
	end
end


function draw2dText(text, pos)
	-- SetTextFont(5)
	SetTextProportional(1)
	SetTextScale(0.45, 0.3)
	SetTextColour(255, 255, 255, 255)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(table.unpack(pos))
end


AddEventHandler("playerSpawned", function()
	while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    Citizen.Wait(15000)
    TriggerServerEvent("checkCommunityService")
end)

RegisterNetEvent("teleportToCommunityService")
AddEventHandler("teleportToCommunityService", function()
    SetEntityCoords(PlayerPedId(), ServiceLocation.x, ServiceLocation.y, ServiceLocation.z)
end)
