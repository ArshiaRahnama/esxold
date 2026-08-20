ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local drag = false
local AS, ASWarn = {}, {}

local units = {}
local callsigns = {}

if Config_police.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'police', Config_police.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'police', _U('alert_police'), true, true)

TriggerEvent('esx_society:registerSociety', 'police', 'Police', 'society_law', 'society_police', 'society_police', {type = 'public'})

RegisterServerEvent('esx_policejob:giveWeapon')
AddEventHandler('esx_policejob:giveWeapon', function(weapon, ammo)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('esx_policejob:requestrelease')
AddEventHandler('esx_policejob:requestrelease', function(targetid, playerheading, playerCoords, playerlocation)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local cPlayer = ESX.GetPlayerFromId(targetid)
	if not GetPlayerName(targetid) or not cPlayer then
		return
	end
	if xPlayer.job.name == "police" or xPlayer.job.name == "sheriff" or xPlayer.job.name == "fbi" or xPlayer.gang.name ~= "nogang" or xPlayer.job.name == "mt" or xPlayer.job.name == "forces" or xPlayer.job.name == "cid" or xPlayer.job.name == "cia" or xPlayer.job.name == "marshal" or xPlayer.job.name == "judge" or xPlayer.job.name == "doa" then
		if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(tonumber(targetid)))) < 15.0 then
			if cPlayer.get("Cuff") then

				TriggerClientEvent("esx_policejob:getuncuffed", targetid, playerheading, playerCoords, playerlocation)
				TriggerClientEvent("esx_policejob:douncuffing", source)

			else
				TriggerClientEvent('esx:showNotification', source, '~y~In Player Dastband Nakhorde Ast')
			end
		else
			exports.Mid_BanSystem:BanThis(source, "Tried To Cuff Players With Cheat", 500)
		end
	else
		TriggerClientEvent('esx:showNotification', source, '~y~Shoma Nemitavanid Dast Band Organ Nezami Ra Baz Konid')
		exports.Mid_BanSystem:BanThis(source, "Tried To Cuff Players With Cheat", 500)
	end
end)

RegisterServerEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(target)
	local cPlayer = ESX.GetPlayerFromId(target)
	if GetPlayerName(target) or cPlayer then
		if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(tonumber(target)))) < 20.0 then
			if cPlayer.get("Cuff") then


				TriggerClientEvent('esx_policejob:drag', target, source)
				TriggerClientEvent('esx_policejob:draging', source)
			else
				TriggerClientEvent('esx:showNotification', source, '~y~Fard Mored Nazar Baraye Drag Kardan Dastband Nakhorde Ast.')
			end
		else
		end
	end
end)

RegisterServerEvent('policejob:putInVehiclecarry')
AddEventHandler('policejob:putInVehiclecarry', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= nil or xPlayer.gan.name ~= 'nogang' then
		TriggerClientEvent('esx_ambulancejob:putInVehicle', target)
	else
		print(('esx_ambulancejob: %s attempted to put in vehicle!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function(target)
	local cPlayer = ESX.GetPlayerFromId(target)

	local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    local vehicles = GetGamePool('CVehicle')
    local closestVehicle = nil
    local closestDistance = nil

	if GetPlayerName(target) or cPlayer then
		if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(tonumber(target)))) < 15.0 then

			if cPlayer.get("Cuff") then

				for _, vehicle in ipairs(vehicles) do
					local vehicleCoords = GetEntityCoords(vehicle)
					local distance = #(playerCoords - vehicleCoords)

					if closestDistance == nil or distance < closestDistance then
						closestDistance = distance
						if distance < 4 then

							TriggerClientEvent('esx_policejob:putInVehicle', target)
							TriggerClientEvent("esx_policejob:draging", source)
							return
						else
							TriggerClientEvent('esx:showNotification', source, '~y~Mashini Nazdik Shoma Nist.')
						end
					end
				end

			else
				TriggerClientEvent('esx:showNotification', source, '~y~Fard Mored Nazar Baraye Vared Kardan Dar Mashin Dastband Nakhorde Ast.')
			end
		else
		end
	end
end)

RegisterServerEvent('policejob:OutVehiclecarry')
AddEventHandler('policejob:OutVehiclecarry', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'nojob' or xPlayer.gang.name ~= 'nogang' then
		TriggerClientEvent('policejob:OutVehiclecarry', target)
	else
		print(('esx_ambulancejob: %s attempted to put in vehicle!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function(target)
	local cPlayer = ESX.GetPlayerFromId(target)
	if GetPlayerName(target) or not cPlayer then
		if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(tonumber(target)))) < 15.0 then
			if cPlayer.get("Cuff") or cPlayer.get("IsDead") then

				TriggerClientEvent('esx_policejob:OutVehicle', target)
			else
				TriggerClientEvent('esx:showNotification', source, '~y~Fard Mored Nazar Baraye Kharej Kardan Az Mashin Dastband Nakhorde Ast.')
			end
		else

		end
	end
end)

RegisterServerEvent('esx_policejob:getStockItem')
AddEventHandler('esx_policejob:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)

		local inventoryItem = inventory.getItem(itemName)


		if count > 0 and inventoryItem.count >= count then


			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))
				TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Withdrawn x' ..count ..' '..inventoryItem.label ,'user', source, true, false)
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end
	end)

end)

RegisterServerEvent('esx_policejob:putStockItems')
AddEventHandler('esx_policejob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)

		local inventoryItem = inventory.getItem(itemName)


		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', count, inventoryItem.label))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end

	end)

end)

