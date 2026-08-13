local PlayersWorking = {}
local vehicles = {}
local allowedJobs = {
	'fisherman',
	'tailor',
	'slaughterer',
	'lumberjack',
	'fueler',
	'miner'
}

-- Unique_Skills is optional; this pack no longer ships it, so guard every
-- call instead of letting it hard-crash the job scripts.
function SafeUpdateSkill(...)
	if GetResourceState('Unique_Skills') ~= 'started' then return end
	local ok = pcall(function(...) exports['Unique_Skills']:UpdateSkill(...) end, ...)
end

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



function WahMoney(Level, xPlayer)
	local eskenascount = 0
	
	if Level == 1 then 
		eskenascount = 4000
	elseif Level == 2 then 
		eskenascount = 5000
	elseif Level == 3 then 
		eskenascount = 6000
	end

	if xPlayer.getInventoryItem('eskenas').count >= 4000 then
		local taghsimeskenas = eskenascount / 100
		local zarbeskenas = taghsimeskenas * 60
		local mathflorpol = math.floor(zarbeskenas)
		xPlayer.removeInventoryItem('eskenas', eskenascount)
		xPlayer.addMoney(mathflorpol)
	end
end






local function Work(source, item)

	SetTimeout(item[1].time, function()

		if PlayersWorking[source] == true then

			local xPlayer = ESX.GetPlayerFromId(source)
			local Src = source
			if xPlayer == nil then
				return
			end

			for i=1, #item, 1 do
				local itemQtty = 0
				if item[i].name ~= _U('delivery') then
					itemQtty = xPlayer.getInventoryItem(item[i].db_name).count
				end

				local requiredItemQtty = 0
				if item[1].requires ~= "nothing" then
					requiredItemQtty = xPlayer.getInventoryItem(item[1].requires).count
				end

				if item[i].name ~= _U('delivery') and itemQtty >= item[i].max then
					TriggerClientEvent('esx:showNotification', source, _U('max_limit', item[i].name))
				elseif item[i].requires ~= "nothing" and requiredItemQtty <= 0 then
					TriggerClientEvent('esx:showNotification', source, _U('not_enough', item[1].requires_name))
				else
					if item[i].name ~= _U('delivery') then
						-- Chances to drwop the item
						if item[i].drop == 100 then
							xPlayer.addInventoryItem(item[i].db_name, item[i].add)
							if item[i].db_name == "wool" then
								WahMoney(1,xPlayer)
								TriggerClientEvent("Task_System:FarmPashm", Src, amount, itemName)
								SafeUpdateSkill(Src, "Lebas", 0.002)
					
							end
							if item[i].db_name == "fabric" then
								WahMoney(2,xPlayer)
								TriggerClientEvent("Task_System:SakhteParche", Src, amount, itemName)
								SafeUpdateSkill(Src, "Lebas", 0.004)
							end
							if item[i].db_name == "clothe" then
								WahMoney(3,xPlayer)
								TriggerClientEvent("Task_System:DokhteLebas", Src, amount, itemName)
								SafeUpdateSkill(Src, "Lebas", 0.006)
								
							end


							if item[i].db_name == "wood" then
								WahMoney(1,xPlayer)
								TriggerClientEvent("Task_System:FarmChoob", Src, 5, itemName)
								SafeUpdateSkill(Src, "ChoobBori", 0.002)
								
							end
							if item[i].db_name == "cutted_wood" then
								WahMoney(2,xPlayer)
								TriggerClientEvent("Task_System:BoresheChoob", Src, amount, itemName)
								SafeUpdateSkill(Src, "ChoobBori", 0.004)
								
							end
							if item[i].db_name == "packaged_plank" then
								WahMoney(3,xPlayer)
								TriggerClientEvent("Task_System:BastebandiChoob", Src, amount, itemName)
								SafeUpdateSkill(Src, "ChoobBori", 0.006)
								
							end


							if item[i].db_name == "alive_chicken" then
								WahMoney(1,xPlayer)
								TriggerClientEvent("Task_System:FarmMorgh", Src, amount, itemName)
								SafeUpdateSkill(Src, "Ghasab", 0.002)
								
							end
							if item[i].db_name == "slaughtered_chicken" then
								WahMoney(2,xPlayer)
								TriggerClientEvent("Task_System:ZebehMorgh", Src, amount, itemName)
								SafeUpdateSkill(Src, "Ghasab", 0.004)
							end
							if item[i].db_name == "packaged_chicken" then
								WahMoney(3,xPlayer)
								TriggerClientEvent("Task_System:BastebandiMorgh", Src, amount, itemName)
								SafeUpdateSkill(Src, "Ghasab", 0.006)
								
							end

							if item[i].db_name == "petrol" then
								WahMoney(1,xPlayer)
								TriggerClientEvent("Task_System:FarmBenzin", Src, amount, itemName)
								SafeUpdateSkill(Src, "SherkatNaft", 0.002)
								
							end
							if item[i].db_name == "petrol_raffin" then
								WahMoney(2,xPlayer)
								TriggerClientEvent("Task_System:FarmRafin", Src, amount, itemName)
								SafeUpdateSkill(Src, "SherkatNaft", 0.004)
								
							end
							if item[i].db_name == "essence" then
								WahMoney(3,xPlayer)
								TriggerClientEvent("Task_System:FarmAsans", Src, amount, itemName)	
								SafeUpdateSkill(Src, "SherkatNaft", 0.006)
							end
						else
							-- local chanceToDrop = math.random(100)
							if item[i].drop then
								xPlayer.addInventoryItem(item[i].db_name, item[i].add)
								if item[i].db_name == "wool" then
									WahMoney(1,xPlayer)
						            TriggerClientEvent("Task_System:FarmPashm", Src, amount, itemName)
									SafeUpdateSkill(Src, "Lebas", 0.002)
								end
								if item[i].db_name == "fabric" then
									WahMoney(2,xPlayer)
									TriggerClientEvent("Task_System:SakhteParche", Src, amount, itemName)
									SafeUpdateSkill(Src, "Lebas", 0.004)
								end
								if item[i].db_name == "clothe" then
									WahMoney(3,xPlayer)
									TriggerClientEvent("Task_System:DokhteLebas", Src, amount, itemName)
									SafeUpdateSkill(Src, "Lebas", 0.006)
								end	
	
								if item[i].db_name == "wood" then
									WahMoney(1,xPlayer)
									TriggerClientEvent("Task_System:FarmChoob", Src, 5, itemName)
									SafeUpdateSkill(Src, "ChoobBori", 0.002)
									
								end
								if item[i].db_name == "cutted_wood" then
									WahMoney(2,xPlayer)
									TriggerClientEvent("Task_System:BoresheChoob", Src, amount, itemName)
									SafeUpdateSkill(Src, "ChoobBori", 0.004)
									
								end
								if item[i].db_name == "packaged_plank" then
									WahMoney(3,xPlayer)
									TriggerClientEvent("Task_System:BastebandiChoob", Src, amount, itemName)
									SafeUpdateSkill(Src, "ChoobBori", 0.006)
								end
	
	
								if item[i].db_name == "alive_chicken" then
									WahMoney(1,xPlayer)
									TriggerClientEvent("Task_System:FarmMorgh", Src, amount, itemName)
									SafeUpdateSkill(Src, "Ghasab", 0.002)
								end
								if item[i].db_name == "slaughtered_chicken" then
									WahMoney(2,xPlayer)
									TriggerClientEvent("Task_System:ZebehMorgh", Src, amount, itemName)
									SafeUpdateSkill(Src, "Ghasab", 0.004)
								end
								if item[i].db_name == "packaged_chicken" then
									WahMoney(3,xPlayer)
									TriggerClientEvent("Task_System:BastebandiMorgh", Src, amount, itemName)
									SafeUpdateSkill(Src, "Ghasab", 0.006)
								end
	
								if item[i].db_name == "petrol" then
									WahMoney(1,xPlayer)
									TriggerClientEvent("Task_System:FarmBenzin", Src, amount, itemName)
									SafeUpdateSkill(Src, "SherkatNaft", 0.002)
									
								end
								if item[i].db_name == "petrol_raffin" then
									WahMoney(2,xPlayer)
									TriggerClientEvent("Task_System:FarmRafin", Src, amount, itemName)
									SafeUpdateSkill(Src, "SherkatNaft", 0.004)
									
								end
								if item[i].db_name == "essence" then
									WahMoney(3,xPlayer)
									TriggerClientEvent("Task_System:FarmAsans", Src, amount, itemName)	
									SafeUpdateSkill(Src, "SherkatNaft", 0.006)
									
								end
								
							end
						end
					else
						-- xPlayer.addMoney(item[i].price)
					end
				end
			end

			if item[1].requires ~= "nothing" then
				local itemToRemoveQtty = xPlayer.getInventoryItem(item[1].requires).count
				if itemToRemoveQtty > 0 then
					xPlayer.removeInventoryItem(item[1].requires, item[1].remove)
				end
			end

			Work(source, item)

		end
	end)
