ESX = nil
local RobberyCode = 0
local Robs ={}
local RobsInProgress = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function IsPoliceJob(jobname)
    for i = 1, #Config.PoliceJobs do
        if Config.PoliceJobs[i] == jobname then
            return true
        end
    end
    return false
end

CreateThread(function()
    while true do
        Wait(1000)
        for k,v in pairs(Config.Robs) do
            if (os.time() - v.lastRobbed) < Config.RobTypes[v.type].cooldown and v.lastRobbed ~= 0 then
                TriggerClientEvent('Morphy_RobSystem:SetMarker', -1, k, false)
            else
                TriggerClientEvent('Morphy_RobSystem:SetMarker', -1, k, true)
            end
        end

    end
end)

-- ESX.RegisterServerCallback("Morphy_RobSystem:getRobsCd", function(source, cb)
--     local Bank = 0
--     local Minibank = 0
--     local Feleca = 0
--     local SheriffBank = 0
--     local shop = 0
--     local Bimeh = 0
--     local mythic = 0
--     local cargo = 0

--     if (Config.RobTypes["Central_Bank"].cooldown - (os.time() - Config.RobTypes["Central_Bank"].lastRobbed)) > 0 then
--         Bank = Config.RobTypes["Central_Bank"].cooldown - (os.time() - Config.RobTypes["Central_Bank"].lastRobbed)
--     end

--     if (Config.RobTypes["Minibank"].successtime - (os.time() - Config.RobTypes["Minibank"].lastRobbed)) > 0 then
--         Minibank = Config.RobTypes["Minibank"].successtime - (os.time() - Config.RobTypes["Minibank"].lastRobbed)
--     end

--     if (Config.RobTypes["Minibank"].successtime - (os.time() - Config.RobTypes["Minibank"].lastRobbed)) > 0 then
--         Feleca = Config.RobTypes["Minibank"].successtime - (os.time() - Config.RobTypes["Minibank"].lastRobbed)
--     end

--     if (Config.RobTypes["MazeBank"].cooldown - (os.time() - Config.RobTypes["MazeBank"].lastRobbed)) > 0 then
--         SheriffBank = Config.RobTypes["MazeBank"].cooldown - (os.time() - Config.RobTypes["MazeBank"].lastRobbed)
--     end

--     if (Config.RobTypes["Shop"].successtime - (os.time() - Config.RobTypes["Shop"].lastRobbed)) > 0 then
--         shop = Config.RobTypes["Shop"].successtime - (os.time() - Config.RobTypes["Shop"].lastRobbed)
--     end

--     if (Config.RobTypes["Life_Invader"].cooldown - (os.time() - Config.RobTypes["Life_Invader"].lastRobbed)) > 0 then
--         Bimeh = Config.RobTypes["Life_Invader"].cooldown - (os.time() - Config.RobTypes["Life_Invader"].lastRobbed)
--     end

--     if (Config.RobTypes["Airport"].cooldown - (os.time() - Config.RobTypes["Airport"].lastRobbed)) > 0 then
--         mythic = Config.RobTypes["Airport"].cooldown - (os.time() - Config.RobTypes["Airport"].lastRobbed)
--     end

--     if (Config.RobTypes["Jaw_Shams"].cooldown - (os.time() - Config.RobTypes["Jaw_Shams"].lastRobbed)) > 0 then
--         cargo = Config.RobTypes["Jaw_Shams"].cooldown - (os.time() - Config.RobTypes["Jaw_Shams"].lastRobbed)
--     end


--     cb({
--         ["Bank"] = Bank,
-- 		["Minibank"] = Minibank,
-- 		["Feleca"] = Feleca,
-- 		["SheriffBank"] = SheriffBank,
-- 		["shop"] = shop,
-- 		["Bimeh"] = Bimeh,
-- 		["mythic"] = mythic,
-- 		["cargo"] = cargo

--     })
-- end)