RegisterCommand('findnumber_police', function(source, args, users)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == "police" or xPlayer.job.name == "sheriff" or xPlayer.job.name == "fbi" or xPlayer.job.name == "mt" or xPlayer.job.name == "cid" or xPlayer.job.name == "cia" or xPlayer.job.name == "marshal" or xPlayer.job.name == "judge" or xPlayer.job.name == "doa" then
        if args[1] then
            if string.len(args[1]) == 10 then
            local number = tonumber(args[1])
                if number then
                    MySQL.Async.fetchAll('SELECT playerName FROM users WHERE phone=@number',
                    {
                        ['@number'] =  number
                    }, function(data)
                        if data[1] then
							TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', " ^0 In Shomare be naame ^3" .. string.gsub(data[1].playerName, "_", " ") .. " ^0Ast!"} })
                        else
							TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', "^0 In shomare vojoud nadarad"} })
                        end
                    end)
                else
					TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', " ^0Shoma dar ghesmat Shomare vaghat mitavanid adad vared konid!"} })
                end
            else
				TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', " ^0Shomare bayad 11 raghami bashad!"} })
            end
        else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', " ^0Shoma dar ghesmat Shomare chizi vared nakardid!"} })
        end
    else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', " ^0Shoma police nistid!"} })
    end
end)

ESX.RegisterServerCallback('esx_policejob:getVehicleInfos', function(source, cb, plate)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE @plate = plate', {
		['@plate'] = plate
	}, function(result)

		local retrivedInfo = {
			plate = plate
		}

		if result[1] then

			MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config_police.EnableESXIdentity then
					retrivedInfo.owner = result2[1].playerName
				else
					retrivedInfo.owner = result2[1].name
				end

				cb(retrivedInfo)
			end)
		else
			cb(retrivedInfo)
		end
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getVehicleFromPlate', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] ~= nil then

			MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config_police.EnableESXIdentity then
					cb(string.gsub(result2[1].playerName, "_", " "), true)
				else
					cb(string.gsub(result2[1].playerName, "_", " "), true)
				end

			end)
		else
			cb(_U('unknown'), false)
		end
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getArmoryWeapons', function(source, cb)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)

	end)

end)

ESX.RegisterServerCallback('esx_policejob:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)

	local xPlayer = ESX.GetPlayerFromId(source)
	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
		TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Deposited ' .. weaponName ,'user', source, true, false)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = weapons[i].count + 1
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = 1
			})
		end

		store.set('weapons', weapons)
		cb()
	end)

end)

ESX.RegisterServerCallback('esx_policejob:buyArmoryWeapon', function(source, cb, weaponName, removeWeapon, tedad)

	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
		TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Deposited ' .. weaponName ,'user', source, true, false)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = weapons[i].count + tedad
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = tonumber(tedad)
			})
		end

		store.set('weapons', weapons)
		cb()
	end)

end)

ESX.RegisterServerCallback('esx_policejob:removeArmoryWeapon', function(source, cb, weaponName)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.addWeapon(weaponName, 500)
	TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Withdrawn ' .. weaponName ,'user', source, true, false)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then

				weapons[i].count = weapons[i].count - 1


				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = 1
			})
		end

		store.set('weapons', weapons)
		cb()
	end)

end)

ESX.RegisterServerCallback('esx_policejob:buy', function(source, cb, amount)


	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_law', function(account)
		if account.money >= amount then
			account.removeMoney(amount)
			cb(true)
		else
			TriggerClientEvent('chat:addMessage', source, {color = { 255, 0, 0}, multiline = false, args = {"^1[^1^*SYSTEM^1]: ^0".."Money Boss Action Baraye Kharid In Tedad Weapon Kafi Nist!" }})
			cb(false)
		end
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_policejob:buyArmoryItem', function(source, cb, weaponName, removeWeapon, tedad)

	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
		TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Deposited ' .. weaponName ,'user', source, true, false)
	end

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)

		local weapons = inventory.items

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = weapons[i].count + tedad
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = tonumber(tedad)
			})
		end

		inventory.addItem(weaponName, tonumber(tedad))
		cb()
	end)

end)

ESX.RegisterServerCallback('esx_policejob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'police')
	end
end)

RegisterServerEvent('esx_policejob:message')
AddEventHandler('esx_policejob:message', function(target, msg)

	TriggerClientEvent('esx:showNotification', target, msg)
end)

local panic = 0
local panicreqx = {}
local panicreqy = {}
local panicreqID = {}
local panicreqname = {}
local sentreq = {}

