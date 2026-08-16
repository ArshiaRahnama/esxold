--[[
	Server side for the 3 corp jobs sitting on top of the 17 businesses.
	See shared/corp.lua for the numbers (cuts, cooldowns, markup).
]]

for _, corp in pairs({ Corp.Meridian, Corp.Blacktide, Corp.CrateCarry }) do
	TriggerEvent('esx_society:registerSociety', corp.Job, corp.Label, 'society_' .. corp.Job, 'society_' .. corp.Job, 'society_' .. corp.Job, { type = 'public' })
end

RegisterNetEvent('uniquecafejobs:corp:spawnVehicle')
AddEventHandler('uniquecafejobs:corp:spawnVehicle', function(vehicleName)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == Corp.Meridian.Job and vehicleName == Corp.Meridian.SpawnVehicle then
		TriggerClientEvent('spawnCarClientCorp', source, vehicleName)
	elseif xPlayer.job.name == Corp.Blacktide.Job and vehicleName == Corp.Blacktide.SpawnVehicle then
		TriggerClientEvent('spawnCarClientCorp', source, vehicleName)
	elseif xPlayer.job.name == Corp.CrateCarry.Job and vehicleName == Corp.CrateCarry.SpawnVehicle then
		TriggerClientEvent('spawnCarClientCorp', source, vehicleName)
	end
end)

-- ══════════════════════════ Meridian Holdings ══════════════════════════

local lastFranchiseCollect = 0 -- os.time() of the last successful collection, server-wide

RegisterNetEvent('uniquecafejobs:corp:requestPortfolio')
AddEventHandler('uniquecafejobs:corp:requestPortfolio', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.name ~= Corp.Meridian.Job then return end

	local rows = {}
	local pending = 0
	for _, cafe in pairs(Cafes) do
		pending = pending + 1
	end

	local function finish()
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. Corp.Meridian.Job, function(mAccount)
			local canCollect = (os.time() - lastFranchiseCollect) >= (Corp.Meridian.CollectCooldownMins * 60)
			table.sort(rows, function(a, b) return a.label < b.label end)
			TriggerClientEvent('uniquecafejobs:corp:showPortfolio', src, rows, canCollect, mAccount.money)
		end)
	end

	for _, cafe in pairs(Cafes) do
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. cafe.Job, function(account)
			table.insert(rows, { label = cafe.Label, balance = account.money })
			pending = pending - 1
			if pending == 0 then finish() end
		end)
	end
end)

RegisterNetEvent('uniquecafejobs:corp:collectFranchiseFee')
AddEventHandler('uniquecafejobs:corp:collectFranchiseFee', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.name ~= Corp.Meridian.Job then return end

	if (os.time() - lastFranchiseCollect) < (Corp.Meridian.CollectCooldownMins * 60) then
		TriggerClientEvent('esx:showNotification', src, 'Franchise fee already collected recently.')
		return
	end
	lastFranchiseCollect = os.time()

	local totalCollected = 0
	for _, cafe in pairs(Cafes) do
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. cafe.Job, function(account)
			local fee = math.floor(account.money * Corp.Meridian.FranchiseFeePercent / 100)
			if fee > 0 then
				account.removeMoney(fee)
				TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. Corp.Meridian.Job, function(mAccount)
					mAccount.addMoney(fee)
				end)
			end
		end)
	end

	TriggerClientEvent('esx:showNotification', src, 'Franchise fees collected from all 17 businesses.')
end)

-- ══════════════════════════ Blacktide Logistics (laundering) ══════════════════════════

local lastWash = {} -- [identifier] = os.time()

RegisterNetEvent('uniquecafejobs:corp:launder')
AddEventHandler('uniquecafejobs:corp:launder', function(businessJob)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.name ~= Corp.Blacktide.Job then return end
	if not GetCafeForJob(businessJob) then return end

	local now = os.time()
	if lastWash[xPlayer.identifier] and (now - lastWash[xPlayer.identifier]) < Corp.Blacktide.CooldownSeconds then
		local wait = Corp.Blacktide.CooldownSeconds - (now - lastWash[xPlayer.identifier])
		TriggerClientEvent('esx:showNotification', src, ('Bayad %d sanie sabr konid.'):format(wait))
		return
	end

	local dirty = xPlayer.getAccount('black_money').money
	if dirty <= 0 then
		TriggerClientEvent('esx:showNotification', src, 'Pool kasif (black_money) nadarid.')
		return
	end

	local amount = math.min(dirty, Corp.Blacktide.MaxPerWash)
	xPlayer.removeAccountMoney('black_money', amount)

	local blacktideCut = math.floor(amount * Corp.Blacktide.LaunderCutPercent / 100)
	local businessCut  = math.floor(amount * Corp.Blacktide.BusinessCutPercent / 100)

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. Corp.Blacktide.Job, function(account)
		account.addMoney(blacktideCut)
	end)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. businessJob, function(account)
		account.addMoney(businessCut)
	end)

	lastWash[xPlayer.identifier] = now
	TriggerClientEvent('esx:showNotification', src, ('Shoma $%d pool kasif shostid, Blacktide $%d gereft.'):format(amount, blacktideCut))
