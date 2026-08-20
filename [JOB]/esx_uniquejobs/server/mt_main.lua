ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local drag = false
local AS, ASWarn = {}, {}

local units = {}
local callsigns = {}

if Config_mt.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'MT', Config_mt.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'mt', _U('alert_mt'), true, true)

TriggerEvent('esx_society:registerSociety', 'mt', 'MT', 'society_law', 'society_mt', 'society_mt', {type = 'public'})

RegisterServerEvent('esx_mtjob:giveWeapon')
AddEventHandler('esx_mtjob:giveWeapon', function(weapon, ammo)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('esx_mtjob:getStockItem')
AddEventHandler('esx_mtjob:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mt', function(inventory)

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

RegisterServerEvent('esx_mtjob:putStockItems')
AddEventHandler('esx_mtjob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mt', function(inventory)

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

RegisterCommand('findnumber_mt', function(source, args, users)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == "mt" or xPlayer.job.name == "sheriff" then
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
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', " ^0Shoma mt nistid!"} })
    end
end)

ESX.RegisterServerCallback('esx_mtjob:getVehicleInfos', function(source, cb, plate)

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

				if Config_mt.EnableESXIdentity then
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

ESX.RegisterServerCallback('esx_mtjob:getVehicleFromPlate', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] ~= nil then

			MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config_mt.EnableESXIdentity then
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

ESX.RegisterServerCallback('esx_mtjob:getArmoryWeapons', function(source, cb)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_mt', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)

	end)

end)

ESX.RegisterServerCallback('esx_mtjob:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)

	local xPlayer = ESX.GetPlayerFromId(source)
	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
		TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Deposited ' .. weaponName ,'user', source, true, false)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_mt', function(store)

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

ESX.RegisterServerCallback('esx_mtjob:buyArmoryWeapon', function(source, cb, weaponName, removeWeapon, tedad)

	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
		TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Deposited ' .. weaponName ,'user', source, true, false)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_mt', function(store)

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

ESX.RegisterServerCallback('esx_mtjob:removeArmoryWeapon', function(source, cb, weaponName)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.addWeapon(weaponName, 500)
	TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Withdrawn ' .. weaponName ,'user', source, true, false)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_mt', function(store)

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

ESX.RegisterServerCallback('esx_mtjob:buy', function(source, cb, amount)


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

ESX.RegisterServerCallback('esx_mtjob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mt', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_mtjob:buyArmoryItem', function(source, cb, weaponName, removeWeapon, tedad)

	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
		TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Deposited ' .. weaponName ,'user', source, true, false)
	end

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mt', function(inventory)

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

ESX.RegisterServerCallback('esx_mtjob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'mt')
	end
end)

RegisterServerEvent('esx_mtjob:message')
AddEventHandler('esx_mtjob:message', function(target, msg)

	TriggerClientEvent('esx:showNotification', target, msg)
end)

local panic = 0
local panicreqx = {}
local panicreqy = {}
local panicreqname = {}
local sentreq = {}

RegisterServerEvent('esx_mtjob:saundplay')
AddEventHandler('esx_mtjob:saundplay', function(soundFile, soundVolume, x, y, plate, IsDistress)
    local source = source
    local namesh = GetPlayerName(source)
    local unit = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()

    if not sentreq[source] then
        panic = panic + 1
        sentreq[source] = true
        panicreqx[panic] = x
        panicreqy[panic] = y
        panicreqname[panic] = unit and unit.get('inunit') or 'Unknown'

        TriggerClientEvent('InteractSound_SV:PlayOnOne', source, soundFile, soundVolume)

        if IsDistress then
            local text = '*'..namesh..' Dastesho Mibare Samte Radio Va Dokme Panic Ro Feshar Mide.*'
			local xxPlayer = ESX.GetPlayerFromId(source)
            TriggerEvent('InteractSound_SV:PlayWithinDistancemt', xxPlayer, 5.0, 'panic', 0.3)


            TriggerClientEvent('chatMessage', source, "[DISPATCH ("..string.upper(xxPlayer.job.name)..") ]", {50, 150, 200},
                "^7Shoma Dar Halat ^1Panic ^7Qarar Gereftid -> ^8/resp "..panic)
            TriggerClientEvent('esx_mtjob:sendbackuptext', source, text)


            for i=1, #xPlayers do
                local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                if xPlayer and xPlayer.source ~= source and (xPlayer.job.name == "mt" or xPlayer.job.name == "sheriff" or xPlayer.job.name == "fbi") then

					TriggerEvent('InteractSound_SV:PlayWithinDistancemt', xPlayer, 5.0, 'panic', 0.3)
                    TriggerClientEvent('chatMessage', xPlayer.source, "[DISPATCH ("..string.upper(xxPlayer.job.name)..") ]", {50, 150, 200},
                        "^7Afsar ^2"..namesh.."^7 Az Vahede  ^7Morede ^1Hamle ^7Gharar Gerefte Ast -> ^8/resp "..panic)
                end
            end
        else
            local text = '*'..namesh..' Dastesho Mibare Samte Radio Va Darkhast 10-70 Mikone.*'
			local xxPlayer = ESX.GetPlayerFromId(source)
            TriggerEvent('InteractSound_SV:PlayWithinDistancemt', xxPlayer, source, 5.0, 'demo', 1.0)


            TriggerClientEvent('chatMessage', source, "[DISPATCH ("..string.upper(xxPlayer.job.name)..") ]", {50, 150, 200},
                "^7Shoma Darkhast ^1Backup ^7Dadid -> ^8/resp "..panic)
            TriggerClientEvent('esx_mtjob:sendbackuptext', source, text)


            for i=1, #xPlayers do
                local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                if xPlayer then
					if xPlayer and xPlayer.source ~= source and (xPlayer.job.name == "mt" or xPlayer.job.name == "sheriff" or xPlayer.job.name == "fbi") then
						TriggerEvent('InteractSound_SV:PlayWithinDistancemt', xPlayer, 5.0, 'demo', 1.0)
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

RegisterServerEvent('esx_mtjob:playSoundRadio')
AddEventHandler('esx_mtjob:playSoundRadio', function(soundFile, soundVolume)
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do

		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		if xPlayer.job.name == "mt" and xPlayer.job.grade >= 0 then

			if xPlayer.source ~= source then
				TriggerEvent('InteractSound_SV:PlayOnOne', xPlayer.source, soundFile, soundVolume)
			end

		end

	end
end)

ESX.RegisterServerCallback('esx_mtjob:getitem', function(source, cb, item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

ESX.RegisterServerCallback('esx_mtjob:getIcName', function(source, cb)
	local _source = source
	characterName = string.gsub(exports.essentialmode:IcName(_source), "_", " ")
	cb(characterName)
end)

RegisterServerEvent("mt:ShotsAlarm")
AddEventHandler("mt:ShotsAlarm", function(x,y,z,s)
	local xPlayers = ESX.GetPlayers()
	 if GetPlayerRoutingBucket( source )  == 0  then
		TriggerClientEvent("mt:ShotsAlarm", -1  , x,y,z,s)
	 end


end)

RegisterCommand('createunit_mt', function(source, args)
	if not args[1] then
		TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "Syntax Vared Shode Eshtebah Ast")
		return
	end

	local xPlayer = ESX.GetPlayerFromId(source)
	print(xPlayer.job.name)
	if xPlayer.job.name == "mt" then
		local identifier = xPlayer.identifier

		if units[identifier] == nil and not IsPlayerInAnyUnit_mt(identifier) then

			local uidentifier = string.upper(args[1])

			if callsigns[uidentifier] == nil then
				units[identifier] = {callsign = uidentifier, members = {}, job = xPlayer.job.name}
				callsigns[uidentifier] = {owner = identifier, name = xPlayer.name, job = xPlayer.job.name}
				TriggerClientEvent('esx:setcallsign', source, uidentifier)
				TriggerClientEvent('esx_mtjob:notifyp', -1, " Vahed ^2" .. uidentifier .. "^0 Tavasot ^3" .. string.gsub(xPlayer.name, "_", " ") .. "^0 sakhte shod!", xPlayer.job.name)
			else
				TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "Callsign ^2" .. uidentifier .. "^0 ghablan Tavasot ^3" .. callsigns[uidentifier].name .. "^0 sakhte shode ast!")
			end

		else
			if not IsPlayerInAnyUnit_mt(identifier) then
				TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "Shoma ghablan unit sakhte id")
			else
				TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "Shoma dar hale hazer unit darid")
			end
		end

	else
		TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "Shoma Dastresi Kafi Baraye Estefade AzIn Dastor Ra Nadarid")
	end

end, false)

RegisterCommand('delunit_mt', function(source, args)
	if not args[1] then
		TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "Syntax Vared Shode Eshtebah Ast")
		return
	end

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "mt"  and xPlayer.job.grade >= 1 then
		local identifier = xPlayer.identifier
		local job = xPlayer.job.name
		local Name = string.gsub(xPlayer.name, "_", " ")

			local uidentifier = string.upper(args[1])

			if callsigns[uidentifier] ~= nil then

				if callsigns[uidentifier].job == xPlayer.job.name then

					local identifier = callsigns[uidentifier].owner
					xPlayer = ESX.GetPlayerFromIdentifier(identifier)
					if xPlayer then
						TriggerClientEvent('esx:setcallsign', xPlayer.source, nil)
					end

					if TableLength_mt(units[identifier].members) > 0 then
						for k,v in pairs(units[identifier].members) do
							xPlayer = ESX.GetPlayerFromIdentifier(k)
							if xPlayer then
								TriggerClientEvent('esx:setcallsign', xPlayer.source, nil)
							end
						end
					end
					TriggerClientEvent('esx_mtjob:notifyp', -1, " Vahed ^2" .. uidentifier .. "^0 Tavsot ^3" .. Name .. "^0 Monhal Shod!", job)

				else
					TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "Shoma Faghat Vahed Haye Department Khod Ra Mitavanid Pak Konid")
				end

			else
				TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "Callsign Vared Shode Vojod Nadarad")
			end

	else
		TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "Shoma Dastresi Kafi Baraye In Dastor Ra Nadarid")
	end

end, false)

RegisterCommand('renameunit_mt', function(source, args)

	if not args[1] then
		TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "Syntax Vared Shode Eshtebah Ast")
		return
	end

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "mt"  then

		local identifier = xPlayer.identifier
		local job = xPlayer.job.name

		if units[identifier] ~= nil then

			local csign = units[identifier].callsign
			local uidentifier = string.upper(args[1])

			if csign == uidentifier then
				TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "Shoma nemitavanid callsign ghabli khod ra entekhab konid!")
				return
			end

			units[identifier].callsign = uidentifier
			callsigns[csign] = nil
			callsigns[uidentifier] = {owner = identifier, job = xPlayer.job.name, name = string.gsub(xPlayer.name, "_", " ")}
			TriggerClientEvent('esx:setcallsign', source, uidentifier)
			if TableLength_mt(units[identifier].members) > 0 then
				for k,v in pairs(units[identifier].members) do
					xPlayer = ESX.GetPlayerFromIdentifier(k)
					if xPlayer then
						TriggerClientEvent('esx:setcallsign', xPlayer.source, uidentifier)
					end
				end
			end
			TriggerClientEvent('esx_mtjob:notifyp', -1, " Vahed ^2" .. csign .. "^0 be ^3" .. uidentifier .. "^0 taghir yaft!", job)

		else
			if not IsPlayerInAnyUnit_mt(identifier) then
				TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "Shoma hich uniti nadarid")
			else
				TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "Shoma saheb in unit nistid")
			end
		end

	else
		TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "Shoma Dastresi Kafi Baraye Estefade AzIn Dastor Ra Nadarid")
	end

