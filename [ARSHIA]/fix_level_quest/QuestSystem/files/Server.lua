ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent("QuestSystem:InitializePlayer")
AddEventHandler("QuestSystem:InitializePlayer", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM quest WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		if not result[1] then
            MySQL.Sync.execute('INSERT INTO quest (identifier, date, quests) VALUES (@identifier, @date, @quests)', {
					['@identifier'] = xPlayer.identifier,
					['@date']       = os.date("%Y/%m/%d"),
                    ['@quests']     = "{}"
			})
            GenerateQuests(xPlayer,xPlayer.identifier)
        elseif result[1].date ~= os.date("%Y/%m/%d") then
            MySQL.Async.execute('UPDATE quest SET quests = @quests , date = @date WHERE identifier = @identifier', {
				['@identifier'] = xPlayer.identifier,
                ['@date']       = os.date("%Y/%m/%d"),
				['@quests']     = "{}"
			})
            GenerateQuests(xPlayer,xPlayer.identifier)
        end
	end)
    -- GenerateQuests(xPlayer.identifier)
    -- local xPlayer = ESX.GetPlayerFromId(source)
    -- local playerId = xPlayer.identifier

    -- if ActiveQuests[playerId] and ActiveQuests[playerId].date ~= os.date("%Y/%m/%d") then
    --     ActiveQuests[playerId] = nil
    -- end
    -- if not ActiveQuests[playerId] then
    --     ActiveQuests[playerId] = {
    --         activeQuest = {type = nil, status = false, completed = 0, id = 0, trigger = "", required = 0},
    --         date = os.date("%Y/%m/%d"),
    --         deeds = {}
    --     }
    --     SaveActiveQuests()
    -- elseif not ActiveQuests[playerId].activeQuest then
    --     ActiveQuests[playerId].activeQuest = {type = nil, status = false, completed = 0, id = 0, trigger = "", required = 0}
    --     SaveActiveQuests()
    -- end
end)

function GenerateQuests(xPlayer,identifier)
    local usedQuestIds = {}
    local quests ={}
    for jobname,_ in pairs(Config.JobQuests) do
        if xPlayer.job.name == jobname or xPlayer.job.name == ('off'..jobname) then
            quests["Job"] = jobname
        end
    end
    for i = 1, 6 do
        local questid
        repeat
            if quests["Job"] then
                questid = math.random(1, #Config.JobQuests[quests["Job"]])
            else
                questid = math.random(1, #Config.DefaultQuest)
            end
        until not usedQuestIds[questid]
        usedQuestIds[questid] = true
        quests[tostring(questid)]=0
    end
    Citizen.Wait(100)
    MySQL.Async.execute('UPDATE quest SET quests = @quests WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
        ['@quests']     = json.encode(quests)
	})
end



for id, quest in ipairs(Config.DefaultQuest) do
    RegisterServerEvent(quest.trigger)
    AddEventHandler(quest.trigger, function()
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer == nil then return end
        if xPlayer.job.name ~= 'nojob' then return end
        MySQL.Async.fetchAll('SELECT * FROM quest WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(result)
            if result[1] then
                local playerquests = json.decode(result[1].quests)
                if playerquests[tostring(id)] then
                    if playerquests[tostring(id)] < quest.requiredTrigger then
                        playerquests[tostring(id)] = playerquests[tostring(id)] + 1
                        if playerquests[tostring(id)] == quest.requiredTrigger then
                            TriggerClientEvent('esx:showNotification', xPlayer.source, "Quest Completed !","success",quest.name)
                            TriggerClientEvent('esx:showNotification', xPlayer.source, "You Got "..quest.XP.." XP And "..quest.coin.." Coins","success","Quest Rewards")
                            TriggerEvent('XP_System:AddXP', xPlayer.source,quest.XP)
                            TriggerClientEvent("QuestSystem:AddCoin",xPlayer.source, quest.coin)
                        else
                            TriggerClientEvent('esx:showNotification', xPlayer.source, "Quest : "..playerquests[tostring(id)].."/"..quest.requiredTrigger,"success",quest.name)
                        end
                        MySQL.Async.execute('UPDATE quest SET quests = @quests WHERE identifier = @identifier', {
                            ['@identifier'] = xPlayer.identifier,
                            ['@quests']     = json.encode(playerquests)
                        })
                    end
                end
            end
        end)

    end)
end

for job, quests in pairs(Config.JobQuests) do
    for id, quest in ipairs(quests) do
        RegisterServerEvent(quest.trigger)
        AddEventHandler(quest.trigger, function()
            
            local xPlayer = ESX.GetPlayerFromId(source)
            if xPlayer == nil then return end

            if xPlayer.job.name ~= job then return end
            MySQL.Async.fetchAll('SELECT * FROM quest WHERE identifier = @identifier', {
                ['@identifier'] = xPlayer.identifier
            }, function(result)
                if result[1] then
                    local playerquests = json.decode(result[1].quests)
                    if playerquests["Job"] then
                        if playerquests["Job"] == job then
                            if playerquests[tostring(id)] then
                                if playerquests[tostring(id)] < quest.requiredTrigger then
                                    playerquests[tostring(id)] = playerquests[tostring(id)] + 1
                                    if playerquests[tostring(id)] == quest.requiredTrigger then
                                        TriggerClientEvent('esx:showNotification', xPlayer.source, "Quest Completed !","success",quest.name)
                                        TriggerClientEvent('esx:showNotification', xPlayer.source, "You Got "..quest.XP.." XP And "..quest.coin.." Coins","success","Quest Rewards")
                                        TriggerEvent('XP_System:AddXP', xPlayer.source,quest.XP)
                                        TriggerClientEvent("QuestSystem:AddCoin",xPlayer.source, quest.coin)
                                    else
                                        TriggerClientEvent('esx:showNotification', xPlayer.source, "Quest : "..playerquests[tostring(id)].."/"..quest.requiredTrigger,"success",quest.name)
                                    end
                                    MySQL.Async.execute('UPDATE quest SET quests = @quests WHERE identifier = @identifier', {
                                        ['@identifier'] = xPlayer.identifier,
                                        ['@quests']     = json.encode(playerquests)
                                    })
                                end
                            end
                        end
                    end
                end
            end)

        end)
    end
end