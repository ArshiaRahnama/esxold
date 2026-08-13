local TargetNumber = {}
ESX = nil
local PlayerData
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end



    while ESX.GetPlayerData().job == nil do 
        Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
    PlayerData.job = ESX.GetPlayerData().job

    while true do 
        Wait(1)
 
        if IsControlJustPressed(0, 167) and PlayerData.job.name == 'uwucafe' then 
            OpenMobileuwueActionsMenu()
        end
    end
    
    
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    UwUCafeMenuAction()
    
end)

Citizen.CreateThread(function()
    for k,v in pairs(Config.uwustasion) do 
       

        local blip = AddBlipForCoord(v.Blip.Pos.x, v.Blip.Pos.y, v.Blip.Pos.z)

        SetBlipSprite (blip, v.Blip.Sprite)
        SetBlipDisplay(blip, v.Blip.Display)
        SetBlipScale  (blip, v.Blip.Scale)
        SetBlipColour (blip, v.Blip.Colour)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(_U('map_blip'))
        EndTextCommandSetBlipName(blip)

    end

 

end)


function RemoveTarget()
    local zoneName = nil
    local zoneNum  = nil
    local Ncount = #TargetNumber
    while Ncount ~= 0 do 
        for k,v in pairs(TargetNumber) do 
            
            exports.ox_target:removeZone(v.num)
            table.remove(TargetNumber, k)
            Citizen.Wait(20)
            Ncount = Ncount - 1
        end
    end
end


-- Target --
function CreateOXTarget(coord, name, event, icon)
    -- freezer
    local numt = exports.ox_target:addBoxZone({
        coords = vec3(coord.x, coord.y, coord.z),
        size = vec3(1.5, 1.5, 1.5),
        rotation = 45,
        debug = false,
        options = {
            {
                name = name,
                event = event,
                icon = icon,
                label = name,
            },
        }
    })
    Citizen.Wait(500)
    table.insert(TargetNumber, {name = name, num = numt})
end

function CreateOXTargetNotJob(coord, name, event, icon)
    -- freezer
    local numt = exports.ox_target:addBoxZone({
        coords = vec3(coord.x, coord.y, coord.z),
        size = vec3(1.5, 1.5, 1.5),
        rotation = 45,
        debug = false,
        options = {
            {
                name = name,
                event = event,
                icon = icon,
                label = name,
            },
        }
    })
end

-- Freezer --

function FreezerTarget()
    -- freezer --
    for k,v in pairs(Config.uwustasion) do 
        CreateOXTarget(v.Freezer.Pos, v.Freezer.Name, 'AH_uwucafejob:OpenInventory', v.Freezer.Icon)
    end
    -- ped --
    for k,v in pairs(Config.uwustasion) do 
        CreateOXTarget(v.PedShop.Pos, v.PedShop.Name, 'AH_uwucafejob:OpenShopMenus', v.PedShop.Icon)
    end
    -- Boss Action --
    for k,v in pairs(Config.uwustasion) do 
        CreateOXTarget(v.BossAction.Pos, v.BossAction.Name, 'AH_uwucafejob:OpenBossMenus', v.BossAction.Icon)
    end
    -- Cloack Room --
    for k,v in pairs(Config.uwustasion) do 
        CreateOXTarget(v.CloackRoom.Pos, v.CloackRoom.Name, 'AH_uwucafejob:OpenCloakroomMenu', v.CloackRoom.Icon)
    end
    -- Crafting Ham Zan--
    for k,v in pairs(Config.uwustasion) do 
        CreateOXTarget(v.Crafting_Hamzan.Pos, v.Crafting_Hamzan.Name, 'AH_uwucafejob:OpenCraftingHamzan', v.Crafting_Hamzan.Icon)
    end
    -- Crafting Ghahve Saz--
    for k,v in pairs(Config.uwustasion) do 
        CreateOXTarget(v.Crafting_Ghahvesaz.Pos, v.Crafting_Ghahvesaz.Name, 'AH_uwucafejob:OpenCraftingGhahvesaz', v.Crafting_Ghahvesaz.Icon)
    end
    -- Crafting Zarf Shoe--
    for k,v in pairs(Config.uwustasion) do 
        CreateOXTarget(v.Crafting_ZarfShoe.Pos, v.Crafting_ZarfShoe.Name, 'AH_uwucafejob:OpenCraftingZarfShoe', v.Crafting_ZarfShoe.Icon)
    end
    -- Crafting Gaz--
    for k,v in pairs(Config.uwustasion) do 
        CreateOXTarget(v.Crafting_Gaz.Pos, v.Crafting_Gaz.Name, 'AH_uwucafejob:OpenCraftingGaz', v.Crafting_Gaz.Icon)
    end
  
end

