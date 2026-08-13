Config               = {}

Config.Locale = 'en'

Config.LicenseEnable = false -- enable boat license? Requires esx_license
Config.LicensePrice  = 50000

Config.MarkerType    = 1
Config.DrawDistance  = 15.0

Config.Marker = {
	r = 100, g = 204, b = 100, -- blue-ish color
	x = 1.0, y = 1.0, z = 1.0  -- standard size circle
}

Config.StoreMarker = {
	r = 255, g = 0, b = 0,     -- red color
	x = 5.0, y = 5.0, z = 1.0  -- big circle for storing boat
}

Config.Zones = {

	Garages = {
	-- 	{ -- Shank St, nearby campaign boat garage
	-- 		GaragePos  = vector3(-772.4, -1430.9, 1.5),
	-- 		SpawnPoint = vector4(-785.39, -1426.3, 0.0, 146.0),
	-- 		StorePos   = vector3(-798.4, -1456.0, 1.0),
	-- 		StoreTP    = vector4(-791.4, -1452.5, 2.5, 318.9)
	-- 	},

	-- 	{ -- Catfish View
	-- 		GaragePos  = vector3(3864.9, 4463.9, 2.6),
	-- 		SpawnPoint = vector4(3854.4, 4477.2, 0.0, 273.0),
	-- 		StorePos   = vector3(3857.0, 4446.9, 1.0),
	-- 		StoreTP    = vector4(3854.7, 4458.6, 2.8, 355.3)
	-- 	},

	-- 	{ -- Great Ocean Highway
	-- 		GaragePos  = vector3(-1614.0, 5260.1, 3.8),
	-- 		SpawnPoint = vector4(-1622.5, 5247.1, 0.0, 21.0),
	-- 		StorePos   = vector3(-1600.3, 5261.9, 1.0),
	-- 		StoreTP    = vector4(-1605.7, 5259.0, 3.0, 25.0)
	-- 	},

	-- 	{ -- North Calafia Way
	-- 		GaragePos  = vector3(712.6, 4093.3, 34.7),
	-- 		SpawnPoint = vector4(712.8, 4080.2, 30.3, 181.0),
	-- 		StorePos   = vector3(705.1, 4110.1, 31.2),
	-- 		StoreTP    = vector4(711.9, 4110.5, 32.3, 180.0)
	-- 	},

	-- 	{ -- Elysian Fields, nearby the airport
	-- 		GaragePos  = vector3(23.8, -2806.8, 5.8),
	-- 		SpawnPoint = vector4(23.3, -2828.6, 1.8, 181.0),
	-- 		StorePos   = vector3(-1.0, -2799.2, 1.5),
	-- 		StoreTP    = vector4(12.6, -2793.8, 3.5, 355.2)
	-- 	},

	-- 	{ -- Cayo 1
	-- 		GaragePos  = vector3(4928.91, -5173.78, 2.46),
	-- 		SpawnPoint = vector4(4925.0, -5171.22, 0.98, 149.99),
	-- 		StorePos   = vector3(4933.43, -5169.93, 0.98),
	-- 		StoreTP    = vector4(4940.28, -5173.3, 2.45, 334.28)
	-- 	},

	-- 	{ -- Cayo 2
	-- 		GaragePos  = vector3(4764.84, -4779.1, 3.8),
	-- 		SpawnPoint = vector4(4758.75, -4778.14, -0.11, 320.82),
	-- 		StorePos   = vector3(4758.75, -4778.14, -0.11),
	-- 		StoreTP    = vector4(4766.17, -4776.25, 4.86, 323.53)
	-- 	},

	-- 	{ -- Barbareno Rd
	-- 		GaragePos  = vector3(-3427.3, 956.9, 8.3),
	-- 		SpawnPoint = vector4(-3448.9, 953.8, 1.0, 75.0),
	-- 		StorePos   = vector3(-3436.5, 946.6, 1.3),
	-- 		StoreTP    = vector4(-3427.0, 952.6, 9.3, 0.0)
	-- 	}
	},

	BoatShops = {
		{ -- Shank St, nearby campaign boat garage
			Outside = vector3(-40.7176, -1094.69, 27.274),
			Inside = vector4(-792.78, -1501.01, -0.47, 110.5)
		}
	}

}

Config.Vehicles = {
	{model = 'jetmax', label = 'Jetmax', price = 10000000},
	{model = 'marquis', label = 'Marquis', price = 60000000},
	{model = 'seashark3', label = 'Seashark', price = 15000000},
	{model = 'speeder', label = 'Speeder', price = 50000000},
	{model = 'speeder2', label = 'Speeder 2', price = 50000000},
	{model = 'toro2', label = 'Toro', price = 50000000},
	{model = 'tropic2', label = 'Tropic2', price = 5000000},
	{model = 'longfin', label = 'Longfin', price = 60000000},
	{model = 'dinghy4', label = 'Dinghy', price = 50000000},
}