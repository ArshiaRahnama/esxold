-- Chetori Dooste Golam Omid Varam Be Khoobi Az In Script Estefade Koni 💓
ESX = nil

open = false

local abtinqx = nil

local kosenanehateram = false

local bankbalance = 0

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()

end)   

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('abtin')
AddEventHandler('abtin', function(pos)
SetNewWaypoint(pos.x, pos.y)
end)


Citizen.CreateThread(function()
	if PlayerPedId() then
		Wait(7000)
		while true do
			Wait(500)
            timeAndDateString = ""
            CalculateTimeToDisplay()
            timeAndDateString = hour .. ":" .. minute
            abtinqx = timeAndDateString
		end
    end
end)

Citizen.CreateThread(function()
	if PlayerPedId() then
		Wait(7000)
        ESX.TriggerServerCallback("GetCC", function(coin) 
            kosenanehateram = coin
        end)
		while true do
			Wait(500)
            ESX.TriggerServerCallback("GetCC", function(coin) 
                kosenanehateram = coin
            end)
		end
    end
end)


function CalculateTimeToDisplay()
	hour = GetClockHours()
	minute = GetClockMinutes()

	if hour <= 9 then
		hour = "0" .. hour
	end
	if minute <= 9 then
		minute = "0" .. minute
	end
end

RegisterNetEvent('hud:bankbalance')
AddEventHandler('hud:bankbalance', function(balance)
	bankbalance = balance
end)

Citizen.CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(10)
    SetRadarBigmapEnabled(false, false)
    if PlayerPedId() then
        Wait(7000)
    ESX.TriggerServerCallback("GetData", function(xPlayer) 
        gangname =  xPlayer.gang.name
        ganggrade =  xPlayer.gang.grade_label
        ESX.TriggerServerCallback("GetProf", function(prof) 
    while true do
        Citizen.Wait(200)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()	
        TriggerEvent('esx_status:getStatus', 'hunger', function(status)
            food = status.getPercent()
        end)
        
        TriggerEvent('esx_status:getStatus', 'thirst', function(status)
            thirst = status.getPercent()
        end)
        if IsPauseMenuActive() then
            SendNUIMessage({
                action = 'disable'
            })
        else
            SendNUIMessage({
                action = 'enable'
            })
        end
        TriggerServerEvent('hud:bbalance')
        local formattedNumber =     string.format("%d", ESX.GetPlayerData().money):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
        local formattedNumberx =     string.format("%d", bankbalance):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
        SendNUIMessage({
            action = "updateInfo",
            id = GetPlayerServerId(PlayerId()),
            coin = kosenanehateram ,
            money = formattedNumber ,
            bank = formattedNumberx ,
            name = ESX.GetPlayerData().name,
            job = ESX.GetPlayerData().job.label,
            gang = gangname,
            jobg = ESX.GetPlayerData().job.grade_label,
            gangg =  ganggrade,
            health = math.floor(GetEntityHealth(PlayerPedId()) - 100),
            armor =  math.floor(GetPedArmour(PlayerPedId())),
            armorx =  GetPedArmour(PlayerPedId()),
            food = math.floor(food),
            water = math.floor(thirst),
            prof = prof,
            time = abtinqx,
        })
    end
end)
end)
    end
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    gangname = gang.name
    ganggrade = gang.grade_label
end)

RegisterCommand("hud", function()
    bool = true
    SendNUIMessage({
        type = "show",
        status = bool,
    })

  SetNuiFocus(bool, bool)
end)

RegisterNUICallback("close", function()
    bool = false
    SendNUIMessage({
        type = "show",
        status = bool,
    })

  SetNuiFocus(bool, bool)
end)

local spam = false
AddEventHandler('onKeyDown',function(key)
	if key == "oem_3" then
        if not spam then
            SendNUIMessage({
                action = 'kostala'
            })
            cc()
        else
            -- ESX.ShowNotification("Lotfan Spam Nakonid !")
        end
	end
end)

function cc()
    spam = true
    Wait(1000)
    spam = false
end

AddEventHandler('')