end)

-- ══════════════════════════ Crate & Carry (wholesale + resale) ══════════════════════════

RegisterNetEvent('uniquecafejobs:corp:openWholesaleMenu')
AddEventHandler('uniquecafejobs:corp:openWholesaleMenu', function(businessJob)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.name ~= Corp.CrateCarry.Job then return end
	local cafe = GetCafeForJob(businessJob)
	if not cafe then return end

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. businessJob, function(inventory)
		local stock = {}
		if inventory then
			for _, v in pairs(inventory.items) do
				if v.count > 0 then
					table.insert(stock, { name = v.name, label = v.label, count = v.count })
				end
			end
		end
		TriggerClientEvent('uniquecafejobs:corp:showWholesaleMenu', src, businessJob, cafe.Label, stock)
	end)
end)

RegisterNetEvent('uniquecafejobs:corp:buyWholesale')
AddEventHandler('uniquecafejobs:corp:buyWholesale', function(businessJob, itemName, quantity)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.name ~= Corp.CrateCarry.Job then return end
	if not GetCafeForJob(businessJob) then return end

	quantity = tonumber(quantity)
	if not quantity or quantity <= 0 or quantity > Corp.CrateCarry.WholesaleBuyLimit then
		TriggerClientEvent('esx:showNotification', src, 'Meghdar nامعتبره.')
		return
	end

	local cost = quantity * Corp.CrateCarry.WholesaleUnitPrice

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. Corp.CrateCarry.Job, function(buyerAccount)
		if buyerAccount.money < cost then
			TriggerClientEvent('esx:showNotification', src, 'Pool sosayeti Crate & Carry kafi nist.')
			return
		end

		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. businessJob, function(sourceInv)
			local sourceItem = sourceInv.getItem(itemName)
			if not sourceItem or sourceItem.count < quantity then
				TriggerClientEvent('esx:showNotification', src, 'In meghdar dar anbar mojood nist.')
				return
			end

			sourceInv.removeItem(itemName, quantity)
			buyerAccount.removeMoney(cost)

			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. businessJob, function(businessAccount)
				businessAccount.addMoney(cost)
			end)

			TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. Corp.CrateCarry.Job, function(myInv)
				myInv.addItem(itemName, quantity)
			end)

			TriggerClientEvent('esx:showNotification', src, ('%d x %s kharidari shod.'):format(quantity, sourceItem.label))
		end)
	end)
end)

RegisterNetEvent('uniquecafejobs:corp:openResaleShop')
AddEventHandler('uniquecafejobs:corp:openResaleShop', function()
	local src = source
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. Corp.CrateCarry.Job, function(inventory)
		local stock = {}
		if inventory then
			for _, v in pairs(inventory.items) do
				if v.count > 0 then
					table.insert(stock, {
						name  = v.name,
						label = v.label,
						count = v.count,
						price = math.ceil(Corp.CrateCarry.WholesaleUnitPrice * Corp.CrateCarry.Markup),
					})
				end
			end
		end
		TriggerClientEvent('uniquecafejobs:corp:showResaleShop', src, stock)
	end)
end)

RegisterNetEvent('uniquecafejobs:corp:buyResale')
AddEventHandler('uniquecafejobs:corp:buyResale', function(itemName)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end

	local price = math.ceil(Corp.CrateCarry.WholesaleUnitPrice * Corp.CrateCarry.Markup)

	if xPlayer.getMoney() < price then
		TriggerClientEvent('esx:showNotification', src, 'Pool kafi nadarid.')
		return
	end

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. Corp.CrateCarry.Job, function(inventory)
		local item = inventory.getItem(itemName)
		if not item or item.count < 1 then
			TriggerClientEvent('esx:showNotification', src, 'Faroosh shode, mojood nist.')
			return
		end

		local playerItem = xPlayer.getInventoryItem(itemName)
		if playerItem.limit ~= -1 and (playerItem.count + 1) > playerItem.limit then
			TriggerClientEvent('esx:showNotification', src, 'Nemitavanid bishtar az in negah darid.')
			return
		end

		xPlayer.removeMoney(price)
		inventory.removeItem(itemName, 1)
		xPlayer.addInventoryItem(itemName, 1)

		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. Corp.CrateCarry.Job, function(account)
			account.addMoney(price)
		end)

		TriggerClientEvent('esx:showNotification', src, ('Shoma %s ro kharidid.'):format(item.label))
	end)
end)