RegisterServerEvent('esx_policejob:saundplay')
AddEventHandler('esx_policejob:saundplay', function(soundFile, soundVolume, x, y, plate, IsDistress)
    local source = source
    local namesh = GetPlayerName(source)
    local unit = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()

    if not sentreq[source] then
        panic = panic + 1
        sentreq[source] = true
        panicreqx[panic] = x
        panicreqy[panic] = y
        panicreqID[panic] = source
        panicreqname[panic] = unit and unit.get('inunit') or 'Unknown'

        TriggerClientEvent('InteractSound_SV:PlayOnOne', source, soundFile, soundVolume)

        if IsDistress then
            local text = '*'..namesh..' Dastesho Mibare Samte Radio Va Dokme Panic Ro Feshar Mide.*'
			local xxPlayer = ESX.GetPlayerFromId(source)
            TriggerEvent('InteractSound_SV:PlayWithinDistancePolice', xxPlayer, 5.0, 'panic', 0.3)


            TriggerClientEvent('chatMessage', source, "[DISPATCH ("..string.upper(xxPlayer.job.name)..") ]", {50, 150, 200},
                "^7Shoma Dar Halat ^1Panic ^7Qarar Gereftid -> ^8/resp "..panic)
            TriggerClientEvent('esx_policejob:sendbackuptext', source, text)


            for i=1, #xPlayers do
                local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                if xPlayer and xPlayer.source ~= source and (xPlayer.job.name == "police" or xPlayer.job.name == "sheriff" or xPlayer.job.name == "fbi"  or xPlayer.job.name == "mt") then

					TriggerEvent('InteractSound_SV:PlayWithinDistancePolice', xPlayer, 5.0, 'panic', 0.3)
                    TriggerClientEvent('chatMessage', xPlayer.source, "[DISPATCH ("..string.upper(xxPlayer.job.name)..") ]", {50, 150, 200},
                        "^7Afsar ^2"..namesh.."^7 Az Vahede  ^7Morede ^1Hamle ^7Gharar Gerefte Ast -> ^8/resp "..panic)
                end
            end
        else
            local text = '*'..namesh..' Dastesho Mibare Samte Radio Va Darkhast 10-70 Mikone.*'
			local xxPlayer = ESX.GetPlayerFromId(source)
            TriggerEvent('InteractSound_SV:PlayWithinDistancePolice', xxPlayer, 5.0, 'demo', 1.0)


            TriggerClientEvent('chatMessage', source, "[DISPATCH ("..string.upper(xxPlayer.job.name)..") ]", {50, 150, 200},
                "^7Shoma Darkhast ^1Backup ^7Dadid -> ^8/resp "..panic)
            TriggerClientEvent('esx_policejob:sendbackuptext', source, text)


            for i=1, #xPlayers do
                local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                if xPlayer then
					if xPlayer and xPlayer.source ~= source and (xPlayer.job.name == "police" or xPlayer.job.name == "sheriff" or xPlayer.job.name == "fbi" or xPlayer.job.name == "mt") then
						TriggerEvent('InteractSound_SV:PlayWithinDistancePolice', xPlayer, 5.0, 'demo', 1.0)
                        TriggerClientEvent('chatMessage', xPlayer.source, "[DISPATCH ("..string.upper(xxPlayer.job.name)..") ]", {50, 150, 200},
                        "^7Afsar ^2"..namesh.."^7 Az Vahede  ^7Darkhast ^1Backup ^7Darad -> ^8/resp "..panic)
                    end
                end
            end
        end
    else
        TriggerClientEvent('esx:showNotification', source, '~r~Darkhast Backup/Panic Shoma Rooye Cooldown Ast.')
    end

    if sentreq[source] then
        SetTimeout(60000, function()
            sentreq[source] = false
        end)
    end
end)

RegisterCommand('resp_police', function(source, args, rawCommand)
    local panicId = tonumber(args[1])
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer and xPlayer.job.name == "police" or xPlayer.job.name == "sheriff" or xPlayer.job.name == "fbi" or xPlayer.job.name == "mt" then
        if panicId and panicreqx[panicId] and panicreqy[panicId] then

            TriggerClientEvent('esx_policejob:markPanicLocation', source, panicreqx[panicId], panicreqy[panicId], panicreqID[panicId])

			TriggerClientEvent('chatMessage', xPlayer.source, "[DISPATCH]"..xPlayer.job.name, {31, 0, 173},
			"Panic Mark Shod Jahat Cancel Kardan ^2/cresp")

            local xPlayers = ESX.GetPlayers()
            for i = 1, #xPlayers do
                local targetPlayer = ESX.GetPlayerFromId(xPlayers[i])
                if targetPlayer and targetPlayer.job.name == "police" then
                    TriggerClientEvent('chatMessage', targetPlayer.source, "[DISPATCH]"..xPlayer.job.name, {31, 0, 173},
                        "^2" .. xPlayer.name .. " ^7Darkhast Panic ^8ID: " .. panicId .. " ^2Ra Accept Kard!")
                end
            end
        else
            TriggerClientEvent('esx:showNotification', source, '~r~ID Morede Nazar Yaft Nashod!')
        end
    else
        TriggerClientEvent('esx:showNotification', source, '~r~Shoma Police Nistid!')
    end
end, false)

RegisterServerEvent('esx_policejob:playSoundRadio')
AddEventHandler('esx_policejob:playSoundRadio', function(soundFile, soundVolume)
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do

		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		if xPlayer.job.name == "police" and xPlayer.job.grade >= 0 then

			if xPlayer.source ~= source then
				TriggerEvent('InteractSound_SV:PlayOnOne', xPlayer.source, soundFile, soundVolume)
			end

		end

	end
end)

