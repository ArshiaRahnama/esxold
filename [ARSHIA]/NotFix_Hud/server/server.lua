ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("GetData", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        cb(xPlayer)
    else
        cb(nil)
    end
end)

ESX.RegisterServerCallback("GetCC", function(source, cb)
    local coin = exports.CoinSystem:Q_Show_Coin_Player(source)
    cb(coin or 0)
end)

ESX.RegisterServerCallback("GetProf", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local prof = GetSteamPP(xPlayer.identifier)
        cb(prof)
    else
        cb(nil)
    end
end)


RegisterServerEvent('hud:bbalance')
AddEventHandler('hud:bbalance', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	balance = xPlayer.bank
	TriggerClientEvent('hud:bankbalance', _source, balance)
	
end)


function GetSteamPP(identifier)
    local avatar = "https://cdn.discordapp.com/attachments/736562375062192199/995301291976831026/noimage.png"
    local callback = promise:new()

    PerformHttpRequest('http://steamcommunity.com/profiles/' .. tonumber(GetIDFromSource('steam', identifier), 16) .. '/?xml=1', function(Error, Content, Head)
        if Content then
            local SteamProfileSplitted = stringsplit(Content, '\n')
            for _, Line in ipairs(SteamProfileSplitted) do
                if Line:find('<avatarFull>') then
                    local avatarURL = Line:gsub('	<avatarFull><!%[CDATA%[', ''):gsub(']]></avatarFull>', '')
                    callback:resolve(avatarURL)
                    return
                end
            end
        end
        callback:resolve(avatar)
    end)

    return Citizen.Await(callback)
end

function GetIDFromSource(Type, CurrentID)
    local ID = stringsplit(CurrentID, ':')
    if (ID[1]:lower() == string.lower(Type)) then
        return ID[2]:lower()
    end
    return nil
end

function stringsplit(input, separator)
    if separator == nil then
        separator = '%s'
    end

    local t = {} 
    local i = 1
    if input ~= nil then
        for str in string.gmatch(input, '([^'..separator..']+)') do
            t[i] = str
            i = i + 1
        end
    end
    return t
end