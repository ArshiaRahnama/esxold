-- ESX is already initialized globally by server.lua; no need to re-fetch it here.
local owners = {}

ESX.RegisterServerCallback('CarLock:haskey', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = "CarKey|" .. ESX.Math.Trim(plate)
    local platePrefix = string.sub(plate, 1, 2) 
	local platePrefixFBI = string.sub(plate, 1, 3) 
    local gangName = xPlayer.gang and xPlayer.gang.name or nil

    if xPlayer.job.name == 'taxi' and platePrefix == 'TX' then
        cb(true)
        return
    end

	if xPlayer.job.name == 'police' and platePrefix == 'PD' then
        cb(true)
        return
    end

	if xPlayer.job.name == 'ambulance' and platePrefix == 'MD' then
        cb(true)
        return
    end


	if xPlayer.job.name == 'fbi' and platePrefixFBI == 'FBI' then
        cb(true)
        return
    end

	if xPlayer.job.name == 'sheriff' and platePrefix == 'SH' then
        cb(true)
        return
    end


	if xPlayer.job.name == 'mechanic' and platePrefix == 'MC' then
        cb(true)
        return
    end

	if xPlayer.job.name == 'weazel' and platePrefix == 'WZ' then
        cb(true)
        return
    end

	if xPlayer.job.name == 'mt' and platePrefix == 'MT' then
        cb(true)
        return
    end

	if xPlayer.job.name == 'cid' and platePrefixFBI == 'CID' then
        cb(true)
        return
    end

	if xPlayer.job.name == 'cia' and platePrefixFBI == 'CIA' then
        cb(true)
        return
    end

	if xPlayer.job.name == 'marshal' and platePrefix == 'MS' then
        cb(true)
        return
    end

	if xPlayer.job.name == 'judge' and platePrefix == 'JD' then
        cb(true)
        return
    end

	if xPlayer.job.name == 'doa' and platePrefixFBI == 'DOA' then
        cb(true)
        return
    end


    local inventoryItem = xPlayer.getInventoryItem(item)
    if inventoryItem and inventoryItem.count >= 1 then
        cb(true)
        return
    end


    if not gangName then
        cb(false)
        return
    end

    MySQL.Async.fetchScalar('SELECT owner FROM owned_vehicles WHERE owner = @gang AND plate = @plate', {
        ['@gang'] = gangName,
        ['@plate'] = plate
    }, function(result)
        if result == gangName then
            cb(true)
        else
            cb(false)
        end
    end)
end)

RegisterCommand('givekey',function(source , args)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.permission_level >= 1 then 
		if tonumber(args[1]) and  ESX.GetPlayerFromId(tonumber(args[1])) then 
			if #( GetEntityCoords(GetPlayerPed(source))   - GetEntityCoords(GetPlayerPed(tonumber(args[1]))) ) <= 15 then 
				TriggerClientEvent('givekey_Cl' ,tonumber(args[1]) , tonumber(args[1]))
			else 
				print('Fasle Shoma Ba Player Mored Nazar Zeyad Ast')
			end 
		else 
			print('Id Eshtbah Ast')
		end 
	end 
end)
RegisterNetEvent("CarLock:CheckKeys")
AddEventHandler("CarLock:CheckKeys", function(KEYS)
	local KEYS = KEYS
	local KeyItems = {}
	if #KEYS <= 0 then return end
	local xPlayer = ESX.GetPlayerFromId(source)
	for i=1, #xPlayer.inventory do
		if string.find(xPlayer.inventory[i].name, "CarKey") then
			KeyItems[xPlayer.inventory[i].name] = false
			g, val = (GetKey(KEYS, xPlayer.inventory[i].name))
			while not g do Wait(14) end
			if g >= 0 then
				if KEYS[g] == xPlayer.inventory[i].name then
					KeyItems[xPlayer.inventory[i].name] = true
				end
			end
		end
	end
	while not KeyItems do Wait(14) end
	if next(KeyItems) then
		for k,v in pairs(KeyItems) do
			if not v then
				xPlayer.removeInventoryItem(k, 1)
			end
		end
	end
end)

