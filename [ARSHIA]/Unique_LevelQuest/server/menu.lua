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
        MySQL.Async.fetchScalar('SELECT Profile_Pic FROM users WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(profilePic)

            local function withGangLogo(gangLogo)
                local jobName = xPlayer.job and xPlayer.job.name
                local function withJobIcon(jobIcon)
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
                        avatarUrl        = (profilePic ~= nil and profilePic ~= '') and profilePic or nil,
                        gangLogoUrl      = gangLogo,
                        jobIconUrl       = jobIcon,
                    })
                end

                if jobName then
                    MySQL.Async.fetchScalar('SELECT icon_url FROM jobs WHERE name = @name', {
                        ['@name'] = jobName
                    }, function(iconUrl)
                        withJobIcon((iconUrl ~= nil and iconUrl ~= '') and iconUrl or nil)
                    end)
                else
                    withJobIcon(nil)
                end
            end

            if xPlayer.gang and xPlayer.gang.name and xPlayer.gang.name ~= 'nogang' then
                MySQL.Async.fetchScalar('SELECT logo FROM gangs_data WHERE gang_name = @name', {
                    ['@name'] = xPlayer.gang.name
                }, function(logo)
                    withGangLogo((logo ~= nil and logo ~= '' and logo ~= 'defaultlogo') and logo or nil)
                end)
            else
                withGangLogo(nil)
            end
        end)
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
