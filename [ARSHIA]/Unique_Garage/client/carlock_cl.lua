-- ESX is already initialized globally by client.lua; no need to re-fetch it here.
local DisableOnKey = false
local hotwireActive = {} 
local showHotwireText = false
local canHotwireVehicle = false
local hotwireText = "~r~[H] ~w~Baraye Pich Goshti Kardan"

CreateThread(function()
    while ESX == nil do Citizen.Wait(100) end
    while true do
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        local plate = vehicle ~= 0 and GetVehicleNumberPlateText(vehicle) or nil

        if vehicle ~= 0 then 
            if GetPedInVehicleSeat(vehicle, -1) == ped then
                ESX.TriggerServerCallback('CarLock:haskey', function(haskey)
                    if not haskey and not (plate and hotwireActive[plate]) then
                        SetVehicleLights(vehicle, false)
                        BringVehicleToHalt(vehicle, 0, 1000, false)
                        DisableOnKey = true
                        showHotwireText = true
                        canHotwireVehicle = true
                    else
                        DisableOnKey = false 
                        StopBringVehicleToHalt(vehicle)
                        showHotwireText = false
                        canHotwireVehicle = false
                    end
                end, plate)
            else 
                Wait(2000)
                showHotwireText = false
                canHotwireVehicle = false
            end
        else 
            Wait(2000)
            showHotwireText = false
            canHotwireVehicle = false
        end 
        Wait(3000) 
    end
end)


CreateThread(function()
    while true do
        if showHotwireText then
            SetTextFont(4)
            SetTextScale(0.7, 0.7)
            SetTextColour(255, 255, 255, 255)
            SetTextOutline()
            SetTextCentre(true)
            BeginTextCommandDisplayText("STRING")
            AddTextComponentSubstringPlayerName(hotwireText)
            EndTextCommandDisplayText(0.5, 0.9)
        end
        Wait(0)
    end
end)


function UseHotwireKit()
    if not canHotwireVehicle then
        return
    end

    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if vehicle == 0 then
        SafeNotify("~r~Shoma Savar Mashin nistid")
        return
    end
    
    local plate = GetVehicleNumberPlateText(vehicle)
    local globalplate = string.gsub(plate, "%s+", "")  
    
    local prefix3 = string.upper(string.sub(globalplate, 1, 3)) 
    local prefix2 = string.upper(string.sub(globalplate, 1, 2))  
    
    local restrictedPrefixes = {
        ["FBI"] = true,  
        ["PD"] = true,   
        ["MT"] = true,
        ["SH"] = true,
        ["TX"] = true,
        ["MD"] = true,
        ["MC"] = true,
        ["WZ"] = true
    }
    
    if restrictedPrefixes[prefix3] or restrictedPrefixes[prefix2] then
        SafeNotify("~r~Nemitanid in mashin ra hotwire konid!")
        return
    end

    ESX.TriggerServerCallback('CarLock:hasHotwireItem', function(hasItem)
        if not hasItem then
            SafeNotify("~r~Shoma Pich Goshti Nadarid!")
            return
        end
        
        local success = lib.skillCheck(
            {'easy', 'easy', {areaSize = 60, speedMultiplier = 2}, 'hard'}, 
            {'w', 'a', 's', 'd'}
        )
        
        if success then
            TriggerServerEvent('CarLock:useHotwireKit')
            SafeNotify("~g~Mashin ba movafaghiat roshan shod!")
        else
            SafeNotify("~r~Pich Goshti Shekast!")
        end
    end)
end

RegisterNetEvent('CarLock:enableVehicleTemporarily')
AddEventHandler('CarLock:enableVehicleTemporarily', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    local plate = vehicle ~= 0 and GetVehicleNumberPlateText(vehicle) or nil
    
    if not plate then return end
    
    hotwireActive[plate] = true 
    showHotwireText = false 

    DisableOnKey = false
    StopBringVehicleToHalt(vehicle)
    SetVehicleEngineOn(vehicle, true, false, false)
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        
        if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped then
            if IsControlJustReleased(0, 74) and showHotwireText then -- فقط وقتی متن نمایش داده می‌شود فعال شود
                UseHotwireKit()
            end
        else
            Citizen.Wait(1000)
        end
    end
end)


