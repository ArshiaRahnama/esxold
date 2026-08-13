ESX= nil

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

Config.PlayerLevels[0] = 0
local GangInfo = {}
local gangs = {}

RegisterCommand("addxpuser", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.permission_level > 9 then
        if args[1] then
            if args[2] then
                UpdateXP(tonumber(args[1]), tonumber(args[2]), source)
                Database(tonumber(args[2]), tonumber(args[1]))
            end
        end
    end
end)

RegisterCommand("removexpuser", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.permission_level > 9 then
        if args[1] then
            if args[2] then
                UpdateXP2(args[1], tonumber(args[2]), source)
                Database2(tonumber(args[2]), args[1])
            end
        end
    end
end)

ESX.RegisterServerCallback("PlayerLevel:GetPlayerLevel_XP", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
        {
            ['@identifier'] = xPlayer.identifier,

        }, function(result)
            if result[1] then
                cb(tonumber(result[1].xp), tonumber(result[1].rank), tonumber(Config.PlayerLevels[tonumber(result[1].rank) + 1]))
            end
        end)
    end
end)

function Database(AddXp, PlayerID)
    local xPlayer = ESX.GetPlayerFromId(PlayerID)
    if xPlayer then
        MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
        {
            ['@identifier'] = xPlayer.identifier,

        }, function(data)
            if data[1] then
             
                Level = tonumber(data[1].rank)
                XP    = tonumber(data[1].xp)
              
                if XP + AddXp >= Config.PlayerLevels[Level + 1] then
                    XP = XP + AddXp - Config.PlayerLevels[Level + 1]
                    Level = Level + 1
                else
                    XP = XP + AddXp
                end
                MySQL.Async.execute('UPDATE users SET xp = @xp, rank = @rank WHERE identifier = @identifier', 
                {
                    ['@xp']    = XP,
                    ['@rank']    = Level,
                    ['@identifier'] = xPlayer.identifier
                })
            end
        end)
    end
end

function Database2(DelXP, Pid)
    local xPlayer = ESX.GetPlayerFromId(tonumber(Pid))
    if xPlayer then 
        MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
        {
            ['@identifier'] = xPlayer.identifier,

        }, function(data)
            if data[1] then
            
                Level = tonumber(data[1].rank)
                XP    = tonumber(data[1].xp)
            
                if XP - DelXP <= Config.PlayerLevels[Level - 1] then
                    XP = XP - DelXP - Config.PlayerLevels[Level - 1]
                    Level = Level - 1
                else
                    XP = XP - DelXP
                end
                MySQL.Async.execute('UPDATE users SET xp = @xp, rank = @rank WHERE identifier = @identifier', 
                {
                    ['@xp']    = XP,
                    ['@rank']    = Level,
                    ['@identifier'] = xPlayer.identifier
                })

            end
        end)
    else

    end
end

function UpdateXP(Player, Add, AdminSRC)
    local xPlayer = ESX.GetPlayerFromId(Player)
    local Admin   = ESX.GetPlayerFromId(AdminSRC)

    if xPlayer then 
        MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
        {
            ['@identifier'] = xPlayer.identifier,

        }, function(data)
            if data[1] then
                Data = {
                    Level = data[1].rank,
                    XP    = data[1].xp
                }
                TriggerClientEvent("PlayerLevel:AddXPtoPlayer", xPlayer.source, Add, Data)
                TriggerClientEvent('esx:showNotification', xPlayer.source, '~g~~h~ Shoma ~y~~h~'..Add.." XP~g~~h~ Az ~y~~h~"..Admin.name.." ~g~~h~Daryaft Kard.")
            end
        end)
    end
end

function UpdateXP2(Player, Remove, AdminSRC)
    local xPlayer = ESX.GetPlayerFromId(Player)
    local Admin   = ESX.GetPlayerFromId(AdminSRC)

    if xPlayer then 
        MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
        {
            ['@identifier'] = xPlayer.identifier,

        }, function(data)
            if data[1] then
                Data = {
                    Level = data[1].rank,
                    XP    = data[1].xp
                }

                TriggerClientEvent("PlayerLevel:RemoveXPtoPlayer", xPlayer.source, Remove, Data)
                TriggerClientEvent('esx:showNotification', xPlayer.source, Admin.name.." Az Shoma "..Remove.. " XP Kam Kard")
            end
        end)
    end
end

function UpdateXPALL(Add, Playerid)
    local xPlayer = ESX.GetPlayerFromId(Playerid)

    if xPlayer then 
        MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
        {
            ['@identifier'] = xPlayer.identifier,

        }, function(data)
            if data[1] then
                Data = {
                    Level = data[1].rank,
                    XP    = data[1].xp
                }
                TriggerClientEvent("PlayerLevel:AddXPtoPlayer", xPlayer.source, Add, Data)
            end
        end)
    end
end

RegisterNetEvent("PlayerLevel:AddXpPlayer")
AddEventHandler('PlayerLevel:AddXpPlayer', function(Add2)
    src = source
    Add = tonumber(Add2)
    UpdateXPALL(Add, src)
    Database(Add, src)
end)

RegisterNetEvent('PlayerLevel:GetLevels_SV')
AddEventHandler('PlayerLevel:GetLevels_SV', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then 
        MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
        {
            ['@identifier'] = xPlayer.identifier,

        }, function(data)
            if data[1] then
                Data = {
                    Level = data[1].rank,
                    XP    = data[1].xp
                }
                TriggerClientEvent("PlayerLevel:GetLevels_CL", xPlayer.source, Data)
            end
        end)
    end
end)