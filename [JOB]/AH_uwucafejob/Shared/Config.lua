Config = {}


Config.JobName = "uwucafe"
Config.itemIconsPath = "nui://esx_inventoryhud/html/img/items/" 

Config.catModels = {"a_c_cat_01"} 
Config.spawnLocations = {
    {x = -582.082, y = -1055.85, z = 21.0},
    {x = -582.100, y = -1054.57, z = 21.0},
    {x = -576.409, y = -1056.27, z = 21.0},
    {x = -576.473, y = -1054.95, z = 21.0},
    {x = -574.052, y = -1054.91, z = 21.0}, 
    {x = -573.980, y = -1056.40, z = 21.0}, 
    {x = -577.532, y = -1063.56, z = 21.0}, 
    {x = -579.982, y = -1061.24, z = 21.0}, 
    {x = -581.632, y = -1064.19, z = 21.0}, 
}

Config.uwustasion = {
    UwU = {

        Blip = {
            Pos     = {x = -581.831, y = -1064.56, z = 22.347},
            Sprite  = 621,
            Display = 4,
            Scale   = 1.0,
            Colour  = 8,
        },

        Freezer = {
            Pos  = {x = -590.8, y = -1058.64, z = 22.744},
            Name = "Freezer",
            Icon = "fa-regular fa-snowflake",
        },

        PedShop = {
            Model = 's_m_m_ammucountry',
            Pos   = {x = -588.1, y = -1068.47, z = 22.344, h = 359.67},
            Name = "Shop",
            Icon = "fa-solid fa-shop",
        },

        BossAction = {
            Pos   = {x = -596.610, y = -1052.73, z = 22.245},
            Name = "Boss Action",
            Icon = "fa-solid fa-gear",
        },

        CloackRoom = {
            Pos   = {x = -586.200, y = -1050.61, z = 22.744},
            Name = "Cloack Room",
            Icon = "fa-solid fa-shirt",
        },

        Crafting_Hamzan = {
            Pos   = {x = -591.0, y = -1064.16, z = 22.544},
            Name = "HamZan",
            Icon = "fa-brands fa-files-pinwheel",
        },

        Crafting_Ghahvesaz = {
            Pos   = {x = -586.874, y = -1061.84, z = 22.344},
            Name = "Ghahve Saz",
            Icon = "fa-brands fa-java",
        },

        Crafting_ZarfShoe = {
            Pos   = {x = -587.6, y = -1062.60, z = 22.556},
            Name = "Zarf Shoe",
            Icon = "fa-brands fa-first-order-alt",
        },

        Crafting_Gaz = {
            Pos   = {x = -591.012, y = -1056.49, z = 22.2},
            Name = "Gaz",
            Icon = "fa-brands fa-firefox-browser",
        },

        Menu_Sefaresh = {
            Pos   = {x = -583.987, y = -1061.46, z = 22.344},
            Name = "Menu",
            Icon = "fa-brands fa-whmcs",
        },

    }
}

Config.UwUMenu_Cake_Item = {
    { title = 'Cake Bastani', value = 'cakebastani', price = 10000, image = Config.itemIconsPath..'cakebastani.png' },
    { title = 'Cake Totfarangi', value = 'caketotfarangi', price = 8000, image = Config.itemIconsPath..'caketotfarangi.png' },
    { title = 'Cupcake', value = 'cupcake', price = 3000, image = Config.itemIconsPath..'cupcake.png' },
    { title = 'Shokolat', value = 'shokolat', price = 5000, image = Config.itemIconsPath..'shokolat.png' },
    { title = 'Cake Bastani Vanili', value = 'cake_bastani_vanili', price = 6100, image = Config.itemIconsPath..'cake_bastani_vanili.png' },
    { title = 'Cake Limoii', value = 'cake_limoii', price = 4800, image = Config.itemIconsPath..'cake_limoii.png' },
    { title = 'Cupcake Shokolati', value = 'cupcake_shokolati', price = 5900, image = Config.itemIconsPath..'cupcake_shokolati.png' },
    { title = 'Mufchocolate', value = 'mufchocolate', price = 8000, image = Config.itemIconsPath..'mufchocolate.png' },
    { title = 'Muffin Tamshak', value = 'muffin_tamshak', price = 4175, image = Config.itemIconsPath..'muffin_tamshak.png' },
    { title = 'Nodel', value = 'nodel', price = 5600, image = Config.itemIconsPath..'nodel.png' },
    { title = 'Pankik', value = 'pankik', price = 3900, image = Config.itemIconsPath..'pankik.png' },
    { title = 'Pankik Nutella', value = 'pankik_nutella', price = 5900, image = Config.itemIconsPath..'pankik_nutella.png' },
    { title = 'Pankik Oreo', value = 'pankik_oreo', price = 6000, image = Config.itemIconsPath..'pankik_oreo.png' },
    { title = 'Tiramisuye Toot Farangi', value = 'tiramisuye_toot_farangi', price = 5150, image = Config.itemIconsPath..'tiramisuye_toot_farangi.png' },
    { title = 'Vafel Nutella', value = 'vafel_nutella', price = 7000, image = Config.itemIconsPath..'vafel_nutella.png' },
}

