-- AntiCheat/server.lua
-- Owns all decisions. Clients only ever report raw anomalies (see client.lua).

local ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end
end)

-- players[src] = { score = 100, lastFlagAt = {kind = time}, history = {} }
local players = {}

-- recentFlags[kind] = { {src=, time=}, ... }  -- for cross-player correlation
local recentFlags = {}

-- ============================================================
-- Temporary exemptions -- lets other resources (job scripts doing a
-- legitimate teleport, e.g. esx_uniquejobs' arrest/uncuff teleports)
-- tell us "don't flag THIS player for THIS check for the next N ms".
--
-- exemptions[src] = { [kind] = expiresAtGameTimer }
--
-- SECURITY: ExemptPlayer is reachable indirectly from a plain client
-- net event in other resources (esx_uniquejobs:AntiCheatExempt), which
-- ANY player can fire on themselves with whatever (ms, kinds) they want
-- -- there's no guarantee the caller is actually a job script. So this
-- export enforces its own hard ceiling on duration and only ever
-- exempts the "a legit script action can trip this" kinds (teleport,
-- speed, and invisibility — e.g. the jail arrest cutscene hiding the
-- player), no matter what a caller asks for. It can never be used to
-- silence noclip, godmode, weapon, or resource-whitelist flags.
-- ============================================================
local exemptions = {}
local EXEMPTABLE_KINDS = { teleport = true, speed = true, invisibility = true }
local MAX_EXEMPT_MS = 10000

local function isExempt(src, kind)
    local playerExemptions = exemptions[src]
    if not playerExemptions then return false end
    local expiresAt = playerExemptions[kind]
    return expiresAt ~= nil and GetGameTimer() < expiresAt
end

exports('ExemptPlayer', function(src, ms, kinds)
    if type(src) ~= 'number' or type(kinds) ~= 'table' then return end

    ms = tonumber(ms) or 5000
    if ms > MAX_EXEMPT_MS then ms = MAX_EXEMPT_MS end
    if ms <= 0 then return end

    local expiresAt = GetGameTimer() + ms
    exemptions[src] = exemptions[src] or {}

    for kind, wanted in pairs(kinds) do
        if wanted and EXEMPTABLE_KINDS[kind] then
            exemptions[src][kind] = expiresAt
        end
    end
end)

local function getPlayer(src)
    if not players[src] then
        players[src] = { score = Config.TrustScore.StartingScore, history = {}, knownUnknownResources = {}, lastFlagAt = {} }
    end
    return players[src]
end

AddEventHandler('playerDropped', function()
    players[source] = nil
    exemptions[source] = nil
end)

-- slow natural recovery so one old flag doesn't follow a legit player forever
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        for src, data in pairs(players) do
            if GetPlayerName(src) then -- still connected
                data.score = math.min(Config.TrustScore.MaxScore, data.score + Config.TrustScore.RecoverPerMinute)
            end
        end
    end
end)

