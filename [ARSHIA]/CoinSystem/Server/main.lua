ESX = nil
TriggerEvent(Config.ESX, function(obj) ESX = obj end)

-- ================================================================= --
-- ==================== Anti-Exploit / Security ==================== --
-- ================================================================= --
-- Everything below was added/changed to fix the coin exploit:
--   1) 'Coin-System:AddCoinCL' let ANY client add ANY amount of coin to
--      themselves directly (no server-side check at all) -> removed.
--   2) 'Coin-System:SetCoin' / 'RemoveCoin' / 'AddCoin' only checked admin
--      permission on the CLIENT (inside the /setcoin command), which is
--      trivial to bypass by firing the server event directly. All three
--      now re-check ESX.GetPlayerFromId(source).permission_level on the
--      SERVER, which cannot be spoofed by the client.
--   3) 'Coin-System:AddTimer' accepted a client-supplied Coin amount and
--      a client-supplied playerId -> now uses a fixed server-side amount
--      and the real `source`, plus a cooldown so it can't be spammed.
--   4) 'Coin-System:ResetCoinTimer' spawned a brand-new infinite loop on
--      EVERY call (every ~2.5 min per player) and never stopped any of
--      them, so a long session ended up with dozens of duplicate loops
--      all paying out rewards for the same player concurrently. Now only
--      one loop per connected player is allowed to run at a time, and it
--      grants the reward directly server-side instead of round-tripping
--      through the client.
-- ================================================================= --

local ADMIN_PERMISSION_LEVEL = 8        -- minimum permission_level allowed to grant/remove/set coins
local MAX_COIN_VALUE         = 1000000  -- hard ceiling so no absurd/overflow values can be written
local TIMER_INCREMENT        = 5        -- fixed, server-side "timercoin" gained per tick
local TIMER_REWARD_AMOUNT    = 1        -- coins granted once timercoin reaches the threshold
local TIMER_THRESHOLD        = 100
local TIMER_TICK_COOLDOWN    = 140      -- seconds; client ticks every 150s, small slack allowed

local activeTimerThreads = {} -- [source] = true while a reward loop is running for that player
local lastTimerTick      = {} -- [source] = os.time() of their last accepted AddTimer call
local attemp              = {}

local function isValidAmount(n)
    n = tonumber(n)
    if not n then return false end
    if n ~= n or n == math.huge or n == -math.huge then return false end -- reject NaN / inf
    if n < 0 or n > MAX_COIN_VALUE then return false end
    return true
end

local function isAdmin(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer ~= nil and xPlayer.permission_level ~= nil and xPlayer.permission_level >= ADMIN_PERMISSION_LEVEL
end

-- Awards a fixed "timercoin" amount for the calling player, at most once
-- every TIMER_TICK_COOLDOWN seconds. Amount and target are both decided
-- server-side now; any arguments the client sends are ignored.
Server('Coin-System:AddTimer', function(_ignoredPlayerId, _ignoredCoin)
    local _source = source
    while ESX == nil do Wait(10) end

    local now = os.time()
    if lastTimerTick[_source] and (now - lastTimerTick[_source]) < TIMER_TICK_COOLDOWN then
        return -- called faster than the intended client cadence, ignore
    end

    while ESX.GetPlayerFromId(_source) == nil do
        attemp[_source] = (attemp[_source] or 0) + 1
        if attemp[_source] >= 4 then
            DropPlayer(_source, "Can't Find User")
            attemp[_source] = nil
            return
        end
        Wait(1000)
    end
    attemp[_source] = nil
    lastTimerTick[_source] = now

    local xPlayer = ESX.GetPlayerFromId(_source)
    local SteamHex = xPlayer.identifier

    MySQL.Async.fetchAll('SELECT timercoin FROM users WHERE identifier = @identifier', {
        ['@identifier'] = SteamHex
    }, function(result)
        if result[1] then
            MySQL.Async.execute('UPDATE users SET timercoin = @timercoin WHERE identifier = @identifier', {
                ['@timercoin'] = (result[1].timercoin or 0) + TIMER_INCREMENT,
                ['@identifier'] = SteamHex,
            })
            TriggerEvent("Coin-System:LoadCoin2", _source)
        end
    end)
end)

-- Admin-only: directly grant coins to a player.
-- NOTE: the client-side /setcoin-style command wrapper only decides
-- whether to SHOW an error to the user; the real gate is here.
Server('Coin-System:AddCoin', function(playerId, Coin)
    local _source = source
    if not isAdmin(_source) then return end
    if not isValidAmount(Coin) then return end

    local targetId = tonumber(playerId)
    local xPlayer = targetId and ESX.GetPlayerFromId(targetId) or nil
    if not xPlayer then return end
    local SteamHex = xPlayer.identifier

    if not Config.CoinItem then
        MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', {
            ['@identifier'] = SteamHex
        }, function(result)
            if result[1] then
                local newCoin = (result[1].coin or 0) + Coin
                MySQL.Async.execute('UPDATE users SET coin = @coin WHERE identifier = @identifier', {
                    ['@coin'] = newCoin,
                    ['@identifier'] = SteamHex,
                })
                TriggerEvent("Coin-System:LoadCoin2", targetId)
                TriggerEvent("Coin-System:UpdateCoin", targetId, tonumber(newCoin))
            end
        end)
    else
        xPlayer.addInventoryItem("coin", Coin, nil, nil, 0)
        local item = xPlayer.getInventoryItem("coin")
        if item then
            TriggerClientEvent("CoinUpdate", xPlayer.source, item.count)
        end
    end