RegisterServerEvent('Morphy_RobSystem:robberyNeeds')
AddEventHandler('Morphy_RobSystem:robberyNeeds', function(robname)
    local _source = source
    if GetPlayerRoutingBucket(_source) ~= 0 then
        TriggerClientEvent('esx:showNotification', _source, "Shoma Dar Worlde Asli Nistid !!",'error')
		return
	end
    local xPlayer  = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
    if RobsInProgress[_source] then
        TriggerClientEvent('esx:showNotification', _source, "Shoma Al'an Dar Hale Ejraye Yek Dozdi Hastid !",'error')
        return
    end
    if Config.Robs[robname].someonerobbing then
        TriggerClientEvent('esx:showNotification', _source, "Fardi Dar Hale Hack Ast .")
        return
    end 

    if IsPoliceJob(xPlayer.job.name) then
        TriggerClientEvent('esx:showNotification', _source, "Azaye Organ Haye Nezami Tavanayi Dozdi Nadarand .",'error')
        return
    end

    if xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'taxi' or xPlayer.job.name == 'mechanic' then
        TriggerClientEvent('esx:showNotification', _source, "Baraye Dozdi Shoma Bayad OFF DUTY Bashid .",'error')
        return
    end



    if (os.time() - Config.Robs[robname].lastRobbed) < Config.RobTypes[Config.Robs[robname].type].cooldown and Config.Robs[robname].lastRobbed ~= 0 then
        TriggerClientEvent('esx:showNotification', _source, "In Makan Qablan Azash Dozdi Shode Lotfan "..(Config.RobTypes[Config.Robs[robname].type].cooldown - (os.time() - Config.Robs[robname].lastRobbed)).." Sanie Sabr Konid Barai Dozdi Dobare" )
        return
    end
    if (os.time() - Config.RobTypes[Config.Robs[robname].type].lastRobbed) < Config.RobTypes[Config.Robs[robname].type].successtime then
        TriggerClientEvent('esx:showNotification', _source, "Robbery Digari Dar Jarian Ast Lotfan "..(Config.RobTypes[Config.Robs[robname].type].successtime - (os.time() - Config.RobTypes[Config.Robs[robname].type].lastRobbed)).." Sanie Sabr Konid " )
        return
    end



    if Config.RobTypes[Config.Robs[robname].type].teammatesrequired ~= 0 then
        local InTeam,PlayerTeam,TeamID = exports["PartySystem"]:IsInTeam(_source)
        if not InTeam then
            TriggerClientEvent('esx:showNotification', _source, "Baraye Starte In Robbery Shoma Bayad Dar Team Bashid! /party" )
            return
        end
        if PlayerTeam[_source].rank ~= "Leader" then
            TriggerClientEvent('esx:showNotification', _source, "Shoma Bayad Leader Team Bashid !" )
            return
        end

        local TeamMemberCount = 0
        local CloseMemberCount = 0
        local ped = GetPlayerPed(_source)
        local playerCoords = GetEntityCoords(ped)
        for mateid,_ in pairs(PlayerTeam) do
            TeamMemberCount = TeamMemberCount + 1
            local ped2 = GetPlayerPed(mateid)
            local playerCoords2 = GetEntityCoords(ped2)
            if #(playerCoords - playerCoords2) <= 10 then
                CloseMemberCount = CloseMemberCount + 1
            end
        end

        if TeamMemberCount < Config.RobTypes[Config.Robs[robname].type].teammatesrequired then
            TriggerClientEvent('esx:showNotification', _source, "Shoma Bayad Hadaghal "..Config.RobTypes[Config.Robs[robname].type].teammatesrequired.." Nafar Dar Team bashid !" )
            return
        end

        if CloseMemberCount < Config.RobTypes[Config.Robs[robname].type].teammatesrequired then
            TriggerClientEvent('esx:showNotification', _source, "Afrade Dakhele Team Az Shoma Door Hastand!",'error')
            return
        end
    end


    local cops = 0
    for i=1, #xPlayers, 1 do
        local yPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if IsPoliceJob(yPlayer.job.name) then
            cops = cops + 1
        end
    end

    if cops < Config.RobTypes[Config.Robs[robname].type].copsrequired then
        TriggerClientEvent('esx:showNotification', _source, "Baraye Starte In Robbery Bayad Hadaghal "..Config.RobTypes[Config.Robs[robname].type].copsrequired.." Police Dar Shahr Bashad")
        return
    end

    for itemname,amount in pairs(Config.RobTypes[Config.Robs[robname].type].itemneed) do
        if xPlayer.getInventoryItem(itemname) then
            if amount > xPlayer.getInventoryItem(itemname).count then
                TriggerClientEvent('esx:showNotification', _source, "Baraye Starte In Robbery Bayad Be tedade "..amount.." az "..itemname.." Dashte Bashid .")
                return
            end
        else
            TriggerClientEvent('esx:showNotification', _source, "Baraye Starte In Robbery Bayad Be tedade "..amount.." az "..itemname.." Dashte Bashid .")
            return
        end
        
    end
    for itemname,amount in pairs(Config.RobTypes[Config.Robs[robname].type].itemneed) do
        xPlayer.removeInventoryItem(itemname, amount)
    end
    Config.Robs[robname].someonerobbing = true
    RobsInProgress[_source] = robname
    TriggerClientEvent('Morphy_RobSystem:StartHack', _source,robname,Config.RobTypes[Config.Robs[robname].type].hacktype)
end)

