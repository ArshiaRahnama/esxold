

local AutoSaveHungerThirst = true
local AutoSaveHungerThirstTimer = 138000

local showHud = true

local factorHunger = (1000 * 100) / 2400000
local factorThirst = (1000 * 100) / 1800000

local hunger = 100
local thirst = 100

local health = 100
local armor = 100

local w = 1920
local h = 1080

local x = 0.885
local y = 0.175

local pname
local showpic = true

local mugshot = nil
local mugTxd = nil

local PlayerData = {}

local ESX = nil

Citizen.CreateThread(function()

    while ESX == nil do

        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)

        Citizen.Wait(100)

    end

end)

local function Notify(message)

    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(false, false)

end

function ToggleHUD()

    showHud = not showHud

    SendNUIMessage({
        toggle = true,
        display = showHud
    })

    if showHud then
        Notify("~g~HUD فعال شد")
    else
        Notify("~r~HUD غیرفعال شد")
    end

    ReloadAllData()

end

exports('ToggleHUD', ToggleHUD)

AddEventHandler('onKeyUP', function(key)

    if key == 'oem_3' then
        showpic = not showpic
        ToggleHUD()
    end

end)

function updateHUD(currentHealth, currentArmor)

    SendNUIMessage({
        update = true,
        health = currentHealth,
        armor = currentArmor
    })

end

function MakeDigit(value)

    value = tostring(value or 0)

    local left, num, right =
        string.match(value, '^([^%d]*%d)(%d*)(.-)$')

    if not left then
        return '$' .. value
    end

    return '$' ..
        left ..
        (num:reverse():gsub('(%d%d%d)', '%1,'):reverse()) ..
        right

end

function ReloadAllData()

    if not ESX then
        return
    end

    local playerData = ESX.GetPlayerData()

    if not playerData then
        return
    end

    local job = playerData.job
    local gang = playerData.gang

    ESX.TriggerServerCallback('reloaddata', function(data)

        if not data then
            return
        end

        TriggerEvent('showStatus')

        pname = data.name

        SendNUIMessage({
            action = "playerName",
            value = string.gsub(data.name or "", "_", " ")
        })

        SendNUIMessage({
            action = "tc",
            valuetc = tostring(data.tc or 0) .. " ₮₡",
            valuetctime = data.tctime or 0
        })

        SendNUIMessage({
            action = "playerId",
            value = GetPlayerServerId(PlayerId())
        })

        SendNUIMessage({
            action = "cash",
            value = MakeDigit(data.money or 0)
        })

        if job then

            local jobName = string.lower(job.name or "")

            if jobName ~= 'nojob'
            and jobName ~= 'police'
            and jobName ~= 'sheriff' then

                SendNUIMessage({
                    action = "job",
                    value = (job.label or job.name) ..
                            " | " ..
                            (job.grade_label or ""),
                    icon = job.name
                })

            elseif jobName == 'police'
            or jobName == 'sheriff' then

                local ext = job.ext or job.name

                SendNUIMessage({
                    action = "job",
                    value = ext:gsub("^%l", string.upper) ..
                            " | " ..
                            (job.grade_label or ""),
                    icon = ext
                })

            else

                SendNUIMessage({
                    action = "job",
                    value = "hide",
                    icon = job.name
                })

            end

        end

        if gang then

            if gang.name and gang.name ~= 'nogang' then

                SendNUIMessage({
                    action = "gang",
                    value = string.gsub(gang.name, "_", " ") ..
                            " | " ..
                            (gang.grade_label or "")
                })

            else

                SendNUIMessage({
                    action = "gang",
                    value = "hide"
                })

            end

        end

    end)

end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)

    Wait(5000)

    PlayerData = xPlayer

    local job = xPlayer.job
    local gang = xPlayer.gang

    if gang and gang.name and gang.name ~= 'nogang' then

        ESX.TriggerServerCallback(
            'gangs:getGangData',
            function(data)

                if data then

                    SendNUIMessage({
                        action = "gang",
                        value = string.gsub(gang.name, "_", " ") ..
                                " | " ..
                                (gang.grade_label or "")
                    })

                    if data.icon then

                        SendNUIMessage({
                            action = "gangimg",
                            value = data.icon
                        })

                    end

                end

            end,
            gang.name
        )

    end

    if job then

        local jobName = string.lower(job.name or "")

        if jobName ~= 'nojob'
        and jobName ~= 'police'
        and jobName ~= 'sheriff' then

            SendNUIMessage({
                action = "job",
                value = (job.label or job.name) ..
                        " | " ..
                        (job.grade_label or ""),
                icon = job.name
            })

        elseif jobName == 'police'
        or jobName == 'sheriff' then

            local ext = job.ext or job.name

            SendNUIMessage({
                action = "job",
                value = ext:gsub("^%l", string.upper) ..
                        " | " ..
                        (job.grade_label or ""),
                icon = ext
            })

        end

    end

    SendNUIMessage({
        action = "playerName",
        value = string.gsub(xPlayer.name or "", "_", " ")
    })

    pname = xPlayer.name

    SendNUIMessage({
        action = "cash",
        value = MakeDigit(xPlayer.money or 0)
    })

    SendNUIMessage({
        action = "playerId",
        value = GetPlayerServerId(PlayerId())
    })

    Wait(1000)

    ReloadAllData()