end)

-- Admin-only: remove coins from a player.
Server('Coin-System:RemoveCoin', function(playerId, Coin)
    local _source = source
    if not isAdmin(_source) then return end
    if not isValidAmount(Coin) then return end

    local targetId = tonumber(playerId)
    local xPlayer = targetId and ESX.GetPlayerFromId(targetId) or nil
    if not xPlayer then return end
    local SteamHex = xPlayer.identifier

    if not Config.CoinItem then
        MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', {
            ['@identifier'] = SteamHex
        }, function(result)
            if result[1] then
                local newCoin = math.max(0, (result[1].coin or 0) - Coin)
                MySQL.Async.execute('UPDATE users SET coin = @coin WHERE identifier = @identifier', {
                    ['@coin'] = newCoin,
                    ['@identifier'] = SteamHex,
                })
                TriggerEvent("Coin-System:LoadCoin2", xPlayer.source)
                TriggerClientEvent("CoinUpdate", xPlayer.source, tonumber(newCoin))
            end
        end)
    else
        xPlayer.removeInventoryItem("coin", Coin)
        local item = xPlayer.getInventoryItem("coin")
        if item then
            TriggerClientEvent("CoinUpdate", xPlayer.source, item.count)
        end
    end
end)

-- Admin-only: set a player's coin balance to an exact value.
Server('Coin-System:SetCoin', function(playerId, Coin)
    local _source = source
    if not isAdmin(_source) then return end
    if not isValidAmount(Coin) then return end

    local targetId = tonumber(playerId)
    local xPlayer = targetId and ESX.GetPlayerFromId(targetId) or nil
    if not xPlayer then return end
    local SteamHex = xPlayer.identifier

    if not Config.CoinItem then
        MySQL.Async.execute('UPDATE users SET coin = @coin WHERE identifier = @identifier', {
            ['@coin'] = Coin,
            ['@identifier'] = SteamHex,
        })
        TriggerEvent("Coin-System:LoadCoin2", xPlayer.source)
        TriggerClientEvent("CoinUpdate", xPlayer.source, tonumber(Coin))
    end
end)

Server("Coin-System:LoadCoin", function()
    local _source = source
    if _source == nil then return end
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer == nil then return end
    local SteamHex = xPlayer.identifier
    if SteamHex == nil then return end
    if not Config.CoinItem then
        MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', { ['@identifier'] = SteamHex }, function(result)
            if result and result[1] then
                local Coin = tonumber(result[1].coin) or 0
                TriggerClientEvent("Coin-System:PlayerCoin", _source, Coin)
                TriggerEvent("Coin-System:LoadCoin2", _source)
            end
        end)
    end
end)

