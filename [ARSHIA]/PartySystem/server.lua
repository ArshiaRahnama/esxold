local Teams = {}

local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function IsInTeam(id)
    local InTeam = false
    local PlayerTeam = {}
    local TeamID = nil
    if Teams then
        for TID,Team in pairs(Teams) do
            for playerid,_ in pairs(Team) do
                if tonumber(playerid) == id then
                    InTeam = true
                    PlayerTeam = Team
                    TeamID = TID

                end
            end
        end
    end
    return InTeam,PlayerTeam,TeamID
end

exports('IsInTeam', IsInTeam)
-- local accepted = exports["PartySystem"]:IsInTeam(RobberyCode)
RegisterCommand('party', function(source, args)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local InTeam,team,teamid = IsInTeam(_source)
    TriggerClientEvent('TeamSystem:OpenMenu',_source,InTeam,_source,team,teamid)

end)

RegisterServerEvent('TeamSystem:CreateTeam')
AddEventHandler('TeamSystem:CreateTeam', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    table.insert(Teams,{[_source] = {name = xPlayer.name , rank = "Leader"}})

end)

RegisterServerEvent('TeamSystem:InvitePlayer')
AddEventHandler('TeamSystem:InvitePlayer', function(InvitedId,InvitedTeamID)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local yPlayer = ESX.GetPlayerFromId(InvitedId)
    if yPlayer then
        local InTeam,Team,teamid = IsInTeam(InvitedId)
        if InTeam then
            TriggerClientEvent('esx:showNotification', _source, "Player Is Already In A Team")
        else
            TriggerClientEvent('esx:showNotification', _source, "Invite Sent",'success')
            TriggerClientEvent('TeamSystem:AskForInvite',InvitedId,xPlayer.name,InvitedTeamID)
        end
    else
        TriggerClientEvent('esx:showNotification', _source, "Player Doesnt Exist !")
    end
end)

RegisterServerEvent('TeamSystem:RequestInvite')
AddEventHandler('TeamSystem:RequestInvite', function(InvitedId)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local InTeam, Team, teamid = IsInTeam(_source)
    if not InTeam then
        TriggerClientEvent('esx:showNotification', _source, "Shoma Ozv Hich Teami Nistid")
        return
    end
    if Team[_source].rank ~= "Leader" then
        TriggerClientEvent('esx:showNotification', _source, "Faghat Leader Mitavanad Da'vat Konad")
        return
    end
    TriggerEvent('TeamSystem:InvitePlayer', InvitedId, teamid)
end)

RegisterServerEvent('TeamSystem:JoinToTeam')
AddEventHandler('TeamSystem:JoinToTeam', function(Teamid)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    Teams[Teamid][_source] ={name = xPlayer.name , rank = "Member"}

end)

RegisterServerEvent('TeamSystem:LeaveTeam')
AddEventHandler('TeamSystem:LeaveTeam', function(Teamid)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    Teams[Teamid][_source] = nil
end)

RegisterServerEvent('TeamSystem:Kick')
AddEventHandler('TeamSystem:Kick', function(Teamid,playerid)
    local _source = playerid
    local xPlayer = ESX.GetPlayerFromId(_source)
    Teams[Teamid][_source] = nil
end)

RegisterServerEvent('TeamSystem:Promote')
AddEventHandler('TeamSystem:Promote', function(Teamid,playerid)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    Teams[Teamid][_source].rank = "Member"
    Teams[Teamid][playerid].rank = "Leader"
end)

RegisterServerEvent('TeamSystem:DeleteTeam')
AddEventHandler('TeamSystem:DeleteTeam', function(Teamid)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    Teams[Teamid] = nil
end)


RegisterCommand('tchat', function(source, args)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local InTeam,team,teamid = IsInTeam(_source)
    if InTeam then
        local name = string.gsub(xPlayer.name, "_", " ")
        local message = table.concat(args, " ")
        
        for id,_ in pairs(team) do
            TriggerClientEvent('chatMessage', id, "", {255, 0, 0},"^4[^1 Team ^4]: ^3" .. name .. " " .. "^0^*" .. message .. "")
        end
    else
        TriggerClientEvent('esx:showNotification', _source, "Shoma Ozv Hich Teami Nistid",'error')
    end


end)





AddEventHandler('playerDropped', function(reason)
    local _source = source
    local InTeam, Team, teamid = IsInTeam(_source)
    if InTeam then
        local wasLeader = Team[_source].rank == "Leader"
        Teams[teamid][_source] = nil

        if wasLeader then
            local newLeader = nil
            for playerid,_ in pairs(Teams[teamid]) do
                newLeader = playerid
                break
            end
            if newLeader then
                Teams[teamid][newLeader].rank = "Leader"
            else
                Teams[teamid] = nil
            end
        end
    end
end)