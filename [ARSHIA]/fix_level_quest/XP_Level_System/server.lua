local Teams = {}

local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand('myxp', function(source, args)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    TriggerClientEvent('chat:addMessage', _source, { args = { '^1[ System ] : ', 'XP : '..xPlayer.xp.." Level : "..xPlayer.rank } })
end, false)





TriggerEvent('es:addAdminCommand', 'addxp', 10, function(source, args, user)
	TriggerEvent('XP_System:AddXP',args[1],args[2],source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Add Xp To Player", params = {{name = "ID", help = "ID Player"},{name = "Amount", help = "Meghdare XP"}}})


RegisterServerEvent('XP_System:AddXP')
AddEventHandler('XP_System:AddXP', function(PlayerID , xp , user)
	local xPlayer = ESX.GetPlayerFromId(PlayerID)
    if xPlayer then
        local rankadded = 0
        local sumxp = xPlayer.xp + tonumber(xp)
        while sumxp >= config.Levels[xPlayer.rank+rankadded] do
            sumxp = sumxp - config.Levels[xPlayer.rank+rankadded]
            rankadded = rankadded + 1
            if not config.Levels[xPlayer.rank+rankadded] then
                rankadded = 101
                sumxp = 0
                break
            end
        end
        local newrank = xPlayer.rank+rankadded
        if newrank >= 100 then
            sumxp = 0
            newrank = 100
        end
        xPlayer.setXP(sumxp)
        xPlayer.setRank(newrank)
        MySQL.Async.execute('UPDATE users SET xp = @xp , rank = @rank WHERE identifier = @identifier',{
            ['identifier'] 	= xPlayer.identifier,
            ['xp']		    = sumxp,
            ['rank']        = newrank
        })
        if user then
            TriggerClientEvent('chat:addMessage', user, { args = { '^4XP/Level ^0Jadide ^3'..xPlayer.name.." :" } })
            TriggerClientEvent('chat:addMessage', user, { args = { '^1XP : ^0'..sumxp..' | ^1Level : ^0'..newrank } })
        end
        TriggerClientEvent('XP_System:SetDecor', PlayerID,newrank)
    else
        if user then
            TriggerClientEvent('esx:showNotification', user, "Playere Morede Nazar Online Nist","error")
        end
    end

end)

RegisterServerEvent("XP_System:setMyDecor")
AddEventHandler("XP_System:setMyDecor", function(src2)
    local src = src2 or source
    local xPlayer = ESX.GetPlayerFromId(src)
    TriggerClientEvent('XP_System:SetDecor', src, xPlayer.rank)
end)


TriggerEvent('es:addAdminCommand', 'removexp', 10, function(source, args, user)
	TriggerEvent('XP_System:RemoveXP',args[1],args[2],source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Remove Xp From Player", params = {{name = "ID", help = "ID Player"},{name = "Amount", help = "Meghdare XP"}}})


RegisterServerEvent('XP_System:RemoveXP')
AddEventHandler('XP_System:RemoveXP', function(PlayerID , xp , user)
	local xPlayer = ESX.GetPlayerFromId(PlayerID)
    if xPlayer then
        local rankremoved = 0
        local sumxp = xPlayer.xp - tonumber(xp)
        while sumxp < 0 do
            if not config.Levels[(xPlayer.rank-rankremoved)-1] then
                sumxp = 0
                rankremoved = xPlayer.rank
                break
            end
            sumxp = sumxp + config.Levels[(xPlayer.rank-rankremoved)-1]
            rankremoved = rankremoved + 1
        end
        local newrank = xPlayer.rank-rankremoved
        if newrank < 1 then
            sumxp = 0
            newrank = 1
        end
        xPlayer.setXP(sumxp)
        xPlayer.setRank(newrank)
        MySQL.Async.execute('UPDATE users SET xp = @xp , rank = @rank WHERE identifier = @identifier',{
            ['identifier'] 	= xPlayer.identifier,
            ['xp']		    = sumxp,
            ['rank']        = newrank
        })
        TriggerClientEvent('XP_System:SetDecor', PlayerID,newrank)
        TriggerClientEvent('chat:addMessage', user, { args = { '^4XP/Level ^0Jadide ^3'..xPlayer.name.." :" } })
        TriggerClientEvent('chat:addMessage', user, { args = { '^1XP : ^0'..sumxp..' | ^1Level : ^0'..newrank } })
    else
        TriggerClientEvent('esx:showNotification', user, "Playere Morede Nazar Online Nist","error")
    end

end)