ESX.RegisterServerCallback('esx_policejob:getitem', function(source, cb, item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

ESX.RegisterServerCallback('esx_policejob:getIcName', function(source, cb)
	local _source = source
	characterName = string.gsub(exports.essentialmode:IcName(_source), "_", " ")
	cb(characterName)
end)

RegisterServerEvent("Police:ShotsAlarm")
AddEventHandler("Police:ShotsAlarm", function(x,y,z,s)
	local xPlayers = ESX.GetPlayers()
	 if GetPlayerRoutingBucket( source )  == 0  then
		TriggerClientEvent("Police:ShotsAlarm", -1  , x,y,z,s)
	 end


end)

RegisterCommand('createunit_police', function(source, args)
	if not args[1] then
		TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Syntax Vared Shode Eshtebah Ast")
		return
	end

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "police" or xPlayer.job.name == "sheriff" or xPlayer.job.name == "mt" or xPlayer.job.name == "fbi" then
		local identifier = xPlayer.identifier

		if units[identifier] == nil and not IsPlayerInAnyUnit_police(identifier) then

			local uidentifier = string.upper(args[1])

			if callsigns[uidentifier] == nil then
				units[identifier] = {callsign = uidentifier, members = {}, job = xPlayer.job.name}
				callsigns[uidentifier] = {owner = identifier, name = xPlayer.name, job = xPlayer.job.name}
				TriggerClientEvent('esx:setcallsign', source, uidentifier)
				TriggerClientEvent('esx_policejob:notifyp', -1, " Vahed ^2" .. uidentifier .. "^0 Tavasot ^3" .. string.gsub(xPlayer.name, "_", " ") .. "^0 sakhte shod!", xPlayer.job.name)
			else
				TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Callsign ^2" .. uidentifier .. "^0 ghablan Tavasot ^3" .. callsigns[uidentifier].name .. "^0 sakhte shode ast!")
			end

		else
			if not IsPlayerInAnyUnit_police(identifier) then
				TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Shoma ghablan unit sakhte id")
			else
				TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Shoma dar hale hazer unit darid")
			end
		end

	else
		TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Shoma Dastresi Kafi Baraye Estefade AzIn Dastor Ra Nadarid")
	end

end, false)

RegisterCommand('delunit_police', function(source, args)
	if not args[1] then
		TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Syntax Vared Shode Eshtebah Ast")
		return
	end

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "police" or xPlayer.job.name == "sheriff" or xPlayer.job.name == "mt" or xPlayer.job.name == "fbi" then
		local identifier = xPlayer.identifier
		local job = xPlayer.job.name
		local Name = string.gsub(xPlayer.name, "_", " ")

		local uidentifier = string.upper(args[1])

		if callsigns[uidentifier] ~= nil then

			if callsigns[uidentifier].job == xPlayer.job.name then
				if xPlayer.job.grade >= 18 then
					local identifier = callsigns[uidentifier].owner
					xPlayer = ESX.GetPlayerFromIdentifier(identifier)
					if xPlayer then
						TriggerClientEvent('esx:setcallsign', xPlayer.source, nil)
					end

					if TableLength_police(units[identifier].members) > 0 then
						for k,v in pairs(units[identifier].members) do
							xPlayer = ESX.GetPlayerFromIdentifier(k)
							if xPlayer then
								TriggerClientEvent('esx:setcallsign', xPlayer.source, nil)
							end
						end
					end
					TriggerClientEvent('esx_policejob:notifyp', -1, " Vahed ^2" .. uidentifier .. "^0 Tavsot ^3" .. Name .. "^0 Monhal Shod!", job)
				else
					TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Shoma Dastresi Kafi Baraye In Dastor Ra Nadarid")
				end

			else
				TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Shoma Faghat Vahed Haye Department Khod Ra Mitavanid Pak Konid")
			end

		else
			TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Callsign Vared Shode Vojod Nadarad")
		end

	else
		TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Shoma Dastresi Kafi Baraye In Dastor Ra Nadarid")
	end

end, false)

RegisterCommand('renameunit_police', function(source, args)

	if not args[1] then
		TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Syntax Vared Shode Eshtebah Ast")
		return
	end

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "police" or xPlayer.job.name == "sheriff" or xPlayer.job.name == "mt" or xPlayer.job.name == "fbi" then

		local identifier = xPlayer.identifier
		local job = xPlayer.job.name

		if units[identifier] ~= nil then

			local csign = units[identifier].callsign
			local uidentifier = string.upper(args[1])

			if csign == uidentifier then
				TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Shoma nemitavanid callsign ghabli khod ra entekhab konid!")
				return
			end

			units[identifier].callsign = uidentifier
			callsigns[csign] = nil
			callsigns[uidentifier] = {owner = identifier, job = xPlayer.job.name, name = string.gsub(xPlayer.name, "_", " ")}
			TriggerClientEvent('esx:setcallsign', source, uidentifier)
			if TableLength_police(units[identifier].members) > 0 then
				for k,v in pairs(units[identifier].members) do
					xPlayer = ESX.GetPlayerFromIdentifier(k)
					if xPlayer then
						TriggerClientEvent('esx:setcallsign', xPlayer.source, uidentifier)
					end
				end
			end
			TriggerClientEvent('esx_policejob:notifyp', -1, " Vahed ^2" .. csign .. "^0 be ^3" .. uidentifier .. "^0 taghir yaft!", job)

		else
			if not IsPlayerInAnyUnit_police(identifier) then
				TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Shoma hich uniti nadarid")
			else
				TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Shoma saheb in unit nistid")
			end
		end

	else
		TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Shoma Dastresi Kafi Baraye Estefade AzIn Dastor Ra Nadarid")
	end

end, false)

RegisterCommand('disbanunit_police', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "police" or xPlayer.job.name == "sheriff" or xPlayer.job.name == "mt" or xPlayer.job.name == "fbi" then
		local identifier = xPlayer.identifier

		if units[identifier] ~= nil then

			local csign = units[identifier].callsign
			TriggerClientEvent('esx:setcallsign', source, nil, xPlayer.job.name)
			callsigns[csign] = nil
			units[identifier] = nil
			TriggerClientEvent('esx_policejob:notifyp', -1, " Vahed ^2" .. csign .. "^0 monhal shod!", xPlayer.job.name)

		else
			if not IsPlayerInAnyUnit_police(identifier) then
				TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Shoma hich uniti nadarid")
			else
				TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Shoma saheb in unit nistid")
			end
		end

	else
		TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Shoma Dastresi Kafi Baraye Estefade AzIn Dastor Ra Nadarid")
	end

end, false)

RegisterCommand('units_police', function(source, args)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "police" or xPlayer.job.name == "sheriff" or xPlayer.job.name == "mt" or xPlayer.job.name == "fbi" then
		local identifier = xPlayer.identifier
		local job = xPlayer.job.name
		if TableLength_police(callsigns) > 0 then
			if args[1] == "all" then
				if xPlayer.job.name == "fbi" then
					for k,v in pairs(callsigns) do
						TriggerClientEvent('chatMessage', source, "[ Info ] : ", {226, 239, 93}, "UNIT ^3'" .. k .. "'^0,   Leader: ^2" .. v.name .. "^0, Members: ^1" .. TableLength_police(units[v.owner].members))
					end
				else
					TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Shoma dastresi kafi baraye in dastor ra nadarid!")
				end
			else
				for k,v in pairs(callsigns) do
					if v.job == job then
						TriggerClientEvent('chatMessage', source, "[ Info ] : ", {226, 239, 93}, "UNIT ^3'" .. k .. "'^0,   Leader: ^2" .. v.name .. "^0, Members: ^1" .. TableLength_police(units[v.owner].members))
					end
				end
			end

		else
			TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Hich Vahedi baraye namayesh vojod nadarad!")
		end

	else
		TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Shoma dastresi kafi baraye estefade Azin dastoor ra nadarid")
	end

end, false)

RegisterCommand('joinunit_police', function(source, args)
	if not args[1] then
		TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Syntax Vared Shode Eshtebah Ast")
		return
	end

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "police" or xPlayer.job.name == "sheriff" or xPlayer.job.name == "mt" or xPlayer.job.name == "fbi" then

		local identifier = xPlayer.identifier

		if units[identifier] == nil and not IsPlayerInAnyUnit_police(identifier) then

			local uidentifier = string.upper(args[1])
			if callsigns[uidentifier] ~= nil then
				units[callsigns[uidentifier].owner].members[identifier] = xPlayer.name
				print(json.encode(units))
				TriggerClientEvent('esx:setcallsign', source, uidentifier)
				TriggerClientEvent('esx_policejob:notifyp', -1, "^3" ..string.gsub(xPlayer.name, "_", " ") .. "^0 Be Vahed ^2" .. uidentifier .. "^0 molhagh shod!", xPlayer.job.name)
			else
				TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "In callsign vojoud nadarad!")
			end

		else
			TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Shoma dar hale hazer unit darid!")
		end

	else
		TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Shoma police nistid")
	end
end, false)

RegisterCommand('leaveunit_police', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "police" or xPlayer.job.name == "sheriff" or xPlayer.job.name == "mt" or xPlayer.job.name == "fbi" then

		local identifier = xPlayer.identifier

		if units[identifier] == nil and IsPlayerInAnyUnit_police(identifier) then

			for k,v in pairs(units) do
				if v.members[identifier] then
					TriggerClientEvent('esx_policejob:notifyp', -1, "^3" ..string.gsub(xPlayer.name, "_", " ") .. "^0 AzVahed ^2" .. v.callsign .. "^0 kharej shod!", xPlayer.job.name)
					v.members[identifier] = nil
					break
				end
			end

		else
			if units[identifier] == nil then
				TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Shoma dakhel hich uniti nistid!")
			else
				TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Shoma nemitavanid AzVahed khod kharej shavid!")
			end
		end

	else
		TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Shoma Dastresi Kafi Baraye Estefade AzIn Dastor Ra Nadarid")
	end
end, false)

local RobberyCode = 0
local Robbs = {}

local function IsPoliceForUnit(jobname)
	return jobname == "police" or jobname == "sheriff" or jobname == "mt" or jobname == "fbi"
end

RegisterNetEvent('Unit:RobAlarm_police')
AddEventHandler('Unit:RobAlarm_police', function(Name)
	RobberyCode = RobberyCode + 1
	Robbs[RobberyCode] = {
		Name = Name,
		Key = RobberyCode,
		Accept = false,
		Player = 0,
		pJob = '',
	}
	TriggerClientEvent('esx_policejob:notifyp', -1, "Alarm robbery dar ^2" .. Name .. "^0 jahat Accept ^3/acceptrob " .. RobberyCode, "police")
	SetTimeout(10 * 60000, function()
		Robbs[RobberyCode] = nil
	end)
end)

RegisterCommand('acceptrob_police', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)

	if IsPoliceForUnit(xPlayer.job.name) then
		local code = tonumber(args[1])

		if code and type(Robbs[code]) == 'table' then
			if Robbs[code].Accept == false then
				Robbs[code].Accept = true
				Robbs[code].Player = source
				Robbs[code].pJob = xPlayer.job.name
				TriggerClientEvent('esx_policejob:notifyp', -1, "Robbery ^2" .. Robbs[code].Name .. "^0 tavasote ^3" .. string.gsub(xPlayer.name, "_", " ") .. "^0 (" .. string.upper(xPlayer.job.name) .. ") accept shod", "police")
			else
				TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "In Rob Ghablan Accept Shode Ast")
			end
		else
			TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Rob Baraye Accept Ba In Code Vojod Nadarad")
		end
	else
		TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Shoma Dastresi Kafi Baraye Estefade AzIn Dastor Ra Nadarid")
	end
