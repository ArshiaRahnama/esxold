Config = {}

-- Job names registered by your esx_policejob resource. Anyone with one of these
-- jobs is treated as a cop for the rob system (blocked from robbing, counted for
-- copsrequired, and notified when a robbery starts/ends).
Config.PoliceJobs = { 'police', 'sheriff', 'fbi', 'mt', 'cid', 'cia', 'marshal', 'judge', 'doa' }

Config.Marker = {
	r = 0, g = 255, b = 0, a = 255,  -- green color
	x = 0.5, y = 0.5, z = 0.5,       -- tiny, cylinder formed circle
	DrawDistance = 15.0, Type = 6    -- default circle type, low draw distance due to indoors area
}






Config.Robs = {
    ["Shop_1"] = {
        nameofrob = "Shop Robbery (Dakhel Shahr)",
        type = "Shop",
        position = { x = -43.217666625977, y = -1748.4660644531, z = 29.421022415161},
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },
    ["Shop_2"] = {
        nameofrob = "Shop Robbery (Dakhel Shahr)",
        type = "Shop",
        position = { x = 28.13338, y = -1339.13, z = 29.49},
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },
    ["Shop_3"] = {
        nameofrob = "Shop Robbery (Dakhel Shahr)",
        type = "Shop",
        position = { x = 1126.7266845703, y = -980.06903076172, z = 45.41577911377},
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },
    ["Shop_4"] = {
        nameofrob = "Shop Robbery (Dakhel Shahr)",
        type = "Shop",
        position = { x = 1159.6395263672, y = -313.95556640625, z = 69.205047607422},
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },
    ["Shop_5"] = {
        nameofrob = "Shop Robbery (Dakhel Shahr)",
        type = "Shop",
        position = { x = 378.19546508789, y = 333.32019042969, z = 103.56635284424},
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },
    ["Shop_6"] = {
        nameofrob = "Shop Robbery (Dakhel Shahr)",
        type = "Shop",
        position = { x = -1478.8537597656, y = -375.3415222168, z = 39.163391113281},
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },
    ["Shop_7"] = {
        nameofrob = "Shop Robbery (Dakhel Shahr)",
        type = "Shop",
        position = { x = -1220.9096679688, y = -916.00067138672, z = 11.326328277588},
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },
    ["Shop_8"] = {
        nameofrob = "Shop Robbery (Dakhel Shahr)",
        type = "Shop",
        position = { x = -709.58001708984, y = -904.08319091797, z = 19.215585708618},
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },
    ["Shop_9"] = {
        nameofrob = "Shop Robbery (Biron Shahr)",
        type = "Shop",
        position = { x = 2549.3823242188, y = 384.84527587891, z = 108.62292480469},
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },
    ["Shop_10"] = {
        nameofrob = "Shop Robbery (Biron Shahr)",
        type = "Shop",
        position = { x = 2672.8884277344, y = 3286.5727539063, z = 55.241123199463},
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },
    ["Shop_11"] = {
        nameofrob = "Shop 2",
        type = "Shop",
        position = { x = 1959.2484130859, y = 3748.974609375, z = 32.343730926514},
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },
    ["Shop_12"] = {
        nameofrob = "Shop Robbery (Biron Shahr)",
        type = "Shop",
        position = { x = 1707.8781738281, y = 4920.267578125, z = 42.063678741455},
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },
    ["Shop_13"] = {
        nameofrob = "Shop Robbery (Biron Shahr)",
        type = "Shop",
        position = { x = 1734.8101806641, y = 6420.76953125, z = 35.037212371826},
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },
    ["Shop_14"] = {
        nameofrob = "Shop Robbery (Biron Shahr)",
        type = "Shop",
        position = { x = 1169.33203125, y = 2717.8833007813, z = 37.157711029053},
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },
    ["Shop_15"] = {
        nameofrob = "Shop Robbery (Biron Shahr)",
        type = "Shop",
        position = { x = -3249.9362792969, y = 1004.3435058594, z = 12.8307056427},
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },
    ["Shop_16"] = {
        nameofrob = "Shop Robbery (Biron Shahr)",
        type = "Shop",
        position = { x = -3047.7390136719, y = 585.63598632813, z = 7.908926486969},
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },
    ["Shop_17"] = {
        nameofrob = "Shop Robbery (Biron Shahr)",
        type = "Shop",
        position = { x = -2959.6220703125, y = 387.05618286133, z = 14.043290138245},
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },
    ["Shop_18"] = {
        nameofrob = "Shop Robbery (Biron Shahr)",
        type = "Shop",
        position = { x = -1829.1010742188, y = 798.88848876953, z = 138.18865966797},
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },
    ----------------------------------------------------------------------
    ["Minibank_1"] = {
        nameofrob = "FleeccE Bank 1",
        type = "Minibank",
        position = vector3(312.7544, -288.8176, 54.14317),
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },
    ["Minibank_2"] = {
        nameofrob = "FleeccE Bank 2",
        type = "Minibank",
        position = vector3(-1206.687, -338.2508, 37.75944),
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },
    ["Minibank_3"] = {
        nameofrob = "FleeccE Bank 3",
        type = "Minibank",
        position = vector3(-352.1897, -59.35669, 49.01496),
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },
    ["Minibank_4"] = {
        nameofrob = "FleeccE Bank 4",
        type = "Minibank",
        position = vector3(1173.054, 2716.382, 38.06644),
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },
    ["Minibank_5"] = {
        nameofrob = "Bank Saheli",
        type = "Minibank",
        position = vector3(-2953.052, 484.5581, 15.67543),
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },
    ---------------------------------------------------------------
    ["Jaw_Shahr"] = {
        nameofrob = "Jaw Shahr",
        type = "Jewerlly",
        position = { x = -631.35131835938, y = -229.70999145508, z = 38.057014465332},
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },
    ["Jaw_BironShahr"] = {
        nameofrob = "Jaw BironShahr",
        type = "Jewerlly",
        position = { x = 2742.3122558594, y = 3469.5939941406, z = 56.287113189697},
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },
    ["Life_Invader"] = {
        nameofrob = "Life Invader",
        type = "Life_Invader",
        position = { x = -1056.8, y = -233.36, z = 44.02 },
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },
    ["Palateo_Bank"] = {
        nameofrob = "Bank Pelato",
        type = "Palateo_Bank",
        position = { x = -103.82, y = 6477.81, z = 31.36 },
        lastRobbed = 0,  -- Dont Touch !!
        available = true,  -- Dont Touch !!
        someonerobbing = false,   -- Dont Touch !!
    },

}