end)

RegisterNetEvent('moneyUpdate')
AddEventHandler('moneyUpdate', function(money)

    SendNUIMessage({
        action = "cash",
        value = MakeDigit(money)
    })

end)

RegisterNetEvent('tcUpdate')
AddEventHandler('tcUpdate', function(tc, time2)

    local time1 = 0

    if time2 ~= nil then
        time1 = time2
    end

    SendNUIMessage({
        action = "tc",
        valuetc = tostring(tc or 0) .. " ₮₡",
        valuetctime = time1
    })

end)

RegisterNetEvent('tctimeUpdate')
AddEventHandler('tctimeUpdate', function(tc)

    SendNUIMessage({
        action = "tc",
        value = MakeDigit(tc)
    })

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)

    if not job then
        return
    end

    local jobName = string.lower(job.name or "")

    if jobName ~= 'nojob'
    and jobName ~= 'police'
    and jobName ~= 'sheriff' then

        SendNUIMessage({
            action = "job",
            value = (job.label or job.name) ..
                    " | " ..
                    (job.grade_label or ""),
            icon = job.name
        })

    elseif job.ext
    and (jobName == 'police' or jobName == 'sheriff') then

        SendNUIMessage({
            action = "job",
            value = job.ext:gsub("^%l", string.upper) ..
                    " | " ..
                    (job.grade_label or ""),
            icon = job.ext
        })

    else

        SendNUIMessage({
            action = "job",
            value = "hide",
            icon = job.name
        })

    end

end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)

    if not gang then
        return
    end

    if gang.name ~= 'nogang' then

        ESX.TriggerServerCallback(
            'gangs:getGangData',
            function(data)

                SendNUIMessage({
                    action = "gang",
                    value = string.gsub(gang.name, "_", " ") ..
                            " | " ..
                            (gang.grade_label or "")
                })

                if data and data.icon then

                    SendNUIMessage({
                        action = "gangimg",
                        value = data.icon
                    })

                end

            end,
            gang.name
        )

    else

        SendNUIMessage({
            action = "gang",
            value = "hide"
        })

    end

end)

RegisterCommand('reload', function()

    ReloadAllData()

    Notify("~g~Status دوباره بارگذاری شد")

end, false)

RegisterNetEvent('esx_customui:updateStatus')
AddEventHandler('esx_customui:updateStatus', function(status)

    SendNUIMessage({
        action = "updateStatus",
        status = status
    })

end)

AddEventHandler('Status:radio', function(data)

    SendNUIMessage(data)

end)

local previousArmor = 0
local previousHealth = 0

RegisterNetEvent('showStatus')
AddEventHandler('showStatus', function()

    Wait(1000)

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

                armor = GetPedArmour(ped)

                if armor == 98 then
                    armor = 100
                end

                if health ~= previousHealth
                or armor ~= previousArmor then

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

    if ESX and ESX.Game then

        mugshot, mugTxd =
            ESX.Game.GetPedMugshot(PlayerPedId(), true)

    end

end)

CreateThread(function()

    while true do

        Wait(1)

        if not IsPedheadshotValid(mugshot)
        or not showHud
        or not showpic then

            goto skin_mugshot

        end

        DrawSprite(
            mugTxd,
            mugTxd,
            x,
            y,
            w,
            h,
            0,
            255,
            255,
            255,
            10000
        )

        ::skin_mugshot::

    end

end)

RegisterCommand("togglehud", function()

    ToggleHUD()

end, false)

RegisterNUICallback('setmugpos', function(data)

    if data.w then
        w = data.w
    end

    if data.h then
        h = data.h
    end

    if data.x and data.w then
        x = data.x + (data.w / 2)
    end

    if data.y and data.h then
        y = data.y + (data.h / 2)
    end

end)

function updateIndicators(type, data)

    local newData = convertData(type, data)

    SendNUIMessage({
        action = "indicator",
        value = newData
    })

end

exports("updateIndicators", updateIndicators)

function convertData(type, data)

    local newData = {}

    if not data then
        return newData
    end

    for id, talking in pairs(data) do

        if talking then

            table.insert(newData, {
                id = id,
                type = type
            })

        end

    end

    return newData

end