Config.UwUMenu_Noshidani_Item = {
    { title = 'Bubblete Totfarangi', value = 'bubbletetotfarangi', price = 9000, image = Config.itemIconsPath..'bubbletetotfarangi.png' },
    { title = 'Ab Porteghal', value = 'abporteghal', price = 6100, image = Config.itemIconsPath..'abporteghal.png' },
    { title = 'Chaee', value = 'chaee', price = 6000, image = Config.itemIconsPath..'chaee.png' },
    { title = 'Ghahve 50', value = 'ghahve50', price = 3000, image = Config.itemIconsPath..'ghahve50.png' },
    { title = 'Ghahve 80', value = 'ghahve80', price = 7000, image = Config.itemIconsPath..'ghahve80.png' },
    { title = 'Ghahve 100', value = 'ghahve100', price = 8000, image = Config.itemIconsPath..'ghahve100.png' },
    { title = 'Hot Chocolate', value = 'hot_chocolate', price = 3000, image = Config.itemIconsPath..'hot_chocolate.png' },
    { title = 'Latte', value = 'latte', price = 3000, image = Config.itemIconsPath..'latte.png' },
    { title = 'Milkshake', value = 'milkshake', price = 5000, image = Config.itemIconsPath..'milkshake.png' },
    { title = 'Bastani', value = 'bastani', price = 6500, image = Config.itemIconsPath..'bastani.png' },
    { title = 'Boba Milk Tea Caramel', value = 'boba_milk_tea_caramel', price = 3800, image = Config.itemIconsPath..'boba_milk_tea_caramel.png' },
    { title = 'Boba Milk Tea Matcha', value = 'boba_milk_tea_matcha', price = 3500, image = Config.itemIconsPath..'boba_milk_tea_matcha.png' },
    { title = 'Bobal Tea Matcha', value = 'bobal_tea_matcha', price = 4500, image = Config.itemIconsPath..'bobal_tea_matcha.png' },
    { title = 'Bobal Tea Tamshak', value = 'bobal_tea_tamshak', price = 4250, image = Config.itemIconsPath..'bobal_tea_tamshak.png' },
    { title = 'Ice Coffee Matcha', value = 'ice_coffee_matcha', price = 4500, image = Config.itemIconsPath..'ice_coffee_matcha.png' },
    { title = 'Milk Shake Shokolati', value = 'milk_shake_shokolati', price = 3900, image = Config.itemIconsPath..'milk_shake_shokolati.png' },
}

Config.UwUItems = {
    -- items masrafi --
    'bubbletetotfarangi', 'cakebastani', 'cakebastanivanili', 'caketotfarangi', 
	'chaee', 'cupcake', 'ghahve50', 'ghahve80', 'ghahve100', 'hot_chocolate','latte', 'milkshake', 
    'shokolat','suop',
    -- New items masrafi --
    'bastani', 'boba_milk_tea_caramel', 'boba_milk_tea_matcha', 'bobal_tea_matcha', 'bobal_tea_tamshak',
	'cake_bastani_vanili', 'cake_limoii', 'cupcake_shokolati', 'ice_coffee_matcha', 'milk_shake_shokolati',
	'mufchocolate', 'muffin_tamshak', 'nodel', 'pankik', 'pankik_nutella', 'pankik_oreo',
    'tiramisuye_toot_farangi', 'vafel_nutella',
    
    -- item avalie --
	'aard', 'bakingpowder', 'daneghahve','egg', 'fenjon', 'fenjonkasif', 'kare', 'kase', 
    'kasekasif', 'limo', 'podrcacao','shekar', 'shir', 'totfarangi','yakh', 'water',
    'bread', "abporteghal", 'nutela',
    -- New item avalie --
	'vanil', 'tamshak', 'powdr_matcha', 'oreo', 'nodel_kham', 'khame',
}


