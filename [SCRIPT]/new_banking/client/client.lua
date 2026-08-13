--================================================================================================
--==                                VARIABLES - DO NOT EDIT                                     ==
--================================================================================================
ESX                         = nil
inMenu                      = false
local showblips = true
local atbank = true
local bankMenu = true
local anim = "mini@atmenter"
local condition, blocked = false, false
local isnearBank = false
local modeltypes = {'prop_fleeca_atm', 'prop_atm_01', 'prop_atm_02', 'prop_atm_03'}
IsPlayerUsingAtm = false

local banks = {
  {name="Bank", id=108, x=150.266, y=-1040.203, z=29.374},
  {name="Bank", id=108, x=-1212.980, y=-330.841, z=37.787},
  {name="Bank", id=108, x=-2962.582, y=482.627, z=15.703},
  {name="Bank", id=108, x=-112.202, y=6469.295, z=31.626},
  {name="Bank", id=108, x=314.187, y=-278.621, z=54.170},
  {name="Bank", id=108, x=-351.534, y=-49.529, z=49.042},
  {name="Bank", id=106, x=246.40, y=222.99, z=106.29},
  {name="Bank", id=108, x=1175.0643310547, y=2706.6435546875, z=38.094036102295}
}	
--================================================================================================
--==                                THREADING - DO NOT EDIT                                     ==
--================================================================================================

--===============================================
--==           Base ESX Threading              ==
--===============================================
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(1)
  end
end)

RegisterNetEvent('new_banking:disableforhour')
AddEventHandler('new_banking:disableforhour', function(pos, time)
  local condition = true
  SetTimeout(time, function()
    condition = false
    blocked = false
  end)
  Citizen.CreateThread(function()
    while condition do
      Citizen.Wait(5000)
      local playerloc = GetEntityCoords(PlayerPedId())
      local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, playerloc, false)
      if distance <= 20.0 then
        blocked = true
      else
        blocked = false
      end
    end
  end)
end)


RegisterNetEvent('currentbalance1')
AddEventHandler('currentbalance1', function(balance, iban)
    local id = PlayerId()
    local playerName = GetPlayerName(id)
    SendNUIMessage({
        type = "balanceHUD",
        balance = balance,
        player = playerName,
        cardnumber = iban -- اضافه کردن IBAN به داده‌های ارسالی به UI
    })
end)

--===============================================
--==             Core Threading                ==
--===============================================
Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(500)

	  if nearBank() then
		isnearBank = true
	  else
		isnearBank = false
	  end
	  
	  

	end
end)

Citizen.CreateThread(function()
	SetNuiFocus(false)
	SendNUIMessage({type = 'close'})

	while true do
		Wait(550)
		playerPed = PlayerPedId()
		x,y,z = table.unpack(GetEntityCoords(playerPed, true))
		IsPlayerInVehicle = IsPedInAnyVehicle(playerPed, true)

		if not IsPlayerNearAtm then
			if not IsPlayerInVehicle then
				for k,v in pairs(modeltypes) do
					atm = GetClosestObjectOfType(x, y, z, 0.75, GetHashKey(v), false)
					if DoesEntityExist(atm) then
						currentAtm = atm
						atmX, atmY, atmZ = table.unpack(GetOffsetFromEntityInWorldCoords(currentAtm, 0.0, -0.65, 0.0))
						IsPlayerNearAtm = true
						isnearBank = true
					end
				end
			end
		else
			if not DoesEntityExist(currentAtm) then
				IsPlayerNearAtm = false
			else
				if GetDistanceBetweenCoords(x,y,z, atmX, atmY, atmZ, true) > 3.0 then
					IsPlayerNearAtm = false
				end
			end
		end
	end
end)

