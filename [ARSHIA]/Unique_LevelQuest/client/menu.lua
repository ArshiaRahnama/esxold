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
                type       = "updateProfile",
                name       = string.gsub(data.name, "_", " ") .. " (" .. myId .. ")",
                job        = jobsection,
                gang       = gangsection,
                level      = data.rank,
                xpCurrent  = data.xp,
                xpNeeded   = config.Levels[data.rank] or 0,
                xpPercent  = config.Levels[data.rank] and (data.xp / config.Levels[data.rank]) * 100 or 0,
                cash       = data.money,
                bank       = data.bank,
                coin       = Coin .. " Coin",
                avatarUrl  = data.avatarUrl,
                gangLogoUrl= data.gangLogoUrl,
                jobIconUrl = data.jobIconUrl,
            })
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
                    local current = tonumber(prog) or 0
                    table.insert(myquests, {
                        id = id,
                        title = questDef.name,
                        description = questDef.description,
                        progress = (current / questDef.requiredTrigger) * 100,
                        current = current,
                        required = questDef.requiredTrigger,
                        xp = questDef.XP,
                        coin = questDef.coin,
                        icon = "fa-shield-halved",
                    })
                end
            end
        else
            for id, prog in pairs(quests) do
                local questDef = Config.DefaultQuest[tonumber(id)]
                if questDef then
                    local current = tonumber(prog) or 0
                    table.insert(myquests, {
                        id = id,
                        title = questDef.name,
                        description = questDef.description,
                        progress = (current / questDef.requiredTrigger) * 100,
                        current = current,
                        required = questDef.requiredTrigger,
                        xp = questDef.XP,
                        coin = questDef.coin,
                        icon = "fa-shield-halved",
                    })
                end
            end
        end

        SendNUIMessage({ type = "loadQuests", quests = myquests })
    end)
end

RegisterCommand('menu', function()
    SetNuiFocus(true, true)
    UpdateProfile()
    UpdateSkills()
    UpdateCollections()
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