-- Players may only ever query their OWN coin/timercoin/admin-perm through
-- these callbacks; `source` (the real caller) is what's used to read data,
-- never a client-supplied id, except GetPlayerCoin's optional lookup which
-- is a read-only balance check.
ESX.RegisterServerCallback('Coin-System:GetPlayerCoin', function(source, cb, id)
    local _source = tonumber(id) or source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return cb(0) end
    if not Config.CoinItem then
        MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier }, function(result)
            if result[1] and result[1].coin then
                cb(tonumber(result[1].coin) or 0)
            else
                cb(0)
            end
        end)
    else
        local item = xPlayer.getInventoryItem("coin")
        if item then
            TriggerClientEvent("CoinUpdate", xPlayer.source, item.count)
            cb(item.count)
        else
            cb(0)
        end
    end
end)

ESX.RegisterServerCallback('Coin-System:GetCoin', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return cb(0) end
    if not Config.CoinItem then
        MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier }, function(result)
            if result[1] and result[1].coin then
                cb(tonumber(result[1].coin) or 0)
            else
                cb(0)
            end
        end)
    else
        local item = xPlayer.getInventoryItem("coin")
        if item then
            TriggerClientEvent("CoinUpdate", _source, item.count)
            cb(item.count)
        else
            cb(0)
        end
    end
end)

ESX.RegisterServerCallback('Coin-System:GetTimerCoin', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return cb(0) end
    MySQL.Async.fetchAll('SELECT timercoin FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier }, function(result)
        if result[1] and result[1].timercoin then
            cb(tonumber(result[1].timercoin) or 0)
        else
            cb(0)
        end
    end)
end)

ESX.RegisterServerCallback('esx_aduty:getAdminPerm', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer and xPlayer.permission_level or 0)
end)

Server("Coin-System:LoadCoin2", function(src)
    local _source = src or source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if _source and xPlayer then
        MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier }, function(result)
            if result[1] and result[1].coin then
                local Coin = tonumber(result[1].coin) or 0
                TriggerClientEvent("Coin-System:PlayerCoin", _source, Coin)
                TriggerClientEvent("CoinUpdate", _source, Coin)
            end
        end)
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5000)
        for k, v in pairs(ESX.GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(v)
            if xPlayer and xPlayer.identifier and not Config.CoinItem then
                MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier }, function(result)
                    if result and result[1] and result[1].coin then
                        local Coin = tonumber(result[1].coin) or 0
                        TriggerClientEvent("Coin-System:PlayerCoin", xPlayer.source, Coin)
                        TriggerClientEvent("CoinUpdate", xPlayer.source, Coin)
                    end
                end)
            end
        end
    end
end)

-- Reward loop. Only one instance is ever allowed to run per connected
-- player (see activeTimerThreads above); the coin is granted directly
-- here, server-side, with no client round trip left to exploit.
Server("Coin-System:ResetCoinTimer", function(_ignoredSrc)
    local _source = source
    if activeTimerThreads[_source] then return end -- already running for this player
    if not ESX.GetPlayerFromId(_source) then return end
    activeTimerThreads[_source] = true

    Citizen.CreateThread(function()
        while activeTimerThreads[_source] do
            local xPlayer = ESX.GetPlayerFromId(_source)
            if not xPlayer then
                activeTimerThreads[_source] = nil
                return
            end

            MySQL.Async.fetchAll('SELECT timercoin FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier }, function(result)
                if result[1] and result[1].timercoin and result[1].timercoin >= TIMER_THRESHOLD then
                    MySQL.Async.execute('UPDATE users SET timercoin = @timercoin WHERE identifier = @identifier', {
                        ['@timercoin'] = 0,
                        ['@identifier'] = xPlayer.identifier
                    })
                    MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier }, function(coinResult)
                        local newCoin = (coinResult[1] and coinResult[1].coin or 0) + TIMER_REWARD_AMOUNT
                        MySQL.Async.execute('UPDATE users SET coin = @coin WHERE identifier = @identifier', {
                            ['@coin'] = newCoin,
                            ['@identifier'] = xPlayer.identifier
                        })
                        TriggerEvent("Coin-System:LoadCoin2", _source)
                    end)
                end
            end)

            Wait(5000)
        end
    end)
end)

AddEventHandler('playerDropped', function()
    local _source = source
    activeTimerThreads[_source] = nil
    lastTimerTick[_source] = nil
    attemp[_source] = nil
end)

-- Server Discord : https://discord.gg/3jzScCJZ5C