if bankMenu then
	Citizen.CreateThread(function()
  while true do
    Wait(1)
    playerPed = PlayerPedId()
    IsPlayerInVehicle = IsPedInAnyVehicle(playerPed, true)
    if not IsPlayerInVehicle then
      if IsPlayerNearAtm or isnearBank and not blocked then
        if not inMenu then
          DisplayHelpText("Baraye dastresi be Bank ~INPUT_PICKUP~ ro bezanid")
        else
          ClearAllHelpMessages()				
          DisableControlAction(0, 201, true)
          DisableControlAction(1, 201, true)
		 DisableAllControlActions(0)
			FreezeEntityPosition(playerPed, true)		  
        end
      
        if IsControlJustPressed(1, 38) and not isnearBank then
			FreezeEntityPosition(playerPed, true)
			DisableAllControlActions(0)
			SetCurrentPedWeapon(playerPed, GetHashKey("weapon_unarmed"), true)
          RequestAnimDict("mini@atmbase")		
          RequestAnimDict(anim)
          while not HasAnimDictLoaded(anim) do
            Wait(1)
          end
			
          
		  Wait(500)
          TaskLookAtEntity(playerPed, currentAtm, 2000, 2048, 2)
          Wait(500)
          TaskGoStraightToCoord(playerPed, atmX, atmY, atmZ, 0.1, 4000, GetEntityHeading(currentAtm), 0.5)
          Wait(2000)
          TaskPlayAnim(playerPed, anim, "enter", 8.0, 1.0, -1, 0, 0.0, 0, 0, 0)
          RemoveAnimDict(animDict)
          Wait(4000)
          TaskPlayAnim(playerPed, "mini@atmbase", "base", 8.0, 1.0, -1, 0, 0.0, 0, 0, 0)
          RemoveAnimDict("mini@atmbase")				
          Wait(1000)
          PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
          
			
          inMenu = true
          SetNuiFocus(true, true)
          SendNUIMessage({type = 'openGeneral'})
          TriggerServerEvent('bank:balance')
          local ped = PlayerPedId()
		  
		elseif IsControlJustPressed(1, 38) then
		   FreezeEntityPosition(playerPed, true)

          inMenu = true
          SetNuiFocus(true, true)
          SendNUIMessage({type = 'openGeneral'})
          TriggerServerEvent('bank:balance')
        end
      end
            
        if IsControlJustPressed(1, 322) then
        inMenu = false
          SetNuiFocus(false, false)
          SendNUIMessage({type = 'close'})
        end
      end
    end
  end)
end


--===============================================
--==             Map Blips	                   ==
--===============================================
Citizen.CreateThread(function()
	if showblips then
	  for k,v in ipairs(banks)do
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(blip, v.id)
		SetBlipScale(blip, 1.0)
		SetBlipColour(blip, 2)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(tostring(v.name))
		EndTextCommandSetBlipName(blip)
	  end
	end
end)



--===============================================
--==           Deposit Event                   ==
--===============================================
RegisterNetEvent('currentbalance1')
AddEventHandler('currentbalance1', function(balance)
	local id = PlayerId()
	local playerName = GetPlayerName(id)
	SendNUIMessage({
		type = "balanceHUD",
		balance = balance,
		player = playerName
		})
end)
--===============================================
--==           Deposit Event                   ==
--===============================================
RegisterNUICallback('deposit', function(data)
	TriggerServerEvent('bank:depositx', tonumber(data.amount))
end)

--===============================================
--==          Withdraw Event                   ==
--===============================================
RegisterNUICallback('withdrawl', function(data)
	TriggerServerEvent('bank:withdrawx', tonumber(data.amountw))
end)

--===============================================
--==         Balance Event                     ==
--===============================================
RegisterNUICallback('balance', function()
	TriggerServerEvent('bank:balance')
end)

RegisterNetEvent('balance:back')
AddEventHandler('balance:back', function(balance)

	SendNUIMessage({type = 'balanceReturn', bal = balance})

end)


--===============================================
--==         Transfer Event                    ==
--===============================================
RegisterNUICallback('transfer', function(data)
	TriggerServerEvent('bank:transferx', data.to, data.amountt)
	
end)




--===============================================
--==               NUIFocusoff                 ==
--===============================================
RegisterNUICallback('NUIFocusOff', function()
  FreezeEntityPosition(PlayerPedId(), false)
  PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
  inMenu = false
  SetNuiFocus(false, false)
  SendNUIMessage({type = 'closeAll'})
end)


--===============================================
--==            Capture Bank Distance          ==
--===============================================
function nearBank()
	local player = PlayerPedId()
	local playerloc = GetEntityCoords(player, 0)
	
	for _, search in pairs(banks) do
		local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, playerloc['x'], playerloc['y'], playerloc['z'], true)
		
		if distance <= 1.0 then
			return true
		end
	end
end


function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
