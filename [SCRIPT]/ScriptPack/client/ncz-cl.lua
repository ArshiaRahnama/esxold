ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(50)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)
local blip = nil
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

local zone = { --ncz
	["Police"] = {x=445.90,y=-981.98,z=30.69,radius = 60.0, color = 1},
	["PoliceVienwood"] = {x = 622.2464, y = -2.20517, z = 82.778,radius = 60.0, color = 1},
	["Paintball"] = {x=-1616.26,y=5119.084,z=52.651,radius = 100.0, color = 1},
	["ParkingMarkazi"] = {x=240.20,y=-790.68,z=30.57,radius = 70.0, color = 1},
	["ParkingMarkazi2"] = {x = 209.5102, y = -856.532, z = 30.422,radius = 70.0, color = 1},
	["Medic"] = {x = 290.7337, y = -588.029, z = 43.188,radius = 60.0, color = 1},   
	["Sheriff"] = {x=-471.02,y =5993.68,z =31.34,radius = 60.0, color = 1},
	["Mechanic"] = {x = -373.6, y = -121.83, z = 38.69,radius = 65.0, color = 1},
	["UWUCafe"] = {x = -579.787, y = -1061.68, z = 22.347,radius = 65.0, color = 1},
	["Sheriff"] = {x = 1852.569, y = 3685.489, z = 34.286,radius = 50.0, color = 1},
}

local zoneMap = {-- blip map (dare sabz)
	["Base"] = {x = -115.583 , y = -919.272, z = 29.339, radius = 1500.0, color = 11},
	--["Hunt"] = {x = -624.914, y = 5085.085, z = 131.74, radius = 250.0, color = 11},   
}

local coords = {label = false,x=nil,y=nil,z=nil,radius=nil}

local WhitelistJobs = {
	 ["police"] = 'police',
	 ["sheriff"] = 'sheriff',
	 ["fbi"] = 'fbi',
	 ["mt"] = 'mt',
	 ["cid"] = 'cid',
	 ["cia"] = 'cia',
	 ["marshal"] = 'marshal',
	 ["judge"] = 'judge',
	 ["doa"] = 'doa',
}

local function RGBRainbow( frequency )
	local result = {}
	local curtime = GetGameTimer() / 1000

	result.r = math.floor( math.sin( curtime * frequency + 0 ) * 127 + 128 )
	result.g = math.floor( math.sin( curtime * frequency + 2 ) * 127 + 128 )
	result.b = math.floor( math.sin( curtime * frequency + 4 ) * 127 + 128 )
	
	return result
end

function GetOnlineActive(Entity)
	for _, id in ipairs(GetActivePlayers()) do
		if(Vdist(GetEntityCoords(GetPlayerPed(id)),coords.x,coords.y,coords.z) <= coords.radius) then
			SetEntityNoCollisionEntity(GetPlayerPed(id),Entity,true)
		end
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local playerPed = PlayerPedId()
		local pedid = PlayerPedId()
		local x, y, z = table.unpack(GetEntityCoords(playerPed, true))

		if not coords.label then
			for i, v in pairs(zone) do
				if Vdist(x, y, z, v.x, v.y, v.z) <= v.radius then
					coords.label = true
					coords.x, coords.y, coords.z, coords.radius = v.x, v.y, v.z, v.radius

					local isWhitelisted = WhitelistJobs[PlayerData.job.name] ~= nil

					if not isWhitelisted then
						ClearPlayerWantedLevel(PlayerId())
						SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true) 
						DisablePlayerFiring(playerPed, true) 
					end
					
					SetPlayerInvincible(playerPed, true)
				end
			end
		end

		if coords.label then
			local isWhitelisted = WhitelistJobs[PlayerData.job.name] ~= nil
			local currentWeapon = GetSelectedPedWeapon(playerPed)


			if not isWhitelisted then
				DisablePlayerFiring(playerPed, true)
				SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true)
				DisableControlAction(0, 263, true) -- Melee Attack (R)
				DisableControlAction(0, 25, true)  -- Aim (Right Click)

			else

				if currentWeapon == GetHashKey("WEAPON_STUNGUN") then
					DisablePlayerFiring(playerPed, false) 
					EnableControlAction(0, 24, true)  
				else
					DisablePlayerFiring(playerPed, true)  
				end
			end

			if not (isWhitelisted and currentWeapon == GetHashKey("WEAPON_STUNGUN")) then
				DisableControlAction(0, 24, true)  -- Attack
				DisableControlAction(0, 257, true) -- Attack 2
				DisableControlAction(0, 140, true) 
				DisableControlAction(0, 141, true) 
				DisableControlAction(0, 142, true) 
				DisableControlAction(0, 106, true) 
			end

			if Vdist(x, y, z, coords.x, coords.y, coords.z) >= coords.radius then
				coords.label = false
				coords.x, coords.y, coords.z, coords.radius = nil, nil, nil, nil
				NetworkSetFriendlyFireOption(true)
				DisableControlAction(2, 37, false)
				DisablePlayerFiring(playerPed, false) 
				EnableControlAction(0, 24, true)  
				DisableControlAction(0, 106, false)
				SetPlayerInvincible(playerPed, false)
				SetEntityAlpha(pedid, 255, false)
			end
		end
	end
end)



--[[
function Draw3DTextx(x,y,z, text,scl) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
	local rainbow = RGBRainbow( 1 )
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(tonumber(rainbow.r), tonumber(rainbow.g), tonumber(rainbow.b), 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString("~h~"..text)
        DrawText(_x,_y)
    end
end
]]


Citizen.CreateThread(function()
	Citizen.Wait(1)
	for k,v in pairs(zoneMap) do
		blip = AddBlipForRadius(v.x,v.y,v.z, v.radius)
		SetBlipSprite(blip, 9)
		SetBlipAlpha(blip, 90)
		SetBlipColour(blip, v.color)	
	end
end)


-- Blips

local blips = {
    -- {title="Administrator", colour=1, id=269, x = 1774.369, y = 3640.417,},   
	-- {title="Game Center", colour=2, id=647, x = -1645.43, y = -1078.53,}, 
	
}

Citizen.CreateThread(function()
  for _, info in pairs(blips) do
    info.blip = AddBlipForCoord(info.x, info.y, info.z)
    SetBlipSprite(info.blip, info.id)
    SetBlipDisplay(info.blip, 4)
    SetBlipScale(info.blip, 0.9)
    SetBlipColour(info.blip, info.colour)
    SetBlipAsShortRange(info.blip, true)
	BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(info.title)
    EndTextCommandSetBlipName(info.blip)
  end
end)