function GetKey(tab, val)
	local tab = tab
    for i, v in ipairs (tab) do 
        if (v == val) then
			return i, val
        end
    end
	return -1
end

-- تابع برای enumerate کردن وسایل نقلیه
function EnumerateVehicles()
    return coroutine.wrap(function()
        local handle, vehicle = FindFirstVehicle()
        if not vehicle then
            return
        end
        local finished = false
        repeat
            coroutine.yield(vehicle)
            finished, vehicle = FindNextVehicle(handle)
        until not finished
        EndFindVehicle(handle)
    end)
end

RegisterNetEvent("CarLock:ToggleKey")
AddEventHandler("CarLock:ToggleKey", function(op, plate)
	if plate ~= nil then
		local xPlayer = ESX.GetPlayerFromId(source)
		
		local item = "CarKey|"..(ESX.Math.Trim(plate))
		
		if xPlayer ~= nil then
			if op then
				if xPlayer.getInventoryItem(item) == nil or xPlayer.getInventoryItem(item).count <= 0 then
					xPlayer.addInventoryItem(item, 1, nil, nil, 0)
				end
			else
				local xPlayers = ESX.GetPlayers()
				for i=1, #xPlayers, 1 do
					local xPlayerr = ESX.GetPlayerFromId(xPlayers[i])
					if item and xPlayerr.getInventoryItem(item) ~= nil and xPlayerr.getInventoryItem(item).count  > 0   then
						xPlayerr.removeInventoryItem(item, 1)
					end
				end 
			end 
		end
	end
end)

RegisterNetEvent("CarLock:ToggleKey2")
AddEventHandler("CarLock:ToggleKey2", function(op, plate , src)
	local src = src 
	if plate ~= nil then
		local item = "CarKey|"..(ESX.Math.Trim(plate))
		local xPlayer = ESX.GetPlayerFromId(src)
		if xPlayer ~= nil then
			if op then
				if xPlayer.getInventoryItem(item) == nil or xPlayer.getInventoryItem(item).count <= 0 then
					xPlayer.addInventoryItem(item, 1, nil, nil, 0)
				end
			else
				if item and xPlayer.getInventoryItem(item) ~= nil  then
					xPlayer.removeInventoryItem(item, 1)
				end
			end
		end
	end
end)

ESX.RegisterServerCallback('CarLock:hasHotwireItem', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local hotwireItem = xPlayer.getInventoryItem(Customize.HotwireItem)
    cb(hotwireItem ~= nil and hotwireItem.count >= 1)
end)

RegisterNetEvent('CarLock:useHotwireKit')
AddEventHandler('CarLock:useHotwireKit', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local hotwireItem = xPlayer.getInventoryItem(Customize.HotwireItem)
    
    if hotwireItem and hotwireItem.count >= 1 then
        xPlayer.removeInventoryItem(Customize.HotwireItem, 1)
        TriggerClientEvent('CarLock:enableVehicleTemporarily', source)

    end
end)


ESX.RegisterServerCallback('CarLock:canHotwire', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = "CarKey|" .. ESX.Math.Trim(plate)
    local gangName = xPlayer.gang and xPlayer.gang.name or nil
    
    local hasKey = xPlayer.getInventoryItem(item) and xPlayer.getInventoryItem(item).count >= 1

    if not gangName then
        cb(not hasKey)
        return
    end

    MySQL.Async.fetchScalar('SELECT owner FROM owned_vehicles WHERE owner = @gang AND plate = @plate', {
        ['@gang'] = gangName,
        ['@plate'] = plate
    }, function(result)
        local isGangVehicle = result == gangName
        cb(not hasKey and not isGangVehicle) 
    end)
end)