local function discordLog(kind, src, evidence, score)
    if not Config.Actions.DiscordWebhook or Config.Actions.DiscordWebhook == '' then return end

    local name = GetPlayerName(src) or ('id:' .. tostring(src))
    local identifiers = GetPlayerIdentifiers(src) or {}
    local idLines = {}
    for _, id in ipairs(identifiers) do
        table.insert(idLines, id)
    end

    local fields = {
        { name = "Player", value = ('%s (server id %s)'):format(name, tostring(src)), inline = false },
        { name = "Flag", value = tostring(kind), inline = true },
        { name = "Trust Score", value = tostring(score), inline = true },
        { name = "Identifiers", value = #idLines > 0 and table.concat(idLines, "\n") or "n/a", inline = false },
        { name = "Evidence", value = "```" .. json.encode(evidence) .. "```", inline = false },
    }

    PerformHttpRequest(Config.Actions.DiscordWebhook, function() end, 'POST',
        json.encode({
            username = Config.Actions.DiscordUsername,
            embeds = {{
                title = "AntiCheat — suspicious activity",
                color = 15158332,
                fields = fields,
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            }}
        }),
        { ['Content-Type'] = 'application/json' }
    )
end

local function correlate(kind, src)
    if not Config.Correlation.Enable then return false end
    local now = GetGameTimer()
    recentFlags[kind] = recentFlags[kind] or {}
    local bucket = recentFlags[kind]

    -- drop stale entries
    for i = #bucket, 1, -1 do
        if now - bucket[i].time > Config.Correlation.WindowMs then
            table.remove(bucket, i)
        end
    end

    table.insert(bucket, { src = src, time = now })

    local distinctPlayers = {}
    for _, e in ipairs(bucket) do
        distinctPlayers[e.src] = true
    end
    local count = 0
    for _ in pairs(distinctPlayers) do count = count + 1 end

    return count >= Config.Correlation.MinPlayers
end

local penaltyByKind = {
    speed           = Config.SpeedCheck.ScorePenalty,
    noclip          = Config.NoclipCheck.ScorePenalty,
    godmode         = Config.GodmodeCheck.ScorePenalty,
    teleport        = Config.TeleportCheck.ScorePenalty,
    superjump       = Config.SuperJumpCheck.ScorePenalty,
    invisibility    = Config.InvisibilityCheck.ScorePenalty,
    infiniteammo    = Config.InfiniteAmmoCheck.ScorePenalty,
    firerate        = Config.FireRateCheck.ScorePenalty,
    weaponblacklist = Config.WeaponBlacklistCheck.ScorePenalty,
    vehiclehandling = Config.VehicleHandlingCheck.ScorePenalty,
    instantrefill   = Config.InstantRefillCheck.ScorePenalty,
    resourcewhitelist = Config.ResourceWhitelistCheck.ScorePenalty,
}

local function applyFlag(src, kind, evidence)
    if type(kind) ~= 'string' or not penaltyByKind[kind] then return end
    if type(evidence) ~= 'table' then evidence = {} end

    -- A legit job script (arrest/uncuff teleport, fast-travel, etc) told us
    -- to hold off on this exact check for this exact player. Skip entirely --
    -- no penalty, no history entry, no webhook -- same as if nothing happened.
    if isExempt(src, kind) then
        if Config.Debug then
            print(('[AntiCheat] %s exempted from %s flag'):format(GetPlayerName(src) or src, kind))
        end
        return
    end

    local data = getPlayer(src)

    -- Safety net (see Config.TrustScore.MinReflagIntervalMs): don't let the
    -- same kind hit the same player twice within the cooldown window, no
    -- matter what the individual check's own debouncing does or doesn't do.
    local now = GetGameTimer()
    local last = data.lastFlagAt[kind]
    if last and (now - last) < (Config.TrustScore.MinReflagIntervalMs or 4000) then
        if Config.Debug then
            print(('[AntiCheat] %s: %s flag suppressed (reflag cooldown)'):format(GetPlayerName(src) or src, kind))
        end
        return
    end
    data.lastFlagAt[kind] = now

    local penalty = penaltyByKind[kind]
    data.score = math.max(Config.TrustScore.MinScore, data.score - penalty)
    table.insert(data.history, { kind = kind, time = os.time(), evidence = evidence })
    if #data.history > 50 then table.remove(data.history, 1) end

    if Config.Persistence and Config.Persistence.Enable then
        local identifiers = GetPlayerIdentifiers(src) or {}
        local identifier = identifiers[1] or ('src:' .. tostring(src))
        MySQL.Async.execute(
            'INSERT INTO `anticheat_flags` (`identifier`, `player_name`, `kind`, `score_after`, `evidence`) VALUES (@identifier, @player_name, @kind, @score_after, @evidence)',
            {
                ['@identifier']  = identifier,
                ['@player_name'] = GetPlayerName(src) or 'unknown',
                ['@kind']        = kind,
                ['@score_after'] = data.score,
                ['@evidence']    = json.encode(evidence),
            }
        )
    end

    local isCorrelated = correlate(kind, src)

    if Config.Debug then
        print(('[AntiCheat] %s flagged=%s score=%s correlated=%s'):format(GetPlayerName(src) or src, kind, data.score, tostring(isCorrelated)))
    end

    if data.score <= Config.TrustScore.WebhookAtScore or isCorrelated then
        discordLog(kind .. (isCorrelated and ' (correlated w/ other players)' or ''), src, evidence, data.score)
    end

    if data.score <= Config.TrustScore.KickAtScore then
        DropPlayer(src, Config.Actions.KickMessage)
        if Config.Debug then
            print(('[AntiCheat] KICKED %s (score reached %s)'):format(GetPlayerName(src) or src, data.score))
        end
    end
end

RegisterNetEvent('AntiCheat:flag')
AddEventHandler('AntiCheat:flag', function(kind, evidence)
    applyFlag(source, kind, evidence)
end)

-- ============================================================
-- Resource Whitelist — compares the client-reported running-resource
-- list against everything the SERVER itself has loaded (the server's
-- own resource list is the ground truth; anything the client reports
-- that the server doesn't know about is the only thing that's actually
-- suspicious — a resource simply being loaded/started is expected).
-- ============================================================
RegisterNetEvent('AntiCheat:resourceList')
AddEventHandler('AntiCheat:resourceList', function(list)
    local src = source
    if type(list) ~= 'table' then return end

    local knownCount = GetNumResources()
    local known = {}
    for i = 0, knownCount - 1 do
        local name = GetResourceByFindIndex(i)
        if name then known[name] = true end
    end
    for _, name in ipairs(Config.ResourceWhitelistCheck.ExtraAllowed or {}) do
        known[name] = true
    end

    -- FIXED: this used to re-flag every unknown name on every 60s report
    -- for as long as it stayed loaded, with no dedup at all -- one
    -- false-positive resource name was a guaranteed kick a few minutes
    -- later. Now we remember (per player) which unknown names we've
    -- already reported and only penalize genuinely NEW ones. If a name
    -- disappears and later reappears, it's treated as new again.
    local data = getPlayer(src)
    local stillPresent = {}
    local unknown = {}
    for _, name in ipairs(list) do
        if not known[name] then
            stillPresent[name] = true
            if not data.knownUnknownResources[name] then
                table.insert(unknown, name)
            end
        end
    end
    data.knownUnknownResources = stillPresent

    if #unknown > 0 then
        applyFlag(src, 'resourcewhitelist', { unknownResources = unknown })
    end
end)

-- Simple in-memory inspection exports for admins to wire into their own
-- permission system (ACE, ESX group, whatever the server already uses) —
-- intentionally left as exports rather than a chat command so you decide
-- who can call it.
exports('GetTrustScore', function(src)
    local data = players[src]
    return data and data.score or Config.TrustScore.StartingScore
end)

exports('GetTrustHistory', function(src)
    local data = players[src]
    return data and data.history or {}
end)