end, false)

RegisterCommand('disbanunit_mt', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "mt"  then
		local identifier = xPlayer.identifier

		if units[identifier] ~= nil then

			local csign = units[identifier].callsign
			TriggerClientEvent('esx:setcallsign', source, nil, xPlayer.job.name)
			callsigns[csign] = nil
			units[identifier] = nil
			TriggerClientEvent('esx_mtjob:notifyp', -1, " Vahed ^2" .. csign .. "^0 monhal shod!", xPlayer.job.name)

		else
			if not IsPlayerInAnyUnit_mt(identifier) then
				TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "Shoma hich uniti nadarid")
			else
				TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "Shoma saheb in unit nistid")
			end
		end

	else
		TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "Shoma Dastresi Kafi Baraye Estefade AzIn Dastor Ra Nadarid")
	end

end, false)

RegisterCommand('units_mt', function(source, args)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "mt"  then
		local identifier = xPlayer.identifier
		local job = xPlayer.job.name
		if TableLength_mt(callsigns) > 0 then
			if args[1] == "all" then
				if xPlayer.job.name == "fbi" then
					for k,v in pairs(callsigns) do
						TriggerClientEvent('chatMessage', source, "[ Info ] : ", {226, 239, 93}, "UNIT ^3'" .. k .. "'^0,   Leader: ^2" .. v.name .. "^0, Members: ^1" .. TableLength_mt(units[v.owner].members))
					end
				else
					TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "Shoma dastresi kafi baraye in dastor ra nadarid!")
				end
			else
				for k,v in pairs(callsigns) do
					if v.job == job then
						TriggerClientEvent('chatMessage', source, "[ Info ] : ", {226, 239, 93}, "UNIT ^3'" .. k .. "'^0,   Leader: ^2" .. v.name .. "^0, Members: ^1" .. TableLength_mt(units[v.owner].members))
					end
				end
			end

		else
			TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "Hich Vahedi baraye namayesh vojod nadarad!")
		end

	else
		TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "Shoma dastresi kafi baraye estefade Azin dastoor ra nadarid")
	end