end



-- // fake event
RegisterServerEvent('esx_jobs:startWork')
AddEventHandler('esx_jobs:startWork', function(item)
	-- exports.BanSql:BanTarget(source, "Triggered blacklisted event: esx_jobs:startWork", "Cheat Lua executor")
end)

RegisterServerEvent('esx_jobs:starServerTestprpWork')
AddEventHandler('esx_jobs:starServerTestprpWork', function(item)
	local xPlayer = ESX.GetPlayerFromId(source)
	--if IsAllowed(xPlayer.job.name) then

		if PlayersWorking[source] == false then
			PlayersWorking[source] = true
			Work(source, item)
		else
			-- print(('esx_jobs: %s attempted to exploit the marker!'):format(GetPlayerIdentifiers(source)[1]))
		end

	--else
	--	exports.BanSql:BanTarget(source, "Tried to bypass check job for Jobs start working", "Cheat Lua executor")
	--end
end)

-- // fake event
RegisterServerEvent('esx_jobs:stopWork')
AddEventHandler('esx_jobs:stopWork', function()
	-- exports.BanSql:BanTarget(source, "Triggered blacklisted event: esx_jobs:stopWork", "Cheat Lua executor")
end)

RegisterServerEvent('esx_jobs:stoServerTestprpWork')
AddEventHandler('esx_jobs:stoServerTestprpWork', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	--if IsAllowed(xPlayer.job.name) then
		PlayersWorking[source] = false
	--else
	--	exports.BanSql:BanTarget(source, "Tried to bypass check job for Jobs stop working", "Cheat Lua executor")
	--end
end)

