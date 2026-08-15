-- ============================================================================
-- Sunset Housing - server/main.lua
-- All `sunset_housing:*` events/callbacks the client (client/functions.lua,
-- object/src/client/main.lua) fires. esx_skin, esx_aduty and the job garage
-- system already exist as their own resources in this project and are left
-- alone - not this resource's job.
-- ============================================================================

ESX = nil
CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(0)
	end
end)

-- players currently standing inside a house, keyed by server id -> houseId
local InsideHouse = {}

local function dist(a, b)
	return #(vector3(a.x, a.y, a.z) - vector3(b.x, b.y, b.z))
end

local function nearHouse(src, house)
	if not house or not house.Entercoords then return false end
	local ped = GetPlayerPed(src)
	if ped == 0 then return false end
	local pcoords = GetEntityCoords(ped)
	return dist(pcoords, house.Entercoords) <= ConfigSV.MaxActionDistance
end

-- ---------------------------------------------------------------------------
-- Lazy single-record fetch (mirrors client's `reqHouse` -> getHouse callback)
-- Used for apartment units, which are NOT included in the initial set_houses
-- broadcast (only the building + unit-id index is).
-- ---------------------------------------------------------------------------
ESX.RegisterServerCallback('sunset_housing:getHouse', function(source, cb, id)
	if ApartmentUnits[id] then
		return cb(ApartmentUnits[id])
	end
	SH_DB.GetApartmentUnit(id, function(row)
		if row then
			ApartmentUnits[id] = SH_BuildApartmentUnitRecord(row)
			cb(ApartmentUnits[id])
		else
			cb(Houses[id])
		end
	end)
end)

-- ---------------------------------------------------------------------------
-- Admin: add / edit / delete a single house
-- Real ownership/permission gating for the add/edit/delete menus is handled
-- client-side via esx_aduty:getAdminPerm before these ever fire; this is a
-- second belt-and-suspenders check.
-- ---------------------------------------------------------------------------
local function isAdmin(src)
	local xPlayer = ESX.GetPlayerFromId(src)
	return xPlayer and (xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin')
end

RegisterServerEvent('sunset_housing:AddHouse')
AddEventHandler('sunset_housing:AddHouse', function(adddata)
	local src = source
	if not isAdmin(src) then return end
	if not adddata or not adddata.enter or not adddata.interior or not adddata.price then return end

	SH_DB.InsertHouse({
		owner        = nil,
		entercoords  = json.encode(adddata.enter),
		garagecoords = adddata.entergarage and json.encode(adddata.entergarage) or nil,
		shell        = adddata.interior,
		shellgarage  = adddata.interiorgarage,
		price        = adddata.price,
	}, function(newId)
		if not newId then return end
		SH_DB.GetHouse(newId, function(row)
			Houses[newId] = SH_BuildHouseRecord(row)
			TriggerClientEvent('sunset_housing:AddHouse', -1, Houses[newId])
		end)
	end)
end)

RegisterServerEvent('sunset_housing:EditHouse')
AddEventHandler('sunset_housing:EditHouse', function(editdata)
	local src = source
	if not isAdmin(src) then return end
	if not editdata or not editdata.id or not Houses[editdata.id] then return end

	local params = {}
	if editdata.coords then params['@entercoords'] = json.encode(editdata.coords) end
	if editdata.price then params['@price'] = editdata.price end
	if editdata.shell then params['@shell'] = editdata.shell end

	SH_DB.UpdateHouse(editdata.id, params, function()
		SH_DB.GetHouse(editdata.id, function(row)
			Houses[editdata.id] = SH_BuildHouseRecord(row)
			TriggerClientEvent('sunset_housing:updatehouse', -1, editdata.id, Houses[editdata.id])
		end)
	end)
end)

RegisterServerEvent('sunset_housing:DeleteHouse')
AddEventHandler('sunset_housing:DeleteHouse', function(editdata)
	local src = source
	if not isAdmin(src) then return end
	local id = editdata and editdata.id
	if not id or not Houses[id] then return end

	SH_DB.DeleteHouse(id, function()
		Houses[id] = nil
		TriggerClientEvent('sunset_housing:DeleteHouse', -1, id)
	end)
end)

-- ---------------------------------------------------------------------------
-- Admin: add an apartment unit into an existing apartment building
-- adddata2 = {price, floor, interior = shellName, enter = apartmentBuildingId}
-- ---------------------------------------------------------------------------
RegisterServerEvent('sunset_housing:AddAP')
AddEventHandler('sunset_housing:AddAP', function(adddata2)
	local src = source
	if not isAdmin(src) then return end
	if not adddata2 or not adddata2.enter or not adddata2.interior or not adddata2.price or not adddata2.floor then return end

	local apartmentId = adddata2.enter
	if not Apartments[apartmentId] then return end

	SH_DB.InsertApartmentUnit({
		apartment_id = apartmentId,
		floor        = adddata2.floor,
		shell        = adddata2.interior,
		price        = adddata2.price,
	}, function(newId)
		if not newId then return end
		ApartmentUnits[newId] = SH_BuildApartmentUnitRecord({
			id = newId, apartment_id = apartmentId, floor = adddata2.floor,
			shell = adddata2.interior, price = adddata2.price,
			inventorylevel = 1, safelevel = 1, furniture = '[]',
		})
		if not ApartmentUnitIndex[apartmentId] then ApartmentUnitIndex[apartmentId] = { house = {} } end
		table.insert(ApartmentUnitIndex[apartmentId].house, { id = newId })
		TriggerClientEvent('sunset_housing:set_houses', -1, Houses, Apartments, ApartmentUnitIndex)
	end)
end)

-- ---------------------------------------------------------------------------
-- Enter / exit tracking - mostly bookkeeping, actual teleport is client-side
-- ---------------------------------------------------------------------------
RegisterServerEvent('sunset_housing:Exit')
AddEventHandler('sunset_housing:Exit', function()
	InsideHouse[source] = nil
end)

RegisterServerEvent('sunset_housing:JoinGuest')
AddEventHandler('sunset_housing:JoinGuest', function(id)
	InsideHouse[source] = id
end)

AddEventHandler('playerDropped', function()
	InsideHouse[source] = nil
end)

-- ---------------------------------------------------------------------------
-- Invites: owner picks a nearby player from GetPosht, we let them in
-- ---------------------------------------------------------------------------
ESX.RegisterServerCallback('sunset_housing:GetPosht', function(source, cb, houseId)
	local house = Houses[houseId] or ApartmentUnits[houseId]
	local players = {}
	if house and house.Entercoords then
		for _, playerId in ipairs(GetPlayers()) do
			playerId = tonumber(playerId)
			if playerId ~= source then
				local ped = GetPlayerPed(playerId)
				if ped ~= 0 then
					local pcoords = GetEntityCoords(ped)
					if dist(pcoords, house.Entercoords) <= 10.0 then
						table.insert(players, { id = playerId, name = GetPlayerName(playerId) })
					end
				end
			end
		end
	end
	cb(players)
end)

RegisterServerEvent('sunset_housing:AcceptInvite')
AddEventHandler('sunset_housing:AcceptInvite', function(targetId, houseId)
	local src = source
	local house = Houses[houseId] or ApartmentUnits[houseId]
	if not house then return end
	-- only the owner (or someone already inside) may invite others in
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end
	if house.Owner ~= xPlayer.identifier and InsideHouse[src] ~= houseId then return end

	targetId = tonumber(targetId)
	if not targetId or not GetPlayerName(targetId) then return end

	InsideHouse[targetId] = houseId
	TriggerClientEvent('sunset_housing:JoinGuest', targetId, houseId)
end)

-- ---------------------------------------------------------------------------
-- Furniture: place / replace / delete
-- data = {item = {id, object, price, name}, pos = vector3(relative to shell), rot = vector3, id = <existing furniture id, only on replace>}
-- ---------------------------------------------------------------------------
ESX.RegisterServerCallback('sunset_housing:CanBuy', function(source, cb, price)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return cb(false) end
	price = tonumber(price) or 0
	cb(xPlayer.getMoney() >= price)
end)

local function saveFurniture(houseId, furniture)
	local house = Houses[houseId]
	if house then
		house.Furniture = furniture
		SH_DB.UpdateHouse(houseId, { ['@furniture'] = json.encode(furniture) })
		return
	end
	local unit = ApartmentUnits[houseId]
	if unit then
		unit.Furniture = furniture
		SH_DB.UpdateApartmentUnit(houseId, { ['@furniture'] = json.encode(furniture) })
	end
end

RegisterServerEvent('sunset_housing:PlaceObject')
AddEventHandler('sunset_housing:PlaceObject', function(houseId, data)
	local src = source
	local house = Houses[houseId] or ApartmentUnits[houseId]
	if not house or not data or not data.item then return end

	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end

	local price = tonumber(data.item.price) or 0
	if ConfigSV.RevalidateFurniturePrice and xPlayer.getMoney() < price then
		TriggerClientEvent('esx:showNotification', src, 'Poul kafi nadarid')
		return
	end
	if ConfigSV.RevalidateFurniturePrice and price > 0 then
		xPlayer.removeMoney(price)
	end

	local furniture = house.Furniture or {}
	local newId = #furniture + 1
	table.insert(furniture, { id = newId, item = data.item, pos = data.pos, rot = data.rot })
	saveFurniture(houseId, furniture)

	TriggerClientEvent('sunset_housing:updatehouse', -1, houseId, house)
end)

RegisterServerEvent('sunset_housing:ReplaceFurniture')
AddEventHandler('sunset_housing:ReplaceFurniture', function(houseId, data)
	local house = Houses[houseId] or ApartmentUnits[houseId]
	if not house or not data or not data.id then return end

	local furniture = house.Furniture or {}
	for _, f in ipairs(furniture) do
		if f.id == data.id then
			f.item = data.item
			f.pos  = data.pos
			f.rot  = data.rot
			break
		end
	end
	saveFurniture(houseId, furniture)
	TriggerClientEvent('sunset_housing:updatehouse', -1, houseId, house)
end)

RegisterServerEvent('sunset_housing:DeleteFurniture')
AddEventHandler('sunset_housing:DeleteFurniture', function(houseId, furnitureId)
	local house = Houses[houseId] or ApartmentUnits[houseId]
	if not house then return end

	local furniture = house.Furniture or {}
	for i, f in ipairs(furniture) do
		if f.id == furnitureId then
			table.remove(furniture, i)
			break
		end
	end
	saveFurniture(houseId, furniture)
	TriggerClientEvent('sunset_housing:updatehouse', -1, houseId, house)
end)

-- ---------------------------------------------------------------------------
-- House data / upgrades
-- ---------------------------------------------------------------------------
ESX.RegisterServerCallback('sunset_housing:GetHouseData', function(source, cb, houseId)
	cb(Houses[houseId] or ApartmentUnits[houseId])
end)

RegisterServerEvent('sunset_housing:UpgradeHouseInventory')
AddEventHandler('sunset_housing:UpgradeHouseInventory', function(houseId)
	local src = source
	local house = Houses[houseId] or ApartmentUnits[houseId]
	if not house then return end
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or house.Owner ~= xPlayer.identifier then return end

	local shellCfg = Config.ShellCoords[house.Shell]
	local nextLevel = shellCfg and shellCfg.InventoryLevel[house.inventorylevel + 1]
	if not nextLevel then return end
	if xPlayer.getMoney() < nextLevel.Price then
		TriggerClientEvent('esx:showNotification', src, 'Poul kafi nadarid')
		return
	end

	xPlayer.removeMoney(nextLevel.Price)
	house.inventorylevel = house.inventorylevel + 1

	if Houses[houseId] then
		SH_DB.UpdateHouse(houseId, { ['@inventorylevel'] = house.inventorylevel })
	else
		SH_DB.UpdateApartmentUnit(houseId, { ['@inventorylevel'] = house.inventorylevel })
	end
	TriggerClientEvent('sunset_housing:updatehouse', -1, houseId, house)
end)

RegisterServerEvent('sunset_housing:UpgradeHouseSafe')
AddEventHandler('sunset_housing:UpgradeHouseSafe', function(houseId)
	local src = source
	local house = Houses[houseId] or ApartmentUnits[houseId]
	if not house then return end
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or house.Owner ~= xPlayer.identifier then return end

	local shellCfg = Config.ShellCoords[house.Shell]
	local nextLevel = shellCfg and shellCfg.SafeLevel[house.safelevel + 1]
	if not nextLevel then return end
	if xPlayer.getMoney() < nextLevel.Price then
		TriggerClientEvent('esx:showNotification', src, 'Poul kafi nadarid')
		return
	end

	xPlayer.removeMoney(nextLevel.Price)
	house.safelevel = house.safelevel + 1

	if Houses[houseId] then
		SH_DB.UpdateHouse(houseId, { ['@safelevel'] = house.safelevel })
	else
		SH_DB.UpdateApartmentUnit(houseId, { ['@safelevel'] = house.safelevel })
	end
	TriggerClientEvent('sunset_housing:updatehouse', -1, houseId, house)
end)

-- Buying a house/unit (not directly wired to a client event name we found,
-- exposed as a callback other menus/events can call into)
function SH_BuyHouse(src, houseId)
	local house = Houses[houseId] or ApartmentUnits[houseId]
	if not house or house.Owner then return false, 'Already owned' end

	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return false end
	if xPlayer.getMoney() < house.Price then return false, 'Not enough money' end

	xPlayer.removeMoney(house.Price)
	house.Owner = xPlayer.identifier

	if Houses[houseId] then
		SH_DB.UpdateHouse(houseId, { ['@owner'] = house.Owner })
	else
		SH_DB.UpdateApartmentUnit(houseId, { ['@owner'] = house.Owner })
	end
	TriggerClientEvent('sunset_housing:updatehouse', -1, houseId, house)
	return true
end

-- ---------------------------------------------------------------------------
-- House garage (self-contained, separate from the job-based Unique_Garage)
-- ---------------------------------------------------------------------------
ESX.RegisterServerCallback('sunset_housing:GetHouseGarage', function(source, cb, houseId)
	MySQL.Async.fetchAll('SELECT * FROM sh_garage_vehicles WHERE house_id = @id', { ['@id'] = houseId }, function(rows)
		local vehicles = {}
		for _, row in ipairs(rows or {}) do
			table.insert(vehicles, {
				plate   = row.plate,
				vehicle = row.vehicle and json.decode(row.vehicle) or nil,
				stored  = row.stored,
				owner   = row.owner,
			})
		end
		cb(vehicles)
	end)
end)

RegisterServerEvent('garage:setVehicleState')
AddEventHandler('garage:setVehicleState', function(houseId, plate, stored, props)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or not plate then return end

	MySQL.Async.fetchAll('SELECT id FROM sh_garage_vehicles WHERE plate = @plate', { ['@plate'] = plate }, function(rows)
		if rows and rows[1] then
			MySQL.Async.execute('UPDATE sh_garage_vehicles SET stored = @stored, vehicle = @vehicle WHERE plate = @plate', {
				['@stored']  = stored and 1 or 0,
				['@vehicle'] = props and json.encode(props) or nil,
				['@plate']   = plate,
			})
		else
			MySQL.Async.insert('INSERT INTO sh_garage_vehicles (house_id, owner, plate, vehicle, stored) VALUES (@house_id, @owner, @plate, @vehicle, @stored)', {
				['@house_id'] = houseId,
				['@owner']    = xPlayer.identifier,
				['@plate']    = plate,
				['@vehicle']  = props and json.encode(props) or nil,
				['@stored']   = stored and 1 or 0,
			})
		end
	end)
end)

RegisterServerEvent('sunset_housing:ReloadHouseVeh')
AddEventHandler('sunset_housing:ReloadHouseVeh', function(houseId)
	-- client just re-requests GetHouseGarage right after this fires;
	-- nothing to push server->client here, kept for parity with client code.
end)
