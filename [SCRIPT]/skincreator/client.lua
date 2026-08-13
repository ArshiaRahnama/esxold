------------------------------------------------------------------
--                          Variables
------------------------------------------------------------------
playerLoaded = false

local showMenu = false					-- Change this value to show/hide UI
local cam = -1							-- Camera control
local heading = 332.219879				-- Heading coord
local zoom = "visage"					-- Define which tab is shown first (Default: Head)
local prvGnd = -1
local firstSpawn = true
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

-- RegisterNetEvent('showRegisterMenu')
-- AddEventHandler('showRegisterMenu', function()
-- 	showMenu = true
-- 	exports.spawnmanager:changeWhiteList(true)
-- 	print("ADDING TO WHITELIST #01")
-- end)

------------------------------------------------------------------
--                          NUI
------------------------------------------------------------------
RegisterNUICallback('updateSkin', function(data)
	updateSkin(data, false)

end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	playerLoaded = true
end)

RegisterNetEvent('skincreator:getGender')
AddEventHandler('skincreator:getGender', function(cb)
	ESX.TriggerServerCallback('getGender', function(gender)
		cb(gender)
	end)
end)
local state = 0


AddEventHandler('playerSpawned', function()
	Citizen.CreateThread(function()
		while not playerLoaded do
			Citizen.Wait(100)
		end

		if firstSpawn then
			firstSpawn = false
			ESX.TriggerServerCallback('getSkin', function(skin)
				if skin then
					while state ~= 12 do
						state = GetPlayerSwitchState()
						Wait(1000)
					end
					TriggerEvent('showStatus')
				else
					while state ~= 12 do
						state = GetPlayerSwitchState()
						Wait(1000)
					end
					--exports.spawnmanager:changeWhiteList(true)
					showMenu = true
				end
			end)
		end
	end)
end)

RegisterNetEvent('skincreator:newChar')
AddEventHandler('skincreator:newChar', function()
	--exports.spawnmanager:changeWhiteList(true)
	showMenu = true
end)

