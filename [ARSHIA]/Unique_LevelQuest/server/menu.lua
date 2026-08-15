-- ================================================================= --
-- HUD menu callbacks (was Interaction_Menu/server.lua)
-- ================================================================= --
-- FIX: GetAcc used to hand back the ENTIRE raw xPlayer object over the
-- network. It's always for the requesting player's own data (source is
-- fixed server-side, can't be spoofed to fetch someone else's), so it
-- wasn't a cross-player leak — but it was still sending internal fields
-- the UI never uses. Trimmed to just what the HUD needs.
-- ================================================================= --

ESX.RegisterServerCallback("HUD_Menu:GetAcc", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb(nil) end

    GetXPRankCached(source, function(xp, rank)
        cb({
            name             = xPlayer.name,
            job              = xPlayer.job,
            gang             = xPlayer.gang,
            rank             = rank or 1,
            xp               = xp or 0,
            money            = xPlayer.money,
            bank             = xPlayer.bank,
            permission_level = xPlayer.permission_level,
            aduty            = xPlayer.aduty,
        })
    end)
end)

ESX.RegisterServerCallback("HUD_Menu:GetCC", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb(0) end

    MySQL.Async.fetchScalar('SELECT coin FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(coin)
        cb(coin or 0)
    end)
end)

ESX.RegisterServerCallback("HUD_Menu:GetQuests", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb({}) end

    MySQL.Async.fetchAll('SELECT * FROM quest WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if result[1] and result[1].quests then
            cb(json.decode(result[1].quests))
        else
            cb({})
        end
    end)
end)
