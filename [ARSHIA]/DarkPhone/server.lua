
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function IsPoliceJob(jobname)
    return jobname == 'police' or jobname == 'sheriff' or jobname == 'fbi' or jobname == 'mt'
end

ESX.RegisterUsableItem('darkphone', function(source)
    TriggerClientEvent('DarkPhone:OpenMenu', source)
end)

-- ==================================== Hostage ===========================================

local LastHostageTime = nil
local HostageOwner = nil

RegisterServerEvent('DarkPhone:StartHostage')
AddEventHandler('DarkPhone:StartHostage', function(coords)
	local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source
    if GetPlayerRoutingBucket(_source) ~= 0 then
        TriggerClientEvent('esx:showNotification', _source, "Shoma Dar Worlde Asli Nistid !!",'error')
		return
	end
    if IsPoliceJob(xPlayer.job.name) then
        TriggerClientEvent('esx:showNotification', _source, "Azaye Organ Haye Nezami Tavanayi Gerogan Giri Nadarand .",'error')
        return
    end

    if xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'taxi' or xPlayer.job.name == 'mechanic' then
        TriggerClientEvent('esx:showNotification', _source, "Baraye Gerogan Giri Shoma Bayad OFF DUTY Bashid .",'error')
        return
    end

    if LastHostageTime then
        if (os.time() - LastHostageTime) < Config.Hostage.Cooldown then
            TriggerClientEvent('esx:showNotification', _source, "Gerogan Giri Dar Cooldown Ast Lotfan "..(Config.Hostage.Cooldown - (os.time() - LastHostageTime)).." Sanie Sabr Konid " )
            return
        end
    end

    local xPlayers = ESX.GetPlayers()
    local cops = 0
    for i=1, #xPlayers, 1 do
        local yPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if IsPoliceJob(yPlayer.job.name) then
            cops = cops + 1
        end
    end

    if cops < Config.Hostage.CopsRequired then
        TriggerClientEvent('esx:showNotification', _source, "Baraye Starte Gerogan Giri Bayad Hadaghal "..Config.Hostage.CopsRequired.." Police Dar Shahr Bashad")
        return
    end
    LastHostageTime = os.time()
    HostageOwner = _source
    xPlayer.removeInventoryItem("darkphone", 1)
    TriggerClientEvent('chat:addMessage', _source, { args = { '^1[Gerogan Giri] ', 'Alarme Gerogan Giri Braye Tamame ^1Niro Haye Nezami^0 Ersal Shod !' } })
    for i=1, #xPlayers, 1 do
        local yPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if IsPoliceJob(yPlayer.job.name) then
            TriggerClientEvent('chat:addMessage', xPlayers[i], { args = { '^1[Gerogan Giri] ', 'Yek ^1Gerogan Giri^0 Start Shod !' } })
            TriggerClientEvent('DarkPhone:setBlipHostage', xPlayers[i], coords)
        end
    end
    TriggerClientEvent('DarkPhone:CheckDistance', _source, coords)
end)

RegisterServerEvent('DarkPhone:CancelHostage')
AddEventHandler('DarkPhone:CancelHostage', function()
	local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source
    TriggerClientEvent('chat:addMessage', _source, { args = { '^1[Gerogan Giri] ', '^1Gerogan Giri^0 Be Dalile Door Shodan Az Mahale Start Cancel Shod !' } })
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local yPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if IsPoliceJob(yPlayer.job.name) then
            TriggerClientEvent('chat:addMessage', xPlayers[i], { args = { '^1[Gerogan Giri] ', 'Gerogan Gir Az Mahale Start Door Shod Va ^1Gerogan Giri^0 Cancel Shod !' } })
            TriggerClientEvent('DarkPhone:killBlipHostage', xPlayers[i])
        end
    end
    HostageOwner = nil
end)

RegisterServerEvent('DarkPhone:SuccessHostage')
AddEventHandler('DarkPhone:SuccessHostage', function()
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local yPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if IsPoliceJob(yPlayer.job.name) then
            TriggerClientEvent('DarkPhone:killBlipHostage', xPlayers[i])
        end
    end
    HostageOwner = nil
end)

-- ==================================== Pursuit ===========================================

local LastPursuitTime = nil
local PursuitOwner = nil
local PursuitAccepted = false

