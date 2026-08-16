--[[
	Client side for the 3 corp jobs. Reuses OpenCloakroomMenu() (from
	functions.lua) and esx_society's boss menu event - only the physical
	zones + a couple of bespoke menus (Portfolio / Launder / Wholesale) are
	new here.
]]

local function myCorpJob()
	if PlayerData.job.name == Corp.Meridian.Job then return Corp.Meridian end
	if PlayerData.job.name == Corp.Blacktide.Job then return Corp.Blacktide end
	if PlayerData.job.name == Corp.CrateCarry.Job then return Corp.CrateCarry end
	return nil
end

-- ── Blips ──
CreateThread(function()
	for _, corp in pairs({ Corp.Meridian, Corp.Blacktide, Corp.CrateCarry }) do
		local blip = AddBlipForCoord(corp.HQ.x, corp.HQ.y, corp.HQ.z)
		SetBlipSprite(blip, corp.Blip.Sprite)
		SetBlipColour(blip, corp.Blip.Color)
		SetBlipScale(blip, corp.Blip.Scale)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(corp.Label)
		EndTextCommandSetBlipName(blip)
	end
end)

-- ── Boss Action / Cloakroom zones (Meridian + Blacktide + CrateCarry) ──
local function addSimpleZone(coord, name, icon, job, event)
	exports.ox_target:addBoxZone({
		coords = vec3(coord.x, coord.y, coord.z),
		size = vec3(1.5, 1.5, 1.5),
		rotation = 45,
		debug = false,
		options = {
			{
				name = name,
				icon = icon,
				label = name,
				canInteract = function()
					return PlayerData.job and PlayerData.job.name == job
				end,
				onSelect = function()
					TriggerEvent(event)
				end,
			},
		},
	})
end

CreateThread(function()
	addSimpleZone(Corp.Meridian.BossAction.Pos, Corp.Meridian.BossAction.Name, Corp.Meridian.BossAction.Icon, Corp.Meridian.Job, 'uniquecafejobs:corp:openMeridianBoss')
	addSimpleZone(Corp.Meridian.CloackRoom.Pos, Corp.Meridian.CloackRoom.Name, Corp.Meridian.CloackRoom.Icon, Corp.Meridian.Job, 'uniquecafejobs:corp:openCloakroom')

	addSimpleZone(Corp.Blacktide.BossAction.Pos, Corp.Blacktide.BossAction.Name, Corp.Blacktide.BossAction.Icon, Corp.Blacktide.Job, 'uniquecafejobs:corp:openBlacktideBoss')
	addSimpleZone(Corp.Blacktide.CloackRoom.Pos, Corp.Blacktide.CloackRoom.Name, Corp.Blacktide.CloackRoom.Icon, Corp.Blacktide.Job, 'uniquecafejobs:corp:openCloakroom')

	addSimpleZone(Corp.CrateCarry.Freezer.Pos, Corp.CrateCarry.Freezer.Name, Corp.CrateCarry.Freezer.Icon, Corp.CrateCarry.Job, 'AH_uwucafejob:OpenInventory') -- reuse the existing freezer inventory menu for cratecarry's own warehouse stock
	addSimpleZone(Corp.CrateCarry.BossAction.Pos, Corp.CrateCarry.BossAction.Name, Corp.CrateCarry.BossAction.Icon, Corp.CrateCarry.Job, 'uniquecafejobs:corp:openCrateCarryBoss')
	addSimpleZone(Corp.CrateCarry.CloackRoom.Pos, Corp.CrateCarry.CloackRoom.Name, Corp.CrateCarry.CloackRoom.Icon, Corp.CrateCarry.Job, 'uniquecafejobs:corp:openCloakroom')

	-- Resale counter - open to EVERYONE (public customers), not job gated
	exports.ox_target:addBoxZone({
		coords = vec3(Corp.CrateCarry.ResaleShop.Pos.x, Corp.CrateCarry.ResaleShop.Pos.y, Corp.CrateCarry.ResaleShop.Pos.z),
		size = vec3(1.5, 1.5, 1.5),
		rotation = 45,
		debug = false,
		options = {
			{
				name = Corp.CrateCarry.ResaleShop.Name,
				icon = Corp.CrateCarry.ResaleShop.Icon,
				label = Corp.CrateCarry.ResaleShop.Name,
				onSelect = function()
					TriggerServerEvent('uniquecafejobs:corp:openResaleShop')
				end,
			},
		},
	})
end)

