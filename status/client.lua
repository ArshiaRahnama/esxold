------------------------------------------------------------------
--                          Variables
------------------------------------------------------------------

local AutoSaveHungerThirst = true             -- Boolean to update hunger / thirst
local AutoSaveHungerThirstTimer = 138000      -- Value in ms. Currently set to 2min30
local showHud = true                          -- Boolean to show / hide HUD
local factorHunger = (1000 * 100) / 2400000   -- Ratio to consume hunger's bar
local factorThirst = (1000 * 100) / 1800000   -- Ratio to consume thirst's bar
local hunger = 100                            -- Init hunger's variable. Set to 100 for development.
local thirst = 100                            -- Init thirst's variable. Set to 100 for development.
local health = 100
local armor  = 100
local w = 1920
local h = 1080
local x = 0.885
local y = 0.175
local pname
local showpic = true
local mugshot, mugTxd = nil, nil
local PlayerData = {}
------------------------------------------------------------------
--                          Edits Ahmad -- kharabesh kardiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
------------------------------------------------------------------


AddEventHandler('onKeyUP',function(key)
	if key == 'oem_3' then
    showpic = not showpic
		ToggleHUD()
	end
end)


------------------------------------------------------------------
--                          Functions
------------------------------------------------------------------
ESX                             = nil

Citizen.CreateThread(function()
while ESX == nil do
  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
  Citizen.Wait(0)
end
end)

function updateHUD(health, armor)
  SendNUIMessage({
    update = true,
    health = health,
    armor  = armor
  })
end

function MakeDigit(value)
	local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

	return ('$' .. left..(num:reverse():gsub('(%d%d%d)','%1' .. ','):reverse())..right)
end

-- my func

function ToggleHUD()
	exports.pNotify:SendNotification(
       {
         text = '<strong class="whit-text">تغییر وضعیت انجام شد</strong>',
         type = "success",
         timeout = 1000,
         layout = "centerLeft",
         queue = "ToggleHUD"
       }
     )
	SendNUIMessage({
    toggle = true
  })
ReloadAllData()  
end

function ReloadAllData()
 job = ESX.GetPlayerData().job
 gang = ESX.GetPlayerData().gang
 ESX.TriggerServerCallback('reloaddata',function(data)
 TriggerEvent('showStatus')
 pname = data.name
 SendNUIMessage({action = "playerName", value = string.gsub(data.name , "_"," ")})
 SendNUIMessage({action = "tc", valuetc = data.tc .." ₮₡",valuetctime = data.tctime})
 SendNUIMessage({action = "playerId", value = GetPlayerServerId(PlayerId()) })
 SendNUIMessage({action = "cash", value = MakeDigit(data.money)})
 if string.lower(job.name) ~= 'nojob' and string.lower(job.name) ~= 'police' and string.lower(job.name) ~= 'sheriff' then
      SendNUIMessage({action = "job", value = job.label .. " | " .. job.grade_label, icon = job.name})
  elseif job.name == 'police' or job.name == 'sheriff' then		
      SendNUIMessage({action = "job", value = job.ext:gsub("^%l", string.upper) .. " | " .. job.grade_label, icon = job.ext})
  else
	 SendNUIMessage({action = "job", value = 'hide', icon = job.name})
  end
 if data.gang ~= 'nogang' then 
	SendNUIMessage({action = "gang", value = string.gsub(data.gang, "_", " ") .. " | " .. data.ganggrade})
 else
	SendNUIMessage({action = "gang", value = 'hide'})
 end
 end)

end
------------------------------------------------------------------
--                          Events
------------------------------------------------------------------

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  Wait(5000)
  PlayerData = xPlayer
  local job = xPlayer.job
  local gang = xPlayer.gang
  if gang.name ~= 'nogang' then
	local icon
    ESX.TriggerServerCallback('gangs:getGangData', function(data)
		icon  = data.icon
		SendNUIMessage({action = "gang", value = string.gsub(gang.name, "_", " ") .. " | " .. gang.grade_label})
	    SendNUIMessage({action = "gangimg", value = data.icon})
    end,gang.name)    
  end
  if string.lower(job.name) ~= 'nojob' and string.lower(job.name) ~= 'police' and string.lower(job.name) ~= 'sheriff' then
      SendNUIMessage({action = "job", value = job.label .. " | " .. job.grade_label, icon = job.name})
  elseif job.name == 'police' or job.name == 'sheriff' then		
      SendNUIMessage({action = "job", value = job.ext:gsub("^%l", string.upper) .. " | " .. job.grade_label, icon = job.ext})
  end
  SendNUIMessage({action = "playerName", value = string.gsub(xPlayer.name , "_"," ")})
  pname = xPlayer.name
  SendNUIMessage({action = "cash", value = MakeDigit(xPlayer.money)})
	SendNUIMessage({action = "playerId", value = GetPlayerServerId(PlayerId()) })
  Wait(1000)
  ReloadAllData()	
end)

RegisterNetEvent('moneyUpdate')
AddEventHandler('moneyUpdate', function(money)
  SendNUIMessage({action = "cash", value = MakeDigit(money)})
end)

RegisterNetEvent('tcUpdate')
AddEventHandler('tcUpdate', function(tc,time2)
  time1 = 0
  if time2 ~= nil then time1 = time2 end
  SendNUIMessage({action = "tc", valuetc = tc .." ₮₡",valuetctime = time1})
end)

