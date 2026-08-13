-- ====================================================================
-- Config_HUNT (از HUNT/Config.lua)
-- ====================================================================
Config_HUNT = {}

Config_HUNT.ItemsLashe = {
    'lasheoghab',
    'lasheaho', 
    'lashekhargush', 
    'lasherottweiler', 
    'lashehusky', 
    'lashecougar', 
    'lashepig', 
    'lashecoyote', 
    'lashemorgh'
}

Config_HUNT.ItemsTabdil = {
    lasheoghab = {name = 'lasheoghab', head = 'headeoghab', gosht = 'goshteoghab', post = ''},
    lasheaho = {name = 'lasheaho', head = 'headeaho', gosht = 'goshteaho', post = 'posteaho'}, 
    lashekhargush = {name = 'lashekhargush', head = 'headekhargush', gosht = 'goshtekhargush', post = 'postekhargush'}, 
    lasherottweiler = {name = 'lasherottweiler', head = 'headerottweiler', gosht = 'goshterottweiler', post = 'posterottweiler'}, 
    lashehusky = {name = 'lashehusky', head = 'headehusky', gosht = 'goshtehusky', post = 'postehusky'}, 
    lashecougar = {name = 'lashecougar', head = 'headecougar', gosht = 'goshtecougar', post = 'postecougar'}, 
    lashepig = {name = 'lashepig', head = 'headepig', gosht = 'goshtepig', post = 'postepig'},
    lashecoyote = {name = 'lashecoyote', head = 'headecoyote', gosht = 'goshtecoyote', post = 'postecoyote'}, 
    lashemorgh = {name = 'lashemorgh', head = 'heademorgh', gosht = 'slaughtered_chicken', post = ''}
}
-- ====================================================================
-- Config_Megaphone (از Megaphone/config.lua)
-- ====================================================================
Config_Megaphone = {}

Config_Megaphone.Framework = 'esx' -- esx, qb-core, 
-- ====================================================================
-- Config_Antipg (از antipg/config.lua)
-- ====================================================================
Config_Antipg = {
    Debug = false,

    InstallLocation = vector3(-352.312, -90.3062, 40.0),  ----- Nasb va Tamir
    
    Marker = {  ------- Chop Shop 
        Position = vector3(602.6905, -438.514, 24.756),
        Color = {r = 255, g = 0, b = 0, a = 100}
    },

    Items = {
        Engine = {
            Name = 'engine',
            Label = 'Engine',
            Prop = 'prop_car_engine_01'
        }
    }
}

-- ====================================================================
-- Config_PedShop (از pedshop/config.lua)
-- ====================================================================
Config_PedShop = {}


Config_PedShop.Locations = {
    PedShop = vector3(-416.513, 1116.741, 325.87),
    PedChange = vector3(-410.834, 1115.171, 325.87) 
}


Config_PedShop.AvailablePedsMale = {
    {label = "Beach Guy", model = "a_m_m_beach_01", expire = 7, price = 100000},   
    {label = "Farmer", model = "a_m_m_farmer_01", expire = 14, price = 500000}, 
}


Config_PedShop.AvailablePedsFemale = {
    {label = "Beach Girl", model = "a_f_y_beach_01", expire = 7, price = 100000},
    {label = "Fitness Girl", model = "a_f_y_fitness_01", expire = 14, price = 500000},
    {label = "Sweet", model = "pmp_st_sweet", expire = 30, price = 20000}, 
    {label = "Yoga", model = "a_f_y_yoga_01", expire = 30, price = 20000}, 
}

-- ====================================================================
-- config (gang_mapings - lowercase, بدون تداخل)
-- ====================================================================
config = {}

-- config.coords = {
--     {x = -1561.27, y = -49.3924, z = 56.501},
--     {x = -1465.53, y = -28.9578, z = 60.655},
--     {x = -1467.11, y = 39.88935, z = 58.928},
-- }



-- blips1 = {
--     -- {title="Gang House", colour=32, id=378, config.coords.x, config.coords.y, config.coords.x.z},
--     {title="Gang House", colour=32, id=378, x = -1561.27, y = -49.3924, z = 56.501},
--     {title="Gang House", colour=32, id=378, x = -1465.53, y = -28.9578, z = 60.655},
--     {title="Gang House", colour=32, id=378, x = -1467.11, y = 39.88935, z = 58.928},
-- }