RegisterNetEvent('uniquecafejobs:corp:openCloakroom')
AddEventHandler('uniquecafejobs:corp:openCloakroom', function()
	OpenCloakroomMenu()
end)

RegisterNetEvent('uniquecafejobs:corp:openMeridianBoss')
AddEventHandler('uniquecafejobs:corp:openMeridianBoss', function()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'meridian_boss_root', {
		title    = 'Meridian Holdings',
		align    = 'top-left',
		elements = {
			{ label = 'Portfolio Dashboard', value = 'dashboard' },
			{ label = 'Manage Portfolio (Acquire / Rank Up)', value = 'portfolio' },
			{ label = 'VIP Partnerships', value = 'vip' },
			{ label = 'Manage Business Staff (Director+)', value = 'staff' },
		},
	}, function(data, menu)
		menu.close()
		if data.current.value == 'dashboard' then
			TriggerServerEvent('uniquecafejobs:corp:requestPortfolio')
		elseif data.current.value == 'portfolio' then
			TriggerServerEvent('uniquecafejobs:corp:requestManagePortfolio')
		elseif data.current.value == 'vip' then
			TriggerServerEvent('uniquecafejobs:corp:requestVIPPartnerships')
		elseif data.current.value == 'staff' then
			TriggerServerEvent('uniquecafejobs:corp:requestManageStaffList')
		end
	end, function(data, menu)
		menu.close()
	end)
end)

RegisterNetEvent('uniquecafejobs:corp:showPortfolio')
AddEventHandler('uniquecafejobs:corp:showPortfolio', function(rows, canCollect, meridianBalance)
	local elements = { { label = ('Meridian Balance: $%d'):format(meridianBalance), value = 'noop', disabled = true } }
	for _, row in ipairs(rows) do
		table.insert(elements, { label = ('%s: $%d'):format(row.label, row.balance), value = 'noop', disabled = true })
	end
	table.insert(elements, { label = canCollect and 'Collect Franchise Fee (' .. Corp.Meridian.FranchiseFeePercent .. '%)' or 'Franchise fee already collected recently', value = 'collect', disabled = not canCollect })

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'meridian_portfolio', {
		title    = 'Portfolio Dashboard',
		align    = 'top-left',
		elements = elements,
	}, function(data, menu)
		if data.current.value == 'collect' then
			TriggerServerEvent('uniquecafejobs:corp:collectFranchiseFee')
		end
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end)

RegisterNetEvent('uniquecafejobs:corp:showManagePortfolio')
AddEventHandler('uniquecafejobs:corp:showManagePortfolio', function(rows)
	local elements = {}
	for _, row in ipairs(rows) do
		local label
		if row.acquired then
			local nextRankCost = nil
			for i, r in ipairs(Corp.Meridian.Ranks) do
				if r.id == row.rank and Corp.Meridian.Ranks[i + 1] then
					nextRankCost = Corp.Meridian.Ranks[i + 1].label .. ' for $' .. Corp.Meridian.Ranks[i + 1].upgradeCost
				end
			end
			label = ('%s - %s rank%s'):format(row.label, row.rank:gsub("^%l", string.upper), nextRankCost and (' (upgrade to ' .. nextRankCost .. ')') or ' (MAX)')
		else
			label = ('%s - not acquired ($%d to acquire)'):format(row.label, Corp.Meridian.AcquireCost)
		end
		table.insert(elements, { label = label, value = row.job, acquired = row.acquired, maxed = row.acquired and row.rank == 'gold' })
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'meridian_manage_portfolio', {
		title    = 'Manage Portfolio',
		align    = 'top-left',
		elements = elements,
	}, function(data, menu)
		if data.current.acquired then
			if not data.current.maxed then
				TriggerServerEvent('uniquecafejobs:corp:upgradeBusiness', data.current.value)
			end
		else
			TriggerServerEvent('uniquecafejobs:corp:acquireBusiness', data.current.value)
		end
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end)

RegisterNetEvent('uniquecafejobs:corp:showVIPPartnerships')
AddEventHandler('uniquecafejobs:corp:showVIPPartnerships', function(rows)
	local elements = {}
	for _, row in ipairs(rows) do
		local label = row.partnered
			and (row.label .. ' - VIP Partner (15% flat cut active)')
			or (row.label .. (' - not partnered ($%d to sign)'):format(Corp.Meridian.VIPPartnershipCost))
		table.insert(elements, { label = label, value = row.job, partnered = row.partnered })
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'meridian_vip_partnerships', {
		title    = 'VIP Partnerships',
		align    = 'top-left',
		elements = elements,
	}, function(data, menu)
		if not data.current.partnered then
			TriggerServerEvent('uniquecafejobs:corp:signVIPPartnership', data.current.value)
		end
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end)

