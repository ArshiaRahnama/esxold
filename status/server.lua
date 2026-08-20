ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- reloaddata: the only server callback client.lua actually calls.
-- 'coin' is pulled live from the real coin system (Unique_LevelQuest/server/coin.lua,
-- callback 'Coin-System:GetCoin') instead of a fake/placeholder "tc" field.
-- Server-side callbacks call each other directly through ESX.ServerCallbacks
-- (ESX.TriggerServerCallback is the client-side version and isn't usable here).
ESX.RegisterServerCallback('reloaddata', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		if ESX.ServerCallbacks['Coin-System:GetCoin'] then
			ESX.ServerCallbacks['Coin-System:GetCoin'](source, function(coinAmount)
				xPlayer.coin = coinAmount or 0
				cb(xPlayer)
			end)
		else
			xPlayer.coin = 0
			cb(xPlayer)
		end
	end
end)

-- Note: 'gangs:getGangData' is intentionally NOT redefined here — it's already
-- registered by [ARSHIA]/Unique_Gangs/server/main.lua, and client.lua calls it
-- by that same name, so it's already wired up correctly as-is.