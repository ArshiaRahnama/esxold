

ESX = nil
TriggerEvent(Config.ESX, function(obj) ESX = obj end)
attemp = {}
Server('Coin-System:AddTimer', function(playerId, Coin)
	while ESX == nil do Wait(10) end
	while ESX.GetPlayerFromId(playerId) == nil do
		attemp[playerId] = attemp[playerId] + 1
		if attemp[playerId] == 4 then
			DropPlayer(source,"Can't Find User")
			attemp[playerId] = nil
		end
		Wait(1000)
	end
		
	local _source = source
    local SteamHex = ESX.GetPlayerFromId(playerId).identifier
	
	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = SteamHex
	}, function(result)
		if result[1] then
			MySQL.Async.execute('UPDATE users SET timercoin = @timercoin WHERE identifier = @identifier', {
				['@timercoin'] = result[1].timercoin + Coin,
				['@identifier'] = SteamHex,	
			})
			TriggerEvent("Coin-System:LoadCoin2", playerId)	
		end
    end)
end)

Server('Coin-System:AddCoinCL', function(Coin)
	local _source = source
	if _source then
		local xPlayer = ESX.GetPlayerFromId(_source)
		if xPlayer then
			local SteamHex = xPlayer.identifier
			if not Config.CoinItem then
				MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
					['@identifier'] = SteamHex
				}, function(result)
					if result[1] then
						MySQL.Async.execute('UPDATE users SET coin = @coin WHERE identifier = @identifier', {
							['@coin'] = result[1].coin + Coin,
							['@identifier'] = SteamHex,	
						})
						TriggerEvent("Coin-System:LoadCoin2", _source)	
						TriggerEvent("Coin-System:UpdateCoin", _source, tonumber(result[1].coin + Coin))	
					end
				end)
			else
				xPlayer.addInventoryItem("coin", (Coin or 1), nil, nil, 0)
				item,i = xPlayer.getInventoryItem("coin")
				if xPlayer and item then
					TriggerClientEvent("CoinUpdate", xPlayer.source, item.count)
				end
			end
		end
	end
end)

Server('Coin-System:AddCoin', function(playerId, Coin)
	local _source = playerId or source
	if _source then
		local xPlayer = ESX.GetPlayerFromId(_source)
		if xPlayer then
			local SteamHex = xPlayer.identifier
			if not Config.CoinItem then
				MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
					['@identifier'] = SteamHex
				}, function(result)
					if result[1] then
						MySQL.Async.execute('UPDATE users SET coin = @coin WHERE identifier = @identifier', {
							['@coin'] = result[1].coin + Coin,
							['@identifier'] = SteamHex,	
						})
						TriggerEvent("Coin-System:LoadCoin2", _source)	
						TriggerEvent("Coin-System:UpdateCoin", _source, tonumber(result[1].coin + Coin))	
					end
				end)
			else
				xPlayer.addInventoryItem("coin", (Coin or 1),nil, nil, 0)
				item,i = xPlayer.getInventoryItem("coin")
				if xPlayer and item then
					TriggerClientEvent("CoinUpdate", xPlayer.source, item.count)
				end
			end
		end
	end
end)

Server('Coin-System:RemoveCoin', function(playerId, Coin)
	local _source = source
    local SteamHex = ESX.GetPlayerFromId(playerId).identifier
	if not Config.CoinItem then
		MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
			['@identifier'] = SteamHex
		}, function(result)
			if result[1] then
				MySQL.Async.execute('UPDATE users SET coin = @coin WHERE identifier = @identifier', {
					['@coin'] = result[1].coin - Coin,
					['@identifier'] = SteamHex,	
				})	
				TriggerEvent("Coin-System:LoadCoin2", playerId)
				TriggerClientEvent("CoinUpdate", xPlayer.source, tonumber(result[1].coin - Coin))
			end
		end)
	else
		xPlayer.removeInventoryItem("coin", Coin)
		item,i = xPlayer.getInventoryItem("coin")
		if xPlayer and item then
			TriggerClientEvent("CoinUpdate", xPlayer.source, item.count)
		end
	end
end)

Server('Coin-System:SetCoin', function(playerId, Coin)
	local _source = source
    local SteamHex = ESX.GetPlayerFromId(playerId).identifier
	if not Config.CoinItem then
		MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
			['@identifier'] = SteamHex
		}, function(result)
			if result[1] then
				MySQL.Async.execute('UPDATE users SET coin = @coin WHERE identifier = @identifier', {
					['@coin'] = Coin,
					['@identifier'] = SteamHex,	
				})	
				TriggerEvent("Coin-System:LoadCoin2", playerId)
				TriggerClientEvent("CoinUpdate", xPlayer.source, tonumber(Coin))
			end
		end)
	end
end)