RegisterNetEvent('uniquecafejobs:corp:showManageStaffList')
AddEventHandler('uniquecafejobs:corp:showManageStaffList', function(rows)
	local elements = {}
	for _, row in ipairs(rows) do
		table.insert(elements, { label = row.label, value = row.job })
	end
	if #elements == 0 then
		table.insert(elements, { label = 'No businesses acquired or partnered yet', value = 'noop', disabled = true })
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'meridian_staff_list', {
		title    = 'Manage Business Staff',
		align    = 'top-left',
		elements = elements,
	}, function(data, menu)
		if data.current.value == 'noop' then return end
		local chosenJob = data.current.value
		menu.close()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'meridian_staff_actions', {
			title    = 'Manage Staff',
			align    = 'top-left',
			elements = {
				{ label = 'Open Boss Menu (hire / fire / grades)', value = 'boss' },
				{ label = 'Appoint Manager (make someone the Boss)', value = 'appoint' },
			},
		}, function(data2, menu2)
			menu2.close()
			if data2.current.value == 'boss' then
				TriggerServerEvent('uniquecafejobs:corp:openBusinessBossMenuAsMeridian', chosenJob)
			elseif data2.current.value == 'appoint' then
				local input = lib.inputDialog('Appoint Manager', {
					{ type = 'number', label = 'Player server ID', required = true },
				})
				if input and input[1] then
					TriggerServerEvent('uniquecafejobs:corp:appointManager', chosenJob, input[1])
				end
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()
	end)
end)

RegisterNetEvent('uniquecafejobs:corp:openRemoteBossMenu')
AddEventHandler('uniquecafejobs:corp:openRemoteBossMenu', function(job)
	TriggerEvent('esx_society:openBosscarysMenu', job, function(data, menu) end, function(data, menu) end)
end)

RegisterNetEvent('uniquecafejobs:corp:openBlacktideBoss')
AddEventHandler('uniquecafejobs:corp:openBlacktideBoss', function()
	TriggerEvent('esx_society:openBosscarysMenu', Corp.Blacktide.Job, function(data, menu) end, function(data, menu) end)
end)

RegisterNetEvent('uniquecafejobs:corp:openCrateCarryBoss')
AddEventHandler('uniquecafejobs:corp:openCrateCarryBoss', function()
	TriggerEvent('esx_society:openBosscarysMenu', Corp.CrateCarry.Job, function(data, menu) end, function(data, menu) end)
end)

-- ── Blacktide: laundering target at EVERY one of the 17 businesses' shop ──
CreateThread(function()
	for _, cafe in pairs(Cafes) do
		exports.ox_target:addBoxZone({
			coords = vec3(cafe.PedShop.Pos.x, cafe.PedShop.Pos.y, cafe.PedShop.Pos.z),
			size = vec3(2.0, 2.0, 2.0),
			rotation = 45,
			debug = false,
			options = {
				{
					name = 'launder_' .. cafe.Job,
					icon = 'fa-solid fa-money-bill-transfer',
					label = 'Launder Cash Through ' .. cafe.Label,
					canInteract = function()
						return PlayerData.job and PlayerData.job.name == Corp.Blacktide.Job
					end,
					onSelect = function()
						TriggerServerEvent('uniquecafejobs:corp:launder', cafe.Job)
					end,
				},
			},
		})
	end
end)

-- ── CrateCarry: wholesale-buy target at EVERY one of the 17 businesses' freezer ──
CreateThread(function()
	for _, cafe in pairs(Cafes) do
		exports.ox_target:addBoxZone({
			coords = vec3(cafe.Freezer.Pos.x, cafe.Freezer.Pos.y, cafe.Freezer.Pos.z),
			size = vec3(2.0, 2.0, 2.0),
			rotation = 45,
			debug = false,
			options = {
				{
					name = 'wholesale_' .. cafe.Job,
					icon = 'fa-solid fa-truck-ramp-box',
					label = 'Buy Wholesale From ' .. cafe.Label,
					canInteract = function()
						return PlayerData.job and PlayerData.job.name == Corp.CrateCarry.Job
					end,
					onSelect = function()
						TriggerServerEvent('uniquecafejobs:corp:openWholesaleMenu', cafe.Job)
					end,
				},
			},
		})
	end
end)