end, false)

function CheckRob_police(RobberyCode)
	return type(Robbs[RobberyCode]) == 'table' and Robbs[RobberyCode].Accept or false
end
exports('CheckRob_police', CheckRob_police)

function TableLength_police(table)

	local count = 0
	for _ in pairs(table) do
		count = count + 1
	end
	return count

end

function IsPlayerInAnyUnit_police(identifier)
	for k,v in pairs(units) do
		if v.members[identifier] then
			return true
		end
	end
	return false
end









RegisterServerEvent('esx_policejob:SetCuffStatus')
AddEventHandler('esx_policejob:SetCuffStatus', function(status)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.set('Cuff', status)
end)

ESX.RegisterServerCallback('esx_policejob:IsHandCuffed', function(source, cb, target)
	local xTarget = ESX.GetPlayerFromId(target)
	if xTarget then
		cb(xTarget.get('Cuff'))

	end
end)

ESX.RegisterServerCallback("PD_CuffStatus:GetPedHandsUpStatus", function(source, cb, ID)
	local Dead = true
	local Injure = true
	local IsCuffed = true
	local xPlayer = ESX.GetPlayerFromId(tonumber(ID))
	if xPlayer.get("Injure") == nil then Injure = false end
	if xPlayer.get("Injure") == false then Injure = false end
	if xPlayer.get("Injure") ~= false then Injure = true end
	if xPlayer.get("IsDead") == nil then Dead = false end
	if xPlayer.get("IsDead") == false then Dead = false end
	if xPlayer.get("IsDead") ~= false then Dead = true end
	if xPlayer.get("Cuff") == nil then IsCuffed = false end
	if xPlayer.get("Cuff") == false then IsCuffed = false end
	cb(IsCuffed, Injure, Dead)
end)