end, false)

RegisterCommand('joinunit_mt', function(source, args)
	if not args[1] then
		TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "Syntax Vared Shode Eshtebah Ast")
		return
	end

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "mt"  then

		local identifier = xPlayer.identifier

		if units[identifier] == nil and not IsPlayerInAnyUnit_mt(identifier) then

			local uidentifier = string.upper(args[1])
			if callsigns[uidentifier] ~= nil then
				units[callsigns[uidentifier].owner].members[identifier] = xPlayer.name
				TriggerClientEvent('esx:setcallsign', source, uidentifier)
				TriggerClientEvent('esx_mtjob:notifyp', -1, "^3" ..string.gsub(xPlayer.name, "_", " ") .. "^0 Be Vahed ^2" .. uidentifier .. "^0 molhagh shod!", xPlayer.job.name)
			else
				TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "In callsign vojoud nadarad!")
			end

		else
			TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "Shoma dar hale hazer unit darid!")
		end

	else
		TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "Shoma mt nistid")
	end
end, false)

RegisterCommand('leaveunit_mt', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "mt"  then

		local identifier = xPlayer.identifier

		if units[identifier] == nil and IsPlayerInAnyUnit_mt(identifier) then

			for k,v in pairs(units) do
				if v.members[identifier] then
					TriggerClientEvent('esx_mtjob:notifyp', -1, "^3" ..string.gsub(xPlayer.name, "_", " ") .. "^0 AzVahed ^2" .. v.callsign .. "^0 kharej shod!", xPlayer.job.name)
					v.members[identifier] = nil
					break
				end
			end

		else
			if units[identifier] == nil then
				TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "Shoma dakhel hich uniti nistid!")
			else
				TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "Shoma nemitavanid AzVahed khod kharej shavid!")
			end
		end

	else
		TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, "Shoma Dastresi Kafi Baraye Estefade AzIn Dastor Ra Nadarid")
	end
