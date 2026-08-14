local ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(1)
    end
end)

function UiShow()
    SendNUIMessage({ type = "openMenu" })
end

function UpdateProfile()
    ESX.TriggerServerCallback('HUD_Menu:GetAcc', function(data)
        if not data then return end

        ESX.TriggerServerCallback('HUD_Menu:GetCC', function(Coin)
            local myId = GetPlayerServerId(PlayerId())
            local jobsection = 'No Job'
            local gangsection = 'No Gang'
            if data.job and data.job.name ~= 'nojob' then
                jobsection = data.job.label .. " | " .. data.job.grade_label .. " (" .. data.job.grade .. ")"
            end
            if data.gang and data.gang.name ~= 'nogang' then
                gangsection = data.gang.name .. " | " .. data.gang.grade_label .. " (" .. data.gang.grade .. ")"
            end

            SendNUIMessage({
                type      = "updateProfile",
                name      = string.gsub(data.name, "_", " ") .. " (" .. myId .. ")",
                job       = jobsection,
                gang      = gangsection,
                level     = data.rank .. " (" .. data.xp .. "/" .. (config.Levels[data.rank] or 0) .. ")",
                xpPercent = config.Levels[data.rank] and (data.xp / config.Levels[data.rank]) * 100 or 0,
                cash      = data.money,
                bank      = data.bank,
                coin      = Coin .. " Coin",
            })

            if data.permission_level and data.permission_level > 0 then
                SendNUIMessage({ type = "adminDutyStatus", status = data.aduty })
            end
        end)
    end)

    ESX.TriggerServerCallback('HUD_Menu:GetQuests', function(quests)
        if not quests then return end

        local myquests = {}
        if quests["Job"] then
            local jobname = quests["Job"]
            quests["Job"] = nil
            for id, prog in pairs(quests) do
                local questDef = Config.JobQuests[jobname] and Config.JobQuests[jobname][tonumber(id)]
                if questDef then
                    table.insert(myquests, {
                        id = id,
                        title = questDef.name,
                        description = questDef.description,
                        progress = (tonumber(prog) / questDef.requiredTrigger) * 100,
                        icon = "fa-shield-halved",
                    })
                end
            end
        else
            for id, prog in pairs(quests) do
                local questDef = Config.DefaultQuest[tonumber(id)]
                if questDef then
                    table.insert(myquests, {
                        id = id,
                        title = questDef.name,
                        description = questDef.description,
                        progress = (tonumber(prog) / questDef.requiredTrigger) * 100,
                        icon = "fa-shield-halved",
                    })
                end
            end
        end

        SendNUIMessage({ type = "loadQuests", quests = myquests })
    end)
end

function UpdateAllPlayers()
    ESX.TriggerServerCallback('HUD_Menu:GetAllPLayers', function(allplayers)
        SendNUIMessage({ type = "loadPlayers", players = allplayers })
    end)
end

RegisterCommand('menu', function()
    SetNuiFocus(true, true)
    UpdateProfile()
    UpdateAllPlayers()
    UiShow()
end, false)

AddEventHandler('onKeyDown', function(key)
    if key == "i" then
        ExecuteCommand('menu')
    end
end)

RegisterNUICallback('menuClosed', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('toggleDuty', function(_, cb)
    ExecuteCommand("aduty")
    ESX.TriggerServerCallback('HUD_Menu:GetAcc', function(data)
        if data and data.permission_level and data.permission_level > 0 then
            SendNUIMessage({ type = "adminDutyStatus", status = data.aduty })
        end
    end)
    cb('ok')
end)

-- NOTE: 'sp' and 'goto' both re-check real admin permission SERVER-SIDE
-- inside their own command handlers (esx_aduty), so a non-admin sending
-- this NUI callback can't actually do anything even though the check
-- here is only client-side. 'freeze' isn't a registered command anywhere
-- on this server, so it's a no-op today; wire a real freeze command
-- server-side first if you want this to do something.
RegisterNUICallback('playerAction', function(data, cb)
    if data.action == 'spect' then
        ExecuteCommand("sp " .. data.id)
    elseif data.action == 'goto' then
        ExecuteCommand("goto " .. data.id)
    elseif data.action == 'freeze' then
        ExecuteCommand("freeze " .. data.id)
    end
    cb('ok')
end)
