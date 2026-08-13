ESX = nil
local markerPos = vector3(-426.296, 1137.764, 326.90)
local zoneCoords = vector3(-420.973, 1139.818, 326.82)
local winnerText = nil
local showWinnerUntil = 0
local Chek = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local dist = #(playerCoords - markerPos)
        if dist < 10.0 then
            DrawMarker(4, markerPos.x, markerPos.y, markerPos.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 150, false, true, 2, nil, nil, false)
            if dist < 1.5 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Jahat Shoroe Mosabeghe")
                if IsControlJustReleased(0, 38) then
                    OpenBoxingMenu()
                end
            end
        end
    end
end)

function OpenBoxingMenu()
    local elements = {
        {label = "📌 تیم 1", value = "team1"},
        {label = "📌 تیم 2", value = "team2"}
    }

    ESX.TriggerServerCallback('boxing:getTeams', function(t1, t2)
        if #t1 > 0 and #t2 > 0 then
            table.insert(elements, {label = "🚀 شروع مبارزه", value = "start"})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boxing_menu', {
            title    = 'بوکس دو تیمه',
            align    = 'top-left',
            elements = elements
        }, function(data, menu)
            if data.current.value == 'team1' then
                OpenTeamMenu(1)
            elseif data.current.value == 'team2' then
                OpenTeamMenu(2)
            elseif data.current.value == 'start' then
                TriggerServerEvent('boxing:startFight')
                
            end
        end, function(data, menu)
            menu.close()
        end)
    end)
end

function OpenTeamMenu(team)
    ESX.TriggerServerCallback('boxing:getTeams', function(t1, t2)
        local elements = {
            {label = "➕ دعوت بازیکن", value = "invite"}
        }

        local currentTeam = team == 1 and t1 or t2
        for i=1, #currentTeam do
            table.insert(elements, {label = "👤 بازیکن: " .. currentTeam[i].name .. " | ID: " .. currentTeam[i].id, value = "member"})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'team_menu', {
            title = 'تیم ' .. team,
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            if data.current.value == "invite" then
                InviteNearbyPlayers(team, t1, t2)
            end
        end, function(data, menu)
            menu.close()
        end)
    end)
end

function InviteNearbyPlayers(team, t1, t2)
    local players = GetActivePlayers()
    local elements = {}
    local excluded = {}

    for _, p in pairs(t1) do excluded[p.id] = true end
    for _, p in pairs(t2) do excluded[p.id] = true end

    for i=1, #players do
        local pid = GetPlayerServerId(players[i])
        local name = GetPlayerName(players[i])
        if not excluded[pid] then
            local dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(players[i])))
            if dist < 10.0 then
                table.insert(elements, {label = name .. " | ID: " .. pid, value = pid})
            end
        end
    end

    if #elements == 0 then
        ESX.ShowNotification("هیچ بازیکنی برای دعوت در دسترس نیست.")
        return
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'invite_menu', {
        title    = 'انتخاب بازیکن برای تیم ' .. team,
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        TriggerServerEvent('boxing:invitePlayer', data.current.value, team)
    end, function(data, menu)
        menu.close()
    end)
end

RegisterNetEvent('boxing:receiveInvite')
AddEventHandler('boxing:receiveInvite', function(inviterId, team)
    local alert = lib.alertDialog({
        header = 'دعوت به تیم بوکس',
        content = 'آیا می‌خواهید به تیم ' .. team .. ' بپیوندید؟',
        centered = true,
        cancel = true,
        labels = {
            confirm = 'بله',
            cancel = 'خیر'
        }
    })
    
    if alert == 'confirm' then
        TriggerServerEvent('boxing:acceptInvite', inviterId, team)
    end
end)

RegisterNetEvent('boxing:teleportToZone')
AddEventHandler('boxing:teleportToZone', function()
    local offset = math.random(-2, 2)
    SetEntityCoords(PlayerPedId(), zoneCoords.x + offset, zoneCoords.y + offset, zoneCoords.z)
    Chek = true
end)