-- ====================================================================
-- Config_Switchjob (از Unique_Scripts_Switchjob/config.lua)
-- ====================================================================
Config_Switchjob = {}


Config_Switchjob.AllowedJobs = {
    ["steam:11000015a735e72"] = {   --- Porya Qanbari
        {name = "police", grade = 20, label = "Police"},
        {name = "fbi", grade = 8, label = "FBI"},
    },
}

Config_Switchjob.MenuCommand = "fbichange"
-- ====================================================================
-- Config_WeaponsOnBack (از weapons-on-back/Config.lua)
-- ====================================================================
Config_WeaponsOnBack = {}

Config_WeaponsOnBack.mahdod = true -- estefade az in job ha va gang ha(nazdik base gang) mitonan estefade kon

Config_WeaponsOnBack.WeaponComponents = {
    -- CARBINE RIFLE
    [GetHashKey("WEAPON_CARBINERIFLE")] = {
        ['clip_default'] = 0x9FBE33EC,
        ['clip_extended'] = 0x91109691,
        ['clip_box'] = 0x91109691,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0xA0D89C42,
        ['suppressor'] = 0x837445AA,
        ['grip'] = 0xC164F53,
        ['luxary_finish'] = 0xD89B9658
    },
    
    -- CARBINE RIFLE MK2
    [GetHashKey("WEAPON_CARBINERIFLE_MK2")] = {
        ['clip_default'] = 0x4C7A391E,
        ['clip_extended'] = 0x5DD5DBD5,
        ['clip_tracer'] = 0x1757F566,
        ['clip_incendiary'] = 0x3D25C2A7,
        ['clip_armor_piercing'] = 0x255D5D57,
        ['clip_fmj'] = 0x44032F11,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope_holo'] = 0x49B2945,
        ['scope_medium'] = 0xC66B6542,
        ['suppressor'] = 0x837445AA,
        ['grip'] = 0x9D65907A,
        ['barrel'] = 0x833637FF
    },
    
    -- ASSAULT RIFLE
    [GetHashKey("WEAPON_ASSAULTRIFLE")] = {
        ['clip_default'] = 0xBE5EEA16,
        ['clip_extended'] = 0xB1214F9B,
        ['clip_drum'] = 0xDBF0A53D,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0x9D2FBF29,
        ['suppressor'] = 0x837445AA,
        ['grip'] = 0xC164F53,
        ['luxary_finish'] = 0x4EAD7533
    },
    
    -- SPECIAL CARBINE
    [GetHashKey("WEAPON_SPECIALCARBINE")] = {
        ['clip_default'] = 0x7C8BD10E,
        ['clip_extended'] = 0x6B59AEAA,
        ['clip_drum'] = 0xD9C1E5B1,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0xA0D89C42,
        ['suppressor'] = 0x837445AA,
        ['grip'] = 0x9D65907A,
        ['luxary_finish'] = 0x730154F2
    },
    
    -- BULLPUP RIFLE
    [GetHashKey("WEAPON_BULLPUPRIFLE")] = {
        ['clip_default'] = 0xC5A12F80,
        ['clip_extended'] = 0xB3688B0F,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0xAA2C45B4,
        ['suppressor'] = 0x837445AA,
        ['grip'] = 0xC164F53,
        ['luxary_finish'] = 0xA857BC78
    },
    
    -- ADVANCED RIFLE
    [GetHashKey("WEAPON_ADVANCEDRIFLE")] = {
        ['clip_default'] = 0xFA8FA10F,
        ['clip_extended'] = 0x8EC1C979,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0xAA2C45B4,
        ['suppressor'] = 0x837445AA,
        ['luxary_finish'] = 0x377CD377
    },
    
    -- SMG
    [GetHashKey("WEAPON_SMG")] = {
        ['clip_default'] = 0x26574997,
        ['clip_extended'] = 0x350966FB,
        ['clip_drum'] = 0x79C77076,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0x3CC6BA57,
        ['suppressor'] = 0xC304849A,
        ['luxary_finish'] = 0x27872C90
    },
    
    -- SMG MK2
    [GetHashKey("WEAPON_SMGMK2")] = {
        ['clip_default'] = 0x4C24806E,
        ['clip_extended'] = 0xB9835B2E,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope_holo'] = 0x3F3C8181,
        ['scope_small'] = 0x3DECC7DA,
        ['suppressor'] = 0xC304849A,
        ['muzzle_flat'] = 0xB99402D4,
        ['muzzle_tactical'] = 0xC867A07B,
        ['barrel'] = 0xD9103EE1
    },
    
    -- MICRO SMG
    [GetHashKey("WEAPON_MICROSMG")] = {
        ['clip_default'] = 0xCB48AEF0,
        ['clip_extended'] = 0x10E6BA2B,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0x9D2FBF29,
        ['suppressor'] = 0xAC42DF71,
        ['luxary_finish'] = 0x487AAE09
    },
    
    -- ASSAULT SMG
    [GetHashKey("WEAPON_ASSAULTSMG")] = {
        ['clip_default'] = 0x8D1307B0,
        ['clip_extended'] = 0xBB46E417,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0x9D2FBF29,
        ['suppressor'] = 0xA73D4664,
        ['luxary_finish'] = 0x278C78AF
    },
    
    -- GUSENBERG
    [GetHashKey("WEAPON_GUSENBERG")] = {
        ['clip_default'] = 0x1CE5A6A5,
        ['clip_extended'] = 0xEAC8C270
    },
    
    -- PISTOL
    [GetHashKey("WEAPON_PISTOL")] = {
        ['clip_default'] = 0xFED0FD71,
        ['clip_extended'] = 0xED265A1C,
        ['flashlight'] = 0x43FD595B,
        ['suppressor'] = 0x65EA7EBB,
        ['luxary_finish'] = 0xD7391086
    },
    
    -- PISTOL .50
    [GetHashKey("WEAPON_PISTOL50")] = {
        ['clip_default'] = 0x2297BE19,
        ['clip_extended'] = 0xD9D3AC92,
        ['flashlight'] = 0x359B7AAE,
        ['suppressor'] = 0xA73D4664,
        ['luxary_finish'] = 0x77B8AB2F
    },
    
    -- SNIPER RIFLE
    [GetHashKey("WEAPON_SNIPERRIFLE")] = {
        ['suppressor'] = 0x9BC64089,
        ['scope_large'] = 0xD2443DDC,
        ['scope_advanced'] = 0xBC54DA77
    },
    
    -- HEAVY SHOTGUN
    [GetHashKey("WEAPON_HEAVYSHOTGUN")] = {
        ['clip_default'] = 0x324F2D5F,
        ['clip_extended'] = 0x971CF6FD,
        ['clip_drum'] = 0x88C7DA53,
        ['flashlight'] = 0x7BC4CDDC,
        ['suppressor'] = 0xA73D4664,
        ['grip'] = 0xC164F53
    },
    
    -- PUMPSHOTGUN
    [GetHashKey("WEAPON_PUMPSHOTGUN")] = {
        ['flashlight'] = 0x7BC4CDDC,
        ['suppressor'] = 0xE608B35E,
        ['luxary_finish'] = 0xA2D79DDB
    },
    
    -- ASSAULT SHOTGUN
    [GetHashKey("WEAPON_ASSAULTSHOTGUN")] = {
        ['clip_default'] = 0x94E81BC7,
        ['clip_extended'] = 0x86BD7F72,
        ['flashlight'] = 0x7BC4CDDC,
        ['suppressor'] = 0x837445AA,
        ['grip'] = 0xC164F53
    },
    
    -- BULLPUP SHOTGUN
    [GetHashKey("WEAPON_BULLPUPSHOTGUN")] = {
        ['flashlight'] = 0x7BC4CDDC,
        ['suppressor'] = 0xA73D4664,
        ['grip'] = 0xC164F53
    },
    

    [GetHashKey("WEAPON_M4")] = {
        ['clip_default'] = 0xBE5EEA16,
        ['clip_extended'] = 0xB1214F9B,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0x9D2FBF29,
        ['suppressor'] = 0x837445AA,
        ['grip'] = 0xC164F53
    }
}