RegisterServerEvent('esx:requestarrestpd')
AddEventHandler('esx:requestarrestpd', function(targetid, playerheading, playerCoords, playerlocation, front)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local cPlayer = ESX.GetPlayerFromId(targetid)
	if not GetPlayerName(targetid) or not cPlayer then
		return
	end
	if xPlayer.job.name == "police" or xPlayer.job.name == "sheriff" or xPlayer.job.name == "fbi" or xPlayer.job.name == "mt" or xPlayer.gang.name ~= "nogang" then
		if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(tonumber(targetid)))) < 15.0 then
			if not cPlayer.get("Cuff") then
				TriggerClientEvent("esx_policejob:getarrested", targetid, playerheading, playerCoords, playerlocation, true, front)
				TriggerClientEvent("esx_policejob:doarrested", source, front)
			else
				TriggerClientEvent('esx:showNotification', source, '~y~In Player Az Ghabl Dastband Khorde Ast.')
			end
		else

		end
	else

	end
end)

RegisterServerEvent('logpdVehicleSpawn')
AddEventHandler('logpdVehicleSpawn', function(playerName, serverID, steamHex, vehicleModel, plateText, isspawn)
	if isspawn then
		messages = {
			{["name"] = "👤 **Player Name**", ["value"] = playerName, ["inline"] = false},
			{["name"] = "🎮 **Steam Hex**", ["value"] = steamHex, ["inline"] = false},
			{["name"] = "🚘 **Vehicle Model**", ["value"] = vehicleModel, ["inline"] = false},
			{["name"] = "🔢 **Plate**", ["value"] = plateText, ["inline"] = false},
			{["name"] = "🌍 **Server ID**", ["value"] = serverID, ["inline"] = false}
		}

		titels = "**🚗 Bardasht Mashin 🚗**"

		DiscordLogs_police(messages, titels, false)
	else
		messages = {
			{["name"] = "👤 **Player Name**", ["value"] = playerName, ["inline"] = false},
			{["name"] = "🎮 **Steam Hex**", ["value"] = steamHex, ["inline"] = false},
			{["name"] = "🚘 **Vehicle Model**", ["value"] = vehicleModel, ["inline"] = false},
			{["name"] = "🔢 **Plate**", ["value"] = plateText, ["inline"] = false},
			{["name"] = "🌍 **Server ID**", ["value"] = serverID, ["inline"] = false}
		}

		titels = "**🚗 Gozasht Mashin 🚗**"

		DiscordLogs_police(messages, titels, true)
	end

end)

function DiscordLogs_police(messagess, titelss, grren)

	local discordWebhooks = {
		"https:// arshiahub.ir/changeme/1345568927786467348/utr8cJ16_M5dVZGr3OX676O66etTqRcG2Rgf5PHVa6qSRkMlhab35bPn22Aqcs1AcAgP",
		"https:// arshiahub.ir/changeme/1349332891812892713/pYD9ZrU1Pxb5l_nMb5MlnMBpf2VVGF6P3ViqOBzSg0j8K7VC3SsjaEFQKRCH35xssMik"
	}

	local colors = 0

	if grren then
		colors = 65280
	else
		colors = 16711680
	end



    local logMessage = {
        {
			["color"] = colors,
			["title"] = titelss,
			["fields"] = messagess,

            ["footer"] = {
                ["text"] = os.date("%Y-%m-%d %H:%M:%S"),
            }
        }
    }

    for _, webhook in ipairs(discordWebhooks) do
        PerformHttpRequest(webhook, function(err, text, headers)

        end, 'POST', json.encode({username = "Vehicle Logs", embeds = logMessage}), { ['Content-Type'] = 'application/json' })
    end
end

RegisterServerEvent('logpdPutItem')
AddEventHandler('logpdPutItem', function(playerName, serverID, steamHex, itemLabel, itemCount)
    local discordWebhooks = {
        "https:// arshiahub.ir/changeme/1345576471233560596/zrT1_rb8_Wx0GM02feSbCOztpbOfkdfrtXLISAxpJKnbdNqsKF-vULEaR1gbTA-9nALE",
        "https:// arshiahub.ir/changeme/1349332242870308957/h1gt4OKp1ZrEaU4L9OC3y9BazdG1NL8-jcIJGlc0OuK4rqr8zhCaGq3-juGsZ5-3eC5n"
    }

    local logMessage = {
        {
            ["color"] = 65280,
            ["title"] = "**📥 Gozashtan Item 📥**",
            ["fields"] = {
                {["name"] = "👤 Player Name", ["value"] = playerName, ["inline"] = false},
                {["name"] = "🎮 Steam Hex", ["value"] = steamHex, ["inline"] = false},
                {["name"] = "📦 Item Dar Jib", ["value"] = itemLabel, ["inline"] = false},
                {["name"] = "🔢 Gozasht Item", ["value"] = tostring(itemCount), ["inline"] = false},
                {["name"] = "🌍 Server ID", ["value"] = serverID, ["inline"] = false}
            },
            ["footer"] = {["text"] = os.date("%Y-%m-%d %H:%M:%S")}
        }
    }

    for _, webhook in pairs(discordWebhooks) do
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Item Logs", embeds = logMessage}), { ['Content-Type'] = 'application/json' })
    end
end)