function updateSkin(data, dontneed)
	gender = tonumber(data.gender)
	if gender ~= prvGnd or dontneed then 
		if gender == 0  then
			local characterModel = GetHashKey('mp_m_freemode_01')
		
			RequestModel(characterModel)

			while not HasModelLoaded(characterModel) do
				RequestModel(characterModel)
				Citizen.Wait(1)
			end
		
			if IsModelInCdimage(characterModel) and IsModelValid(characterModel) then
				SetPlayerModel(PlayerId(), characterModel)
				SetPedDefaultComponentVariation(PlayerPedId())
			end
			SetModelAsNoLongerNeeded(characterModel)
		else
			local characterModel = GetHashKey('mp_f_freemode_01')
		
			RequestModel(characterModel)
		
			while not HasModelLoaded(characterModel) do
				RequestModel(characterModel)
				Citizen.Wait(1)
			end
		
			if IsModelInCdimage(characterModel) and IsModelValid(characterModel) then
				SetPlayerModel(PlayerId(), characterModel)
				SetPedDefaultComponentVariation(PlayerPedId())
			end
		
			SetModelAsNoLongerNeeded(characterModel)
		end
		prvGnd = gender
	end
	v = data.value
	-- Face
	dad = tonumber(data.dad)
	mum = tonumber(data.mum)
	dadmumpercent = tonumber(data.dadmumpercent)
	skin = tonumber(data.color)
	eyecolor = tonumber(data.eyecolor)
	acne = tonumber(data.acne)
	skinproblem = tonumber(data.skinproblem)
	freckle = tonumber(data.freckle)
	wrinkle = tonumber(data.wrinkle)
	wrinkleopacity = tonumber(data.wrinkleopacity)
	hair = tonumber(data.hair)
	haircolor = tonumber(data.haircolor1)
	hairhighlight = tonumber(data.haircolor2)
	eyebrow = tonumber(data.eyebrow)
	eyebrowopacity = tonumber(data.eyebrowopacity)
	beard = tonumber(data.beard)
	beardopacity = tonumber(data.beardopacity)
	beardcolor = tonumber(data.beardcolor)
	-- Clothes
	hats = tonumber(data.hats)
	glasses = tonumber(data.glasses)
	ears = tonumber(data.ears)
	tops = tonumber(data.tops)
	pants = tonumber(data.pants)
	shoes = tonumber(data.shoes)
	watches = tonumber(data.watches)
	-- makeup
	makeupopacity = tonumber(data.makeupopacity)
	makeupcolor = tonumber(data.makeupcolor)
	if(v == true) then
		showMenu = false
		--exports.spawnmanager:changeWhiteList(false)
		local ped = PlayerPedId()
		local torso = GetPedDrawableVariation(ped, 3)
		local torsotext = GetPedTextureVariation(ped, 3)
		local leg = GetPedDrawableVariation(ped, 4)
		local legtext = GetPedTextureVariation(ped, 4)
		local shoes = GetPedDrawableVariation(ped, 6)
		local shoestext = GetPedTextureVariation(ped, 6)
		local accessory = GetPedDrawableVariation(ped, 7)
		local accessorytext = GetPedTextureVariation(ped, 7)
		local undershirt = GetPedDrawableVariation(ped, 8)
		local undershirttext = GetPedTextureVariation(ped, 8)
		local torso2 = GetPedDrawableVariation(ped, 11)
		local torso2text = GetPedTextureVariation(ped, 11)
		local prop_hat = GetPedPropIndex(ped, 0)
		local prop_hat_text = GetPedPropTextureIndex(ped, 0)
		local prop_glasses = GetPedPropIndex(ped, 1)
		local prop_glasses_text = GetPedPropTextureIndex(ped, 1)
		local prop_earrings = GetPedPropIndex(ped, 2)
		local prop_earrings_text = GetPedPropTextureIndex(ped, 2)
		local prop_watches = GetPedPropIndex(ped, 6)
		local prop_watches_text = GetPedPropTextureIndex(ped, 6)
		-- local face
		-- if gender == 0 then face = dad else face = mum end
		local skinn = {["sex"]=gender,["face_1"]=dad,["face_2"]=mum,["face_3"]=dadmumpercent,["skin"]=skin,["eye_color"]=eyecolor,["complexion_1"]=skinproblem,["complexion_2"]=1,["moles_1"]=freckle,["moles_2"]=1,["age_1"]=wrinkle,["age_2"]=wrinkleopacity,["eyebrows_1"]=eyebrow,["eyebrows_2"]=eyebrowopacity,["beard_1"]=beard,["beard_2"]=beardopacity,["beard_3"]=beardcolor,["beard_4"]=beardcolor,["hair_1"]=hair,["hair_2"]=0,["hair_color_1"]=haircolor,["hair_color_2"]=hairhighlight,["arms"]=torso,["arms_2"]=torsotext,["pants_1"]=leg,["pants_2"]=legtext,["shoes_1"]=shoes,["shoes_2"]=shoestext,["chain_1"]=accessory,["chain_2"]=accessorytext,["tshirt_1"]=undershirt,["tshirt_2"]=undershirttext,["torso_1"]=torso2,["torso_2"]=torso2text,["helmet_1"]=prop_hat,["helmet_2"]=prop_hat_text,["glasses_1"]=prop_glasses,["glasses_2"]=prop_glasses_text,["ears_1"]=prop_earrings,["ears_2"]=prop_earrings_text,["watches_1"]=prop_watches,["watches_2"]=prop_watches_text}
		TriggerServerEvent('updateSkin', skinn)
		TriggerEvent('skinchanger:loadSkin', skinn)
		TriggerEvent('showStatus')
		TriggerServerEvent('report_system:addreport', "More", "New Player id: "..GetPlayerServerId(PlayerId()))
	elseif gender == 0 then

		SetPedDefaultComponentVariation(PlayerPedId())	

		-- Face
		SetPedHeadBlendData			(PlayerPedId(), dad, mum, 0, skin, skin, skin, dadmumpercent * 0.1, dadmumpercent * 0.1, 0, true)
		SetPedEyeColor				(PlayerPedId(), eyecolor)
		if acne == 0 then
			SetPedHeadOverlay		(PlayerPedId(), 0, acne, 0.0)
		else
			SetPedHeadOverlay		(PlayerPedId(), 0, acne, 1.0)
		end
		SetPedHeadOverlay			(PlayerPedId(), 6, skinproblem, 1.0)
		if freckle == 0 then
			SetPedHeadOverlay		(PlayerPedId(), 9, freckle, 0.0)
		else
			SetPedHeadOverlay		(PlayerPedId(), 9, freckle, 1.0)
		end
		SetPedHeadOverlay       	(PlayerPedId(), 3, wrinkle, wrinkleopacity * 0.1)
		SetPedComponentVariation	(PlayerPedId(), 2, hair, 0, 2)
		SetPedHairColor				(PlayerPedId(), haircolor, hairhighlight)
		SetPedHeadOverlay       	(PlayerPedId(), 2, eyebrow, eyebrowopacity * 0.1) 
		SetPedHeadOverlay       	(PlayerPedId(), 1, beard, beardopacity * 0.1)   
		SetPedHeadOverlayColor  	(PlayerPedId(), 1, 1, beardcolor, beardcolor) 
		SetPedHeadOverlayColor  	(PlayerPedId(), 2, 1, beardcolor, beardcolor)
	
		-- Clothes variations
		if hats == 0 then		ClearPedProp(PlayerPedId(), 0)
		elseif hats == 1 then	SetPedPropIndex(PlayerPedId(), 0, 3-1, 1-1, 2)
		elseif hats == 2 then	SetPedPropIndex(PlayerPedId(), 0, 3-1, 7-1, 2)
		elseif hats == 3 then	SetPedPropIndex(PlayerPedId(), 0, 4-1, 3-1, 2)
		elseif hats == 4 then	SetPedPropIndex(PlayerPedId(), 0, 5-1, 1-1, 2)
		elseif hats == 5 then	SetPedPropIndex(PlayerPedId(), 0, 5-1, 2-1, 2)
		elseif hats == 6 then	SetPedPropIndex(PlayerPedId(), 0, 6-1, 1-1, 2)
		elseif hats == 7 then	SetPedPropIndex(PlayerPedId(), 0, 8-1, 1-1, 2)
		elseif hats == 8 then	SetPedPropIndex(PlayerPedId(), 0, 8-1, 2-1, 2)
		elseif hats == 9 then	SetPedPropIndex(PlayerPedId(), 0, 8-1, 3-1, 2)
		elseif hats == 10 then	SetPedPropIndex(PlayerPedId(), 0, 8-1, 6-1, 2)
		elseif hats == 11 then	SetPedPropIndex(PlayerPedId(), 0, 11-1, 6-1, 2)
		elseif hats == 12 then	SetPedPropIndex(PlayerPedId(), 0, 10-1, 6-1, 2)
		elseif hats == 13 then	SetPedPropIndex(PlayerPedId(), 0, 11-1, 8-1, 2)
		elseif hats == 14 then	SetPedPropIndex(PlayerPedId(), 0, 10-1, 8-1, 2)
		elseif hats == 15 then	SetPedPropIndex(PlayerPedId(), 0, 13-1, 1-1, 2)
		elseif hats == 16 then	SetPedPropIndex(PlayerPedId(), 0, 13-1, 2-1, 2)
		elseif hats == 17 then	SetPedPropIndex(PlayerPedId(), 0, 14-1, 3-1, 2)
		elseif hats == 18 then	SetPedPropIndex(PlayerPedId(), 0, 15-1, 1-1, 2)
		elseif hats == 19 then	SetPedPropIndex(PlayerPedId(), 0, 15-1, 2-1, 2)
		elseif hats == 20 then	SetPedPropIndex(PlayerPedId(), 0, 16-1, 2-1, 2)
		elseif hats == 21 then	SetPedPropIndex(PlayerPedId(), 0, 16-1, 3-1, 2)
		elseif hats == 22 then	SetPedPropIndex(PlayerPedId(), 0, 21-1, 6-1, 2)
		elseif hats == 23 then	SetPedPropIndex(PlayerPedId(), 0, 22-1, 1-1, 2)
		elseif hats == 24 then	SetPedPropIndex(PlayerPedId(), 0, 26-1, 2-1, 2)
		elseif hats == 25 then	SetPedPropIndex(PlayerPedId(), 0, 27-1, 1-1, 2)
		elseif hats == 26 then	SetPedPropIndex(PlayerPedId(), 0, 28-1, 1-1, 2)
		elseif hats == 27 then	SetPedPropIndex(PlayerPedId(), 0, 35-1, 0, 2)
		elseif hats == 28 then	SetPedPropIndex(PlayerPedId(), 0, 56-1, 1-1, 2)
		elseif hats == 29 then	SetPedPropIndex(PlayerPedId(), 0, 56-1, 2-1, 2)
		elseif hats == 30 then	SetPedPropIndex(PlayerPedId(), 0, 56-1, 3-1, 2)
		elseif hats == 31 then	SetPedPropIndex(PlayerPedId(), 0, 77-1, 20-1, 2)
		elseif hats == 32 then	SetPedPropIndex(PlayerPedId(), 0, 97-1, 3-1, 2)
		end
		
		if glasses == 0 then		ClearPedProp(PlayerPedId(), 1)
		elseif glasses == 1 then	SetPedPropIndex(PlayerPedId(), 1, 4-1, 1-1, 2)
		elseif glasses == 2 then	SetPedPropIndex(PlayerPedId(), 1, 4-1, 10-1, 2)
		elseif glasses == 3 then	SetPedPropIndex(PlayerPedId(), 1, 5-1, 5-1, 2)
		elseif glasses == 4 then	SetPedPropIndex(PlayerPedId(), 1, 5-1, 10-1, 2)
		elseif glasses == 5 then	SetPedPropIndex(PlayerPedId(), 1, 6-1, 1-1, 2)
		elseif glasses == 6 then	SetPedPropIndex(PlayerPedId(), 1, 6-1, 9-1, 2)
		elseif glasses == 7 then	SetPedPropIndex(PlayerPedId(), 1, 8-1, 1-1, 2)
		elseif glasses == 8 then	SetPedPropIndex(PlayerPedId(), 1, 9-1, 2-1, 2)
		elseif glasses == 9 then	SetPedPropIndex(PlayerPedId(), 1, 10-1, 1-1, 2)
		elseif glasses == 10 then	SetPedPropIndex(PlayerPedId(), 1, 16-1, 7-1, 2)
		elseif glasses == 11 then	SetPedPropIndex(PlayerPedId(), 1, 18-1, 10-1, 2)
		elseif glasses == 12 then	SetPedPropIndex(PlayerPedId(), 1, 26-1, 1-1, 2)
		end
	
		if ears == 0 then		ClearPedProp(PlayerPedId(), 2)
		elseif ears == 1 then	SetPedPropIndex(PlayerPedId(), 2, 4-1, 1-1, 2)
		elseif ears == 2 then	SetPedPropIndex(PlayerPedId(), 2, 5-1, 1-1, 2)
		elseif ears == 3 then	SetPedPropIndex(PlayerPedId(), 2, 6-1, 1-1, 2)
		elseif ears == 4 then	SetPedPropIndex(PlayerPedId(), 2, 10-1, 2-1, 2)
		elseif ears == 5 then	SetPedPropIndex(PlayerPedId(), 2, 11-1, 2-1, 2)
		elseif ears == 6 then	SetPedPropIndex(PlayerPedId(), 2, 12-1, 2-1, 2)
		elseif ears == 7 then	SetPedPropIndex(PlayerPedId(), 2, 19-1, 4-1, 2)
		elseif ears == 8 then	SetPedPropIndex(PlayerPedId(), 2, 20-1, 4-1, 2)
		elseif ears == 9 then	SetPedPropIndex(PlayerPedId(), 2, 21-1, 4-1, 2)
		elseif ears == 10 then	SetPedPropIndex(PlayerPedId(), 2, 28-1, 1-1, 2)
		elseif ears == 11 then	SetPedPropIndex(PlayerPedId(), 2, 29-1, 1-1, 2)
		elseif ears == 12 then	SetPedPropIndex(PlayerPedId(), 2, 30-1, 1-1, 2)
		elseif ears == 13 then	SetPedPropIndex(PlayerPedId(), 2, 31-1, 1-1, 2)
		elseif ears == 14 then	SetPedPropIndex(PlayerPedId(), 2, 32-1, 1-1, 2)
		elseif ears == 15 then	SetPedPropIndex(PlayerPedId(), 2, 33-1, 1-1, 2)
		end
	
		-- Keep these 4 variations together.
		-- It avoids empty arms or noisy clothes superposition
		if tops == 0 then
			SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 15, 0, 2) 	-- Torso 2
		elseif tops == 1 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 0, 0, 2) 		-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 0, 1, 2) 	-- Torso 2
		elseif tops == 2 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 0, 0, 2) 		-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 0, 7, 2) 	-- Torso 2
		elseif tops == 3 then
			SetPedComponentVariation(PlayerPedId(), 3, 2, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 2, 9, 2) 	-- Torso 2
		elseif tops == 4 then
			SetPedComponentVariation(PlayerPedId(), 3, 6, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 5, 0, 2) 		-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 3, 11, 2) 	-- Torso 2
		elseif tops == 5 then
			SetPedComponentVariation(PlayerPedId(), 3, 6, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 5, 0, 2) 		-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 3, 15, 2) 	-- Torso 2
		elseif tops == 6 then
			SetPedComponentVariation(PlayerPedId(), 3, 6, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 23, 0, 2) 		-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 4, 0, 2) 	-- Torso 2
		elseif tops == 7 then
			SetPedComponentVariation(PlayerPedId(), 3, 6, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 4, 0, 2) 		-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 4, 0, 2) 	-- Torso 2
		elseif tops == 8 then
			SetPedComponentVariation(PlayerPedId(), 3, 6, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 26, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 4, 0, 2) 	-- Torso 2
		elseif tops == 9 then
			SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 5, 0, 2) 		-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 5, 0, 2) 	-- Torso 2
		elseif tops == 10 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 2, 4, 2) 		-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 6, 11, 2) 	-- Torso 2
		elseif tops == 11 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 2, 4, 2) 		-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 6, 0, 2) 	-- Torso 2
		elseif tops == 12 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 2, 4, 2) 		-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 6, 3, 2) 	-- Torso 2
		elseif tops == 13 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 23, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 7, 4, 2) 	-- Torso 2
		elseif tops == 14 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 23, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 7, 10, 2) 	-- Torso 2
		elseif tops == 15 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 23, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 7, 12, 2) 	-- Torso 2
		elseif tops == 16 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 23, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 7, 13, 2) 	-- Torso 2
		elseif tops == 17 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 9, 0, 2) 		-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 9, 0, 2) 	-- Torso 2
		elseif tops == 18 then
			SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 10, 0, 2) 		-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 10, 0, 2) 	-- Torso 2
		elseif tops == 19 then
			SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 12, 2, 2) 	-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 10, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 10, 0, 2) 	-- Torso 2
		elseif tops == 20 then
			SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 18, 0, 2) 	-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 10, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 10, 0, 2) 	-- Torso 2
		elseif tops == 21 then
			SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 11, 2, 2) 	-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 10, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 10, 0, 2) 	-- Torso 2
		elseif tops == 22 then
			SetPedComponentVariation(PlayerPedId(), 3, 12, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 12, 10, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 12, 10, 2) 	-- Torso 2
		elseif tops == 23 then
			SetPedComponentVariation(PlayerPedId(), 3, 11, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 13, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 13, 0, 2) 	-- Torso 2
		elseif tops == 24 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 14, 0, 2) 	-- Torso 2
		elseif tops == 25 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 14, 1, 2) 	-- Torso 2
		elseif tops == 26 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 16, 0, 2) 	-- Torso 2
		elseif tops == 27 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 16, 1, 2) 	-- Torso 2
		elseif tops == 28 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 16, 2, 2) 	-- Torso 2
		elseif tops == 29 then
			SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 17, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 17, 0, 2) 	-- Torso 2
		elseif tops == 30 then
			SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 17, 1, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 17, 1, 2) 	-- Torso 2
		elseif tops == 31 then
			SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 17, 4, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 17, 4, 2) 	-- Torso 2
		elseif tops == 32 then
			SetPedComponentVariation(PlayerPedId(), 3, 11, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 27, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 26, 0, 2) 	-- Torso 2
		elseif tops == 33 then
			SetPedComponentVariation(PlayerPedId(), 3, 11, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 27, 5, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 26, 5, 2) 	-- Torso 2
		elseif tops == 34 then
			SetPedComponentVariation(PlayerPedId(), 3, 11, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 27, 6, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 26, 6, 2) 	-- Torso 2
		elseif tops == 35 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 63, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 31, 0, 2) 	-- Torso 2
		elseif tops == 36 then
			SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 57, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 36, 4, 2) 	-- Torso 2
		elseif tops == 37 then
			SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 57, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 36, 5, 2) 	-- Torso 2
		elseif tops == 38 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 24, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 37, 0, 2) 	-- Torso 2
		elseif tops == 39 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 24, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 37, 1, 2) 	-- Torso 2
		elseif tops == 40 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 24, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 37, 2, 2) 	-- Torso 2
		elseif tops == 41 then
			SetPedComponentVariation(PlayerPedId(), 3, 8, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 38, 0, 2) 	-- Torso 2
		elseif tops == 42 then
			SetPedComponentVariation(PlayerPedId(), 3, 8, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 38, 3, 2) 	-- Torso 2
		elseif tops == 43 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 39, 0, 2) 	-- Torso 2
		elseif tops == 44 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 39, 1, 2) 	-- Torso 2
		elseif tops == 45 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 41, 0, 2) 	-- Torso 2
		elseif tops == 46 then
			SetPedComponentVariation(PlayerPedId(), 3, 11, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 42, 0, 2) 	-- Torso 2
		elseif tops == 47 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 50, 0, 2) 	-- Torso 2
		elseif tops == 48 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 50, 3, 2) 	-- Torso 2
		elseif tops == 49 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 50, 4, 2) 	-- Torso 2
		elseif tops == 50 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 57, 0, 2) 	-- Torso 2
		elseif tops == 51 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 50, 1, 2) 	-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 23, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 70, 0, 2) 	-- Torso 2
		elseif tops == 52 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 50, 1, 2) 	-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 23, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 70, 1, 2) 	-- Torso 2
		elseif tops == 53 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 50, 1, 2) 	-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 23, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 70, 7, 2) 	-- Torso 2
		elseif tops == 54 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 3, 1, 2) 		-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 72, 1, 2) 	-- Torso 2
		elseif tops == 55 then
			SetPedComponentVariation(PlayerPedId(), 3, 6, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 87, 0, 2) 	-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 5, 0, 2) 		-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 74, 0, 2) 	-- Torso 2
		elseif tops == 56 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 12, 2, 2) 	-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 28, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 77, 0, 2) 	-- Torso 2
		elseif tops == 57 then
			SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 79, 0, 2) 	-- Torso 2
		elseif tops == 58 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 80, 0, 2) 	-- Torso 2
		elseif tops == 59 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 80, 1, 2) 	-- Torso 2
		elseif tops == 60 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 82, 5, 2) 	-- Torso 2
		elseif tops == 61 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 82, 8, 2) 	-- Torso 2
		elseif tops == 62 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 82, 9, 2) 	-- Torso 2
		elseif tops == 63 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 86, 0, 2) 	-- Torso 2
		elseif tops == 64 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 86, 2, 2) 	-- Torso 2
		elseif tops == 65 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 86, 4, 2) 	-- Torso 2
		elseif tops == 66 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 87, 11, 2) 	-- Torso 2
		elseif tops == 67 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 87, 0, 2) 	-- Torso 2
		elseif tops == 68 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 87, 1, 2) 	-- Torso 2
		elseif tops == 69 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 87, 2, 2) 	-- Torso 2
		elseif tops == 70 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 87, 4, 2) 	-- Torso 2
		elseif tops == 71 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 87, 8, 2) 	-- Torso 2
		elseif tops == 72 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 89, 0, 2) 	-- Torso 2
		elseif tops == 73 then
			SetPedComponentVariation(PlayerPedId(), 3, 11, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 95, 0, 2) 	-- Torso 2
		elseif tops == 74 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 31, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 99, 1, 2) 	-- Torso 2
		elseif tops == 75 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 31, 13, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 99, 3, 2) 	-- Torso 2
		elseif tops == 76 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 31, 13, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 101, 0, 2) 	-- Torso 2
		elseif tops == 77 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 105, 0, 2) 	-- Torso 2
		elseif tops == 78 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 10, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 106, 0, 2) 	-- Torso 2
		elseif tops == 79 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 73, 2, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 109, 0, 2) 	-- Torso 2
		elseif tops == 80 then
			SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 111, 0, 2) 	-- Torso 2
		elseif tops == 81 then
			SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 111, 3, 2) 	-- Torso 2
		elseif tops == 82 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 113, 0, 2) 	-- Torso 2
		elseif tops == 83 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 126, 5, 2) 	-- Torso 2
		elseif tops == 84 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 126, 9, 2) 	-- Torso 2
		elseif tops == 85 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 126, 10, 2) 	-- Torso 2
		elseif tops == 86 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 126, 14, 2) 	-- Torso 2
		elseif tops == 87 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 131, 0, 2) 	-- Torso 2
		elseif tops == 88 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 134, 0, 2) 	-- Torso 2
		elseif tops == 89 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 134, 1, 2) 	-- Torso 2
		elseif tops == 90 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 143, 0, 2) 	-- Torso 2
		elseif tops == 91 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 143, 2, 2) 	-- Torso 2
		elseif tops == 92 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 143, 4, 2) 	-- Torso 2
		elseif tops == 93 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 143, 5, 2) 	-- Torso 2
		elseif tops == 94 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 143, 6, 2) 	-- Torso 2
		elseif tops == 95 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 143, 8, 2) 	-- Torso 2
		elseif tops == 96 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 143, 9, 2) 	-- Torso 2
		elseif tops == 97 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 146, 0, 2) 	-- Torso 2
		elseif tops == 98 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 16, 2, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 166, 0, 2) 	-- Torso 2
		elseif tops == 99 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 38, 1, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 167, 0, 2) 	-- Torso 2
		elseif tops == 100 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 38, 1, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 167, 4, 2) 	-- Torso 2
		elseif tops == 101 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 38, 1, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 167, 6, 2) 	-- Torso 2
		elseif tops == 102 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 38, 1, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 167, 12, 2) 	-- Torso 2
		elseif tops == 103 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 38, 1, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 169, 0, 2) 	-- Torso 2
		elseif tops == 104 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 38, 1, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 172, 0, 2) 	-- Torso 2
		elseif tops == 105 then
			SetPedComponentVariation(PlayerPedId(), 3, 2, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 38, 1, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 173, 0, 2) 	-- Torso 2
		elseif tops == 106 then
			SetPedComponentVariation(PlayerPedId(), 3, 2, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 41, 2, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 185, 0, 2) 	-- Torso 2
		elseif tops == 107 then
			SetPedComponentVariation(PlayerPedId(), 3, 2, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 202, 0, 2) 	-- Torso 2
		elseif tops == 108 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 203, 10, 2) 	-- Torso 2
		elseif tops == 109 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 203, 16, 2) 	-- Torso 2
		elseif tops == 110 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 203, 25, 2) 	-- Torso 2
		elseif tops == 111 then
			SetPedComponentVariation(PlayerPedId(), 3, 2, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 205, 0, 2) 	-- Torso 2
		elseif tops == 112 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 226, 0, 2) 	-- Torso 2
		elseif tops == 113 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 257, 0, 2) 	-- Torso 2
		elseif tops == 114 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 257, 9, 2) 	-- Torso 2
		elseif tops == 115 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 257, 17, 2) 	-- Torso 2
		elseif tops == 116 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 259, 9, 2) 	-- Torso 2
		elseif tops == 117 then
			SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 5, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 269, 2, 2) 	-- Torso 2
		elseif tops == 118 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 282, 6, 2) 	-- Torso 2
		end
	
		if pants == 0 then 		SetPedComponentVariation(PlayerPedId(), 4, 61, 4, 2)
		elseif pants == 1 then	SetPedComponentVariation(PlayerPedId(), 4, 0, 0, 2)
		elseif pants == 2 then	SetPedComponentVariation(PlayerPedId(), 4, 0, 2, 2)
		elseif pants == 3 then	SetPedComponentVariation(PlayerPedId(), 4, 1, 12, 2)
		elseif pants == 4 then	SetPedComponentVariation(PlayerPedId(), 4, 2, 11, 2)
		elseif pants == 5 then	SetPedComponentVariation(PlayerPedId(), 4, 3, 0, 2)
		elseif pants == 6 then	SetPedComponentVariation(PlayerPedId(), 4, 4, 0, 2)
		elseif pants == 7 then	SetPedComponentVariation(PlayerPedId(), 4, 4, 1, 2)
		elseif pants == 8 then	SetPedComponentVariation(PlayerPedId(), 4, 4, 4, 2)
		elseif pants == 9 then	SetPedComponentVariation(PlayerPedId(), 4, 5, 0, 2)
		elseif pants == 10 then	SetPedComponentVariation(PlayerPedId(), 4, 5, 2, 2)
		elseif pants == 11 then	SetPedComponentVariation(PlayerPedId(), 4, 7, 0, 2)
		elseif pants == 12 then	SetPedComponentVariation(PlayerPedId(), 4, 7, 1, 2)
		elseif pants == 13 then	SetPedComponentVariation(PlayerPedId(), 4, 9, 0, 2)
		elseif pants == 14 then	SetPedComponentVariation(PlayerPedId(), 4, 9, 1, 2)
		elseif pants == 15 then	SetPedComponentVariation(PlayerPedId(), 4, 10, 0, 2)
		elseif pants == 16 then	SetPedComponentVariation(PlayerPedId(), 4, 10, 2, 2)
		elseif pants == 17 then	SetPedComponentVariation(PlayerPedId(), 4, 12, 0, 2)
		elseif pants == 18 then	SetPedComponentVariation(PlayerPedId(), 4, 12, 5, 2)
		elseif pants == 19 then	SetPedComponentVariation(PlayerPedId(), 4, 12, 7, 2)
		elseif pants == 20 then	SetPedComponentVariation(PlayerPedId(), 4, 14, 0, 2)
		elseif pants == 21 then	SetPedComponentVariation(PlayerPedId(), 4, 14, 1, 2)
		elseif pants == 22 then	SetPedComponentVariation(PlayerPedId(), 4, 14, 3, 2)
		elseif pants == 23 then	SetPedComponentVariation(PlayerPedId(), 4, 15, 0, 2)
		elseif pants == 24 then	SetPedComponentVariation(PlayerPedId(), 4, 20, 0, 2)
		elseif pants == 25 then	SetPedComponentVariation(PlayerPedId(), 4, 24, 0, 2)
		elseif pants == 26 then	SetPedComponentVariation(PlayerPedId(), 4, 24, 1, 2)
		elseif pants == 27 then	SetPedComponentVariation(PlayerPedId(), 4, 24, 5, 2)
		elseif pants == 28 then	SetPedComponentVariation(PlayerPedId(), 4, 26, 0, 2)
		elseif pants == 29 then	SetPedComponentVariation(PlayerPedId(), 4, 26, 4, 2)
		elseif pants == 30 then	SetPedComponentVariation(PlayerPedId(), 4, 26, 5, 2)
		elseif pants == 31 then	SetPedComponentVariation(PlayerPedId(), 4, 26, 6, 2)
		elseif pants == 32 then	SetPedComponentVariation(PlayerPedId(), 4, 28, 0, 2)
		elseif pants == 33 then	SetPedComponentVariation(PlayerPedId(), 4, 28, 3, 2)
		elseif pants == 34 then	SetPedComponentVariation(PlayerPedId(), 4, 28, 8, 2)
		elseif pants == 35 then	SetPedComponentVariation(PlayerPedId(), 4, 28, 14, 2)
		elseif pants == 36 then	SetPedComponentVariation(PlayerPedId(), 4, 42, 0, 2)
		elseif pants == 37 then	SetPedComponentVariation(PlayerPedId(), 4, 42, 1, 2)
		elseif pants == 38 then	SetPedComponentVariation(PlayerPedId(), 4, 48, 0, 2)
		elseif pants == 39 then	SetPedComponentVariation(PlayerPedId(), 4, 48, 1, 2)
		elseif pants == 40 then	SetPedComponentVariation(PlayerPedId(), 4, 49, 0, 2)
		elseif pants == 41 then	SetPedComponentVariation(PlayerPedId(), 4, 49, 1, 2)
		elseif pants == 42 then	SetPedComponentVariation(PlayerPedId(), 4, 54, 1, 2)
		elseif pants == 43 then	SetPedComponentVariation(PlayerPedId(), 4, 55, 0, 2)
		elseif pants == 44 then	SetPedComponentVariation(PlayerPedId(), 4, 60, 2, 2)
		elseif pants == 45 then	SetPedComponentVariation(PlayerPedId(), 4, 60, 9, 2)
		elseif pants == 46 then	SetPedComponentVariation(PlayerPedId(), 4, 71, 0, 2)
		elseif pants == 47 then	SetPedComponentVariation(PlayerPedId(), 4, 75, 2, 2)
		elseif pants == 48 then	SetPedComponentVariation(PlayerPedId(), 4, 76, 2, 2)
		elseif pants == 49 then	SetPedComponentVariation(PlayerPedId(), 4, 78, 0, 2)
		elseif pants == 50 then	SetPedComponentVariation(PlayerPedId(), 4, 78, 2, 2)
		elseif pants == 51 then	SetPedComponentVariation(PlayerPedId(), 4, 78, 4, 2)
		elseif pants == 52 then	SetPedComponentVariation(PlayerPedId(), 4, 82, 0, 2)
		elseif pants == 53 then	SetPedComponentVariation(PlayerPedId(), 4, 82, 2, 2)
		elseif pants == 54 then	SetPedComponentVariation(PlayerPedId(), 4, 82, 3, 2)
		elseif pants == 55 then	SetPedComponentVariation(PlayerPedId(), 4, 86, 9, 2)
		elseif pants == 56 then	SetPedComponentVariation(PlayerPedId(), 4, 88, 9, 2)
		elseif pants == 57 then	SetPedComponentVariation(PlayerPedId(), 4, 100, 9, 2)
		end
	
		if shoes == 0 then 	SetPedComponentVariation(PlayerPedId(), 6, 34, 0, 2)
		elseif shoes == 1 then	SetPedComponentVariation(PlayerPedId(), 6, 0, 10, 2)
		elseif shoes == 2 then	SetPedComponentVariation(PlayerPedId(), 6, 1, 0, 2)
		elseif shoes == 3 then	SetPedComponentVariation(PlayerPedId(), 6, 1, 1, 2)
		elseif shoes == 4 then	SetPedComponentVariation(PlayerPedId(), 6, 1, 3, 2)
		elseif shoes == 5 then	SetPedComponentVariation(PlayerPedId(), 6, 3, 0, 2)
		elseif shoes == 6 then	SetPedComponentVariation(PlayerPedId(), 6, 3, 6, 2)
		elseif shoes == 7 then	SetPedComponentVariation(PlayerPedId(), 6, 3, 14, 2)
		elseif shoes == 8 then	SetPedComponentVariation(PlayerPedId(), 6, 48, 0, 2)
		elseif shoes == 9 then	SetPedComponentVariation(PlayerPedId(), 6, 48, 1, 2)
		elseif shoes == 10 then SetPedComponentVariation(PlayerPedId(), 6, 49, 0, 2)
		elseif shoes == 11 then SetPedComponentVariation(PlayerPedId(), 6, 49, 1, 2)
		elseif shoes == 12 then SetPedComponentVariation(PlayerPedId(), 6, 5, 0, 2)
		elseif shoes == 13 then SetPedComponentVariation(PlayerPedId(), 6, 6, 0, 2)
		elseif shoes == 14 then SetPedComponentVariation(PlayerPedId(), 6, 7, 0, 2)
		elseif shoes == 15 then SetPedComponentVariation(PlayerPedId(), 6, 7, 9, 2)
		elseif shoes == 16 then SetPedComponentVariation(PlayerPedId(), 6, 7, 13, 2)
		elseif shoes == 17 then SetPedComponentVariation(PlayerPedId(), 6, 9, 3, 2)
		elseif shoes == 18 then SetPedComponentVariation(PlayerPedId(), 6, 9, 6, 2)
		elseif shoes == 19 then SetPedComponentVariation(PlayerPedId(), 6, 9, 7, 2)
		elseif shoes == 20 then SetPedComponentVariation(PlayerPedId(), 6, 10, 0, 2)
		elseif shoes == 21 then SetPedComponentVariation(PlayerPedId(), 6, 12, 0, 2)
		elseif shoes == 22 then SetPedComponentVariation(PlayerPedId(), 6, 12, 2, 2)
		elseif shoes == 23 then SetPedComponentVariation(PlayerPedId(), 6, 12, 13, 2)
		elseif shoes == 24 then SetPedComponentVariation(PlayerPedId(), 6, 15, 0, 2)
		elseif shoes == 25 then SetPedComponentVariation(PlayerPedId(), 6, 15, 1, 2)
		elseif shoes == 26 then SetPedComponentVariation(PlayerPedId(), 6, 16, 0, 2)
		elseif shoes == 27 then SetPedComponentVariation(PlayerPedId(), 6, 20, 0, 2)
		elseif shoes == 28 then SetPedComponentVariation(PlayerPedId(), 6, 24, 0, 2)
		elseif shoes == 29 then SetPedComponentVariation(PlayerPedId(), 6, 27, 0, 2)
		elseif shoes == 30 then SetPedComponentVariation(PlayerPedId(), 6, 28, 0, 2)
		elseif shoes == 31 then SetPedComponentVariation(PlayerPedId(), 6, 28, 1, 2)
		elseif shoes == 32 then SetPedComponentVariation(PlayerPedId(), 6, 28, 3, 2)
		elseif shoes == 33 then SetPedComponentVariation(PlayerPedId(), 6, 28, 2, 2)
		elseif shoes == 34 then SetPedComponentVariation(PlayerPedId(), 6, 31, 2, 2)
		elseif shoes == 35 then SetPedComponentVariation(PlayerPedId(), 6, 31, 4, 2)
		elseif shoes == 36 then SetPedComponentVariation(PlayerPedId(), 6, 36, 0, 2)
		elseif shoes == 37 then SetPedComponentVariation(PlayerPedId(), 6, 36, 3, 2)
		elseif shoes == 38 then SetPedComponentVariation(PlayerPedId(), 6, 42, 0, 2)
		elseif shoes == 39 then SetPedComponentVariation(PlayerPedId(), 6, 42, 1, 2)
		elseif shoes == 40 then SetPedComponentVariation(PlayerPedId(), 6, 42, 7, 2)
		elseif shoes == 41 then SetPedComponentVariation(PlayerPedId(), 6, 57, 0, 2)
		elseif shoes == 42 then SetPedComponentVariation(PlayerPedId(), 6, 57, 3, 2)
		elseif shoes == 43 then SetPedComponentVariation(PlayerPedId(), 6, 57, 8, 2)
		elseif shoes == 44 then SetPedComponentVariation(PlayerPedId(), 6, 57, 9, 2)
		elseif shoes == 45 then SetPedComponentVariation(PlayerPedId(), 6, 57, 10, 2)
		elseif shoes == 46 then SetPedComponentVariation(PlayerPedId(), 6, 57, 11, 2)
		elseif shoes == 47 then SetPedComponentVariation(PlayerPedId(), 6, 75, 4, 2)
		elseif shoes == 48 then SetPedComponentVariation(PlayerPedId(), 6, 75, 7, 2)
		elseif shoes == 49 then SetPedComponentVariation(PlayerPedId(), 6, 75, 8, 2)
		elseif shoes == 50 then SetPedComponentVariation(PlayerPedId(), 6, 77, 0, 2)
		end
	
		if watches == 0 then		ClearPedProp(PlayerPedId(), 6)
		elseif watches == 1 then	SetPedPropIndex(PlayerPedId(), 6, 1-1, 1-1, 2)
		elseif watches == 2 then	SetPedPropIndex(PlayerPedId(), 6, 2-1, 1-1, 2)
		elseif watches == 3 then	SetPedPropIndex(PlayerPedId(), 6, 4-1, 1-1, 2)
		elseif watches == 4 then	SetPedPropIndex(PlayerPedId(), 6, 4-1, 3-1, 2)
		elseif watches == 5 then	SetPedPropIndex(PlayerPedId(), 6, 5-1, 1-1, 2)
		elseif watches == 6 then	SetPedPropIndex(PlayerPedId(), 6, 9-1, 1-1, 2)
		elseif watches == 7 then	SetPedPropIndex(PlayerPedId(), 6, 11-1, 1-1, 2)
		end
		
		-- Unused yet
		-- These presets will be editable in V2 release
		SetPedHeadOverlay       	(PlayerPedId(), 4, 0, 0.0)   	-- Lipstick
		SetPedHeadOverlay       	(PlayerPedId(), 8, 0, 0.0) 		-- Makeup
		SetPedHeadOverlayColor  	(PlayerPedId(), 4, 1, 0, 0)      -- Makeup Color
		SetPedHeadOverlayColor  	(PlayerPedId(), 8, 1, 0, 0)      -- Lipstick Color
		SetPedComponentVariation	(PlayerPedId(), 1,  0,0, 2)    	-- Mask
	elseif gender == 1 then

		SetPedDefaultComponentVariation(PlayerPedId())	

		-- Face
		SetPedHeadBlendData			(PlayerPedId(), dad, mum, 0, skin, skin, skin, dadmumpercent * 0.1, dadmumpercent * 0.1, 0, true)
		SetPedEyeColor				(PlayerPedId(), eyecolor)
		if acne == 0 then
			SetPedHeadOverlay		(PlayerPedId(), 0, acne, 0.0)
		else
			SetPedHeadOverlay		(PlayerPedId(), 0, acne, 1.0)
		end
		SetPedHeadOverlay			(PlayerPedId(), 6, skinproblem, 1.0)
		if freckle == 0 then
			SetPedHeadOverlay		(PlayerPedId(), 9, freckle, 0.0)
		else
			SetPedHeadOverlay		(PlayerPedId(), 9, freckle, 1.0)
		end
		SetPedHeadOverlay       	(PlayerPedId(), 3, wrinkle, wrinkleopacity * 0.1)
		if hair == 0 then SetPedComponentVariation(PlayerPedId(), 2, 39 + 0, hair, 2)
		elseif hair == 1 then SetPedComponentVariation(PlayerPedId(), 2, 39 + hair, 0, 2)
		elseif hair == 2 then 
			SetPedComponentVariation(PlayerPedId(), 2, 39 + hair, 0, 2)
			if hats == 0 then
				SetPedPropIndex(PlayerPedId(), 0, 5, 0, 2)
			end
		elseif hair == 3 then SetPedComponentVariation(PlayerPedId(), 2, 39 + hair, 0, 2)
		elseif hair == 38 then SetPedComponentVariation(PlayerPedId(), 2, 2, 0, 2)
		elseif hair == 39 then SetPedComponentVariation(PlayerPedId(), 2, 1, 0, 2)
		elseif hair == 40 then SetPedComponentVariation(PlayerPedId(), 2, 0, 0, 2)
		elseif hair >= 24 then SetPedComponentVariation(PlayerPedId(), 2, hair + 1, 0, 2)
		elseif hair > 3 then SetPedComponentVariation(PlayerPedId(), 2, hair, 0, 2) end

		
		-- SetPedComponentVariation	(PlayerPedId(), 2, hair, 0, 2)
		SetPedHairColor				(PlayerPedId(), haircolor, hairhighlight)
		SetPedHeadOverlay       	(PlayerPedId(), 2, eyebrow, eyebrowopacity * 0.1) 
		SetPedHeadOverlay       	(PlayerPedId(), 1, beard, beardopacity * 0.1)   
		SetPedHeadOverlayColor  	(PlayerPedId(), 1, 1, beardcolor, beardcolor) 
		SetPedHeadOverlayColor  	(PlayerPedId(), 2, 1, beardcolor, beardcolor)
	
		-- Clothes variations
		if hats == 0 and hair ~= 2 then		ClearPedProp(PlayerPedId(), 0)
		elseif hats == 1 then	SetPedPropIndex(PlayerPedId(), 0, 4, 0, 2)
		elseif hats == 2 then	SetPedPropIndex(PlayerPedId(), 0, 4, 1, 2)
		elseif hats == 3 then	SetPedPropIndex(PlayerPedId(), 0, 4, 2, 2)
		elseif hats == 4 then	SetPedPropIndex(PlayerPedId(), 0, 4, 3, 2)
		elseif hats == 5 then	SetPedPropIndex(PlayerPedId(), 0, 4, 4, 2)
		elseif hats == 6 then	SetPedPropIndex(PlayerPedId(), 0, 4, 5, 2)
		elseif hats == 7 then	SetPedPropIndex(PlayerPedId(), 0, 4, 6, 2)
		elseif hats == 8 then	SetPedPropIndex(PlayerPedId(), 0, 4, 7, 2)	
		elseif hats == 9 then	SetPedPropIndex(PlayerPedId(), 0, 5, 0, 2)
		elseif hats == 10 then	SetPedPropIndex(PlayerPedId(), 0, 5, 1, 2)
		elseif hats == 11 then	SetPedPropIndex(PlayerPedId(), 0, 5, 2, 2)
		elseif hats == 12 then	SetPedPropIndex(PlayerPedId(), 0, 5, 3, 2)
		elseif hats == 13 then	SetPedPropIndex(PlayerPedId(), 0, 5, 4, 2)
		elseif hats == 14 then	SetPedPropIndex(PlayerPedId(), 0, 5, 5, 2)
		elseif hats == 15 then	SetPedPropIndex(PlayerPedId(), 0, 5, 6, 2)
		elseif hats == 16 then	SetPedPropIndex(PlayerPedId(), 0, 5, 7, 2)
		elseif hats == 17 then	SetPedPropIndex(PlayerPedId(), 0, 9, 0, 2)
		elseif hats == 18 then	SetPedPropIndex(PlayerPedId(), 0, 9, 2, 2)
		elseif hats == 19 then	SetPedPropIndex(PlayerPedId(), 0, 9, 3, 2)
		elseif hats == 20 then	SetPedPropIndex(PlayerPedId(), 0, 9, 4, 2)
		elseif hats == 21 then	SetPedPropIndex(PlayerPedId(), 0, 9, 5, 2)
		elseif hats == 22 then	SetPedPropIndex(PlayerPedId(), 0, 9, 6, 2)
		elseif hats == 23 then	SetPedPropIndex(PlayerPedId(), 0, 9, 7, 2)
		elseif hats == 24 then	SetPedPropIndex(PlayerPedId(), 0, 9, 1, 2)
		elseif hats == 25 then	SetPedPropIndex(PlayerPedId(), 0, 12, 0, 2)
		elseif hats == 26 then	SetPedPropIndex(PlayerPedId(), 0, 12, 6, 2)
		elseif hats == 27 then	SetPedPropIndex(PlayerPedId(), 0, 12, 7, 2)
		elseif hats == 28 then	SetPedPropIndex(PlayerPedId(), 0, 13, 3, 2)
		elseif hats == 29 then	SetPedPropIndex(PlayerPedId(), 0, 13, 4, 2)
		elseif hats == 30 then	SetPedPropIndex(PlayerPedId(), 0, 13, 5, 2)
		elseif hats == 31 then	SetPedPropIndex(PlayerPedId(), 0, 13, 2, 2)
		elseif hats == 32 then	SetPedPropIndex(PlayerPedId(), 0, 13, 1, 2)
		end
		
		if glasses == 0 then		ClearPedProp(PlayerPedId(), 1)
		elseif glasses == 1 then	SetPedPropIndex(PlayerPedId(), 1, 3, 1-1, 2)
		elseif glasses == 2 then	SetPedPropIndex(PlayerPedId(), 1, 3, 10-1, 2)
		elseif glasses == 3 then	SetPedPropIndex(PlayerPedId(), 1, 4, 5-1, 2)
		elseif glasses == 4 then	SetPedPropIndex(PlayerPedId(), 1, 4, 10-1, 2)
		elseif glasses == 5 then	SetPedPropIndex(PlayerPedId(), 1, 14, 1-1, 2)
		elseif glasses == 6 then	SetPedPropIndex(PlayerPedId(), 1, 24, 1, 2)
		elseif glasses == 7 then	SetPedPropIndex(PlayerPedId(), 1, 11, 1-1, 2)
		elseif glasses == 8 then	SetPedPropIndex(PlayerPedId(), 1, 8, 0, 2)
		elseif glasses == 9 then	SetPedPropIndex(PlayerPedId(), 1, 9, 1-1, 2)
		elseif glasses == 10 then	SetPedPropIndex(PlayerPedId(), 1, 16, 1, 2)
		elseif glasses == 11 then	SetPedPropIndex(PlayerPedId(), 1, 17, 10-1, 2)
		elseif glasses == 12 then	SetPedPropIndex(PlayerPedId(), 1, 25, 1-1, 2)
		end

		if ears == 0 then		ClearPedProp(PlayerPedId(), 2)
		elseif ears == 1 then	SetPedPropIndex(PlayerPedId(), 2, 3, 0, 2)
		elseif ears == 2 then	SetPedPropIndex(PlayerPedId(), 2, 4, 0, 2)
		elseif ears == 3 then	SetPedPropIndex(PlayerPedId(), 2, 5, 0, 2)
		elseif ears == 4 then	SetPedPropIndex(PlayerPedId(), 2, 6, 1, 2)
		elseif ears == 5 then	SetPedPropIndex(PlayerPedId(), 2, 7, 1, 2)
		elseif ears == 6 then	SetPedPropIndex(PlayerPedId(), 2, 8, 1, 2)
		elseif ears == 7 then	SetPedPropIndex(PlayerPedId(), 2, 9, 1, 2)
		elseif ears == 8 then	SetPedPropIndex(PlayerPedId(), 2, 10, 1, 2)
		elseif ears == 9 then	SetPedPropIndex(PlayerPedId(), 2, 11, 1, 2)
		elseif ears == 10 then	SetPedPropIndex(PlayerPedId(), 2, 11, 0, 2)
		elseif ears == 11 then	SetPedPropIndex(PlayerPedId(), 2, 13, 0, 2)
		elseif ears == 12 then	SetPedPropIndex(PlayerPedId(), 2, 6, 0, 2)
		elseif ears == 13 then	SetPedPropIndex(PlayerPedId(), 2, 15, 0, 2)
		elseif ears == 14 then	SetPedPropIndex(PlayerPedId(), 2, 14, 0, 2)
		elseif ears == 15 then	SetPedPropIndex(PlayerPedId(), 2, 17, 0, 2)
		end
	
		-- Keep these 4 variations together.
		-- 			SetPedComponentVariation(PlayerPedId(), 3, 3, 0, 2)		-- astin boland
		-- It avoids empty arms or noisy clothes superposition
		if tops == 0 then
			SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 15, 0, 2) 	-- Torso 2
		elseif tops == 1 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 0, 0, 2) 		-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 0, 1, 2) 	-- Torso 2
		elseif tops == 2 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 0, 0, 2) 		-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 0, 7, 2) 	-- Torso 2
		elseif tops == 3 then
			SetPedComponentVariation(PlayerPedId(), 3, 2, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 2, 9, 2) 	-- Torso 2
		elseif tops == 4 then
			SetPedComponentVariation(PlayerPedId(), 3, 3, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 2, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 3, 0, 2) 	-- Torso 2
		elseif tops == 5 then
			SetPedComponentVariation(PlayerPedId(), 3, 3, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 2, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 3, 1, 2) 	-- Torso 2
		elseif tops == 6 then
			SetPedComponentVariation(PlayerPedId(), 3, 3, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 2, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 3, 2, 2) 	-- Torso 2
		elseif tops == 7 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 41, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 6, 0, 2) 	-- Torso 2
		elseif tops == 8 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 40, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 6, 1, 2) 	-- Torso 2
		elseif tops == 9 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 40, 1, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 6, 2, 2) 	-- Torso 2
		elseif tops == 10 then
			SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 21, 0, 2) 		-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 8, 0, 2) 	-- Torso 2
		elseif tops == 11 then
			SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 21, 1, 2) 		-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 8, 0, 2) 	-- Torso 2
		elseif tops == 12 then
			SetPedComponentVariation(PlayerPedId(), 3, 9, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 2, 0, 2) 		-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 9, 0, 2) 	-- Torso 2
		elseif tops == 13 then
			SetPedComponentVariation(PlayerPedId(), 3, 9, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 2, 0, 2) 		-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 9, 1, 2) 	-- Torso 2
		elseif tops == 14 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 9, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 14, 0, 2) 	-- Torso 2
		elseif tops == 15 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 9, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 14, 1, 2) 	-- Torso 2
		elseif tops == 16 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 9, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 14, 2, 2) 	-- Torso 2
		elseif tops == 17 then
			SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 9, 0, 2) 		-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 16, 0, 2) 	-- Torso 2
		elseif tops == 18 then
			SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 10, 0, 2) 		-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 16, 1, 2) 	-- Torso 2
		elseif tops == 19 then
			SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 12, 2, 2) 	-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 10, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 16, 2, 2) 	-- Torso 2

			--- here
		elseif tops == 20 then
			SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 18, 0, 2) 	-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 10, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 10, 0, 2) 	-- Torso 2
		elseif tops == 21 then
			SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 11, 2, 2) 	-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 10, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 10, 0, 2) 	-- Torso 2
		elseif tops == 22 then
			SetPedComponentVariation(PlayerPedId(), 3, 12, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 12, 10, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 12, 10, 2) 	-- Torso 2
		elseif tops == 23 then
			SetPedComponentVariation(PlayerPedId(), 3, 11, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 13, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 13, 0, 2) 	-- Torso 2
		elseif tops == 24 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 14, 0, 2) 	-- Torso 2
		elseif tops == 25 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 14, 1, 2) 	-- Torso 2
		elseif tops == 26 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 16, 0, 2) 	-- Torso 2
		elseif tops == 27 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 16, 1, 2) 	-- Torso 2
		elseif tops == 28 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 16, 2, 2) 	-- Torso 2
		elseif tops == 29 then
			SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 17, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 17, 0, 2) 	-- Torso 2
		elseif tops == 30 then
			SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 17, 1, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 17, 1, 2) 	-- Torso 2
		elseif tops == 31 then
			SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 17, 4, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 17, 4, 2) 	-- Torso 2
		elseif tops == 32 then
			SetPedComponentVariation(PlayerPedId(), 3, 11, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 27, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 26, 0, 2) 	-- Torso 2
		elseif tops == 33 then
			SetPedComponentVariation(PlayerPedId(), 3, 11, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 27, 5, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 26, 5, 2) 	-- Torso 2
		elseif tops == 34 then
			SetPedComponentVariation(PlayerPedId(), 3, 11, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 27, 6, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 26, 6, 2) 	-- Torso 2
		elseif tops == 35 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 63, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 31, 0, 2) 	-- Torso 2
		elseif tops == 36 then
			SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 57, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 36, 4, 2) 	-- Torso 2
		elseif tops == 37 then
			SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 57, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 36, 5, 2) 	-- Torso 2
		elseif tops == 38 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 24, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 37, 0, 2) 	-- Torso 2
		elseif tops == 39 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 24, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 37, 1, 2) 	-- Torso 2
		elseif tops == 40 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 24, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 37, 2, 2) 	-- Torso 2
		elseif tops == 41 then
			SetPedComponentVariation(PlayerPedId(), 3, 8, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 38, 0, 2) 	-- Torso 2
		-- elseif tops == 42 then
		-- 	SetPedComponentVariation(PlayerPedId(), 3, 8, 0, 2)		-- Torso
		-- 	SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		-- 	SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
		-- 	SetPedComponentVariation(PlayerPedId(), 11, 38, 3, 2) 	-- Torso 2
		-- elseif tops == 43 then
		-- 	SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
		-- 	SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		-- 	SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
		-- 	SetPedComponentVariation(PlayerPedId(), 11, 39, 0, 2) 	-- Torso 2
		elseif tops == 44 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 39, 1, 2) 	-- Torso 2
		elseif tops == 45 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 41, 0, 2) 	-- Torso 2
		elseif tops == 46 then
			SetPedComponentVariation(PlayerPedId(), 3, 11, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 42, 0, 2) 	-- Torso 2
		elseif tops == 47 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 50, 0, 2) 	-- Torso 2
		elseif tops == 48 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 50, 3, 2) 	-- Torso 2
		elseif tops == 49 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 50, 4, 2) 	-- Torso 2
		elseif tops == 50 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 57, 0, 2) 	-- Torso 2
		elseif tops == 51 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 50, 1, 2) 	-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 23, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 70, 0, 2) 	-- Torso 2
		elseif tops == 52 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 50, 1, 2) 	-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 23, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 70, 1, 2) 	-- Torso 2
		elseif tops == 53 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 50, 1, 2) 	-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 23, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 70, 7, 2) 	-- Torso 2
		elseif tops == 54 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 3, 1, 2) 		-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 72, 1, 2) 	-- Torso 2
		elseif tops == 55 then
			SetPedComponentVariation(PlayerPedId(), 3, 6, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 87, 0, 2) 	-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 5, 0, 2) 		-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 74, 0, 2) 	-- Torso 2
		elseif tops == 56 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 12, 2, 2) 	-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 28, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 77, 0, 2) 	-- Torso 2
		elseif tops == 57 then
			SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 79, 0, 2) 	-- Torso 2
		elseif tops == 58 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 80, 0, 2) 	-- Torso 2
		elseif tops == 59 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 80, 1, 2) 	-- Torso 2
		elseif tops == 60 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 82, 5, 2) 	-- Torso 2
		elseif tops == 61 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 82, 8, 2) 	-- Torso 2
		elseif tops == 62 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 82, 9, 2) 	-- Torso 2
		elseif tops == 63 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 86, 0, 2) 	-- Torso 2
		elseif tops == 64 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 86, 2, 2) 	-- Torso 2
		elseif tops == 65 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 86, 4, 2) 	-- Torso 2
		elseif tops == 66 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 87, 11, 2) 	-- Torso 2
		elseif tops == 67 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 87, 0, 2) 	-- Torso 2
		elseif tops == 68 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 87, 1, 2) 	-- Torso 2
		elseif tops == 69 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 87, 2, 2) 	-- Torso 2
		elseif tops == 70 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 87, 4, 2) 	-- Torso 2
		elseif tops == 71 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 87, 8, 2) 	-- Torso 2
		elseif tops == 72 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 89, 0, 2) 	-- Torso 2
		elseif tops == 73 then
			SetPedComponentVariation(PlayerPedId(), 3, 11, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 95, 0, 2) 	-- Torso 2
		elseif tops == 74 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 31, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 99, 1, 2) 	-- Torso 2
		elseif tops == 75 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 31, 13, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 99, 3, 2) 	-- Torso 2
		elseif tops == 76 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 31, 13, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 101, 0, 2) 	-- Torso 2
		elseif tops == 77 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 105, 0, 2) 	-- Torso 2
		elseif tops == 78 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 10, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 106, 0, 2) 	-- Torso 2
		elseif tops == 79 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 73, 2, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 109, 0, 2) 	-- Torso 2
		elseif tops == 80 then
			SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 111, 0, 2) 	-- Torso 2
		elseif tops == 81 then
			SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 111, 3, 2) 	-- Torso 2
		elseif tops == 82 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 113, 0, 2) 	-- Torso 2
		elseif tops == 83 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 126, 5, 2) 	-- Torso 2
		elseif tops == 84 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 126, 9, 2) 	-- Torso 2
		elseif tops == 85 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 126, 10, 2) 	-- Torso 2
		elseif tops == 86 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 126, 14, 2) 	-- Torso 2
		elseif tops == 87 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 131, 0, 2) 	-- Torso 2
		elseif tops == 88 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 134, 0, 2) 	-- Torso 2
		elseif tops == 89 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 134, 1, 2) 	-- Torso 2
		elseif tops == 90 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 143, 0, 2) 	-- Torso 2
		elseif tops == 91 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 143, 2, 2) 	-- Torso 2
		elseif tops == 92 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 143, 4, 2) 	-- Torso 2
		elseif tops == 93 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 143, 5, 2) 	-- Torso 2
		elseif tops == 94 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 143, 6, 2) 	-- Torso 2
		elseif tops == 95 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 143, 8, 2) 	-- Torso 2
		elseif tops == 96 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 143, 9, 2) 	-- Torso 2
		elseif tops == 97 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 146, 0, 2) 	-- Torso 2
		elseif tops == 98 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 16, 2, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 166, 0, 2) 	-- Torso 2
		elseif tops == 99 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 38, 1, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 167, 0, 2) 	-- Torso 2
		elseif tops == 100 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 38, 1, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 167, 4, 2) 	-- Torso 2
		elseif tops == 101 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 38, 1, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 167, 6, 2) 	-- Torso 2
		elseif tops == 102 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 38, 1, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 167, 12, 2) 	-- Torso 2
		elseif tops == 103 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 38, 1, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 169, 0, 2) 	-- Torso 2
		elseif tops == 104 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 38, 1, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 172, 0, 2) 	-- Torso 2
		elseif tops == 105 then
			SetPedComponentVariation(PlayerPedId(), 3, 2, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 38, 1, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 173, 0, 2) 	-- Torso 2
		elseif tops == 106 then
			SetPedComponentVariation(PlayerPedId(), 3, 2, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 41, 2, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 185, 0, 2) 	-- Torso 2
		elseif tops == 107 then
			SetPedComponentVariation(PlayerPedId(), 3, 2, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 202, 0, 2) 	-- Torso 2
		elseif tops == 108 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 203, 10, 2) 	-- Torso 2
		elseif tops == 109 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 203, 16, 2) 	-- Torso 2
		elseif tops == 110 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 203, 25, 2) 	-- Torso 2
		elseif tops == 111 then
			SetPedComponentVariation(PlayerPedId(), 3, 2, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 205, 0, 2) 	-- Torso 2
		elseif tops == 112 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 226, 0, 2) 	-- Torso 2
		elseif tops == 113 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 257, 0, 2) 	-- Torso 2
		elseif tops == 114 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 257, 9, 2) 	-- Torso 2
		elseif tops == 115 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 257, 17, 2) 	-- Torso 2
		elseif tops == 116 then
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 259, 9, 2) 	-- Torso 2
		elseif tops == 117 then
			SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 5, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 269, 2, 2) 	-- Torso 2
		elseif tops == 118 then
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
			SetPedComponentVariation(PlayerPedId(), 11, 282, 6, 2) 	-- Torso 2
		end
		-- SetPedComponentVariation(PlayerPedId(), 3, bazo, 0, 2)		-- Torso
	
		if pants == 0 then 		SetPedComponentVariation(PlayerPedId(), 4, 15, 0, 2)
		elseif pants == 1 then	SetPedComponentVariation(PlayerPedId(), 4, 0, 0, 2)
		elseif pants == 2 then	SetPedComponentVariation(PlayerPedId(), 4, 0, 2, 2)
		elseif pants == 3 then	SetPedComponentVariation(PlayerPedId(), 4, 2, 2, 2)
		elseif pants == 4 then	SetPedComponentVariation(PlayerPedId(), 4, 2, 1, 2)
		elseif pants == 5 then	SetPedComponentVariation(PlayerPedId(), 4, 3, 0, 2)
		elseif pants == 6 then	SetPedComponentVariation(PlayerPedId(), 4, 4, 0, 2)
		elseif pants == 7 then	SetPedComponentVariation(PlayerPedId(), 4, 4, 1, 2)
		elseif pants == 8 then	SetPedComponentVariation(PlayerPedId(), 4, 4, 4, 2)
		elseif pants == 9 then	SetPedComponentVariation(PlayerPedId(), 4, 85, 0, 2)
		elseif pants == 10 then	SetPedComponentVariation(PlayerPedId(), 4, 6, 0, 2)
		elseif pants == 11 then	SetPedComponentVariation(PlayerPedId(), 4, 7, 0, 2)
		elseif pants == 12 then	SetPedComponentVariation(PlayerPedId(), 4, 11, 1, 2)
		elseif pants == 13 then	SetPedComponentVariation(PlayerPedId(), 4, 11, 0, 2)
		elseif pants == 14 then	SetPedComponentVariation(PlayerPedId(), 4, 11, 2, 2)
		elseif pants == 15 then	SetPedComponentVariation(PlayerPedId(), 4, 23, 0, 2)
		elseif pants == 16 then	SetPedComponentVariation(PlayerPedId(), 4, 23, 2, 2)
		elseif pants == 17 then	SetPedComponentVariation(PlayerPedId(), 4, 25, 0, 2)
		elseif pants == 18 then	SetPedComponentVariation(PlayerPedId(), 4, 25, 1, 2)
		elseif pants == 19 then	SetPedComponentVariation(PlayerPedId(), 4, 25, 2, 2)
		elseif pants == 20 then	SetPedComponentVariation(PlayerPedId(), 4, 27, 0, 2)
		elseif pants == 21 then	SetPedComponentVariation(PlayerPedId(), 4, 27, 1, 2)
		elseif pants == 22 then	SetPedComponentVariation(PlayerPedId(), 4, 27, 3, 2)
		elseif pants == 23 then	SetPedComponentVariation(PlayerPedId(), 4, 30, 4, 2)
		elseif pants == 24 then	SetPedComponentVariation(PlayerPedId(), 4, 30, 0, 2)
		elseif pants == 25 then	SetPedComponentVariation(PlayerPedId(), 4, 31, 0, 2)
		elseif pants == 26 then	SetPedComponentVariation(PlayerPedId(), 4, 83, 0, 2)
		elseif pants == 27 then	SetPedComponentVariation(PlayerPedId(), 4, 31, 2, 2)
		elseif pants == 28 then	SetPedComponentVariation(PlayerPedId(), 4, 43, 0, 2)
		elseif pants == 29 then	SetPedComponentVariation(PlayerPedId(), 4, 43, 1, 2)
		elseif pants == 30 then	SetPedComponentVariation(PlayerPedId(), 4, 43, 2, 2)
		elseif pants == 31 then	SetPedComponentVariation(PlayerPedId(), 4, 43, 3, 2)
		elseif pants == 32 then	SetPedComponentVariation(PlayerPedId(), 4, 44, 0, 2)
		elseif pants == 33 then	SetPedComponentVariation(PlayerPedId(), 4, 44, 2, 2)
		elseif pants == 34 then	SetPedComponentVariation(PlayerPedId(), 4, 51, 0, 2)
		elseif pants == 35 then	SetPedComponentVariation(PlayerPedId(), 4, 51, 1, 2)
		elseif pants == 36 then	SetPedComponentVariation(PlayerPedId(), 4, 51, 2, 2)
		elseif pants == 37 then	SetPedComponentVariation(PlayerPedId(), 4, 64, 1, 2)
		elseif pants == 38 then	SetPedComponentVariation(PlayerPedId(), 4, 64, 0, 2)
		elseif pants == 39 then	SetPedComponentVariation(PlayerPedId(), 4, 14, 0, 2)
		elseif pants == 40 then	SetPedComponentVariation(PlayerPedId(), 4, 49, 0, 2)
		elseif pants == 41 then	SetPedComponentVariation(PlayerPedId(), 4, 49, 1, 2)
		elseif pants == 42 then	SetPedComponentVariation(PlayerPedId(), 4, 54, 1, 2)
		elseif pants == 43 then	SetPedComponentVariation(PlayerPedId(), 4, 55, 0, 2)
		elseif pants == 44 then	SetPedComponentVariation(PlayerPedId(), 4, 73, 2, 2)
		elseif pants == 45 then	SetPedComponentVariation(PlayerPedId(), 4, 73, 1, 2)
		elseif pants == 46 then	SetPedComponentVariation(PlayerPedId(), 4, 74, 0, 2)
		elseif pants == 47 then	SetPedComponentVariation(PlayerPedId(), 4, 74, 2, 2)
		elseif pants == 48 then	SetPedComponentVariation(PlayerPedId(), 4, 74, 1, 2)
		elseif pants == 49 then	SetPedComponentVariation(PlayerPedId(), 4, 78, 0, 2)
		elseif pants == 50 then	SetPedComponentVariation(PlayerPedId(), 4, 77, 0, 2)
		elseif pants == 51 then	SetPedComponentVariation(PlayerPedId(), 4, 80, 0, 2)
		elseif pants == 52 then	SetPedComponentVariation(PlayerPedId(), 4, 81, 0, 2)
		elseif pants == 53 then	SetPedComponentVariation(PlayerPedId(), 4, 82, 0, 2)
		elseif pants == 54 then	SetPedComponentVariation(PlayerPedId(), 4, 84, 0, 2)
		elseif pants == 55 then	SetPedComponentVariation(PlayerPedId(), 4, 87, 0, 2)
		elseif pants == 56 then	SetPedComponentVariation(PlayerPedId(), 4, 12, 5, 2)
		elseif pants == 57 then	SetPedComponentVariation(PlayerPedId(), 4, 12, 7, 2)
		end
	
		if shoes == 0 then 	SetPedComponentVariation(PlayerPedId(), 6, 35, 0, 2)
		elseif shoes == 1 then	SetPedComponentVariation(PlayerPedId(), 6, 0, 0, 2)
		elseif shoes == 2 then	SetPedComponentVariation(PlayerPedId(), 6, 1, 0, 2)
		elseif shoes == 3 then	SetPedComponentVariation(PlayerPedId(), 6, 1, 1, 2)
		elseif shoes == 4 then	SetPedComponentVariation(PlayerPedId(), 6, 1, 2, 2)
		elseif shoes == 5 then	SetPedComponentVariation(PlayerPedId(), 6, 1, 3, 2)
		elseif shoes == 6 then	SetPedComponentVariation(PlayerPedId(), 6, 3, 6, 2)
		elseif shoes == 7 then	SetPedComponentVariation(PlayerPedId(), 6, 3, 1, 2)
		elseif shoes == 8 then	SetPedComponentVariation(PlayerPedId(), 6, 4, 0, 2)
		elseif shoes == 9 then	SetPedComponentVariation(PlayerPedId(), 6, 4, 1, 2)
		elseif shoes == 10 then SetPedComponentVariation(PlayerPedId(), 6, 4, 2, 2)
		elseif shoes == 11 then SetPedComponentVariation(PlayerPedId(), 6, 5, 0, 2)
		elseif shoes == 12 then SetPedComponentVariation(PlayerPedId(), 6, 6, 0, 2)
		elseif shoes == 13 then SetPedComponentVariation(PlayerPedId(), 6, 6, 1, 2)
		elseif shoes == 14 then SetPedComponentVariation(PlayerPedId(), 6, 7, 0, 2)
		elseif shoes == 15 then SetPedComponentVariation(PlayerPedId(), 6, 7, 9, 2)
		elseif shoes == 16 then SetPedComponentVariation(PlayerPedId(), 6, 7, 13, 2)
		elseif shoes == 17 then SetPedComponentVariation(PlayerPedId(), 6, 9, 0, 2)
		elseif shoes == 18 then SetPedComponentVariation(PlayerPedId(), 6, 9, 1, 2)
		elseif shoes == 19 then SetPedComponentVariation(PlayerPedId(), 6, 9, 2, 2)
		elseif shoes == 20 then SetPedComponentVariation(PlayerPedId(), 6, 10, 0, 2)
		elseif shoes == 21 then SetPedComponentVariation(PlayerPedId(), 6, 10, 1, 2)
		elseif shoes == 22 then SetPedComponentVariation(PlayerPedId(), 6, 14, 0, 2)
		elseif shoes == 23 then SetPedComponentVariation(PlayerPedId(), 6, 14, 1, 2)
		elseif shoes == 24 then SetPedComponentVariation(PlayerPedId(), 6, 15, 0, 2)
		elseif shoes == 25 then SetPedComponentVariation(PlayerPedId(), 6, 15, 1, 2)
		elseif shoes == 26 then SetPedComponentVariation(PlayerPedId(), 6, 18, 0, 2)
		elseif shoes == 27 then SetPedComponentVariation(PlayerPedId(), 6, 18, 1, 2)
		elseif shoes == 28 then SetPedComponentVariation(PlayerPedId(), 6, 19, 0, 2)
		elseif shoes == 29 then SetPedComponentVariation(PlayerPedId(), 6, 20, 0, 2)
		elseif shoes == 30 then SetPedComponentVariation(PlayerPedId(), 6, 22, 0, 2)
		elseif shoes == 31 then SetPedComponentVariation(PlayerPedId(), 6, 22, 1, 2)
		elseif shoes == 32 then SetPedComponentVariation(PlayerPedId(), 6, 55, 0, 2)
		elseif shoes == 33 then SetPedComponentVariation(PlayerPedId(), 6, 23, 2, 2)
		elseif shoes == 34 then SetPedComponentVariation(PlayerPedId(), 6, 23, 0, 2)
		elseif shoes == 35 then SetPedComponentVariation(PlayerPedId(), 6, 25, 0, 2)
		elseif shoes == 36 then SetPedComponentVariation(PlayerPedId(), 6, 66, 0, 2)
		elseif shoes == 37 then SetPedComponentVariation(PlayerPedId(), 6, 61, 0, 2)
		elseif shoes == 38 then SetPedComponentVariation(PlayerPedId(), 6, 61, 1, 2)
		elseif shoes == 39 then SetPedComponentVariation(PlayerPedId(), 6, 77, 1, 2)
		elseif shoes == 40 then SetPedComponentVariation(PlayerPedId(), 6, 77, 0, 2)
		elseif shoes == 41 then SetPedComponentVariation(PlayerPedId(), 6, 33, 0, 2)
		elseif shoes == 42 then SetPedComponentVariation(PlayerPedId(), 6, 33, 1, 2)
		elseif shoes == 43 then SetPedComponentVariation(PlayerPedId(), 6, 33, 2, 2)
		elseif shoes == 44 then SetPedComponentVariation(PlayerPedId(), 6, 36, 0, 2)
		elseif shoes == 45 then SetPedComponentVariation(PlayerPedId(), 6, 36, 1, 2)
		elseif shoes == 46 then SetPedComponentVariation(PlayerPedId(), 6, 36, 0, 2)
		elseif shoes == 47 then SetPedComponentVariation(PlayerPedId(), 6, 43, 4, 2)
		elseif shoes == 48 then SetPedComponentVariation(PlayerPedId(), 6, 44, 3, 2)
		elseif shoes == 49 then SetPedComponentVariation(PlayerPedId(), 6, 49, 0, 2)
		elseif shoes == 50 then SetPedComponentVariation(PlayerPedId(), 6, 50, 0, 2)
		end
	
		if watches == 0 then		ClearPedProp(PlayerPedId(), 6)
		elseif watches == 1 then	SetPedPropIndex(PlayerPedId(), 6, 16, 1-1, 2)
		elseif watches == 2 then	SetPedPropIndex(PlayerPedId(), 6, 5, 1-1, 2)
		elseif watches == 3 then	SetPedPropIndex(PlayerPedId(), 6, 6, 1-1, 2)
		elseif watches == 4 then	SetPedPropIndex(PlayerPedId(), 6, 7, 3-1, 2)
		elseif watches == 5 then	SetPedPropIndex(PlayerPedId(), 6, 8, 1-1, 2)
		elseif watches == 6 then	SetPedPropIndex(PlayerPedId(), 6, 9, 1-1, 2)
		elseif watches == 7 then	SetPedPropIndex(PlayerPedId(), 6, 10, 1-1, 2)
		end
		
		-- SetPedHeadOverlay       	(PlayerPedId(), 4, lipstick, lipopacity)   	-- Lipstick
		SetPedHeadOverlay       	(PlayerPedId(), 8, 3, makeupopacity/10) 		-- lipstick
		SetPedHeadOverlayColor  	(PlayerPedId(), 8, 2, makeupcolor, 0)      -- lipstick
		-- SetPedHeadOverlayColor  	(PlayerPedId(), 8, 2, lipstickcolor, 0)      -- Lipstick Color
	end
