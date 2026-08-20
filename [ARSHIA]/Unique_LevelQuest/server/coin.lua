

local TIMER_INCREMENT     = 5
local TIMER_REWARD_AMOUNT = 1
local TIMER_THRESHOLD     = 100
local TIMER_TICK_COOLDOWN = 140

local activeTimerThreads = {}
local lastTimerTick      = {}
local coinAttempts       = {}

local function isValidCoinAmount(n)
    n = tonumber(n)
    if not n then return false end
    if n ~= n or n == math.huge or n == -math.huge then return false end
    if n < 0 or n > Config.CoinMaxValue then return false end
    return true
end

local function isCoinAdmin(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer ~= nil and xPlayer.permission_level ~= nil and xPlayer.permission_level >= Config.CoinAdminPermission
end

function GrantCoin(targetId, coinAmount)
    if not isValidCoinAmount(coinAmount) then return false end
    targetId = tonumber(targetId)
    local xPlayer = targetId and ESX.GetPlayerFromId(targetId) or nil
    if not xPlayer then return false end

    if not Config.CoinItem then
        MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(result)
            if result[1] then
                local newCoin = (result[1].coin or 0) + coinAmount
                MySQL.Async.execute('UPDATE users SET coin = @coin WHERE identifier = @identifier', {
                    ['@coin'] = newCoin,
                    ['@identifier'] = xPlayer.identifier,
                })
                TriggerEvent("Coin-System:LoadCoin2", targetId)
            end
        end)
    else
        xPlayer.addInventoryItem("coin", coinAmount, nil, nil, 0)
        local item = xPlayer.getInventoryItem("coin")
        if item then
            TriggerClientEvent("CoinUpdate", xPlayer.source, item.count)
        end
    end
    return true
end

RegisterServerEvent('Coin-System:AddTimer')
AddEventHandler('Coin-System:AddTimer', function(_ignoredPlayerId, _ignoredCoin)
    local _source = source

    local now = os.time()
    if lastTimerTick[_source] and (now - lastTimerTick[_source]) < TIMER_TICK_COOLDOWN then
        return
    end

    while ESX.GetPlayerFromId(_source) == nil do
        coinAttempts[_source] = (coinAttempts[_source] or 0) + 1
        if coinAttempts[_source] >= 4 then
            coinAttempts[_source] = nil
            return
        end
        Wait(1000)
    end
    coinAttempts[_source] = nil
    lastTimerTick[_source] = now

    local xPlayer = ESX.GetPlayerFromId(_source)

    MySQL.Async.fetchAll('SELECT timercoin FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if result[1] then
            MySQL.Async.execute('UPDATE users SET timercoin = @timercoin WHERE identifier = @identifier', {
                ['@timercoin'] = (result[1].timercoin or 0) + TIMER_INCREMENT,
                ['@identifier'] = xPlayer.identifier,
            })
            TriggerEvent("Coin-System:LoadCoin2", _source)
        end
    end)
end)

RegisterServerEvent('Coin-System:AddCoin')
AddEventHandler('Coin-System:AddCoin', function(playerId, coinAmount)
    if not isCoinAdmin(source) then return end
    GrantCoin(playerId, coinAmount)
end)

RegisterServerEvent('Coin-System:RemoveCoin')
AddEventHandler('Coin-System:RemoveCoin', function(playerId, coinAmount)
    if not isCoinAdmin(source) then return end
    if not isValidCoinAmount(coinAmount) then return end

    local targetId = tonumber(playerId)
    local xPlayer = targetId and ESX.GetPlayerFromId(targetId) or nil
    if not xPlayer then return end

    if not Config.CoinItem then
        MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(result)
            if result[1] then
                local newCoin = math.max(0, (result[1].coin or 0) - coinAmount)
                MySQL.Async.execute('UPDATE users SET coin = @coin WHERE identifier = @identifier', {
                    ['@coin'] = newCoin,
                    ['@identifier'] = xPlayer.identifier,
                })
                TriggerEvent("Coin-System:LoadCoin2", xPlayer.source)
            end
        end)
    else
        xPlayer.removeInventoryItem("coin", coinAmount)
        local item = xPlayer.getInventoryItem("coin")
        if item then
            TriggerClientEvent("CoinUpdate", xPlayer.source, item.count)
        end
    end
end)

RegisterServerEvent('Coin-System:SetCoin')
AddEventHandler('Coin-System:SetCoin', function(playerId, coinAmount)
    if not isCoinAdmin(source) then return end
    if not isValidCoinAmount(coinAmount) then return end

    local targetId = tonumber(playerId)
    local xPlayer = targetId and ESX.GetPlayerFromId(targetId) or nil
    if not xPlayer then return end

    if not Config.CoinItem then
        MySQL.Async.execute('UPDATE users SET coin = @coin WHERE identifier = @identifier', {
            ['@coin'] = coinAmount,
            ['@identifier'] = xPlayer.identifier,
        })
        TriggerEvent("Coin-System:LoadCoin2", xPlayer.source)
    end
end)

RegisterServerEvent("Coin-System:LoadCoin")
AddEventHandler("Coin-System:LoadCoin", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return end
    if not Config.CoinItem then
        MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier }, function(result)
            if result and result[1] then
                local coinAmount = tonumber(result[1].coin) or 0
                TriggerClientEvent("Coin-System:PlayerCoin", _source, coinAmount)
            end
        end)
    end
end)

ESX.RegisterServerCallback('Coin-System:GetPlayerCoin', function(source, cb, id)
    local _source = tonumber(id) or source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return cb(0) end
    if not Config.CoinItem then
        MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier }, function(result)
            cb(result[1] and tonumber(result[1].coin) or 0)
        end)
    else
        local item = xPlayer.getInventoryItem("coin")
        cb(item and item.count or 0)
    end
end)

ESX.RegisterServerCallback('Coin-System:GetCoin', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb(0) end
    if not Config.CoinItem then
        MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier }, function(result)
            cb(result[1] and tonumber(result[1].coin) or 0)
        end)
    else
        local item = xPlayer.getInventoryItem("coin")
        cb(item and item.count or 0)
    end
end)

ESX.RegisterServerCallback('Coin-System:GetTimerCoin', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb(0) end
    MySQL.Async.fetchAll('SELECT timercoin FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier }, function(result)
        cb(result[1] and tonumber(result[1].timercoin) or 0)
    end)
end)

RegisterServerEvent("Coin-System:LoadCoin2")
AddEventHandler("Coin-System:LoadCoin2", function(src)
    local _source = src or source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if _source and xPlayer then
        MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier }, function(result)
            if result[1] and result[1].coin then
                local coinAmount = tonumber(result[1].coin) or 0
                TriggerClientEvent("Coin-System:PlayerCoin", _source, coinAmount)
            end
        end)
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5000)
        for _, v in pairs(ESX.GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(v)
            if xPlayer and xPlayer.identifier and not Config.CoinItem then
                MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier }, function(result)
                    if result and result[1] and result[1].coin then
                        TriggerClientEvent("Coin-System:PlayerCoin", xPlayer.source, tonumber(result[1].coin) or 0)
                    end
                end)
            end
        end
    end
end)

RegisterServerEvent("Coin-System:ResetCoinTimer")
AddEventHandler("Coin-System:ResetCoinTimer", function(_ignoredSrc)
    local _source = source
    if activeTimerThreads[_source] then return end
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
                    GrantCoin(_source, TIMER_REWARD_AMOUNT)
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
    coinAttempts[_source] = nil
end)
