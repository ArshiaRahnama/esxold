ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local team1 = {}
local team2 = {}
local alivePlayers = {}

RegisterServerEvent('boxing:invitePlayer')
AddEventHandler('boxing:invitePlayer', function(targetId, team)
    TriggerClientEvent('boxing:receiveInvite', targetId, source, team)
end)

RegisterServerEvent('boxing:acceptInvite')
AddEventHandler('boxing:acceptInvite', function(inviterId, team)
    local src = source
    for i=#team1,1,-1 do if team1[i] == src then table.remove(team1, i) end end
    for i=#team2,1,-1 do if team2[i] == src then table.remove(team2, i) end end

    if team == 1 then
        table.insert(team1, src)
    elseif team == 2 then
        table.insert(team2, src)
    end
end)

ESX.RegisterServerCallback('boxing:getTeams', function(source, cb)
    local players1, players2 = {}, {}

    for _, id in pairs(team1) do
        local xPlayer = ESX.GetPlayerFromId(id)
        if xPlayer then
            table.insert(players1, {id = id, name = xPlayer.name})
        end
    end

    for _, id in pairs(team2) do
        local xPlayer = ESX.GetPlayerFromId(id)
        if xPlayer then
            table.insert(players2, {id = id, name = xPlayer.name})
        end
    end

    cb(players1, players2)
end)

RegisterServerEvent('boxing:startFight')
AddEventHandler('boxing:startFight', function()
  
    for _, id in pairs(team1) do
        TriggerClientEvent('esx_ambulancejob:revivex', id)
        TriggerClientEvent('boxing:teleportToZone', id)
        TriggerClientEvent('boxing:startFightClient', id) 
    end
    for _, id in pairs(team2) do
        TriggerClientEvent('esx_ambulancejob:revivex', id)
        TriggerClientEvent('boxing:teleportToZone', id)
        TriggerClientEvent('boxing:startFightClient', id)
    end


    Citizen.CreateThread(function()
        while true do
            alivePlayers = {}

            for _, id in pairs(team1) do
                TriggerClientEvent('boxing:checkAlive', id)
            end
            for _, id in pairs(team2) do
                TriggerClientEvent('boxing:checkAlive', id)
            end

            Citizen.Wait(3000)

            if #alivePlayers == 1 then
                local winnerId = alivePlayers[1]
                local xPlayer = ESX.GetPlayerFromId(winnerId)
                if xPlayer then
                    TriggerClientEvent('boxing:announceWinner', -1, xPlayer.name)
                    TriggerClientEvent('boxing:displayWinnerText', -1, string.gsub(xPlayer.name, "_", " "))
                end

                for _, id in pairs(team1) do
                    TriggerClientEvent('boxing:returnToMarker', id)
                end
                for _, id in pairs(team2) do
                    TriggerClientEvent('boxing:returnToMarker', id)
                end

                TriggerClientEvent('boxing:matchEnded', -1)

                team1 = {}
                team2 = {}
                
                break
            end

            Citizen.Wait(3000)
        end
    end)
end)


RegisterServerEvent('boxing:checkAliveResult')
AddEventHandler('boxing:checkAliveResult', function(isAlive)
    if isAlive then
        table.insert(alivePlayers, source)
    end
end)

RegisterNetEvent('Unique_Boxing:ended')
AddEventHandler('Unique_Boxing:ended', function()
    local winnerId = alivePlayers[1]
    local xPlayer = ESX.GetPlayerFromId(winnerId)
    Wait(5000)
    if xPlayer then
        TriggerClientEvent('boxing:announceWinner', -1, xPlayer.name)
        TriggerClientEvent('boxing:displayWinnerText', -1, xPlayer.name)
    end

    for _, id in pairs(team1) do
        TriggerClientEvent('boxing:returnToMarker', id)
    end
    for _, id in pairs(team2) do
        TriggerClientEvent('boxing:returnToMarker', id)
    end

    TriggerClientEvent('boxing:matchEnded', -1)

    team1 = {}
    team2 = {}
end)