RegisterNetEvent('uniquecafejobs:corp:showWholesaleMenu')
AddEventHandler('uniquecafejobs:corp:showWholesaleMenu', function(businessJob, businessLabel, stock)
	local elements = {}
	for _, s in ipairs(stock) do
		table.insert(elements, { label = ('%s (x%d in stock) - $%d/unit'):format(s.label, s.count, Corp.CrateCarry.WholesaleUnitPrice), value = s.name })
	end
	if #elements == 0 then
		table.insert(elements, { label = 'Nothing in stock right now', value = 'noop', disabled = true })
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'wholesale_menu', {
		title    = 'Wholesale - ' .. businessLabel,
		align    = 'top-left',
		elements = elements,
	}, function(data, menu)
		if data.current.value ~= 'noop' then
			local input = lib.inputDialog('Buy Wholesale', {
				{ type = 'number', label = 'Quantity (max ' .. Corp.CrateCarry.WholesaleBuyLimit .. ')', default = 1, min = 1, max = Corp.CrateCarry.WholesaleBuyLimit },
			})
			if input and input[1] then
				TriggerServerEvent('uniquecafejobs:corp:buyWholesale', businessJob, data.current.value, tonumber(input[1]))
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end)

RegisterNetEvent('uniquecafejobs:corp:showResaleShop')
AddEventHandler('uniquecafejobs:corp:showResaleShop', function(stock)
	local elements = {}
	for _, s in ipairs(stock) do
		table.insert(elements, { label = ('%s - $%d (x%d in stock)'):format(s.label, s.price, s.count), value = s.name })
	end
	if #elements == 0 then
		table.insert(elements, { label = 'Sold out - come back later', value = 'noop', disabled = true })
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'resale_shop', {
		title    = Corp.CrateCarry.Label,
		align    = 'top-left',
		elements = elements,
	}, function(data, menu)
		if data.current.value ~= 'noop' then
			TriggerServerEvent('uniquecafejobs:corp:buyResale', data.current.value)
		end
	end, function(data, menu)
		menu.close()
	end)
end)

-- ── Vehicle spawn/delete for the 3 corp jobs (same pattern as the 17 businesses) ──
CreateThread(function()
	while true do
		Citizen.Wait(0)
		local corp = myCorpJob()
		if corp then
			local playerCoords = GetEntityCoords(PlayerPedId())
			local spawnMarker = vector3(corp.SpawnMarker.x, corp.SpawnMarker.y, corp.SpawnMarker.z)
			local deleteMarker = vector3(corp.DeleteMarker.x, corp.DeleteMarker.y, corp.DeleteMarker.z)

			if #(playerCoords - spawnMarker) < 10.0 then
				DrawMarker(36, spawnMarker.x, spawnMarker.y, spawnMarker.z - 1.0, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 0, 255, 0, 150, false, true, 2, false, nil, nil, false)
				if #(playerCoords - spawnMarker) < 2.0 then
					ESX.ShowHelpNotification("برای دریافت خودرو ~INPUT_CONTEXT~ را فشار دهید")
					if IsControlJustPressed(0, 38) then
						TriggerServerEvent('uniquecafejobs:corp:spawnVehicle', corp.SpawnVehicle)
					end
				end
			end

			if #(playerCoords - deleteMarker) < 10.0 then
				DrawMarker(24, deleteMarker.x, deleteMarker.y, deleteMarker.z - 1.0, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 255, 0, 0, 150, false, true, 2, false, nil, nil, false)
				if #(playerCoords - deleteMarker) < 2.0 then
					ESX.ShowHelpNotification("برای حذف خودرو ~INPUT_CONTEXT~ را فشار دهید")
					if IsControlJustPressed(0, 38) then
						local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
						if vehicle and vehicle ~= 0 then
							ESX.Game.DeleteVehicle(vehicle)
						end
					end
				end
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

RegisterNetEvent("spawnCarClientCorp")
AddEventHandler("spawnCarClientCorp", function(vehicleName)
	local corp = myCorpJob()
	if not corp then return end
	local spawnPoint = vector4(corp.SpawnPoint.x, corp.SpawnPoint.y, corp.SpawnPoint.z, corp.SpawnPoint.w)
	ESX.Game.SpawnVehicle(vehicleName, spawnPoint, spawnPoint.w, function(vehicle)
		TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
		SetEntityAsNoLongerNeeded(vehicle)
	end)
end)