RegisterServerEvent('esx_jobs:addVehicle')
AddEventHandler('esx_jobs:addVehicle', function(netID)
	local identifier = GetPlayerIdentifier(source)

	if netID ~= nil then

		local vehicle = NetworkGetEntityFromNetworkId(netID)
		if DoesEntityExist(vehicle) then

			local model = GetEntityModel(vehicle)

			if model == GetHashKey("benson") then
				if not vehicles[identifier] then
					vehicles[identifier] = 0
				end
		
				vehicles[identifier] = netID
				TriggerClientEvent('esx_carlock:workVehicle', source, vehicles[identifier])

			end

		end
		
	else

		if not vehicles[identifier] then
			vehicles[identifier] = 0
		end
	
		vehicles[identifier] = 0
		TriggerClientEvent('esx_carlock:workVehicle', source, nil)

	end

end)

AddEventHandler('esx:playerLoaded', function(source)

	local identifier = GetPlayerIdentifier(source)
	if vehicles[identifier] ~= nil and vehicles[identifier] ~= 0 then
		TriggerClientEvent('esx_carlock:workVehicle', source, vehicles[identifier])
	end

end)

RegisterServerEvent('esx_jobs:cascaryution')
AddEventHandler('esx_jobs:cascaryution', function(cautionType, cautionAmount, spawnPoint, vehicle)
	local xPlayer = ESX.GetPlayerFromId(source)

	if cautionType == "take" then
		TriggerEvent('esx_addonaccount:getAccount', 'caution', xPlayer.identifier, function(account)
			-- xPlayer.removeBank(50000)
			-- account.addMoney(50000)
		end)

		-- TriggerClientEvent('esx:showNotification', source, _U('bank_deposit_taken', ESX.Math.GroupDigits(50000)))
		TriggerClientEvent('esx_jobs:spawnJobVehicle', source, spawnPoint, vehicle)
	elseif cautionType == "give_back" then

		--if 50000 > 1 then
		--	print(('esx_jobs: %s is using cheat engine!'):format(xPlayer.identifier))
		--	return
		--end

		TriggerEvent('esx_addonaccount:getAccount', 'caution', xPlayer.identifier, function(account)
			--local caution = account.money
			--local toGive = ESX.Math.Round(caution * cautionAmount)

			-- xPlayer.addBank(50000)
			-- account.removeMoney(50000)
			-- TriggerClientEvent('esx:showNotification', source, _U('bank_deposit_returned', ESX.Math.GroupDigits(50000)))
		end)
	end
end)


function IsAllowed(job)
	for i,v in ipairs(allowedJobs) do
		if v == job then
			return true
		end
	end

	return false
end