RegisterNetEvent('tctimeUpdate')
AddEventHandler('tctimeUpdate', function(tc)
  SendNUIMessage({action = "tc", value = MakeDigit(tc)})
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  if string.lower(job.name) ~= 'nojob' and (string.lower(job.name) ~= 'police' or job.ext == nil) then
      SendNUIMessage({action = "job", value = job.label .. " | " .. job.grade_label, icon = job.name})
    
  elseif job.ext and (job.name == 'police' or job.name == 'sheriff') then
      SendNUIMessage({action = "job", value = job.ext:gsub("^%l", string.upper) .. " | " .. job.grade_label, icon = job.ext})
      
  else
    SendNUIMessage({action = "job", value = 'hide', icon = job.name})
  end
end)

--RegisterNetEvent('status:updatePing')
--AddEventHandler('status:updatePing', function(ping)
-- SendNUIMessage({action = "ping", value = ping})
--end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
  if gang.name ~= 'nogang' then
  local icon
    ESX.TriggerServerCallback('gangs:getGangData', function(data)
		icon  = data.icon
	SendNUIMessage({action = "gang", value = string.gsub(gang.name, "_", " ") .. " | " .. gang.grade_label})
	SendNUIMessage({action = "gangimg", value = data.icon})
    end,gang.name)   	
  else
    SendNUIMessage({action = "gang", value = 'hide'})
  end
end)


RegisterCommand('reload',function()
	ReloadAllData()
end)
------------------------------------------------------------------
--                          Citizen
------------------------------------------------------------------
RegisterNetEvent('esx_customui:updateStatus')
AddEventHandler('esx_customui:updateStatus', function(status)
	SendNUIMessage({action = "updateStatus", status = status})
end)


AddEventHandler('Status:radio', function(data)
  SendNUIMessage(data)
end)

--[[RegisterNetEvent('showStatus')
AddEventHandler('showStatus', function()
  -- Show HUD
  Citizen.CreateThread(function()
    local showed = false
    while true do
      if showed ~= showHud and not IsPauseMenuActive() then
        SendNUIMessage({
          display = showHud
        })
        showed = showHud
      end
      if IsPauseMenuActive() and showed then
        SendNUIMessage({
          display = false
        })
        showed = false
      end
      if showHud then
        local ped = GetPlayerPed(-1)
        -- Health
        local pedhealth = GetEntityHealth(ped)

        if pedhealth < 100 then
          health = 0
        else
          pedhealth = pedhealth - 100
          health    = pedhealth
        end
        -- armor
        local armor = GetPedArmour(ped)
	    	if armor >= 98 then
	    	armor = 100
	    	end
        updateHUD(health, armor)
      end
      Citizen.Wait(2000)
    end
  end)]]
 
local previousArmor = 0
local previousHealth = 0
RegisterNetEvent('showStatus')
AddEventHandler('showStatus', function()
	Wait(1000)
  -- Show HUD
  local wait = 1000
  Citizen.CreateThread(function()
    local showed = false
    while true do

      local pause = IsPauseMenuActive()

      if showed ~= showHud and not pause then
        SendNUIMessage({
          display = showHud
        })
        showed = showHud
		wait = 1000
      end
      if pause and showed then
        SendNUIMessage({
          display = false
        })
        showed = false
		wait = 5000
      end

      if showHud and showed then
        local ped = PlayerPedId()
        local pedhealth = GetEntityHealth(ped)
        if pedhealth < 100 then
          health = 0
        else
          health = pedhealth - 100
        end
        -- armor
        local armor = GetPedArmour(ped)
		if armor == 98 then
		armor = 100
		end
        if health ~= previousHealth or armor ~= previousArmor then
          previousHealth = health
          previousArmor = armor
          updateHUD(health, armor)
        end
        
      end
      Citizen.Wait(wait)
    end
end)
end)

AddEventHandler('skinchanger:modelLoaded', function()
  while not PlayerData.name do
		Wait(100)
	end
  Wait(5000)

	while not HasPedHeadBlendFinished(PlayerPedId()) do
		Wait(10)
	end
	mugshot, mugTxd = ESX.Game.GetPedMugshot(PlayerPedId(), true)
end)

CreateThread(function()
  while not PlayerData.name do
      Wait(100)
  end

  while true do
  Wait(1)

  if not IsPedheadshotValid(mugshot) or not showHud or not showpic then
    goto skin_mugshot
  end

  DrawSprite(mugTxd, mugTxd, x, y, w, h, 0, 255, 255, 255, 10000);
  ::skin_mugshot::
  end
end)

RegisterCommand("togglehud", function(source, args)
  showHud = not showHud
end)

RegisterNUICallback('setmugpos', function(data)
  w = data.w
  h = data.h
  x = data.x + (data.w/2)
  y = data.y + (data.h/2)
end)


-- [Function]
function updateIndicators(type, data)
  local newData = convertData(type, data)
  SendNUIMessage({action = "indicator", value = newData})
end
exports("updateIndicators", updateIndicators)

function convertData(type, data)
    local newData = {}
    for id,talking in pairs(data) do
      if talking then
        table.insert(newData, {id = id, type = type})
      end
    end

    return newData
end