Server("Coin-System:LoadCoin", function()
	local _source = source
	if _source == nil then return Wait(100) end
	local xPlayer = ESX.GetPlayerFromId(_source) 
	if xPlayer == nil then return Wait(100) end
    local SteamHex = xPlayer.identifier
	if SteamHex == nil then return Wait(100) end
	if not Config.CoinItem then
		MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', {['@identifier'] = SteamHex}, function(result)
			if result then
				if result[1].coin then
					data = result[1].coin
					Coin = tonumber(data)
					TriggerClientEvent("Coin-System:PlayerCoin", _source, Coin)
					TriggerEvent("Coin-System:LoadCoin2", _source)
				else
					Coin = tonumber(0)
					TriggerClientEvent("Coin-System:PlayerCoin", _source, Coin)
					TriggerEvent("Coin-System:LoadCoin2", _source)
				end
			end
		end)
	end
end)

ESX.RegisterServerCallback('Coin-System:GetPlayerCoin', function(source, cb, id)
	local _source = id
    local player = GetPlayerIdentifier(_source)
	if not Config.CoinItem then
		MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', {['@identifier'] = player}, function(result)
			if result[1].coin then
				data = json.decode(result[1].coin)
				Coin = tonumber(data)
				cb(Coin)
			end
		end)
	else
		local xPlayer = ESX.GetPlayerFromId(_source)
		item,i = xPlayer.getInventoryItem("coin")
		TriggerClientEvent("CoinUpdate", xPlayer.source, xPlayer.inventory[i].count)
		cb(xPlayer.inventory[i].count)
	end
end)

ESX.RegisterServerCallback('Coin-System:GetCoin', function(source, cb)
	local _source = source
    local player = GetPlayerIdentifier(_source)
	if not Config.CoinItem then
		MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', {['@identifier'] = player}, function(result)
			if result[1]  then
				if result[1].coin then
					data = json.decode(result[1].coin)
					Coin = tonumber(data)
					cb(Coin)
				end
			end
		end)
	else
		local xPlayer = ESX.GetPlayerFromId(_source)
		item,i = xPlayer.getInventoryItem("coin")
		TriggerClientEvent("CoinUpdate", _source, item.count)
		cb(item.count)
	end
end)

ESX.RegisterServerCallback('Coin-System:GetTimerCoin', function(source, cb)
	local _source = source
    local player = ESX.GetPlayerFromId(_source).identifier
	if player or _source then 
		MySQL.Async.fetchAll('SELECT timercoin FROM users WHERE identifier = @identifier', {['@identifier'] = player}, function(result)
			if result[1] == nil then return Wait(100) end
			if result[1].timercoin then
				data = json.decode(result[1].timercoin)
				timercoin = tonumber(data)
				cb(timercoin)
			end
		end)
	end
end)

ESX.RegisterServerCallback('esx_aduty:getAdminPerm', function(source, cb)
	local _source = source
    local player = ESX.GetPlayerFromId(_source)
	cb(player.permission_level)
end)

Server("Coin-System:LoadCoin2", function(src)	
	local _source = src
	xPlayer = ESX.GetPlayerFromId(_source)
	if _source and xPlayer then 
		local SteamHex = ESX.GetPlayerFromId(_source).identifier
		if _source == nil then return Wait(100) end	
		if not Config.CoinItem then
			MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', {['@identifier'] = SteamHex}, function(result)
				if result[1]  then
					if result[1].coin then
						data = result[1].coin
						Coin = tonumber(data)
						TriggerClientEvent("Coin-System:PlayerCoin", _source, Coin)
						TriggerClientEvent("CoinUpdate", _source, Coin)
					end
				end
			end)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(5000)
		for k, v in pairs(ESX.GetPlayers()) do
			local xPlayer = ESX.GetPlayerFromId(v)
			if xPlayer then
				if xPlayer.identifier  then
					if not Config.CoinItem then
						MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', {['@identifier'] = xPlayer.identifier}, function(result)
							if result  and result[1]  then
								if result[1].coin then
									data = result[1].coin
									Coin = tonumber(data)
									TriggerClientEvent("Coin-System:PlayerCoin", xPlayer.source, Coin)
									TriggerClientEvent("CoinUpdate", xPlayer.source, Coin)
								end
							end
						end)
					end
				end
			end
		end
	end
end)
	
Server("Coin-System:ResetCoinTimer", function(src)	
	local PlayerId = source
    local xP = ESX.GetPlayerFromId(PlayerId)
	if not xP then
		local xP = ESX.GetPlayerFromId(src)
	end
	if xP then
		local SteamHex = xP.identifier
		Citizen.CreateThread(function()
			while true do
				if SteamHex and xP and src then
					MySQL.Async.fetchAll('SELECT timercoin FROM users WHERE identifier = @identifier', {['@identifier'] = SteamHex}, function(result)
						if result[1] then
							if result[1].timercoin then
								timercoin = result[1].timercoin
								if timercoin >= 100 then
									MySQL.Async.execute('UPDATE users SET timercoin = @timercoin WHERE identifier = @identifier', {['@timercoin'] = 0, ['@identifier'] = SteamHex })
									Wait(1000)
									TriggerClientEvent("Coin-System:AddCoin", xP.source, 1)
									Wait(15000)
								end
							end
						end
					end)
				end
				Wait(1000)
			end
		end)
	end
end)


-- Server Discord : https://discord.gg/3jzScCJZ5C