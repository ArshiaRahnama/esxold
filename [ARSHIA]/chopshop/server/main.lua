ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Session-only tracking (no DB table for this exists on the server, and the vehicle
-- entity is deleted once chopped anyway, so a plate can't realistically be re-chopped
-- within the same uptime). Resets on resource/server restart.
local choppedPlates     = {}
local choppingInProgress = {}

local function trim(s)
	return s and s:gsub('^%s+', ''):gsub('%s+$', '') or s
end

-- ============================================================
-- Eligibility check ("carlock:isVehicleowned")
-- Returns true when the vehicle is safe to chop: either it isn't a
-- registered/owned vehicle at all, or it's registered to someone other than
-- the calling player / their gang. Mirrors the same ownership pattern used
-- in Unique_Pack's chop shop (engine:checkVehicleOwnership).
-- ============================================================
ESX.RegisterServerCallback('carlock:isVehicleowned', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	plate = trim(plate)

	if not plate or plate == '' or not xPlayer then
		cb(false)
		return
	end

	exports.oxmysql:scalar('SELECT owner FROM owned_vehicles WHERE plate = ?', { plate }, function(owner)
		if not owner then
			-- Not in owned_vehicles at all -> treat as eligible
			cb(true)
			return
		end

		local isMine = (owner == xPlayer.identifier) or (xPlayer.gang and owner == xPlayer.gang.name)
		cb(not isMine)
	end)
end)

-- ============================================================
-- Already-chopped check ("choped")
-- ============================================================
ESX.RegisterServerCallback('choped', function(source, cb, plate)
	plate = trim(plate)
	cb(choppedPlates[plate] == true)
end)

-- ============================================================
-- Chop started: mark the plate as "in progress" so it can't be double
-- started by someone else while the timer is running.
-- ============================================================
RegisterNetEvent('startchop')
AddEventHandler('startchop', function(vehNetId)
	local vehicle = NetworkGetEntityFromNetworkId(vehNetId)
	if not DoesEntityExist(vehicle) then return end

	local plate = trim(GetVehicleNumberPlateText(vehicle))
	choppingInProgress[plate] = true
end)

-- ============================================================
-- Chop finished: called by the client once the timer completes.
-- Marks the plate permanently chopped for this session and rewards the
-- player with a random tiered scrap-engine item (this reward step did not
-- exist in the original client code at all — the vehicle was simply left
-- sitting in the world with nothing given to the player).
-- ============================================================
RegisterNetEvent('chop:finish')
AddEventHandler('chop:finish', function(vehNetId, plate)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end

	plate = trim(plate)
	if not plate or plate == '' then return end

	if not choppingInProgress[plate] then
		-- Never started server-side (or already finished) — ignore to avoid abuse
		return
	end

	choppingInProgress[plate] = nil
	choppedPlates[plate] = true

	local tier = math.random(1, 6)
	local item = 'engine' .. tier
	xPlayer.addInventoryItem(item, 1)
	TriggerClientEvent('esx:showNotification', src, 'Shoma 1x ' .. item .. ' Daryaft Kardid!')
end)

-- ============================================================
-- Craft lockpick ("chop:craft")
-- Requirements shown in the client menu: 1x shahkelid, 1x iron, 1x blowtorch.
-- 'iron' and 'blowtorch' already exist as items on this server; 'shahkelid'
-- does not and needs to be added (see accompanying SQL snippet).
-- ============================================================
local LOCKPICK_CRAFT_REQUIREMENTS = {
	{ item = 'shahkelid', count = 1 },
	{ item = 'iron',      count = 1 },
	{ item = 'blowtorch', count = 1 },
}

RegisterNetEvent('chop:craft')
AddEventHandler('chop:craft', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end

	for _, req in ipairs(LOCKPICK_CRAFT_REQUIREMENTS) do
		local invItem = xPlayer.getInventoryItem(req.item)
		if not invItem or invItem.count < req.count then
			TriggerClientEvent('esx:showNotification', src, 'Shoma Vasayel Kafi Baraye Craft Nadarid!')
			return
		end
	end

	for _, req in ipairs(LOCKPICK_CRAFT_REQUIREMENTS) do
		xPlayer.removeInventoryItem(req.item, req.count)
	end

	xPlayer.addInventoryItem('lockpick', 1)
	TriggerClientEvent('esx:showNotification', src, 'Shoma 1x Lockpick Craft Kardid!')
end)

-- ============================================================
-- Craft engine ("chop:craftengine") — MECHANIC JOB ONLY. Pay money for a
-- tiered scrap engine item. Uses Config.craftengine[key] as the cost table
-- (only 'money' entries are supported, matching what's actually defined in
-- config.lua).
-- ============================================================
RegisterNetEvent('chop:craftengine')
AddEventHandler('chop:craftengine', function(key)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end

	if not xPlayer.job or xPlayer.job.name ~= 'mechanic' then
		TriggerClientEvent('esx:showNotification', src, 'In Kar Faghat Baraye Mechanic Hast!')
		return
	end

	local requirements = Config.craftengine[key]
	if not requirements then return end

	local totalCost = 0
	for _, req in ipairs(requirements) do
		if req.type == 'money' then
			totalCost = totalCost + req.count
		end
	end

	-- FIX: essentialmode's xPlayer has no getMoney() method — money is
	-- the .money property directly.
	if xPlayer.money < totalCost then
		TriggerClientEvent('esx:showNotification', src, 'Pool Kafi Nadarid!')
		return
	end

	xPlayer.removeMoney(totalCost)
	xPlayer.addInventoryItem('engine' .. key, 1)
	TriggerClientEvent('esx:showNotification', src, 'Shoma 1x Engine X' .. key .. ' Craft Kardid!')
end)

-- ============================================================
-- Buy screwdriver ("chop:buypich") — flat price from Config.tokenzero.
-- 'hotwire' ("Pich Goshti") is the existing item on this server matching
-- the "Pich gousti" label shown in the client buy menu.
-- ============================================================
RegisterNetEvent('chop:buypich')
AddEventHandler('chop:buypich', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end

	-- FIX: same getMoney() crash as chop:craftengine — use .money property
	if xPlayer.money < Config.tokenzero then
		TriggerClientEvent('esx:showNotification', src, 'Pool Kafi Nadarid!')
		return
	end

	xPlayer.removeMoney(Config.tokenzero)
	xPlayer.addInventoryItem('hotwire', 1)
	TriggerClientEvent('esx:showNotification', src, 'Shoma 1x Pich Goshti Kharidid!')
end)

-- ============================================================
-- Sell engine ("chop:sell") — removes the tiered engine item, pays out
-- Config.sell[key] (only 'money' entries are supported).
-- ============================================================
RegisterNetEvent('chop:sell')
AddEventHandler('chop:sell', function(key)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end

	local item = 'engine' .. key
	local invItem = xPlayer.getInventoryItem(item)
	if not invItem or invItem.count < 1 then
		TriggerClientEvent('esx:showNotification', src, 'Shoma In Item Ro Nadarid!')
		return
	end

	local rewards = Config.sell[key]
	if not rewards then return end

	xPlayer.removeInventoryItem(item, 1)

	local totalReward = 0
	for _, reward in ipairs(rewards) do
		if reward.type == 'money' then
			totalReward = totalReward + reward.count
		end
	end

	xPlayer.addMoney(totalReward)
	TriggerClientEvent('esx:showNotification', src, 'Shoma ' .. totalReward .. '$ Daryaft Kardid!')
end)
