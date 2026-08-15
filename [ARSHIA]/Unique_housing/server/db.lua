-- ============================================================================
-- Sunset Housing - Database layer
-- Uses the mysql-async style API (MySQL.Async.*) provided by oxmysql's
-- compatibility shim (@oxmysql/lib/MySQL.lua) - same pattern esx_property
-- already uses elsewhere in this project (MySQL.Async.fetchAll / execute /
-- insert), so this stays consistent with the rest of your resources.
-- ============================================================================

CreateThread(function()
	MySQL.ready(function()
		-- Single houses (normal standalone properties, not apartment units)
		MySQL.Async.execute([[
			CREATE TABLE IF NOT EXISTS `sh_houses` (
				`id`             INT(11)      NOT NULL AUTO_INCREMENT,
				`owner`          VARCHAR(60)  DEFAULT NULL,
				`label`          VARCHAR(150) DEFAULT NULL,
				`entercoords`    LONGTEXT     DEFAULT NULL,
				`garagecoords`   LONGTEXT     DEFAULT NULL,
				`shell`          VARCHAR(100) DEFAULT NULL,
				`shellgarage`    VARCHAR(100) DEFAULT NULL,
				`price`          INT(11)      NOT NULL DEFAULT 0,
				`inventorylevel` INT(11)      NOT NULL DEFAULT 1,
				`safelevel`      INT(11)      NOT NULL DEFAULT 1,
				`furniture`      LONGTEXT     DEFAULT '[]',
				`storage_data`   VARCHAR(100) DEFAULT 'housing',
				PRIMARY KEY (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
		]])

		-- safe for existing installs that already had sh_houses without `label`
		MySQL.Async.execute('ALTER TABLE `sh_houses` ADD COLUMN IF NOT EXISTS `label` VARCHAR(150) DEFAULT NULL')

		-- Apartment buildings (the blip/entrance you interact with to pick a unit)
		MySQL.Async.execute([[
			CREATE TABLE IF NOT EXISTS `sh_apartments` (
				`id`          INT(11)      NOT NULL AUTO_INCREMENT,
				`label`       VARCHAR(100) DEFAULT NULL,
				`entercoords` LONGTEXT     DEFAULT NULL,
				PRIMARY KEY (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
		]])

		-- Individual apartment units inside an apartment building.
		-- Lazily fetched client-side via the `sunset_housing:getHouse` callback
		-- (mirrors the `reqHouse` pattern already in client/functions.lua).
		MySQL.Async.execute([[
			CREATE TABLE IF NOT EXISTS `sh_apartment_units` (
				`id`             INT(11)      NOT NULL AUTO_INCREMENT,
				`apartment_id`   INT(11)      NOT NULL,
				`floor`          INT(11)      NOT NULL DEFAULT 1,
				`owner`          VARCHAR(60)  DEFAULT NULL,
				`label`          VARCHAR(150) DEFAULT NULL,
				`shell`          VARCHAR(100) DEFAULT NULL,
				`price`          INT(11)      NOT NULL DEFAULT 0,
				`inventorylevel` INT(11)      NOT NULL DEFAULT 1,
				`safelevel`      INT(11)      NOT NULL DEFAULT 1,
				`furniture`      LONGTEXT     DEFAULT '[]',
				`storage_data`   VARCHAR(100) DEFAULT 'housing',
				PRIMARY KEY (`id`),
				KEY `apartment_id` (`apartment_id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
		]])

		-- safe for existing installs that already had sh_apartment_units without `label`
		MySQL.Async.execute('ALTER TABLE `sh_apartment_units` ADD COLUMN IF NOT EXISTS `label` VARCHAR(150) DEFAULT NULL')

		-- House inventory / safe / postbox storage - one row per named stash,
		-- e.g. 'house_12', 'house_safe_12', 'house_postbox_12'.
		-- Mirrors bag_inventories / trunk_inventories in esx_inventoryhud so
		-- storage plugs into the same items+weapons shape sun-inventory-hud uses.
		MySQL.Async.execute([[
			CREATE TABLE IF NOT EXISTS `sh_storage` (
				`name`    VARCHAR(64) NOT NULL PRIMARY KEY,
				`items`   LONGTEXT    NOT NULL DEFAULT ('[]'),
				`weapons` LONGTEXT    NOT NULL DEFAULT ('[]')
			) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
		]])

		-- Vehicles parked in a specific house's private garage.
		-- Separate from Unique_Garage's job-based owned_vehicles system on
		-- purpose - house garages are per-house, not per-job, so this avoids
		-- touching/risking that already-working resource.
		MySQL.Async.execute([[
			CREATE TABLE IF NOT EXISTS `sh_garage_vehicles` (
				`id`      INT(11)      NOT NULL AUTO_INCREMENT,
				`house_id` INT(11)     NOT NULL,
				`owner`   VARCHAR(60)  NOT NULL,
				`plate`   VARCHAR(12)  NOT NULL,
				`vehicle` LONGTEXT     DEFAULT NULL,
				`stored`  TINYINT(4)   NOT NULL DEFAULT 1,
				PRIMARY KEY (`id`),
				UNIQUE KEY `plate` (`plate`),
				KEY `house_id` (`house_id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
		]])

		TriggerEvent('sunset_housing:dbReady')
	end)
end)

SH_DB = {}

-- ---------------------------------------------------------------------------
-- Houses
-- ---------------------------------------------------------------------------

function SH_DB.GetAllHouses(cb)
	MySQL.Async.fetchAll('SELECT * FROM sh_houses', {}, cb)
end

function SH_DB.GetHouse(id, cb)
	MySQL.Async.fetchAll('SELECT * FROM sh_houses WHERE id = @id', { ['@id'] = id }, function(rows)
		cb(rows and rows[1] or nil)
	end)
end

function SH_DB.InsertHouse(data, cb)
	MySQL.Async.insert([[
		INSERT INTO sh_houses (owner, label, entercoords, garagecoords, shell, shellgarage, price, inventorylevel, safelevel, furniture, storage_data)
		VALUES (@owner, @label, @entercoords, @garagecoords, @shell, @shellgarage, @price, 1, 1, '[]', @storage_data)
	]], {
		['@owner']        = data.owner,
		['@label']        = data.label,
		['@entercoords']  = data.entercoords,
		['@garagecoords'] = data.garagecoords,
		['@shell']        = data.shell,
		['@shellgarage']  = data.shellgarage,
		['@price']        = data.price,
		['@storage_data'] = data.storage_data or ConfigSV.StorageNamespace,
	}, cb)
end

-- params: table of @column = value pairs to SET
function SH_DB.UpdateHouse(id, params, cb)
	local setClause = {}
	for col in pairs(params) do
		setClause[#setClause + 1] = ('`%s` = @%s'):format(col, col)
	end
	params['@id'] = id
	local sql = ('UPDATE sh_houses SET %s WHERE id = @id'):format(table.concat(setClause, ', '))
	MySQL.Async.execute(sql, params, cb)
end

function SH_DB.DeleteHouse(id, cb)
	MySQL.Async.execute('DELETE FROM sh_houses WHERE id = @id', { ['@id'] = id }, cb)
end

-- ---------------------------------------------------------------------------
-- Apartments (buildings) + units
-- ---------------------------------------------------------------------------

function SH_DB.GetAllApartments(cb)
	MySQL.Async.fetchAll('SELECT * FROM sh_apartments', {}, cb)
end

function SH_DB.GetAllApartmentUnits(cb)
	MySQL.Async.fetchAll('SELECT * FROM sh_apartment_units', {}, cb)
end

function SH_DB.GetApartmentUnit(id, cb)
	MySQL.Async.fetchAll('SELECT * FROM sh_apartment_units WHERE id = @id', { ['@id'] = id }, function(rows)
		cb(rows and rows[1] or nil)
	end)
end

function SH_DB.InsertApartmentUnit(data, cb)
	MySQL.Async.insert([[
		INSERT INTO sh_apartment_units (apartment_id, floor, shell, price, label, inventorylevel, safelevel, furniture, storage_data)
		VALUES (@apartment_id, @floor, @shell, @price, @label, 1, 1, '[]', @storage_data)
	]], {
		['@apartment_id'] = data.apartment_id,
		['@floor']        = data.floor,
		['@shell']        = data.shell,
		['@price']        = data.price,
		['@label']        = data.label,
		['@storage_data'] = data.storage_data or ConfigSV.StorageNamespace,
	}, cb)
end

function SH_DB.UpdateApartmentUnit(id, params, cb)
	local setClause = {}
	for col in pairs(params) do
		setClause[#setClause + 1] = ('`%s` = @%s'):format(col, col)
	end
	params['@id'] = id
	local sql = ('UPDATE sh_apartment_units SET %s WHERE id = @id'):format(table.concat(setClause, ', '))
	MySQL.Async.execute(sql, params, cb)
end