Config.UwUShopItem = {
    {label = 'Aard', icon = Config.itemIconsPath .. 'aard.png', price = 100, args = 'aard'},
    {label = 'Ab Porteghal', icon = Config.itemIconsPath .. 'abporteghal.png', price = 5000, args = 'abporteghal'},
    -- {label = 'Boba Milk Tea Matcha', icon = Config.itemIconsPath .. 'boba_milk_tea_matcha.png', price = 4000, args = 'boba_milk_tea_matcha'},
    -- {label = 'Boba Milk Tea Caramel', icon = Config.itemIconsPath .. 'boba_milk_tea_caramel.png', price = 4100, args = 'boba_milk_tea_caramel'},
    {label = 'Ice Coffee Matcha', icon = Config.itemIconsPath .. 'ice_coffee_matcha.png', price = 4500, args = 'ice_coffee_matcha'},
    {label = 'Bastani', icon = Config.itemIconsPath .. 'bastani.png', price = 5000, args = 'bastani'},
    {label = 'Nutela', icon = Config.itemIconsPath .. 'nutela.png', price = 200, args = 'nutela'},
    {label = 'Chaee', icon = Config.itemIconsPath .. 'chaee.png', price = 5000, args = 'chaee'},
    {label = 'Baking Powder', icon = Config.itemIconsPath .. 'bakingpowder.png', price = 200, args = 'bakingpowder'},
    {label = 'Dane Ghahve', icon = Config.itemIconsPath .. 'daneghahve.png', price = 200, args = 'daneghahve'},
    {label = 'Tokhm Morgh', icon = Config.itemIconsPath .. 'egg.png', price = 100, args = 'egg'},
    {label = 'Fenjon', icon = Config.itemIconsPath .. 'fenjon.png', price = 100, args = 'fenjon'},
    {label = 'Kare', icon = Config.itemIconsPath .. 'kare.png', price = 200, args = 'kare'},
    {label = 'Kase', icon = Config.itemIconsPath .. 'kase.png', price = 100, args = 'kase'},
    {label = 'Limo', icon = Config.itemIconsPath .. 'limo.png', price = 100, args = 'limo'},
    {label = 'Podr Cacao', icon = Config.itemIconsPath .. 'podrcacao.png', price = 200, args = 'podrcacao'},
    {label = 'Shekar', icon = Config.itemIconsPath .. 'shekar.png', price = 100, args = 'shekar'},
    {label = 'Shir', icon = Config.itemIconsPath .. 'shir.png', price = 200, args = 'shir'},
    {label = 'Tot Farangi', icon = Config.itemIconsPath .. 'totfarangi.png', price = 200, args = 'totfarangi'},
    {label = 'Yakh', icon = Config.itemIconsPath .. 'yakh.png', price = 100, args = 'yakh'},
    {label = 'Water', icon = Config.itemIconsPath .. 'water.png', price = 100, args = 'water'},
    {label = 'Bread', icon = Config.itemIconsPath .. 'bread.png', price = 100, args = 'bread'},
  
    {label = 'Vanil', icon = Config.itemIconsPath .. 'vanil.png', price = 200, args = 'vanil'},
    {label = 'Tamshak', icon = Config.itemIconsPath .. 'tamshak.png', price = 175, args = 'tamshak'},
    {label = 'Powdr Matcha', icon = Config.itemIconsPath .. 'powdr_matcha.png', price = 200, args = 'powdr_matcha'},
    {label = 'Oreo', icon = Config.itemIconsPath .. 'oreo.png', price = 100, args = 'oreo'},
    {label = 'Nodel Kham', icon = Config.itemIconsPath .. 'nodel_kham.png', price = 300, args = 'nodel_kham'},
    {label = 'Khame', icon = Config.itemIconsPath .. 'khame.png', price = 150, args = 'khame'},

}