function unlockVehicle(vehicle)
    local ply = PlayerPedId()
    local vehicleModel = GetEntityModel(vehicle)
    local vehicleName = GetDisplayNameFromVehicleModel(vehicleModel)
    local vehicleLabel = GetLabelText(vehicleName)
    local plate = GetVehicleNumberPlateText(vehicle)

    if IsPedInAnyVehicle(ply, true) then
        SetVehicleDoorsLocked(vehicle, 1)
        SetVehicleAlarm(vehicle, 0)
        SafeNotify("~w~Shoma Dar ~b~" .. vehicleLabel .. " ~w~(" .. plate .. ") ~w~Ra ~g~Baz ~w~Kardid!")
        lockStatus = 1
        TriggerEvent('InteractSound_CL:PlayOnOne' , 'unlock', 1.0)
    else
        playAnimation(false)
        SetVehicleDoorsLocked(vehicle, 1)
        SetVehicleAlarm(vehicle, 0)
        SafeNotify("~w~Shoma Dar ~b~" .. vehicleLabel .. " ~w~(" .. plate .. ") ~w~Ra ~g~Baz ~w~Kardid!")
        lockStatus = 1
    end
end



function lockVehicle(vehicle)
    local ply = PlayerPedId()
    local vehicleModel = GetEntityModel(vehicle)
    local vehicleName = GetDisplayNameFromVehicleModel(vehicleModel)
    local vehicleLabel = GetLabelText(vehicleName)
    local plate = GetVehicleNumberPlateText(vehicle)

    if IsPedInAnyVehicle(ply, true) then
        SetVehicleDoorsLocked(vehicle, 2)
        SafeNotify("~w~Shoma Dar ~b~" .. vehicleLabel .. " ~w~(" .. plate .. ") ~w~Ra ~r~Gofl ~w~Kardid!")
        lockStatus = 2
        TriggerEvent('InteractSound_CL:PlayOnOne' , 'lock', 1.0)
    else
        playAnimation(true)
        SetVehicleDoorsLocked(vehicle, 2)
        SafeNotify("~w~Shoma Dar ~b~" .. vehicleLabel .. " ~w~(" .. plate .. ") ~w~Ra ~r~Gofl ~w~Kardid!")
        lockStatus = 2
    end
end



function getVehicleNetId(vehID)
	return NetToVeh(NetworkGetNetworkIdFromEntity(vehID))
end

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, PlayerPedId(), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