end

-- Character rotation
RegisterNUICallback('rotateleftheading', function(data)
	local currentHeading = GetEntityHeading(PlayerPedId())
	SetEntityHeading(PlayerPedId(), currentHeading+tonumber(data.value))
end)

RegisterNUICallback('rotaterightheading', function(data)
	local currentHeading = GetEntityHeading(PlayerPedId())
	SetEntityHeading(PlayerPedId(), currentHeading-tonumber(data.value))
end)

-- Define which part of the body must be zoomed
RegisterNUICallback('zoom', function(data)
	zoom = data.zoom
end)


------------------------------------------------------------------
--                          Functions
------------------------------------------------------------------
local disabledBefore = false
local camerases = nil
local enabled = false
function toggleMenu(enable)
	local ped = PlayerPedId()
	if enable and camerases ~= zoom then
		-- SetPlayerInvincible(ped, true)
		RenderScriptCams(false, false, 0, 1, 0)
		DestroyCam(cam, false)
		if(not DoesCamExist(cam)) then
			cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
			SetCamCoord(cam, GetEntityCoords(PlayerPedId()))
			SetCamRot(cam, 0.0, 0.0, 0.0)
			SetCamActive(cam,  true)
			RenderScriptCams(true,  false,  0,  true,  true)
			SetCamCoord(cam, GetEntityCoords(PlayerPedId()))
		end
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
		if zoom == "visage" or zoom == "pilosite" then
			SetCamCoord(cam, x+0.2, y+0.5, z+0.7)
			SetCamRot(cam, 0.0, 0.0, 150.0)
		elseif zoom == "vetements" then
			SetCamCoord(cam, x+0.3, y+2.0, z+0.0)
			SetCamRot(cam, 0.0, 0.0, 170.0)
		end
		camerases = zoom
	end
	if enable == true then
		DisableControlAction(2, 14, true)
		DisableControlAction(2, 15, true)
		DisableControlAction(2, 16, true)
		DisableControlAction(2, 17, true)
		DisableControlAction(2, 30, true)
		DisableControlAction(2, 31, true)
		DisableControlAction(2, 32, true)
		DisableControlAction(2, 33, true)
		DisableControlAction(2, 34, true)
		DisableControlAction(2, 35, true)
		DisableControlAction(0, 25, true)
		DisableControlAction(0, 24, true)

		-- if IsDisabledControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
		-- 	SendNUIMessage({type = "click"})
		-- end
		disabledBefore = false
	elseif not enable and (not disabledBefore or camerases ~= zoom) then
		RenderScriptCams(false, true, 500, 0, 0)

		camerases = true
		FreezeEntityPosition(ped, false)
		-- SetPlayerInvincible(ped, false)
		disabledBefore = true
	end

	if enable ~= enabled then
		SetEntityHeading(PlayerPedId(), heading)
		enabled = enable
		SetNuiFocus(enable, enable)
		SendNUIMessage({
			openSkinCreator = enable
		})
	end

end



------------------------------------------------------------------
--                          Citizen
------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		toggleMenu(showMenu)
	end
end)