end, false)

function TableLength_mt(table)

	local count = 0
	for _ in pairs(table) do
		count = count + 1
	end
	return count

end

function IsPlayerInAnyUnit_mt(identifier)
	for k,v in pairs(units) do
		if v.members[identifier] then
			return true
		end
	end
	return false
end

RegisterServerEvent('logMTVehicleSpawn')
AddEventHandler('logMTVehicleSpawn', function(playerName, serverID, steamHex, vehicleModel, plateText, isspawn)
	if isspawn then
		messages = {
			{["name"] = "👤 **Player Name**", ["value"] = playerName, ["inline"] = false},
			{["name"] = "🎮 **Steam Hex**", ["value"] = steamHex, ["inline"] = false},
			{["name"] = "🚘 **Vehicle Model**", ["value"] = vehicleModel, ["inline"] = false},
			{["name"] = "🔢 **Plate**", ["value"] = plateText, ["inline"] = false},
			{["name"] = "🌍 **Server ID**", ["value"] = serverID, ["inline"] = false}
		}

		titels = "**🚗 Bardasht Mashin 🚗**"

		DiscordLogs_mt(messages, titels, false)
	else
		messages = {
			{["name"] = "👤 **Player Name**", ["value"] = playerName, ["inline"] = false},
			{["name"] = "🎮 **Steam Hex**", ["value"] = steamHex, ["inline"] = false},
			{["name"] = "🚘 **Vehicle Model**", ["value"] = vehicleModel, ["inline"] = false},
			{["name"] = "🔢 **Plate**", ["value"] = plateText, ["inline"] = false},
			{["name"] = "🌍 **Server ID**", ["value"] = serverID, ["inline"] = false}
		}

		titels = "**🚗 Gozasht Mashin 🚗**"

		DiscordLogs_mt(messages, titels, true)
	end

end)