function playAnimation(lock)
	local ply = PlayerPedId()
	local lib = "anim@mp_player_intmenu@key_fob@"
	local anim = "fob_click"
	-- lock.ogg

	ESX.Streaming.RequestAnimDict(lib, function()
		if lock then 
			TriggerEvent('InteractSound_CL:PlayOnOne' , 'lock', 1.0)
		else 
			TriggerEvent('InteractSound_CL:PlayOnOne' , 'unlock', 1.0)
		end 
		TaskPlayAnim(ply, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
	end)
end

RegisterCommand("uniquegarage_carlock_toggle", function()
	local ply = PlayerPedId()
	if (IsPedInAnyVehicle(ply, true)) and GetPedInVehicleSeat(GetVehiclePedIsIn(ply, false), -1) == ply then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		local plate = GetVehicleNumberPlateText(vehicle)
		ESX.TriggerServerCallback('CarLock:haskey', function(result)
			if result then
				lockStatus     = GetVehicleDoorLockStatus(vehicle)
				if lockStatus == 2 then
					unlockVehicle(vehicle)
				else
					lockVehicle(vehicle)
				end
			end
		end, plate)
	else
		local coordA = GetEntityCoords(ply, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(ply, 0.0, 8.0, 0.0)
		
		local vehicle = ESX.Game.GetClosestVehicle(coordA)
		local vehicleDistance = #(GetEntityCoords(ply) - GetEntityCoords(vehicle))
		local plate = GetVehicleNumberPlateText(vehicle)
		if vehicle and vehicleDistance <= 10.0 then
			ESX.TriggerServerCallback('CarLock:haskey', function(result)
				if result then
					lockStatus     = GetVehicleDoorLockStatus(vehicle)
					if lockStatus == 2 then
						unlockVehicle(vehicle)
					else
						lockVehicle(vehicle)
					end
			
					
				end
			end, plate)
		else
			SafeNotify("Mashin Nazdik Shoma Nist")
		end
	end
end)
-- Native FiveM key binding (no external "keys"/onKeyDown resource needed; players can rebind this in Settings > Key Bindings > FiveM).
RegisterKeyMapping("uniquegarage_carlock_toggle", "Lock/Unlock nearby vehicle", "keyboard", Customize.Hotkey or "U")


RegisterCommand("keys", function()
	TriggerEvent("CarLock:RefreshKeys")
end)

RegisterNetEvent("CarLock:RefreshKeys")
AddEventHandler("CarLock:RefreshKeys", function()
	local KYES = {}
    for vehicle in CarLock_EnumerateVehicles() do
        Plate = GetVehicleNumberPlateText(vehicle)
		if DoesEntityExist(vehicle) then
			table.insert(KYES,("CarKey|"..ESX.Math.Trim(Plate)))
		end
    end
	TriggerServerEvent("CarLock:CheckKeys", KYES)
end)

local carLockEntityEnumerator = {
    __gc = function(enum)
    if enum.destructor and enum.handle then
      enum.destructor(enum.handle)
    end
    enum.destructor = nil
    enum.handle = nil
  end
}

local function CarLock_EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
		  disposeFunc(iter)
		  return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, carLockEntityEnumerator)

		local next = true
		repeat
		  coroutine.yield(id)
		  next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function CarLock_EnumerateVehicles()
	return CarLock_EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end
RegisterNetEvent('givekey_Cl')
AddEventHandler('givekey_Cl',function(target)
	GiveCarkey(target)
end)
function GiveCarkey(target)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, true)
	local plate = GetVehicleNumberPlateText(vehicle)
	if not IsPedInAnyVehicle(ped) then return SafeNotify('~r~ Zamani Ke Savar Mashin Hastid mitvanid Give Key Konid') end 
	if not vehicle then return SafeNotify('~r~ Mashin Peyda Nashod') end 
	if #(GetEntityCoords(vehicle)  - GetEntityCoords(ped)    ) > 15.0 then return SafeNotify('~r~ Fasle Shoma Ba Akharin Mashin Ke Savar Shodid Besyar Zeyad Ast') end 
	--ESX.TriggerServerCallback('CarLock:haskey', function(haskey)
	--	if haskey then 
		--	TriggerServerEvent('CarLock:ToggleKey', false ,plate )
			TriggerServerEvent('CarLock:ToggleKey2', true ,plate , target )
	--	else 
	--		SafeNotify('~r~Klid Mashin ke Akharin Bar Savar Shodid Ra Nadarid')
--		end 
--	end, plate)
end
-- Citizen.CreateThread(function()
-- 	local isRadarExtended =false 
-- 	AddEventHandler('onKeyDown',function(key)
-- 		if key == 'z' then -- 20 is z
	
-- 			if not isRadarExtended then
-- 				SetRadarBigmapEnabled(true, false)
			
-- 				isRadarExtended = true
-- 			elseif isRadarExtended then
-- 				SetRadarBigmapEnabled(false, false)
				
-- 				isRadarExtended = false
-- 			end
-- 		end
-- 	end)
-- end)