RegisterServerEvent('DarkPhone:StartPursuit')
AddEventHandler('DarkPhone:StartPursuit', function(coords)
	local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source
    if GetPlayerRoutingBucket(_source) ~= 0 then
        TriggerClientEvent('esx:showNotification', _source, "Shoma Dar Worlde Asli Nistid !!",'error')
		return
	end
    if IsPoliceJob(xPlayer.job.name) then
        TriggerClientEvent('esx:showNotification', _source, "Azaye Organ Haye Nezami Tavanayi Starte Pursuit Ra Nadarand .",'error')
        return
    end

    if xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'taxi' or xPlayer.job.name == 'mechanic' then
        TriggerClientEvent('esx:showNotification', _source, "Baraye Starte Pursuit Shoma Bayad OFF DUTY Bashid .",'error')
        return
    end

    if LastPursuitTime then
        if (os.time() - LastPursuitTime) < Config.Pursuit.Cooldown then
            TriggerClientEvent('esx:showNotification', _source, "Pursuit Dar Cooldown Ast Lotfan ~y~"..(Config.Pursuit.Cooldown - (os.time() - LastPursuitTime)).."~s~ Sanie Sabr Konid " )
            return
        end
    end

    local xPlayers = ESX.GetPlayers()
    local cops = 0
    for i=1, #xPlayers, 1 do
        local yPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if IsPoliceJob(yPlayer.job.name) then
            cops = cops + 1
        end
    end

    if cops < Config.Pursuit.CopsRequired then
        TriggerClientEvent('esx:showNotification', _source, "Baraye Starte Pursuit Bayad Hadaghal "..Config.Pursuit.CopsRequired.." Police Dar Shahr Bashad")
        return
    end
    LastPursuitTime = os.time()
    PursuitOwner = _source
    xPlayer.removeInventoryItem("darkphone", 1)
    TriggerClientEvent('chat:addMessage', _source, { args = { '^1[Pursuit] ', 'Alarme Pursuit Braye Tamame ^1Niro Haye Nezami^0 Ersal Shod !' } })
    for i=1, #xPlayers, 1 do
        local yPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if IsPoliceJob(yPlayer.job.name) then
            TriggerClientEvent('chat:addMessage', xPlayers[i], { args = { '^1[Pursuit] ', 'Yek ^1Pursuit^0 Start Shod !' } })
            TriggerClientEvent('chat:addMessage', xPlayers[i], { args = { '^1[Pursuit] ', 'Baraye Accept Kardane In Pursuit Az /accp Estefade Konid .' } })
            TriggerClientEvent('DarkPhone:setBlipPursuit', xPlayers[i], coords,_source)
        end
    end
    TriggerClientEvent('DarkPhone:StartProgressBar', _source)
end)

RegisterServerEvent('DarkPhone:SuccessPursuit')
AddEventHandler('DarkPhone:SuccessPursuit', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local yPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if IsPoliceJob(yPlayer.job.name) then
            TriggerClientEvent('DarkPhone:killBlipPursuit', xPlayers[i])
            TriggerClientEvent('chat:addMessage', xPlayers[i], { args = { '^1[Pursuit] ', 'Alarme ^1Pursuit^0 Be Payan Resid !' } })
        end
    end
    PursuitOwner = nil
    if PursuitAccepted then
        xPlayer.addMoney(Config.Pursuit.Reward)
        TriggerClientEvent('chat:addMessage', source, { args = { '^1[Pursuit] ', 'Alarme ^1Pursuit^0 Be Payan Resid Va Shoma $'..Config.Pursuit.Reward..' Pool Daryaft Kardid !' } })
    else
        TriggerClientEvent('chat:addMessage', source, { args = { '^1[Pursuit] ', 'Alarme ^1Pursuit^0 Be Payan Resid !' } })
    end
    PursuitAccepted = false
end)

ESX.RegisterServerCallback('DarkPhone:getcoord', function(source, cb, id)
	local coord = GetEntityCoords(GetPlayerPed(id))
	cb(coord)
end)

RegisterCommand('accp', function(source, args)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if IsPoliceJob(xPlayer.job.name) then
        if PursuitOwner then
            if PursuitOwner ~= nil then
                PursuitAccepted = true
                local xPlayers = ESX.GetPlayers()
                for i=1, #xPlayers, 1 do
                    local yPlayer = ESX.GetPlayerFromId(xPlayers[i])
                    if IsPoliceJob(yPlayer.job.name) then
                        TriggerClientEvent('chatMessage',xPlayers[i] , "", {255, 0, 0}, "^5[ Dispatch ] ^7:" .. 'Pursuit' ..  '^7 tavasot ^2'.. xPlayer.name .. ' ^7(^5' .. string.upper(xPlayer.job.name ) ..   '^7) ^7 accept shod' )
                    end
                end
            else
                TriggerClientEvent('esx:showNotification', _source, "Pursuiti Dar Jarian Nist !")
            end
        else
            TriggerClientEvent('esx:showNotification', _source, "Pursuiti Dar Jarian Nist !")
        end
    end
end)





AddEventHandler('playerDropped', function(reason)
    local _source = source
    if HostageOwner then
        if HostageOwner == _source then
            local xPlayers = ESX.GetPlayers()
            for i=1, #xPlayers, 1 do
                local yPlayer = ESX.GetPlayerFromId(xPlayers[i])
                if IsPoliceJob(yPlayer.job.name) then
                    TriggerClientEvent('DarkPhone:killBlipHostage', xPlayers[i])
                end
            end
            HostageOwner = nil
        end
    end

    if PursuitOwner then
        if PursuitOwner == _source then
            local xPlayers = ESX.GetPlayers()
            for i=1, #xPlayers, 1 do
                local yPlayer = ESX.GetPlayerFromId(xPlayers[i])
                if IsPoliceJob(yPlayer.job.name) then
                    TriggerClientEvent('DarkPhone:killBlipPursuit', xPlayers[i])
                end
            end
            PursuitOwner = nil
        end
    end


end)