RegisterServerEvent('Morphy_RobSystem:robberyStarted')
AddEventHandler('Morphy_RobSystem:robberyStarted', function(robname)
    Config.Robs[robname].someonerobbing = false
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    RobsInProgress[_source] = robname
	local xPlayers = ESX.GetPlayers()
    SetAlarmPolice(robname , "start",_source)
    RobberyCode = RobberyCode + 1
    for i=1, #xPlayers, 1 do
        local yPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if IsPoliceJob(yPlayer.job.name) then
            TriggerClientEvent('esx:showNotification', xPlayers[i],"Yek Robbery Dar "..Config.Robs[robname].nameofrob.." Start Shod")
            TriggerClientEvent('Morphy_RobSystem:setBlip', xPlayers[i], robname, Config.Robs[robname].position)
        end
    end
    TriggerEvent('DiscordBot:ToDiscord', 'rob', "Robbery System", "```css\n[ID] : ".._source.."\n[IC Name] : "..xPlayer.name.."\n[Steam Name] : "..GetPlayerName(source).."\n[Gang Name] : "..xPlayer.gang.name.."\n[Gang Grade] : "..xPlayer.gang.grade.."\n[Steam Hex] : "..xPlayer.identifier.."\n[Rob Name] : "..robname.."\n[Rob Code] : "..RobberyCode.."\n[Status] : Started\n```",'user', _source, true, false)
    TriggerClientEvent('esx:showNotification', _source, "Robbery Start Shod !",'success')
    TriggerClientEvent('Morphy_RobSystem:StartProgressBar', _source, robname, RobberyCode)

    Config.RobTypes[Config.Robs[robname].type].lastRobbed = os.time()
    Config.Robs[robname].lastRobbed = os.time()

end)

RegisterServerEvent('Morphy_RobSystem:robberyHackFail')
AddEventHandler('Morphy_RobSystem:robberyHackFail', function(robname)
    local _source = source
    Config.Robs[robname].someonerobbing = false
    RobsInProgress[_source] = nil

    Config.RobTypes[Config.Robs[robname].type].lastRobbed = os.time()
    Config.Robs[robname].lastRobbed = os.time()

end)

RegisterServerEvent('Morphy_RobSystem:robberySuccess')
AddEventHandler('Morphy_RobSystem:robberySuccess', function(robname,RobberyCode)
    local _source = source
    RobsInProgress[_source] = nil
    local xPlayer  = ESX.GetPlayerFromId(_source)
    local accepted = exports["esx_policejob"]:CheckRob(RobberyCode)
    if accepted then
        for itemname,amount in pairs(Config.RobTypes[Config.Robs[robname].type].reward) do
            if type(amount) == "table" then
                amount = math.random(amount.min, amount.max)
            end
            if itemname == "cash" then
                xPlayer.addMoney(amount)
            elseif string.sub(itemname, 1, 2) == "xp" then
                if xPlayer.gang.name ~= "nogang" then
                    xPlayer.addInventoryItem(itemname, amount)
                end
            else
                xPlayer.addInventoryItem(itemname, amount)
            end
        end
    else
        for itemname,amount in pairs(Config.RobTypes[Config.Robs[robname].type].lessreward) do
            if type(amount) == "table" then
                amount = math.random(amount.min, amount.max)
            end
            if itemname == "cash" then
                xPlayer.addMoney(amount)
            elseif string.sub(itemname, 1, 2) == "xp" then
                if xPlayer.gang.name ~= "nogang" then
                    xPlayer.addInventoryItem(itemname, amount)
                end
            else
                xPlayer.addInventoryItem(itemname, amount)
            end
        end
    end
    TriggerEvent('DiscordBot:ToDiscord', 'rob', "Robbery System", "```css\n[ID] : ".._source.."\n[IC Name] : "..xPlayer.name.."\n[Steam Name] : "..GetPlayerName(source).."\n[Gang Name] : "..xPlayer.gang.name.."\n[Gang Grade] : "..xPlayer.gang.grade.."\n[Steam Hex] : "..xPlayer.identifier.."\n[Rob Name] : "..robname.."\n[Rob Code] : "..RobberyCode.."\n[Status] : Success".."\n[Is Accepted] : "..tostring(accepted).."\n```",'user', _source, true, false)
    local xPlayers, yPlayer = ESX.GetPlayers(), nil
    SetAlarmPolice(robname , "end",_source)
    for i=1, #xPlayers, 1 do
        yPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if IsPoliceJob(yPlayer.job.name) then
            TriggerClientEvent('esx:showNotification', xPlayers[i],"Robbery "..Config.Robs[robname].nameofrob.." Success Shod",'success')
            TriggerClientEvent('Morphy_RobSystem:killBlip', xPlayers[i],robname)
        end
    end

end)