RegisterNetEvent('boxing:returnToMarker')
AddEventHandler('boxing:returnToMarker', function()
    TriggerEvent("esx_ambulancejob:revivex", GetPlayerServerId(PlayerId())) 
    SetEntityCoords(PlayerPedId(), markerPos.x, markerPos.y, markerPos.z)
end)

RegisterNetEvent('boxing:announceWinner')
AddEventHandler('boxing:announceWinner', function(winnerName)
    -- ESX.ShowAdvancedNotification("🏆 بوکس", "برنده مبارزه", winnerName .. " برنده شد!", "CHAR_PROPERTY_BAR_AIRPORT", 1)
end)

RegisterNetEvent('boxing:displayWinnerText')
AddEventHandler('boxing:displayWinnerText', function(name)
    winnerText = "🏆 Winner: " .. name
    showWinnerUntil = GetGameTimer() + 50000
end)

local boxingGloves = {} 


function GiveBoxingGloves()
    local playerPed = PlayerPedId()
    
  
    RemoveBoxingGloves()
    
    
    local gloveModel = `prop_boxing_glove_01`
    

    RequestModel(gloveModel)
    while not HasModelLoaded(gloveModel) do
        Citizen.Wait(10)
    end
    
    
    local rightGlove = CreateObject(gloveModel, 0, 0, 0, true, true, true)
    AttachEntityToEntity(rightGlove, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.0, 0.0, 90.0, 90.0, true, true, false, true, 1, true)
    
   
    local leftGlove = CreateObject(gloveModel, 0, 0, 0, true, true, true)
    AttachEntityToEntity(leftGlove, playerPed, GetPedBoneIndex(playerPed, 60309), 0.0, 0.0, 0.0, 0.0, 90.0, -90.0, true, true, false, true, 1, true)
    
   
    boxingGloves = {right = rightGlove, left = leftGlove}
end


function RemoveBoxingGloves()
    if boxingGloves.right and DoesEntityExist(boxingGloves.right) then
        DeleteObject(boxingGloves.right)
    end
    if boxingGloves.left and DoesEntityExist(boxingGloves.left) then
        DeleteObject(boxingGloves.left)
    end
    boxingGloves = {}
end


RegisterNetEvent('boxing:startFightClient')
AddEventHandler('boxing:startFightClient', function()
    GiveBoxingGloves()
end)


RegisterNetEvent('boxing:matchEnded')
AddEventHandler('boxing:matchEnded', function()
    RemoveBoxingGloves()
    ESX.UI.Menu.CloseAll()
    -- ESX.ShowNotification("Fight Tamom Shod!")
end)

AddEventHandler("esx:onPlayerDeath",function(KillData)
    local ped = PlayerPedId()
    local isAlive = not IsEntityDead(ped)
    local pCoords = GetEntityCoords(ped)
    local Distance = GetDistanceBetweenCoords(zoneCoords.x, zoneCoords.y, zoneCoords.z, pCoords.x, pCoords.y, pCoords.z, true)
    if Distance <= 6.5 then 
        TriggerServerEvent('Unique_Boxing:ended')
    end
end)

RegisterNetEvent('boxing:checkAlive')
AddEventHandler('boxing:checkAlive', function()
    local ped = PlayerPedId()
    local isAlive = not IsEntityDead(ped)
    TriggerServerEvent('boxing:checkAliveResult', isAlive)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if winnerText and GetGameTimer() < showWinnerUntil then
            DrawText3D(zoneCoords.x, zoneCoords.y, zoneCoords.z + 1.5, winnerText)
        end
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local p = GetGameplayCamCoords()
    local dist = #(vector3(x, y, z) - p)
    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    if onScreen then
        SetTextScale(1.2 * scale, 1.2 * scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