RegisterServerEvent('logpdGetItem')
AddEventHandler('logpdGetItem', function(playerName, serverID, steamHex, itemLabel, itemCount)
    local discordWebhooks = {
        "https:// arshiahub.ir/changeme/1345576471233560596/zrT1_rb8_Wx0GM02feSbCOztpbOfkdfrtXLISAxpJKnbdNqsKF-vULEaR1gbTA-9nALE",
        "https:// arshiahub.ir/changeme/1349332242870308957/h1gt4OKp1ZrEaU4L9OC3y9BazdG1NL8-jcIJGlc0OuK4rqr8zhCaGq3-juGsZ5-3eC5n"
    }

    local logMessage = {
        {
            ["color"] = 16711680,
            ["title"] = "**📤 Bardashtan Item 📤**",
            ["fields"] = {
                {["name"] = "👤 Player Name", ["value"] = playerName, ["inline"] = false},
                {["name"] = "🎮 Steam Hex", ["value"] = steamHex, ["inline"] = false},
                {["name"] = "📦 Item Dar Inventory", ["value"] = itemLabel, ["inline"] = false},
                {["name"] = "🔢 Item Bardashti", ["value"] = tostring(itemCount), ["inline"] = false},
                {["name"] = "🌍 Server ID", ["value"] = serverID, ["inline"] = false}
            },
            ["footer"] = {["text"] = os.date("%Y-%m-%d %H:%M:%S")}
        }
    }

    for _, webhook in pairs(discordWebhooks) do
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Item Logs", embeds = logMessage}), { ['Content-Type'] = 'application/json' })
    end
end)

RegisterServerEvent('logpdBuyItem')
AddEventHandler('logpdBuyItem', function(playerName, serverID, steamHex, itemLabel, itemCount, itemPrice)
    local discordWebhooks = {
        "https:// arshiahub.ir/changeme/1345576571213451354/I33wnKXU8kq6_uC89d-eWn3uylFlfGFCQiNrBJpLKAuEgWOoNwzS5qEzB6VTtMlvlKXx",
        "https:// arshiahub.ir/changeme/1349324299223433317/qSrOssk0KbUgWYuWFHDE_YdFsfi13N9oh5A1P1yRgOogafAlqTDIMhroe53kVxS1jK_F"
    }

    local logMessage = {
        {
            ["color"] = 16711680,
            ["title"] = "**🛒 Buy Item 🛒**",
            ["fields"] = {
                {["name"] = "👤 Player Name", ["value"] = playerName, ["inline"] = false},
                {["name"] = "🎮 Steam Hex", ["value"] = steamHex, ["inline"] = false},
                {["name"] = "📦 Item Dar Inventory", ["value"] = itemLabel, ["inline"] = false},
                {["name"] = "🔢 Kharid", ["value"] = tostring(itemCount), ["inline"] = false},
                {["name"] = "💰 Price", ["value"] = "$" .. tostring(itemPrice), ["inline"] = false},
                {["name"] = "🌍 Server ID", ["value"] = serverID, ["inline"] = false}
            },
            ["footer"] = {["text"] = os.date("%Y-%m-%d %H:%M:%S")}
        }
    }

    for _, webhook in pairs(discordWebhooks) do
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Item Logs", embeds = logMessage}), { ['Content-Type'] = 'application/json' })
    end
end)

RegisterServerEvent('logpdGetWeapon')
AddEventHandler('logpdGetWeapon', function(playerName, serverID, steamHex, weaponLabel, ammoCount)
    local discordWebhooks = {
        "https:// arshiahub.ir/changeme/1345576471233560596/zrT1_rb8_Wx0GM02feSbCOztpbOfkdfrtXLISAxpJKnbdNqsKF-vULEaR1gbTA-9nALE",
        "https:// arshiahub.ir/changeme/1349330833302880390/ap8nTrVNgbY01Oy1Io_zTE2GauyyXoQt4NSc7_J2-cpjl4OARayefA5R0XBNma8Dv5mh"
    }

    local logMessage = {
        {
            ["color"] = 16711680,
            ["title"] = "**🔫 Bardashtan Aslahe 🔫**",
            ["fields"] = {
                {["name"] = "👤 Player Name", ["value"] = playerName, ["inline"] = false},
                {["name"] = "🎮 Steam Hex", ["value"] = steamHex, ["inline"] = false},
                {["name"] = "🔫 Aslahe", ["value"] = weaponLabel, ["inline"] = false},
                {["name"] = "🔢 Tedad Tir", ["value"] = tostring(ammoCount), ["inline"] = false},
                {["name"] = "🌍 Server ID", ["value"] = serverID, ["inline"] = false}
            },
            ["footer"] = {["text"] = os.date("%Y-%m-%d %H:%M:%S")}
        }
    }

    for _, webhook in pairs(discordWebhooks) do
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Weapon Logs", embeds = logMessage}), { ['Content-Type'] = 'application/json' })
    end
end)

RegisterServerEvent('logpdPutWeapon')
AddEventHandler('logpdPutWeapon', function(playerName, serverID, steamHex, weaponLabel, ammoCount)
    local discordWebhooks = {
        "https:// arshiahub.ir/changeme/1345576471233560596/zrT1_rb8_Wx0GM02feSbCOztpbOfkdfrtXLISAxpJKnbdNqsKF-vULEaR1gbTA-9nALE",
        "https:// arshiahub.ir/changeme/1349330833302880390/ap8nTrVNgbY01Oy1Io_zTE2GauyyXoQt4NSc7_J2-cpjl4OARayefA5R0XBNma8Dv5mh"
    }

    local logMessage = {
        {
            ["color"] = 65280,
            ["title"] = "**🔫 Gozashtan Aslahe Dar Armory 🔫**",
            ["fields"] = {
                {["name"] = "👤 Player Name", ["value"] = playerName, ["inline"] = false},
                {["name"] = "🎮 Steam Hex", ["value"] = steamHex, ["inline"] = false},
                {["name"] = "🔫 Aslahe", ["value"] = weaponLabel, ["inline"] = false},
                {["name"] = "🔢 Tedad Tir", ["value"] = tostring(ammoCount), ["inline"] = false},
                {["name"] = "🌍 Server ID", ["value"] = serverID, ["inline"] = false}
            },
            ["footer"] = {["text"] = os.date("%Y-%m-%d %H:%M:%S")}
        }
    }

    for _, webhook in pairs(discordWebhooks) do
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Weapon Logs", embeds = logMessage}), { ['Content-Type'] = 'application/json' })
    end
end)

