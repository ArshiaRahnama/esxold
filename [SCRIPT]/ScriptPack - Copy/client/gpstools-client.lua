ESX = nil
local isMinimapEnabled = false
local PlayerData = {}
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(50)
	end
	while ESX.GetPlayerData() == nil do
		Citizen.Wait(10)
	end
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('gpstools:setgps')
AddEventHandler('gpstools:setgps', function(pos)
	-- add required decimal or else it wont work
	pos.x = pos.x + 0.00
	pos.y = pos.y + 0.00

	SetNewWaypoint(pos.x, pos.y)
	ESX.ShowHelpNotification("Loc Set Shod")
end)

RegisterNetEvent('gpstools:getpos')
AddEventHandler('gpstools:getpos', function()
	local playerPed = PlayerPedId()

	local pos      = GetEntityCoords(playerPed)
	local heading  = GetEntityHeading(playerPed)
	local finalPos = {}

	-- round to 2 decimals
	finalPos.x = string.format("%.2f", pos.x)
	finalPos.y = string.format("%.2f", pos.y)
	finalPos.z = string.format("%.2f", pos.z)
	finalPos.h = string.format("%.2f", heading)

	local formattedText = "x = " .. finalPos.x .. ", y = " .. finalPos.y .. ", z = " .. finalPos.z .. ', h = ' .. finalPos.h
	TriggerEvent('chatMessage', 'SYSTEM', { 0, 0, 0 }, formattedText)
	print(formattedText)
end)

--[[RegisterNetEvent('gpstools:togglegps')
AddEventHandler('gpstools:togglegps', function()
	if not isMinimapEnabled then
		SetRadarBigmapEnabled(true, false)
		isMinimapEnabled = true
	else
		SetRadarBigmapEnabled(false, false)
		isMinimapEnabled = false
	end
end)]]

RegisterNetEvent('gpstools:tpwaypoint')
AddEventHandler('gpstools:tpwaypoint', function()
	local playerPed = PlayerPedId()
	if(IsPedInAnyVehicle(playerPed))then
		playerPed = GetVehiclePedIsUsing(playerPed)
	end
	local WaypointHandle = GetFirstBlipInfoId(8)
	if DoesBlipExist(WaypointHandle) then
		local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
		for height = 1, 1000 do
			SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
			local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)
			if foundGround then
				SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
				break
			end
			Citizen.Wait(1)
		end
		ESX.ShowNotification("Shoma be marker roye map teleport shodid!")
	else
		ESX.ShowNotification("Markeri baraye teleport shodan vojoud nadarad!")
	end
end)
Citizen.CreateThread(function()
	SetRadarBigmapEnabled(false, false)
end)
SetRadarDisabled = function()
	SetRadarBigmapEnabled(false, false)
	isMinimapEnabled = false
end

RegisterCommand('togglegps', function()
	if isMinimapEnabled then
		SetRadarBigmapEnabled(false, false)
		isMinimapEnabled = false
	else
		SetRadarBigmapEnabled(true, false)
		isMinimapEnabled = true
	end
end)

-- RegisterNetEvent('esx:playerLoaded')
-- AddEventHandler('esx:playerLoaded', function(xPlayer)
-- 	if xPlayer == nil then return Wait(1000) end
-- 	while IsPlayerSwitchInProgress() do return Citizen.Wait(5000) end
-- 	TriggerEvent('esx_gps:removeGPS')
-- 	Wait(1000)
-- 	for i=1, #ESX.PlayerData.inventory, 1 do
-- 		if ESX.PlayerData.inventory[i].name == 'gps' then
-- 			if ESX.PlayerData.inventory[i].count > 0 then
-- 				TriggerEvent('esx_gps:addGPS')
-- 			end
-- 		end
-- 	end
-- end)

-- RegisterNetEvent('esx_gps:addGPS')
-- AddEventHandler('esx_gps:addGPS', function()
-- 	DisplayRadar(true)
-- end)

-- RegisterNetEvent('esx_gps:removeGPS')
-- AddEventHandler('esx_gps:removeGPS', function()
-- 	DisplayRadar(false)
-- end)