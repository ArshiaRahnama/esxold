-- ============================================================================
-- Sunset Housing - inventory / safe / postbox storage
-- Mirrors the get/put shape client/functions.lua already expects from
-- sun-inventory-hud (openOtherInventory / sortItems), and reuses the
-- items+weapons storage pattern esx_inventoryhud already uses for bags/trunks
-- (server/bag.lua, server/trunk.lua) - just its own table (sh_storage) keyed
-- by a name like 'house_12', 'house_safe_12', 'house_postbox_12'.
-- ============================================================================

local function storageName(houseId, kind)
	if kind == 'safe' then return 'house_safe_' .. houseId end
	if kind == 'postbox' then return 'house_postbox_' .. houseId end
	return 'house_' .. houseId
end

local function loadStorage(name, cb)
	MySQL.Async.fetchAll('SELECT items, weapons FROM sh_storage WHERE name = @name', { ['@name'] = name }, function(rows)
		if rows and rows[1] then
			local ok1, items = pcall(json.decode, rows[1].items or '[]')
			local ok2, weapons = pcall(json.decode, rows[1].weapons or '[]')
			cb(ok1 and items or {}, ok2 and weapons or {})
		else
			MySQL.Async.execute('INSERT INTO sh_storage (name, items, weapons) VALUES (@name, @items, @weapons)', {
				['@name'] = name, ['@items'] = '[]', ['@weapons'] = '[]',
			})
			cb({}, {})
		end
	end)
end

local function saveStorage(name, items, weapons)
	MySQL.Async.execute('UPDATE sh_storage SET items = @items, weapons = @weapons WHERE name = @name', {
		['@name']    = name,
		['@items']   = json.encode(items),
		['@weapons'] = json.encode(weapons),
	})
end

local function getShellSize(house, kind)
	local shellCfg = Config.ShellCoords and Config.ShellCoords[house.Shell]
	if not shellCfg then return 9999 end
	if kind == 'safe' then
		return (shellCfg.SafeLevel and shellCfg.SafeLevel[house.safelevel] and shellCfg.SafeLevel[house.safelevel].Size) or 9999
	end
	return (shellCfg.InventoryLevel and shellCfg.InventoryLevel[house.inventorylevel] and shellCfg.InventoryLevel[house.inventorylevel].Size) or 9999
end

local function getHouseById(houseId)
	return Houses[houseId] or ApartmentUnits[houseId]
end

-- ---------------------------------------------------------------------------
-- Callbacks: sun-inventory-hud reads these when opening a house's
-- inventory/safe/postbox (client/functions.lua -> getHouseInventory)
-- ---------------------------------------------------------------------------

local function registerFetchCallback(eventName, kind)
	ESX.RegisterServerCallback(eventName, function(source, cb, houseId)
		local house = getHouseById(houseId)
		if not house then return cb({ items = {}, weapons = {}, hex = storageName(houseId, kind) }) end

		local name = storageName(houseId, kind)
		loadStorage(name, function(items, weapons)
			cb({ items = items, weapons = weapons, hex = name })
		end)
	end)
end

registerFetchCallback('sunset_housing:GetHouseInventory', 'main')
registerFetchCallback('sunset_housing:GetHouseSafe', 'safe')
registerFetchCallback('sunset_housing:getHousePostBox', 'postbox')

-- ---------------------------------------------------------------------------
-- move item FROM player's main inventory INTO the house storage
-- args from client: (hex, houseId, itemType, itemName, count, data)
-- ---------------------------------------------------------------------------
RegisterServerEvent('sunset_housing:inventory:put')
AddEventHandler('sunset_housing:inventory:put', function(hex, houseId, itemType, itemName, count, data)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or not itemName then return end

	local house = getHouseById(houseId)
	if not house then return end

	count = tonumber(count) or 1

	if itemType == 'item_weapon' then
		local weapon = xPlayer.getWeapon(itemName)
		if not weapon then return end

		xPlayer.removeWeapon(itemName)

		loadStorage(hex, function(items, weapons)
			table.insert(weapons, { name = itemName, ammo = weapon.ammo, components = weapon.components, tintIndex = weapon.tintIndex })
			saveStorage(hex, items, weapons)
		end)
	else
		local sourceItem = xPlayer.getInventoryItem(itemName)
		if not sourceItem or sourceItem.count < count then return end

		loadStorage(hex, function(items, weapons)
			local total = #items + #weapons
			local max = getShellSize(house, hex:find('safe') and 'safe' or 'main')
			if total >= max then
				TriggerClientEvent('esx:showNotification', src, 'Anbar khane por shode ast')
				return
			end

			xPlayer.removeInventoryItem(itemName, count)

			local found = false
			for _, entry in ipairs(items) do
				if entry.name == itemName then
					entry.count = entry.count + count
					found = true
					break
				end
			end
			if not found then
				table.insert(items, { name = itemName, count = count, slot = data and data.droppedTo })
			end
			saveStorage(hex, items, weapons)
		end)
	end
end)

-- ---------------------------------------------------------------------------
-- move item FROM house storage INTO player's main inventory
-- args from client: (hex, houseId, itemType, itemName, count, data)
-- ---------------------------------------------------------------------------
RegisterServerEvent('sunset_housing:inventory:get')
AddEventHandler('sunset_housing:inventory:get', function(hex, houseId, itemType, itemName, count, data)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or not itemName then return end

	count = tonumber(count) or 1

	if itemType == 'item_weapon' then
		loadStorage(hex, function(items, weapons)
			for i, w in ipairs(weapons) do
				if w.name == itemName then
					table.remove(weapons, i)
					xPlayer.addWeapon(itemName, w.ammo or 0)
					saveStorage(hex, items, weapons)
					return
				end
			end
		end)
	else
		loadStorage(hex, function(items, weapons)
			for i, entry in ipairs(items) do
				if entry.name == itemName then
					local take = math.min(count, entry.count)
					if take < 1 then return end
					if not xPlayer.canCarryItem(itemName, take) then
						TriggerClientEvent('esx:showNotification', src, 'Vazn Zaiad Ast !')
						return
					end
					entry.count = entry.count - take
					if entry.count <= 0 then table.remove(items, i) end
					saveStorage(hex, items, weapons)
					xPlayer.addInventoryItem(itemName, take)
					return
				end
			end
		end)
	end
end)

-- ---------------------------------------------------------------------------
-- drag/drop slot repositioning within a house's storage
-- args from client: (houseId, hex, data)  where data.name + data.droppedTo/slot
-- ---------------------------------------------------------------------------
RegisterServerEvent('housing:inventory:updateSlot')
AddEventHandler('housing:inventory:updateSlot', function(houseId, hex, data)
	if not data or not data.name then return end

	loadStorage(hex, function(items, weapons)
		for _, entry in ipairs(items) do
			if entry.name == data.name then
				entry.slot = data.droppedTo or data.slot
			end
		end
		saveStorage(hex, items, weapons)
	end)
end)