Config.RobTypes ={
    ["Shop"] ={
        reward = {
            ["blackmoney"] = {min = 2500, max = 4000},
            ["xpshop"] = 1,
        },
        lessreward = {
            ["blackmoney"] = {min = 1500, max = 2000},
        },
        itemneed = {
        },
		successtime = 300, -- seconds - zamane success rob
        cooldown = 600, -- seconds - cooldown bade rob
        copsrequired = 3,
        cancelDistance = 20.0,
        lastRobbed = 0,  -- Dont Touch !!
        blipsprite = 52, -- akse blip rob
        hacktype = 0,  -- 0 for no hack - 1 for easy hack - 2 for hard hack
        teammatesrequired = 0, -- 0 for no teammates checking
    },
    ["Minibank"] ={
        reward = {
            ["blackmoney"] = {min = 11500, max = 12400},
            ["xpfleeca"] = 1,
        },
        lessreward = {
            ["blackmoney"] = {min = 8500, max = 9500},
        },
        itemneed = {
            ["blowtorch"] = 1,
        },
		successtime = 600, -- seconds - zamane success rob
        cooldown = 1200, -- seconds - cooldown bade rob
        copsrequired = 5,
        cancelDistance = 20.0,
        lastRobbed = 0,  -- Dont Touch !!
        blipsprite = 431, -- akse blip rob
        hacktype = 0,
        teammatesrequired = 4, -- 0 for no teammates checking
    },
    ["Jewerlly"] ={
        reward = {
            ["blackmoney"] = {min = 37000, max = 40000},
            ["xpjewel"] = 1,
        },
        lessreward = {
            ["blackmoney"] = {min = 20000, max = 30000},
        },
        itemneed = {
            ["laptophack"] = 1,
        },
		successtime = 700, -- seconds - zamane success rob
        cooldown = 1200, -- seconds - cooldown bade rob
        copsrequired = 5,
        cancelDistance = 25.0,
        lastRobbed = 0,  -- Dont Touch !!
        blipsprite = 617, -- akse blip rob
        hacktype = 1,
        teammatesrequired = 4, -- 0 for no teammates checking
    },
    ["Life_Invader"] ={
        reward = {
            ["blackmoney"] = {min = 40000, max = 50000},
            ["xpbime"] = 1,
        },
        lessreward = {
            ["blackmoney"] = {min = 25000, max = 35000},
        },
        itemneed = {
            ["laptophack"] = 1,
        },
		successtime = 1200, -- seconds - zamane success rob
        cooldown = 1800, -- seconds - cooldown bade rob
        copsrequired = 7,
        cancelDistance = 40.0,
        lastRobbed = 0,  -- Dont Touch !!
        blipsprite = 77, -- akse blip rob
        hacktype = 2,
        teammatesrequired = 5, -- 0 for no teammates checking
    },
    ["Palateo_Bank"] ={
        reward = {
            ["blackmoney"] = {min = 1700000, max = 2500000},
            ["xpbankp"] = 1,
        },
        lessreward = {
            ["blackmoney"] = {min = 400000, max = 500000},
        },
        itemneed = {
            ["laptophack"] = 1,
        },
		successtime = 1200, -- seconds - zamane success rob
        cooldown = 2100, -- seconds - cooldown bade rob
        copsrequired = 7,
        cancelDistance = 20.0,
        lastRobbed = 0,  -- Dont Touch !!
        blipsprite = 207, -- akse blip rob
        hacktype = 2,
        teammatesrequired = 5, -- 0 for no teammates checking
    },
}