function DiscordLogs_mt(messagess, titelss, grren)

	local discordWebhooks = {
		"https:// arshiahub.ir/changeme/1345568927786467348/utr8cJ16_M5dVZGr3OX676O66etTqRcG2Rgf5PHVa6qSRkMlhab35bPn22Aqcs1AcAgP",
		"https:// arshiahub.ir/changeme/1354115895730896918/pM6Y0IVfTtMsJcHQr_mVIN1VAIllS4Qx51e5tItqqnKvFvWS21cagSSWcCnvM88PyfDZ"
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

RegisterServerEvent('logMTPutItem')
AddEventHandler('logMTPutItem', function(playerName, serverID, steamHex, itemLabel, itemCount)
    local discordWebhooks = {
        "https:// arshiahub.ir/changeme/1345576471233560596/zrT1_rb8_Wx0GM02feSbCOztpbOfkdfrtXLISAxpJKnbdNqsKF-vULEaR1gbTA-9nALE",
        "https:// arshiahub.ir/changeme/1354115439281569832/zZQlH5s0tvOF_LZw0qZQfIfFA2h36HNsTS9GDFmxDRea9GUsSZmRMBKwdn-MrfBHblfa"
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

RegisterServerEvent('logMTGetItem')
AddEventHandler('logMTGetItem', function(playerName, serverID, steamHex, itemLabel, itemCount)
    local discordWebhooks = {
        "https:// arshiahub.ir/changeme/1345576471233560596/zrT1_rb8_Wx0GM02feSbCOztpbOfkdfrtXLISAxpJKnbdNqsKF-vULEaR1gbTA-9nALE",
        "https:// arshiahub.ir/changeme/1354115439281569832/zZQlH5s0tvOF_LZw0qZQfIfFA2h36HNsTS9GDFmxDRea9GUsSZmRMBKwdn-MrfBHblfa"
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

RegisterServerEvent('logMTBuyItem')
AddEventHandler('logMTBuyItem', function(playerName, serverID, steamHex, itemLabel, itemCount, itemPrice)
    local discordWebhooks = {
        "https:// arshiahub.ir/changeme/1345576571213451354/I33wnKXU8kq6_uC89d-eWn3uylFlfGFCQiNrBJpLKAuEgWOoNwzS5qEzB6VTtMlvlKXx",
        "https:// arshiahub.ir/changeme/1354115332788322355/B8PS_mhpX64iYIZLfOJUP2GPHxyQsXA88_qciG0SbNq5ayuFgu9O61mFB7gcK3WM3qL9"
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

RegisterServerEvent('logMTGetWeapon')
AddEventHandler('logMTGetWeapon', function(playerName, serverID, steamHex, weaponLabel, ammoCount)
    local discordWebhooks = {
        "https:// arshiahub.ir/changeme/1345576471233560596/zrT1_rb8_Wx0GM02feSbCOztpbOfkdfrtXLISAxpJKnbdNqsKF-vULEaR1gbTA-9nALE",
        "https:// arshiahub.ir/changeme/1354115439281569832/zZQlH5s0tvOF_LZw0qZQfIfFA2h36HNsTS9GDFmxDRea9GUsSZmRMBKwdn-MrfBHblfa"
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

RegisterServerEvent('logMTPutWeapon')
AddEventHandler('logMTPutWeapon', function(playerName, serverID, steamHex, weaponLabel, ammoCount)
    local discordWebhooks = {
        "https:// arshiahub.ir/changeme/1345576471233560596/zrT1_rb8_Wx0GM02feSbCOztpbOfkdfrtXLISAxpJKnbdNqsKF-vULEaR1gbTA-9nALE",
        "https:// arshiahub.ir/changeme/1354115439281569832/zZQlH5s0tvOF_LZw0qZQfIfFA2h36HNsTS9GDFmxDRea9GUsSZmRMBKwdn-MrfBHblfa"
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

RegisterServerEvent('logMTBuyWeapon')
AddEventHandler('logMTBuyWeapon', function(playerName, serverID, steamHex, weaponLabel, buyCount, totalPrice)
    local discordWebhooks = {
        "https:// arshiahub.ir/changeme/1345576571213451354/I33wnKXU8kq6_uC89d-eWn3uylFlfGFCQiNrBJpLKAuEgWOoNwzS5qEzB6VTtMlvlKXx",
        "https:// arshiahub.ir/changeme/1354115332788322355/B8PS_mhpX64iYIZLfOJUP2GPHxyQsXA88_qciG0SbNq5ayuFgu9O61mFB7gcK3WM3qL9"
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

RegisterServerEvent("MtBillingWebhook")
AddEventHandler("MtBillingWebhook", function(targetId, amount, reason)
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

    PerformHttpRequest("https:// arshiahub.ir/changeme/1357840871051235540/IoLvfHLHT54BFJK7-_r3siSHIClvTBrRwbGPQ4Mx1uH62BGV7jgaNupgH6HGa5sHwr_d", function(err, text, headers) end, 'POST', json.encode({
        content = "",
        embeds = {{
            title = "📄 LSMT Billing",
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

RegisterServerEvent("MtJailWebhook")
AddEventHandler("MtJailWebhook", function(targetId, jailTime, reason)
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

    PerformHttpRequest("https:// arshiahub.ir/changeme/1357839690639736983/rkmhGAbr_gnRjojU346a6LH6DviErEQo-pwYAHsfE0o2QKXBP6B7sZbycc94-29Ko86E", function(err, text, headers) end, 'POST', json.encode({
        content = "",
        embeds = { {
            title = "🚔 LSMT Jail",
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