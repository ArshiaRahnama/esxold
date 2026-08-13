ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(1)
	end
end)

function UiShow()
    SendNUIMessage({type = "openMenu"})
end

function UpdateProfile()
    ESX.TriggerServerCallback('HUD_Menu:GetAcc', function(xPlayer,id)
        while not xPlayer do
            Citizen.Wait(100)
        end
        ESX.TriggerServerCallback('HUD_Menu:GetCC', function(Coin)
            while not Coin do
                Citizen.Wait(100)
            end
            local jobsection = 'No Job'
            local gangsection = 'No Gang'
            if xPlayer.job.name ~= 'nojob' then
                jobsection = xPlayer.job.label.." | "..xPlayer.job.grade_label.." ("..xPlayer.job.grade..")"
            end
            if xPlayer.gang.name ~= 'nogang' then
                gangsection = xPlayer.gang.name.." | "..xPlayer.gang.grade_label.." ("..xPlayer.gang.grade..")"
            end

            SendNUIMessage({type = "updateProfile",
                            name = string.gsub(xPlayer.name, "_", " ").." ("..id..")",
                            job = jobsection,
                            gang = gangsection,
                            level = xPlayer.rank.." ("..xPlayer.xp.."/"..config.Levels[xPlayer.rank]..")",
                            xpPercent = (xPlayer.xp/config.Levels[xPlayer.rank])*100,
                            cash = xPlayer.money,
                            bank = xPlayer.bank,
                            coin = Coin.." Coin"

            })
            if xPlayer.permission_level > 0 then
                SendNUIMessage({
                    type = "adminDutyStatus",
                    status = xPlayer.aduty -- یا false یا nil
                })
            end
        end)

    end)
    ESX.TriggerServerCallback('HUD_Menu:GetQuests', function(quests)
        while not quests  do
            Citizen.Wait(100)
        end
        local myquests = {}
        if quests["Job"] then
            local jobname = quests["Job"]
            quests["Job"] = nil
            for id,prog in pairs(quests) do
                table.insert(myquests,{
                    id = id,
                    title = Config.JobQuests[jobname][tonumber(id)].name,
                    description = Config.JobQuests[jobname][tonumber(id)].description,
                    progress = (tonumber(prog)/Config.JobQuests[jobname][tonumber(id)].requiredTrigger)*100,
                    icon = "fa-shield-halved"
                })
            end
        else
            for id,prog in pairs(quests) do
                table.insert(myquests,{
                    id = id,
                    title = Config.DefaultQuest[tonumber(id)].name,
                    description = Config.DefaultQuest[tonumber(id)].description,
                    progress = (tonumber(prog)/Config.DefaultQuest[tonumber(id)].requiredTrigger)*100,
                    icon = "fa-shield-halved"
                })
            end
        end
        SendNUIMessage({type = "loadQuests",
                    quests= myquests
        })
    end)
end


function UpdateAllPlayers()
    ESX.TriggerServerCallback('HUD_Menu:GetAllPLayers', function(allplayers)
        SendNUIMessage({
        type = "loadPlayers",
        players = allplayers
        })
    end)
end


RegisterCommand('menu', function()
    SetNuiFocus(true,true)
    UpdateProfile()
    UpdateAllPlayers()
    UiShow()
end, false)

AddEventHandler('onKeyDown',function(key)
	if key == "i" then
        ExecuteCommand('menu')
	end
end)

RegisterNUICallback('menuClosed', function(data, cb)
	SetNuiFocus(false,false)
end)

RegisterNUICallback('toggleDuty', function(data, cb)
	ExecuteCommand("aduty")
    ESX.TriggerServerCallback('HUD_Menu:GetAcc', function(xPlayer,id)
        while not xPlayer do
            Citizen.Wait(100)
        end
        if xPlayer.permission_level > 0 then
                SendNUIMessage({
                    type = "adminDutyStatus",
                    status = xPlayer.aduty -- یا false یا nil
                })
            end
    end)
end)

RegisterNUICallback('playerAction', function(data, cb)
    if data.action == 'spect' then
        ExecuteCommand("sp "..data.id)
    elseif data.action == 'goto' then
        ExecuteCommand("goto "..data.id)
    elseif data.action == 'freeze' then
        ExecuteCommand("freeze "..data.id)
    end
end)





-- --  Dadane Data Be JS Arad
-- RegisterNUICallback('openBank', function(data, cb)
-- 	ESX.TriggerServerCallback('QuantumPhone:GetBankBalance', function(data2)
--         SendNUIMessage({action = 'updateBalance', balance = tostring(data2)})
--     end)
-- end)

-- RegisterNUICallback('banktransfer', function(data, cb)
--     if tonumber(data.money) > 0 then
--         TriggerServerEvent('QuantumPhone:TransferMoney', data.id, data.money)
--         Citizen.Wait(100)
--         ESX.TriggerServerCallback('QuantumPhone:GetBankBalance', function(data2)
--             SendNUIMessage({action = 'updateBalance', balance = tostring(data2)})
--         end)
--     end

-- end)

-- RegisterNUICallback('Close', function(data, cb)
-- 	SetNuiFocus(false,false)
-- end)