Citizen.CreateThread(function()
    local options = {}
    local input   = nil
    -- for k,v in pairs(Config.uwustasion) do 
    --     local ped = CreatePed(v.PedShop.Model, GetHashKey(v.PedShop.Model), v.PedShop.Pos.x,v.PedShop.Pos.y, v.PedShop.Pos.z-1, v.PedShop.Pos.h, true, true)
    --     FreezeEntityPosition(ped, true)
    --     SetEntityInvincible(ped, true)
    --     SetBlockingOfNonTemporaryEvents(ped, true)
    -- end

    for k,v in pairs(Config.UwUShopItem) do 

        table.insert(options, {label = v.label.."      "..v.price.." $", icon = v.icon, args = {item = v.args,  price = v.price,}})
    end

    lib.registerMenu({
        id = 'shop_menu_uwu',
        title = 'Foroshgah',
        position = 'top-right',
        -- onSideScroll = function(selected, scrollIndex, args)

        -- end,
        onSelected = function(selected, secondary, args)
            if args.item then
             
          
            end
        end,
        onClose = function(keyPressed)
          
            if keyPressed then
          
            end
        end,

        options = options
        
    }, function(selected, scrollIndex, args)
        ::relog::
        input = lib.inputDialog('Buy Item', {'Tedad'})
       
        if input[1] and tonumber(input[1]) then
            TriggerServerEvent('AH_uwucafejob:BuyItems', args.item, input[1], args.price)
            Wait(300)
            OpendMenuShops()
        else
            input = nil
            goto relog
        end
    end)
end)

function OpendMenuShops()
    lib.showMenu('shop_menu_uwu')
end


function OpenCloakroomMenu()
    local elements = {}
    local nname = {}
    local playerPed = PlayerPedId()
    local grade = PlayerData.job.grade_name
    local dvisname
    local elements = {
        {label = "Lebas Kar", value = 'work_wear'},
        { label = _U('citizen_wear'), value = 'citizen_wear' },
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
    {
        title    = _U('cloakroom'),
        align    = 'left',
        elements = elements
    }, function(data, menu)

        cleanPlayer(playerPed)

        if data.current.value == 'citizen_wear' then

            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
        end

        if data.current.value == 'work_wear' then
            local job =  PlayerData.job.name
            local gradenum =  PlayerData.job.grade
            
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                ESX.TriggerServerCallback('esx_society:getUniforms', function(SkinMale, SkinFemale)-- get uniform from esx_society
                
                    if skin.sex == 0 then
                        TriggerEvent('skinchanger:loadClothes', skin, SkinMale)
                    else
                        TriggerEvent('skinchanger:loadClothes', skin, SkinFemale)
                    end
                    
                end,gradenum, job)
                
            end)
                
        end
    end, function(data, menu)
        menu.close()
    end)

end


function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

RegisterNetEvent('AH_uwucafejob:OpenMenuSefaresh')
AddEventHandler('AH_uwucafejob:OpenMenuSefaresh', function()
    ESX.TriggerServerCallback('AH_uwucafejob:GetOnDutyJob', function(tojob) 
        if tojob then 
            lib.showContext('uwu_menu')
        else
            ExecuteCommand('asdfghjkl;sfsdfsdfzxcvnads23adfghuwu')
        end
    end)
end)



Citizen.CreateThread(function()

    SetTimeout(5000, function()

        for k,v in pairs(Config.uwustasion) do 
            CreateOXTargetNotJob(v.Menu_Sefaresh.Pos, v.Menu_Sefaresh.Name, 'AH_uwucafejob:OpenMenuSefaresh', v.Menu_Sefaresh.Icon)
        end
        UwUCafeMenuAction()
    end)
end)

function UwUCafeMenuAction()
    local options = {}
    
    if PlayerData.job.name == "uwucafe" then 
        table.insert(options, {
            title = 'Action House', 
            value = 'menu_Action', 
            onSelect = function()
                ExecuteCommand('asdfghjkl;sfsdfsdfzxcvnads23adfghuwu')
            end
        })
    end

    table.insert(options, {title = 'Menu Cake', value = 'menu_cakes', onSelect = function() lib.showContext('cake_menu') end})
    table.insert(options, {title = 'Menu Noshidani', value = 'menu_noshidani', onSelect = function() lib.showContext('noshidani_menu') end})

    Citizen.Wait(2000)
    lib.registerContext({
        id = 'uwu_menu',
        title = 'UwU Menu',
        icon = 'fa-brands fa-shopify',
        options = options
        
    })
end


