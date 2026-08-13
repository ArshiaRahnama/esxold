local ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

TriggerEvent('chat:addSuggestion', '/party', 'Menu Party', {
})

TriggerEvent('chat:addSuggestion', '/tchat', 'Chate Azaye Team', {
    { name="Matn", help="Matne Payam" }
})

TriggerEvent('chat:addSuggestion', '/tinvite', 'Invite Player To Team', {
    { name="ID", help="Player ID" }
})

RegisterNetEvent('TeamSystem:OpenMenu')
AddEventHandler('TeamSystem:OpenMenu', function(InTeam,id,team,teamid)
    local elements = {}

    if not InTeam then
        table.insert(elements, {
            img = "create.png", text = "Create New Team", text2 = "Start a new team",
            callBack = function()
                TriggerServerEvent('TeamSystem:CreateTeam')
                Citizen.Wait(200)
                ExecuteCommand("party")
            end
        })
    else
        table.insert(elements, {
            img = "human.png", text = team[id].name, text2 = "Rank: " .. team[id].rank
        })

        if team[id].rank == "Leader" then
            table.insert(elements, {
                img = "give.png", text = "Invite Player", text2 = "Use /tinvite [ID]",
                callBack = function()
                    TriggerEvent('chat:addMessage', {args = {"^1[Team]", "Baraye Da'vat Az ^2/tinvite [ID] ^0Estefade Konid"}})
                end
            })
        end

        table.insert(elements, {
            img = "stop.png",
            text = (team[id].rank == "Leader") and "Disband Team" or "Leave Team",
            text2 = (team[id].rank == "Leader") and "Deletes the team for everyone" or "Leave this team",
            callBack = function()
                if team[id].rank == "Leader" then
                    TriggerServerEvent('TeamSystem:DeleteTeam', teamid)
                else
                    TriggerServerEvent('TeamSystem:LeaveTeam', teamid)
                end
            end
        })

        for playerid,details in pairs(team) do
            if playerid ~= id then
                table.insert(elements, {
                    img = "human.png", text = details.name, text2 = details.rank,
                    callBack = function()
                        if team[id].rank == "Leader" then
                            OpenMemberMenu(playerid, details, team, teamid, id)
                        end
                    end
                })
            end
        end
    end

    exports.icon_menu:OpenMenu(elements, {
        positionX   = "90%",
        positionY   = "50%",
        size        = "0.9",
        maxHeight   = "80vh",
    })
end)

function OpenMemberMenu(playerid, details, team, teamid, id)
    local elements = {
        {
            img = "back.png", text = "Back", text2 = "Return to team menu", isBack = true,
            callBack = function()
                TriggerEvent('TeamSystem:OpenMenu', true, id, team, teamid)
            end
        },
        {
            img = "level.png", text = "Promote To Leader", text2 = details.name,
            callBack = function()
                TriggerServerEvent('TeamSystem:Promote', teamid, playerid)
                Citizen.Wait(200)
                ExecuteCommand("party")
            end
        },
        {
            img = "delete.png", text = "Kick", text2 = details.name,
            callBack = function()
                TriggerServerEvent('TeamSystem:Kick', teamid, playerid)
                Citizen.Wait(200)
                ExecuteCommand("party")
            end
        },
    }

    exports.icon_menu:OpenMenu(elements, {
        positionX   = "90%",
        positionY   = "50%",
        size        = "0.9",
        maxHeight   = "80vh",
    })
end

RegisterNetEvent('TeamSystem:AskForInvite')
AddEventHandler('TeamSystem:AskForInvite', function(Invitename,InvitedTeamID)
    local elements = {
        {
            img = "quest.png", text = "Accept Invite", text2 = "From " .. Invitename,
            callBack = function()
                TriggerEvent('chat:addMessage', {args = {"^1[Team] ", "Shoma join team shodid jahate didane etelaat az ^2/party ^0estefade konid !"}})
                TriggerServerEvent('TeamSystem:JoinToTeam', InvitedTeamID)
            end
        },
        {
            img = "close.png", text = "Decline", text2 = "From " .. Invitename,
            callBack = function()
                exports.icon_menu:ForceCloseMenu()
            end
        },
    }

    exports.icon_menu:OpenMenu(elements, {
        positionX   = "90%",
        positionY   = "50%",
        size        = "0.9",
        maxHeight   = "80vh",
    })
end)

RegisterCommand('tinvite', function(source, args)
    local InvitedID = tonumber(args[1])
    if not InvitedID then
        TriggerEvent('chat:addMessage', {args = {"^1[Team]", "Estefade: /tinvite [ID]"}})
        return
    end
    TriggerServerEvent('TeamSystem:RequestInvite', InvitedID)
end)
