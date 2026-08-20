

local PlayerXP   = {}
local PlayerRank = {}

local function clearCache(source)
    PlayerXP[source] = nil
    PlayerRank[source] = nil
end

local function getXPRank(playerId, cb)
    if PlayerXP[playerId] and PlayerRank[playerId] then
        cb(PlayerXP[playerId], PlayerRank[playerId])
        return
    end

    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then cb(nil, nil) return end

    MySQL.Async.fetchAll('SELECT xp, rank FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        local xp   = (result[1] and tonumber(result[1].xp)) or 0
        local rank = (result[1] and tonumber(result[1].rank)) or 1
        if rank < 1 then rank = 1 end
        PlayerXP[playerId] = xp
        PlayerRank[playerId] = rank
        cb(xp, rank)
    end)
end

local function saveXPRank(playerId, xp, rank)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then return end
    PlayerXP[playerId] = xp
    PlayerRank[playerId] = rank
    MySQL.Async.execute('UPDATE users SET xp = @xp, rank = @rank WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier,
        ['@xp']         = xp,
        ['@rank']       = rank,
    })
    TriggerClientEvent('XP_System:SetDecor', playerId, rank)
end

function GrantXP(playerId, xp, notifySource)
    playerId = tonumber(playerId)
    xp = tonumber(xp)
    if not playerId or not xp or xp <= 0 then return end

    getXPRank(playerId, function(curXP, curRank)
        if not curXP then
            if notifySource then
                TriggerClientEvent('esx:showNotification', notifySource, "Playere Morede Nazar Online Nist", "error")
            end
            return
        end

        local rankadded = 0
        local sumxp = curXP + xp
        while config.Levels[curRank + rankadded] and sumxp >= config.Levels[curRank + rankadded] do
            sumxp = sumxp - config.Levels[curRank + rankadded]
            rankadded = rankadded + 1
            if not config.Levels[curRank + rankadded] then
                rankadded = 101
                sumxp = 0
                break
            end
        end

        local newrank = curRank + rankadded
        if newrank >= 100 then
            sumxp = 0
            newrank = 100
        end

        saveXPRank(playerId, sumxp, newrank)

        if notifySource then
            local xPlayer = ESX.GetPlayerFromId(playerId)
            local name = xPlayer and xPlayer.name or ("id " .. playerId)
            TriggerClientEvent('chat:addMessage', notifySource, { args = { '^4XP/Level ^0Jadide ^3' .. name .. " :" } })
            TriggerClientEvent('chat:addMessage', notifySource, { args = { '^1XP : ^0' .. sumxp .. ' | ^1Level : ^0' .. newrank } })
        end
    end)
end

function RevokeXP(playerId, xp, notifySource)
    playerId = tonumber(playerId)
    xp = tonumber(xp)
    if not playerId or not xp or xp <= 0 then return end

    getXPRank(playerId, function(curXP, curRank)
        if not curXP then
            if notifySource then
                TriggerClientEvent('esx:showNotification', notifySource, "Playere Morede Nazar Online Nist", "error")
            end
            return
        end

        local rankremoved = 0
        local sumxp = curXP - xp
        while sumxp < 0 do
            if not config.Levels[(curRank - rankremoved) - 1] then
                sumxp = 0
                rankremoved = curRank
                break
            end
            sumxp = sumxp + config.Levels[(curRank - rankremoved) - 1]
            rankremoved = rankremoved + 1
        end

        local newrank = curRank - rankremoved
        if newrank < 1 then
            sumxp = 0
            newrank = 1
        end

        saveXPRank(playerId, sumxp, newrank)

        if notifySource then
            local xPlayer = ESX.GetPlayerFromId(playerId)
            local name = xPlayer and xPlayer.name or ("id " .. playerId)
            TriggerClientEvent('chat:addMessage', notifySource, { args = { '^4XP/Level ^0Jadide ^3' .. name .. " :" } })
            TriggerClientEvent('chat:addMessage', notifySource, { args = { '^1XP : ^0' .. sumxp .. ' | ^1Level : ^0' .. newrank } })
        end
    end)
end

RegisterCommand('myxp', function(source)
    getXPRank(source, function(xp, rank)
        if not xp then return end
        TriggerClientEvent('chat:addMessage', source, { args = { '^1[ System ] : ', 'XP : ' .. xp .. " Level : " .. rank } })
    end)
end, false)

TriggerEvent('es:addAdminCommand', 'addxp', config.AdminXPPermission, function(source, args)
    GrantXP(tonumber(args[1]), args[2], source)
end, function(source)
    TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, { help = "Add Xp To Player", params = { { name = "ID", help = "ID Player" }, { name = "Amount", help = "Meghdare XP" } } })

TriggerEvent('es:addAdminCommand', 'removexp', config.AdminXPPermission, function(source, args)
    RevokeXP(tonumber(args[1]), args[2], source)
end, function(source)
    TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, { help = "Remove Xp From Player", params = { { name = "ID", help = "ID Player" }, { name = "Amount", help = "Meghdare XP" } } })

RegisterServerEvent('XP_System:AddXP')
AddEventHandler('XP_System:AddXP', function(playerId, xp)
    local _source = source
    local caller = ESX.GetPlayerFromId(_source)
    if not caller or not caller.permission_level or caller.permission_level < config.AdminXPPermission then
        return
    end
    GrantXP(tonumber(playerId), xp, _source)
end)

RegisterServerEvent('XP_System:RemoveXP')
AddEventHandler('XP_System:RemoveXP', function(playerId, xp)
    local _source = source
    local caller = ESX.GetPlayerFromId(_source)
    if not caller or not caller.permission_level or caller.permission_level < config.AdminXPPermission then
        return
    end
    RevokeXP(tonumber(playerId), xp, _source)
end)

RegisterServerEvent("XP_System:setMyDecor")
AddEventHandler("XP_System:setMyDecor", function()
    local src = source
    getXPRank(src, function(xp, rank)
        if rank then
            TriggerClientEvent('XP_System:SetDecor', src, rank)
        end
    end)
end)

ESX.RegisterServerCallback('XP_System:getRank', function(_source, cb, targetId)
    getXPRank(tonumber(targetId), function(_, rank)
        cb(rank or -1)
    end)
end)

function GetXPRankCached(playerId, cb)
    getXPRank(playerId, cb)
end

AddEventHandler('playerDropped', function()
    clearCache(source)
end)