Citizen.CreateThread(function()
    local options1 = {}
    
    for i, item in ipairs(Config.UwUMenu_Cake_Item) do
      table.insert(options1, {
            title = item.title,
            description = 'Price: $' .. item.price,
            icon = item.image,
            image = item.image,
            onSelect = function()
             
              lib.showContext('cake_menu')
            end
      })
    end
 
    lib.registerContext({
        id = 'cake_menu',
        title = 'Cake Items',
        menu = 'uwu_menu',
        onBack = function()
          
         
        end,
        options = options1
    })

    local options2 = {}
    
    for i, item in ipairs(Config.UwUMenu_Noshidani_Item) do
      table.insert(options2, {
            title = item.title,
            description = 'Price: $' .. item.price,
            icon = item.image,
            image = item.image,
            onSelect = function()
              
              lib.showContext('noshidani_menu')
            end
      })
    end
 
    lib.registerContext({
        id = 'noshidani_menu',
        title = 'Noshidani Items',
        menu = 'uwu_menu',
        onBack = function()
        
        end,
        options = options2
    })

    
end)
  
    
local prop = nil
function OpenMobileuwueActionsMenu()
    ESX.UI.Menu.CloseAll()
		

    elements = {
        {label = 'Ghabz ',   value = 'bling'},
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
        title    = "UwU Cafe Menu",
        align    = 'bottom-right',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'bling' then 
            PlayerBlingMenu()
        end
       

    end, function(data, menu)
        menu.close()
    end)
	
end

function PlayerBlingMenu()
	ESX.UI.Menu.CloseAll()
	dataplayer = {}
	local elements = {}
	local nearbyPlayers = getNearbyPlayers(3) 
	local elements = {}
	table.insert(elements, {label = "ID"  , value = " " })
	local playerId22 = GetPlayerServerId(PlayerId())
	local names = nil
	
	for _, player in ipairs(nearbyPlayers) do
		local playerPed = GetPlayerPed(GetPlayerFromServerId(player.id)) 
		local health = GetEntityHealth(playerPed) 
		if player.id ~= playerId22 and health ~= 0 then
			
            table.insert(elements, { label = "Player ID : " .. " [" .. player.id .. "]", value = player.id })
			
		end
	end

	Citizen.Wait(500)

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'bling_player',
		{
			title = "Bling Player ID",
			align = 'center-left',
			elements = elements
		}, function(data, menu)

			if data.current.value ~= " " then 
				
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 or closestDistance > 2.0 then
					ESX.ShowNotification("No players nearby!")
				else
					
					local playerid = data.current.value

                    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
                        title = 'Qeymat'
                    }, function(data2, menu2)
                        local amount = tonumber(data2.value)
                        if amount == nil then
                            
                        else
                            menu2.close()
                            if closestPlayer == -1 or closestDistance > 2.0 then
                                ESX.ShowNotification("No players nearby!")
                            else
                                TriggerServerEvent("AH_uwucafejob:blingrequest", playerid, GetPlayerServerId(PlayerId()), amount)

                            end
                        end
                    end, function(data2, menu2)
                        menu2.close()
                    end)
					
					stopActiveMarker()
			
					-- ESX.UI.Menu.CloseAll()
						
					
				end
				
			
		end


        
			
		end, function(data, menu)
			menu.close()

			
		end, function(data, menu)
			local tttrp = true
			stopActiveMarker()
			Wait(5)
			
			local targetPlayer = GetPlayerPed(GetPlayerFromServerId(data.current.value))
			activeMarkerThread = true
			
			local playerId22 = GetPlayerServerId(PlayerId())

			while activeMarkerThread and tttrp do
				if DoesEntityExist(targetPlayer) then
					local coords = GetEntityCoords(targetPlayer)
					if data.current.value ~= " " then
						

						DrawMarker(23, coords.x, coords.y, coords.z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 0, 255, 0, 100, false, true, 2, nil, nil, false)
						
						if IsControlJustPressed(0, 177) or IsControlJustPressed(0, 322) then
							tttrp = false
						end
					else 

					end
				else
					stopActiveMarker()
				end
				Wait(0)
			end
			
		end,function()

		end
	)
end

RegisterNetEvent('AH_uwucafejob:OpenMenuDialog')
AddEventHandler('AH_uwucafejob:OpenMenuDialog', function(player, target, amount)

    ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'Aks_For_bling',
        {
            title 	 = 'Qgabz UwU Cafe',
            align    = 'center',
            question = "Aya Shoma Qhabz ("..amount.."$) Ra Ghabol Darid ?",
            elements = {
                {label = 'Bale', value = 'yes'},
                {label = 'Kheir', value = 'no'},
            },
        }, 
        function(data, menu)
            if data.current.value == 'yes' then
                TriggerServerEvent('esx_billing:send2Bill2', target, player, 'society_uwucafe', 'uwucafe', amount)
                TriggerServerEvent("AH_uwucafejob:ChatMessage",target, player, true)

                ESX.UI.Menu.CloseAll()		
            elseif data.current.value == 'no' then
               
                TriggerServerEvent("AH_uwucafejob:ChatMessage",target, player, false)
                menu.close()
                												
            end
        end
    )
end)

function getNearbyPlayers(radius)
    local players = {}
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _, playerId in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(playerId)
        local targetCoords = GetEntityCoords(targetPed)
        local distance = #(playerCoords - targetCoords)

        if distance <= radius then
            table.insert(players, {
                id = GetPlayerServerId(playerId),
                name = GetPlayerName(playerId)
            })
        end
    end

    return players
end

local activeMarkerTarget = nil 
function stopActiveMarker()
    if activeMarkerThread then
        activeMarkerThread = nil
    end
end