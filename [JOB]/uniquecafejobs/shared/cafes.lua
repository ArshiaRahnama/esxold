--[[
	Multi-cafe registry. Add a new cafe by copying one of the blocks below and
	giving it a new `Job` (must also exist in the `jobs` / `job_grades` SQL
	tables), a new `Society` name, and its own set of station coordinates.

	Every cafe is a fully separate business: an employee of one cafe cannot
	use another cafe's freezer/crafting/boss menu/cloakroom - same rule as
	the rest of the server's job resources.

	Only "UwU Café" keeps its original coordinates (that's the one that
	already existed and works). The 2 new cafes use PLACEHOLDER coordinates -
	move them in-game to wherever you actually want them.
]]

Cafes = {

	-- ── Café #1: UwU Café (original, unchanged location) ──
	UwU = {
		Job     = 'uwucafe',
		Society = 'uwucafe',
		Label   = 'UwU Café',

		Blip = {
			Pos     = { x = -581.831, y = -1064.56, z = 22.347 },
			Sprite  = 621,
			Display = 4,
			Scale   = 1.0,
			Colour  = 8, -- pink
		},

		Freezer            = { Pos = { x = -590.8,   y = -1058.64, z = 22.744 }, Name = "Freezer",     Icon = "fa-regular fa-snowflake" },
		PedShop            = { Model = 's_m_m_ammucountry', Pos = { x = -588.1, y = -1068.47, z = 22.344, h = 359.67 }, Name = "Shop", Icon = "fa-solid fa-shop" },
		BossAction         = { Pos = { x = -596.610, y = -1052.73, z = 22.245 }, Name = "Boss Action", Icon = "fa-solid fa-gear" },
		CloackRoom         = { Pos = { x = -586.200, y = -1050.61, z = 22.744 }, Name = "Cloack Room", Icon = "fa-solid fa-shirt" },
		Crafting_Hamzan    = { Pos = { x = -591.0,   y = -1064.16, z = 22.544 }, Name = "HamZan",      Icon = "fa-brands fa-files-pinwheel" },
		Crafting_Ghahvesaz = { Pos = { x = -586.874, y = -1061.84, z = 22.344 }, Name = "Ghahve Saz",  Icon = "fa-brands fa-java" },
		Crafting_ZarfShoe  = { Pos = { x = -587.6,   y = -1062.60, z = 22.556 }, Name = "Zarf Shoe",   Icon = "fa-brands fa-first-order-alt" },
		Crafting_Gaz       = { Pos = { x = -591.012, y = -1056.49, z = 22.2 },   Name = "Gaz",         Icon = "fa-brands fa-firefox-browser" },
		Menu_Sefaresh      = { Pos = { x = -583.987, y = -1061.46, z = 22.344 }, Name = "Menu",        Icon = "fa-brands fa-whmcs" },

		SpawnVehicle = 'scania',
		SpawnMarker  = { x = -607.457, y = -1064.42, z = 22.788 },
		SpawnPoint   = { x = -621.072, y = -1058.83, z = 21.789, w = 268.28 },
		DeleteMarker = { x = -612.353, y = -1059.27, z = 22.788 },

		CatModel        = "a_c_cat_01",
		SpawnLocations = {
			{ x = -582.082, y = -1055.85, z = 21.0 },
			{ x = -582.100, y = -1054.57, z = 21.0 },
			{ x = -576.409, y = -1056.27, z = 21.0 },
			{ x = -576.473, y = -1054.95, z = 21.0 },
			{ x = -574.052, y = -1054.91, z = 21.0 },
			{ x = -573.980, y = -1056.40, z = 21.0 },
			{ x = -577.532, y = -1063.56, z = 21.0 },
			{ x = -579.982, y = -1061.24, z = 21.0 },
			{ x = -581.632, y = -1064.19, z = 21.0 },
		},
	},

	-- ── Café #2: Obsidian Brew ──
	-- PLACEHOLDER location (Rockford Hills area) - move in-game.
	Obsidian = {
		Job     = 'obsidian',
		Society = 'obsidian',
		Label   = 'Obsidian Brew',

		Blip = {
			Pos     = { x = -1223.0, y = -906.0, z = 12.33 },
			Sprite  = 621,
			Display = 4,
			Scale   = 1.0,
			Colour  = 27, -- dark purple / obsidian-ish
		},

		Freezer            = { Pos = { x = -1231.5, y = -900.4, z = 12.6 },  Name = "Freezer",     Icon = "fa-regular fa-snowflake" },
		PedShop            = { Model = 's_m_m_ammucountry', Pos = { x = -1229.0, y = -913.0, z = 12.2, h = 200.0 }, Name = "Shop", Icon = "fa-solid fa-shop" },
		BossAction         = { Pos = { x = -1238.0, y = -893.5, z = 12.7 },  Name = "Boss Action", Icon = "fa-solid fa-gear" },
		CloackRoom         = { Pos = { x = -1227.6, y = -891.8, z = 12.6 },  Name = "Cloack Room", Icon = "fa-solid fa-shirt" },
		Crafting_Hamzan    = { Pos = { x = -1232.3, y = -906.0, z = 12.35 }, Name = "HamZan",      Icon = "fa-brands fa-files-pinwheel" },
		Crafting_Ghahvesaz = { Pos = { x = -1227.7, y = -903.2, z = 12.15 }, Name = "Ghahve Saz",  Icon = "fa-brands fa-java" },
		Crafting_ZarfShoe  = { Pos = { x = -1228.4, y = -903.9, z = 12.35 }, Name = "Zarf Shoe",   Icon = "fa-brands fa-first-order-alt" },
		Crafting_Gaz       = { Pos = { x = -1232.4, y = -898.3, z = 12.05 }, Name = "Gaz",         Icon = "fa-brands fa-firefox-browser" },
		Menu_Sefaresh      = { Pos = { x = -1225.2, y = -902.8, z = 12.15 }, Name = "Menu",        Icon = "fa-brands fa-whmcs" },

		SpawnVehicle = 'scania',
		SpawnMarker  = { x = -1248.0, y = -906.0, z = 12.63 },
		SpawnPoint   = { x = -1262.0, y = -900.0, z = 11.6,  w = 268.28 },
		DeleteMarker = { x = -1253.0, y = -900.9, z = 12.63 },

		CatModel        = "a_c_cat_01",
		SpawnLocations = {
			{ x = -1222.7, y = -897.5, z = 10.8 },
			{ x = -1222.7, y = -896.2, z = 10.8 },
			{ x = -1217.0, y = -897.9, z = 10.8 },
			{ x = -1217.1, y = -896.6, z = 10.8 },
			{ x = -1214.7, y = -896.5, z = 10.8 },
			{ x = -1214.6, y = -898.0, z = 10.8 },
			{ x = -1218.2, y = -905.2, z = 10.8 },
			{ x = -1220.6, y = -902.9, z = 10.8 },
			{ x = -1222.3, y = -905.8, z = 10.8 },
		},
	},

	-- ── Café #3: Voltage Coffee Co. ──
	-- PLACEHOLDER location (Textile City / industrial area) - move in-game.
	Voltage = {
		Job     = 'voltage',
		Society = 'voltage',
		Label   = 'Voltage Coffee Co.',

		Blip = {
			Pos     = { x = 442.9, y = -1750.0, z = 29.5 },
			Sprite  = 621,
			Display = 4,
			Scale   = 1.0,
			Colour  = 5, -- yellow / electric
		},

		Freezer            = { Pos = { x = 434.4, y = -1743.6, z = 29.8 }, Name = "Freezer",     Icon = "fa-regular fa-snowflake" },
		PedShop            = { Model = 's_m_m_ammucountry', Pos = { x = 436.9, y = -1753.6, z = 29.4, h = 90.0 }, Name = "Shop", Icon = "fa-solid fa-shop" },
		BossAction         = { Pos = { x = 428.3, y = -1738.1, z = 29.9 }, Name = "Boss Action", Icon = "fa-solid fa-gear" },
		CloackRoom         = { Pos = { x = 438.7, y = -1736.0, z = 29.8 }, Name = "Cloack Room", Icon = "fa-solid fa-shirt" },
		Crafting_Hamzan    = { Pos = { x = 434.0, y = -1749.7, z = 29.6 }, Name = "HamZan",      Icon = "fa-brands fa-files-pinwheel" },
		Crafting_Ghahvesaz = { Pos = { x = 438.2, y = -1747.2, z = 29.4 }, Name = "Ghahve Saz",  Icon = "fa-brands fa-java" },
		Crafting_ZarfShoe  = { Pos = { x = 437.4, y = -1747.9, z = 29.6 }, Name = "Zarf Shoe",   Icon = "fa-brands fa-first-order-alt" },
		Crafting_Gaz       = { Pos = { x = 434.0, y = -1742.1, z = 29.3 }, Name = "Gaz",         Icon = "fa-brands fa-firefox-browser" },
		Menu_Sefaresh      = { Pos = { x = 441.4, y = -1746.8, z = 29.4 }, Name = "Menu",        Icon = "fa-brands fa-whmcs" },

		SpawnVehicle = 'scania',
		SpawnMarker  = { x = 418.0, y = -1750.0, z = 29.5 },
		SpawnPoint   = { x = 404.0, y = -1744.0, z = 28.6, w = 88.0 },
		DeleteMarker = { x = 413.0, y = -1744.9, z = 29.5 },

		CatModel        = "a_c_cat_01",
		SpawnLocations = {
			{ x = 443.2, y = -1740.9, z = 27.8 },
			{ x = 443.2, y = -1739.6, z = 27.8 },
			{ x = 448.9, y = -1741.3, z = 27.8 },
			{ x = 448.8, y = -1740.0, z = 27.8 },
			{ x = 451.2, y = -1739.9, z = 27.8 },
			{ x = 451.3, y = -1741.4, z = 27.8 },
			{ x = 447.7, y = -1748.6, z = 27.8 },
			{ x = 445.3, y = -1746.3, z = 27.8 },
			{ x = 443.6, y = -1749.2, z = 27.8 },
		},
	},
}

-- ── Helpers shared by both client and server ──

CafeJobSet = {}
for _, cafe in pairs(Cafes) do
	CafeJobSet[cafe.Job] = true
end

-- Returns the cafe table this job belongs to, or nil if it's not a cafe job.
function GetCafeForJob(jobName)
	for _, cafe in pairs(Cafes) do
		if cafe.Job == jobName then
			return cafe
		end
	end
	return nil
end

function IsCafeJob(jobName)
	return CafeJobSet[jobName] == true
end
