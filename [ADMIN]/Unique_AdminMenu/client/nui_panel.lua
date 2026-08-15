-- ============================================================================
-- Unique_AdminMenu / client/nui_panel.lua
-- Drives the dark-themed NUI: the always-on stats corner widget, the F7
-- radial quick-actions menu, and closes the Inspect/Reports/ChatLog panel.
-- ============================================================================

InAdminNui = false

RegisterKeyMapping('adminradial', 'Open Admin Quick Actions Radial Menu', 'keyboard', 'F7')
RegisterKeyMapping('adminreports', 'Open Admin Report Queue', 'keyboard', 'F12')

RegisterCommand('adminreports', function()
    if not aduty then return end
    if InAdminNui then return end
    ESX.TriggerServerCallback('Unique_AdminMenu:GetReports', function(reports)
        InAdminNui = true
        SetNuiFocus(true, true)
        SendNUIMessage({ type = 'reports', data = reports })
    end)
end, false)

RegisterCommand('adminradial', function()
    if not aduty then return end
    if InAdminNui then return end
    InAdminNui = true
    SetNuiFocus(true, true)
    SendNUIMessage({ type = 'showRadial' })
end, false)

RegisterNUICallback('closePanel', function(_, cb)
    InAdminNui = false
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('closeRadial', function(_, cb)
    InAdminNui = false
    SetNuiFocus(false, false)
    cb('ok')
end)

local function GetNearestPlayerServerId()
    local myPed = PlayerPedId()
    local myCoords = GetEntityCoords(myPed)
    local closestId, closestDist = nil, 15.0
    for _, playerId in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(playerId)
        if ped ~= myPed and DoesEntityExist(ped) then
            local dist = #(myCoords - GetEntityCoords(ped))
            if dist < closestDist then
                closestDist = dist
                closestId = GetPlayerServerId(playerId)
            end
        end
    end
    return closestId
end

RegisterNUICallback('radialAction', function(payload, cb)
    local action = payload.action

    if action == 'freeze' then
        local target = GetNearestPlayerServerId()
        if target then
            TriggerServerEvent('Unique_AdminMenu:FreezePlayer', target)
        else
            drawNotification("~r~No nearby player to freeze")
        end
    elseif action == 'heal' then
        TriggerServerEvent('Unique_AdminMenu:HealPlayer', GetPlayerServerId(PlayerId()))
    elseif action == 'revive' then
        TriggerServerEvent('Unique_AdminMenu:RevivePlayer', GetPlayerServerId(PlayerId()))
    elseif action == 'spawncar' then
        TriggerServerEvent('Unique_AdminMenu:SpawnVehicle', 'adder', '')
    elseif action == 'fixcar' then
        TriggerServerEvent('Unique_AdminMenu:VehicleAction', 'fix')
    elseif action == 'tpwp' then
        local waypoint = GetFirstBlipInfoId(8)
        if DoesBlipExist(waypoint) then
            local coords = GetBlipInfoIdCoord(waypoint)
            local groundZ = getGroundZ(coords.x, coords.y, 1000.0)
            TriggerServerEvent('Unique_AdminMenu:TeleportCoords', coords.x, coords.y, groundZ > 0 and groundZ or coords.z)
        else
            drawNotification("~r~No waypoint set on the map")
        end
    end

    InAdminNui = false
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('reportAction', function(payload, cb)
    local id = payload.id
    local action = payload.action -- 'accept' or 'close'
    if id then
        if action == 'accept' then
            ExecuteCommand('ar ' .. id)
        elseif action == 'close' then
            ExecuteCommand('cr ' .. id)
        end
        -- give the server a moment to update `reports`, then push a refresh
        Citizen.SetTimeout(300, function()
            ESX.TriggerServerCallback('Unique_AdminMenu:GetReports', function(reports)
                SendNUIMessage({ type = 'reports', data = reports })
            end)
        end)
    end
    cb('ok')
end)

-- Stats widget: refreshes every 8s while the player is an on-duty admin.
-- Also watches for the open-report count going UP between polls to fire a
-- sound + on-screen toast, so new reports don't just sit silently in a
-- corner number.
local lastOpenReports = 0
Citizen.CreateThread(function()
    while true do
        if aduty then
            ESX.TriggerServerCallback('Unique_AdminMenu:GetServerStats', function(stats)
                if stats then
                    SendNUIMessage({ type = 'stats', data = stats })
                    local openReports = stats.openReports or 0
                    if openReports > lastOpenReports then
                        PlaySoundFrontend(-1, "CHALLENGE_UNLOCKED", "HUD_AWARDS", true)
                        SendNUIMessage({ type = 'newReportAlert', count = openReports - lastOpenReports })
                    end
                    lastOpenReports = openReports
                end
            end)
            Citizen.Wait(8000)
        else
            lastOpenReports = 0
            Citizen.Wait(2000)
        end
    end
end)