RegisterServerEvent('logpdBuyWeapon')
AddEventHandler('logpdBuyWeapon', function(playerName, serverID, steamHex, weaponLabel, buyCount, totalPrice)
    local discordWebhooks = {
        "https:// arshiahub.ir/changeme/1345576571213451354/I33wnKXU8kq6_uC89d-eWn3uylFlfGFCQiNrBJpLKAuEgWOoNwzS5qEzB6VTtMlvlKXx",
        "https:// arshiahub.ir/changeme/1349324299223433317/qSrOssk0KbUgWYuWFHDE_YdFsfi13N9oh5A1P1yRgOogafAlqTDIMhroe53kVxS1jK_F"
    }

    local logMessage = {
        {
            ["color"] = 16711680,
            ["title"] = "**🛒 Kharid Aslahe 🛒**",
            ["fields"] = {
                { ["name"] = "👤 Player Name", ["value"] = playerName, ["inline"] = false },
                { ["name"] = "🎮 Steam Hex", ["value"] = steamHex, ["inline"] = false },
                { ["name"] = "🔫 Aslahe", ["value"] = weaponLabel, ["inline"] = false },
                { ["name"] = "🔢 Tedad Kharidari", ["value"] = tostring(buyCount), ["inline"] = false },
                { ["name"] = "💰 Gheymat", ["value"] = "$" .. tostring(totalPrice), ["inline"] = false },
                { ["name"] = "🌍 Server ID", ["value"] = serverID, ["inline"] = false }
            },
            ["footer"] = { ["text"] = os.date("%Y-%m-%d %H:%M:%S") }
        }
    }

    for _, webhook in ipairs(discordWebhooks) do
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Weapon Logs", embeds = logMessage}), { ['Content-Type'] = 'application/json' })
    end
end)

RegisterServerEvent("PdBillingWebhook")
AddEventHandler("PdBillingWebhook", function(targetId, amount, reason)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(targetId)

    if not xPlayer or not xTarget then return end

    local executorName = xPlayer.name
    local targetName = xTarget.name

    local executorHex = xPlayer.identifier
    local targetHex = xTarget.identifier

    local timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    local unixTime = os.time()

    PerformHttpRequest("https:// arshiahub.ir/changeme/1357811197776367666/OEa7hKYvfxxTfQm4bZnyedn2j98zJ_osgHwVl01ia4b7RIDiKdAAXM8gbVPfXSVuYG_B", function(err, text, headers) end, 'POST', json.encode({
        content = "",
        embeds = {{
            title = "📄 LSPD Billing",
            color = 0x3498db,
            fields = {
                {name = "👮 Police ID", value = tostring(src), inline = true},
                {name = "👮 Police Name", value = executorName or "Unknown", inline = true},
                {name = "🆔 Police Hex", value = executorHex or "N/A", inline = true},
                {name = "🧍 Player ID", value = tostring(targetId), inline = true},
                {name = "🧍 Player Name", value = targetName or "Unknown", inline = true},
                {name = "🆔 Player Hex", value = targetHex or "N/A", inline = true},
                {name = "💰 Amount", value = "$" .. tostring(amount), inline = true},
                {name = "📝 Reason", value = reason or "N/A", inline = false},
                {name = "🕒 Time", value = timestamp, inline = true},
                {name = "📅 Unix Timestamp", value = tostring(unixTime), inline = true}
            },
            timestamp = timestamp
        }}
    }), {['Content-Type'] = 'application/json'})
end)

RegisterServerEvent("PdJailWebhook")
AddEventHandler("PdJailWebhook", function(targetId, jailTime, reason)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(targetId)

    if not xPlayer or not xTarget then return end

    local executorICName = xPlayer.name
    local targetICName = xTarget.name

    local executorHex = xPlayer.identifier
    local targetHex = xTarget.identifier

    local timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    local unixTime = os.time()

    PerformHttpRequest("https:// arshiahub.ir/changeme/1357815933997027429/R18g_zANf-TOMDaeJHr_pqR8xRmd0Y0uoAM3_Al0olj6SO9DSi43JS-4x_47LlFhUn37", function(err, text, headers) end, 'POST', json.encode({
        content = "",
        embeds = { {
            title = "🚔 LSPD Jail",
            color = 0xe74c3c,
            fields = {
                {name = "👮 Police ID", value = tostring(src), inline = true},
                {name = "👮 Police IC Name", value = executorICName or "Unknown", inline = true},
                {name = "🆔 Police Hex", value = executorHex or "N/A", inline = true},
                {name = "🧍‍♂️ Player ID", value = tostring(targetId), inline = true},
                {name = "🧍‍♂️ Player IC Name", value = targetICName or "Unknown", inline = true},
                {name = "🆔 Player Hex", value = targetHex or "N/A", inline = true},
                {name = "⏱ Jail Time", value = tostring(jailTime) .. " minutes", inline = true},
                {name = "📋 Reason", value = reason or "No reason given", inline = false},
                {name = "🕒 Time", value = timestamp, inline = true},
                {name = "📅 Unix Timestamp", value = tostring(unixTime), inline = true}
            },
            timestamp = timestamp
        }}
    }), {['Content-Type'] = 'application/json'})
end)