RegisterServerEvent('Morphy_RobSystem:robberyCancel')
AddEventHandler('Morphy_RobSystem:robberyCancel', function(robname)
    local _source = source
    RobsInProgress[_source] = nil
    local xPlayer  = ESX.GetPlayerFromId(_source)
    TriggerClientEvent('esx:showNotification', _source, "Be Dalile Door Shodan Az Robbery , Robery Shoma Cancel Shod !")
    local xPlayers, yPlayer = ESX.GetPlayers(), nil
    TriggerEvent('DiscordBot:ToDiscord', 'rob', "Robbery System", "```css\n[ID] : ".._source.."\n[IC Name] : "..xPlayer.name.."\n[Steam Name] : "..GetPlayerName(source).."\n[Gang Name] : "..xPlayer.gang.name.."\n[Gang Grade] : "..xPlayer.gang.grade.."\n[Steam Hex] : "..xPlayer.identifier.."\n[Rob Name] : "..robname.."\n[Status] : Canceled\n```",'user', _source, true, false)
    SetAlarmPolice(robname , "cancel",_source)
    for i=1, #xPlayers, 1 do
        yPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if IsPoliceJob(yPlayer.job.name) then
            TriggerClientEvent('esx:showNotification', xPlayers[i],"Robbery "..Config.Robs[robname].nameofrob.." Cnacel Shod")
            TriggerClientEvent('Morphy_RobSystem:killBlip', xPlayers[i],robname)
        end
    end

end)



function SetAlarmPolice(Name ,  typ , source )
    local xPlayers = ESX.GetPlayers()
    if typ == 'start' then 
        
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if IsPoliceJob(xPlayer.job.name)  then
             SendMessage( xPlayer.source , 'Az Dispatch be Tamai Vahed Ha Az ^1' ..Config.Robs[Name].nameofrob .. '^0 Gozarsh Dozdi Reside')
            end
        end
        TriggerEvent('Unit:RobAlarm' , Name )
    elseif typ  == 'end' then 
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if IsPoliceJob(xPlayer.job.name)  then
              SendMessage( xPlayer.source , 'Az Dispatch be Tamai Vahed Ha Dar ^1' ..Config.Robs[Name].nameofrob .. '^0 Sareghan ^1Movafagh^0 Be Dozdi Shodand')
            end
        end
    elseif typ  == 'cancel' then 
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if IsPoliceJob(xPlayer.job.name) then
                SendMessage( xPlayer.source , 'Az Dispatch be Tamai Vahed Ha Dar ^1' ..Config.Robs[Name].nameofrob .. '^0 Sareghan Dar Dozdi ^1Na Movafagh^0 Bodand')
            end
        end
    end 
end 

function SendMessage( src , msg )
    template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color:rgba(13, 196, 196, 0.4);  border-radius: 3px;">Dispatch   <br> '..msg..' <br> </div>'
    TriggerClientEvent('chat:addMessage', src , {template = template ,args = "."})
end 


AddEventHandler('playerDropped', function(reason)
    local _source = source
    if RobsInProgress[_source] then
        if RobsInProgress[_source] ~= nil then
            local xPlayer  = ESX.GetPlayerFromId(_source)
            local xPlayers, yPlayer = ESX.GetPlayers(), nil
            TriggerEvent('DiscordBot:ToDiscord', 'rob', "Robbery System", "```css\n[ID] : ".._source.."\n[IC Name] : "..xPlayer.name.."\n[Steam Name] : "..GetPlayerName(source).."\n[Gang Name] : "..xPlayer.gang.name.."\n[Gang Grade] : "..xPlayer.gang.grade.."\n[Steam Hex] : "..xPlayer.identifier.."\n[Rob Name] : "..RobsInProgress[_source].."\n[Status] : Canceled\n```",'user', _source, true, false)
            SetAlarmPolice(RobsInProgress[_source] , "cancel",_source)
            for i=1, #xPlayers, 1 do
                yPlayer = ESX.GetPlayerFromId(xPlayers[i])

                if IsPoliceJob(yPlayer.job.name) then
                    TriggerClientEvent('esx:showNotification', xPlayers[i],"Robbery "..Config.Robs[RobsInProgress[_source]].nameofrob.." Cnacel Shod")
                    TriggerClientEvent('Morphy_RobSystem:killBlip', xPlayers[i],RobsInProgress[_source])
                end
            end
        end
    end
    RobsInProgress[_source] = nil

end)