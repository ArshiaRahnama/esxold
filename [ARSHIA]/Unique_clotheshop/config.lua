Config = {}

-- ============================================================
-- Component / prop slot ids.
-- These MUST stay identical to esx_inventoryhud's own
-- ([ARSHIA]/esx_inventoryhud/client/clothe.lua -> componentIds,
-- shared/config.lua -> Config.ClotheComponentTypes / ClothePropTypes),
-- because esx_inventoryhud is what actually equips and persists worn
-- items -- this shop only needs to sell items using names it recognizes.
-- ============================================================
Config.ComponentSlot = {
    tshirt = 8, torso = 11, pants = 4, shoes = 6, mask = 1,
    bproof = 9, chain = 7, bag = 5, arms = 3, decals = 10,
}
Config.PropSlot = {
    helmet = 0, glasses = 1, watches = 6, bracelets = 7, ears = 2,
}

-- Display labels (Finglish, matches the rest of the server's style)
Config.TypeLabel = {
    tshirt = 'Tishert', torso = 'Lebas', pants = 'Shalvar', shoes = 'Kafsh',
    mask = 'Mask', bproof = 'Jelighe', chain = 'Gardanband', bag = 'Kif',
    arms = 'Dastkesh', decals = 'Neshan', helmet = 'Kolah', glasses = 'Eynak',
    watches = 'Saat', bracelets = 'Dastband', ears = 'Gushvare',
}

-- ============================================================
-- Shop zones. Every group gets a map blip by default (either its own
-- `blip` coord, or -- if that's not set -- the coord of its first
-- sub-zone) so every shop is actually findable on the map. Set
-- `noBlip = true` on a group to deliberately hide it (e.g. a secret
-- jewellery counter) instead of just omitting `blip`.
-- ============================================================
Config.Zones = {
    { -- lebas forooshi javaheri (nazdik barbari)
        blip = vector3(72.254, -1399.102, 28.376),
        zones = {
            { coords = vector3(72.254, -1399.102, 28.376), label = 'Lebas',           access = { 'arms', 'tshirt', 'torso', 'shoes', 'pants' } },
            { coords = vector3(75.36, -1391.29, 28.38),    label = 'Eynak',           access = { 'glasses' } },
            { coords = vector3(81.43, -1397.26, 28.38),    label = 'Kolah',           access = { 'helmet' } },
            { coords = vector3(79.82, -1389.4, 28.38),     label = 'Kif,Gardanband',  access = { 'bag', 'chain' } },
        },
    },
    { -- lebas forooshi javaheri (shik)
        blip = vector3(-703.776, -152.258, 36.415),
        zones = {
            { coords = vector3(-703.776, -152.258, 36.415), label = 'Lebas',          access = { 'arms', 'tshirt', 'torso', 'shoes', 'pants' } },
            { coords = vector3(-710.03, -152.77, 36.42),    label = 'Eynak',          access = { 'glasses' } },
            { coords = vector3(-715.54, -146.81, 36.42),    label = 'Kolah',          access = { 'helmet' } },
            { coords = vector3(-705.95, -159.12, 36.42),    label = 'Kif,Gardanband', access = { 'bag', 'chain' } },
        },
    },
    { -- lebas forooshi khune fbi (shik)
        blip = vector3(-167.863, -298.969, 38.733),
        zones = {
            { coords = vector3(-167.863, -298.969, 38.733), label = 'Lebas',          access = { 'arms', 'tshirt', 'torso', 'shoes', 'pants' } },
            { coords = vector3(-163.54, -303.36, 38.73),    label = 'Eynak',          access = { 'glasses' } },
            { coords = vector3(-164.76, -311.28, 38.73),    label = 'Kolah',          access = { 'helmet' } },
            { coords = vector3(-161.35, -295.62, 38.73),    label = 'Kif,Gardanband', access = { 'bag', 'chain' } },
        },
    },
    { -- lebas forooshi PD (koochik)
        blip = vector3(428.694, -800.106, 28.491),
        zones = {
            { coords = vector3(428.694, -800.106, 28.491), label = 'Lebas',          access = { 'arms', 'tshirt', 'torso', 'shoes', 'pants' } },
            { coords = vector3(425.39, -807.2, 28.49),     label = 'Eynak',          access = { 'glasses' } },
            { coords = vector3(419.74, -801.97, 28.49),    label = 'Kolah',          access = { 'helmet' } },
            { coords = vector3(420.88, -809.73, 28.49),    label = 'Kif,Gardanband', access = { 'bag', 'chain' } },
        },
    },
    { -- lebas forooshi weazel (koochik)
        blip = vector3(-829.413, -1073.710, 10.328),
        zones = {
            { coords = vector3(-829.413, -1073.710, 10.328), label = 'Lebas',          access = { 'arms', 'tshirt', 'torso', 'shoes', 'pants' } },
            { coords = vector3(-821.74, -1073.35, 10.33),    label = 'Eynak',          access = { 'glasses' } },
            { coords = vector3(-823.08, -1080.62, 10.33),    label = 'Kolah',          access = { 'helmet' } },
            { coords = vector3(-817.31, -1075.54, 10.33),    label = 'Kif,Gardanband', access = { 'bag', 'chain' } },
        },
    },
    { -- lebas forooshi chape bime (shik)
        blip = vector3(-1447.797, -242.461, 48.820),
        zones = {
            { coords = vector3(-1447.797, -242.461, 48.820), label = 'Lebas',          access = { 'arms', 'tshirt', 'torso', 'shoes', 'pants' } },
            { coords = vector3(-1450.2, -237.2, 48.81),      label = 'Eynak',          access = { 'glasses' } },
            { coords = vector3(-1446.37, -230.17, 48.81),    label = 'Kolah',          access = { 'helmet' } },
            { coords = vector3(-1455.05, -243.38, 48.81),    label = 'Kif,Gardanband', access = { 'bag', 'chain' } },
        },
    },
    { -- lebas forooshi bank sheriff (koochik)
        blip = vector3(11.632, 6514.224, 30.877),
        zones = {
            { coords = vector3(11.632, 6514.224, 30.877), label = 'Lebas',          access = { 'arms', 'tshirt', 'torso', 'shoes', 'pants' } },
            { coords = vector3(4.21, 6512.0, 30.88),      label = 'Eynak',          access = { 'glasses' } },
            { coords = vector3(4.02, 6519.5, 30.88),      label = 'Kolah',          access = { 'helmet' } },
            { coords = vector3(-0.4, 6513.44, 30.88),     label = 'Kif,Gardanband', access = { 'bag', 'chain' } },
        },
    },
    { -- lebas forooshi minibank1 (motovaset)
        blip = vector3(123.646, -219.440, 53.557),
        zones = {
            { coords = vector3(123.646, -219.440, 53.557), label = 'Lebas',          access = { 'arms', 'tshirt', 'torso', 'shoes', 'pants' } },
            { coords = vector3(123.45, -228.09, 53.56),    label = 'Eynak',          access = { 'glasses' } },
            { coords = vector3(123.63, -209.22, 53.56),    label = 'Kolah',          access = { 'helmet' } },
            { coords = vector3(131.33, -211.77, 53.56),    label = 'Kif,Gardanband', access = { 'bag', 'chain' } },
        },
    },
    { -- lebas forooshi coca (koochik)
        blip = vector3(1696.291, 4829.312, 41.063),
        zones = {
            { coords = vector3(1696.291, 4829.312, 41.063), label = 'Lebas',          access = { 'arms', 'tshirt', 'torso', 'shoes', 'pants' } },
            { coords = vector3(1693.95, 4822.23, 41.06),    label = 'Eynak',          access = { 'glasses' } },
            { coords = vector3(1687.75, 4826.25, 41.06),    label = 'Kolah',          access = { 'helmet' } },
            { coords = vector3(1689.54, 4818.79, 41.06),    label = 'Kif,Gardanband', access = { 'bag', 'chain' } },
        },
    },
    { -- lebas forooshi AH mechanicki bala (motovaset)
        blip = vector3(618.093, 2759.629, 41.088),
        zones = {
            { coords = vector3(618.093, 2759.629, 41.088), label = 'Lebas',          access = { 'arms', 'tshirt', 'torso', 'shoes', 'pants' } },
            { coords = vector3(614.32, 2767.44, 41.09),    label = 'Eynak',          access = { 'glasses' } },
            { coords = vector3(613.93, 2749.81, 41.09),    label = 'Kolah',          access = { 'helmet' } },
            { coords = vector3(622.33, 2750.04, 41.09),    label = 'Kif,Gardanband', access = { 'bag', 'chain' } },
        },
    },
    { -- lebas forooshi mechanicki bala (koochik)
        blip = vector3(1190.550, 2713.441, 37.222),
        zones = {
            { coords = vector3(1190.550, 2713.441, 37.222), label = 'Lebas',          access = { 'arms', 'tshirt', 'torso', 'shoes', 'pants' } },
            { coords = vector3(1197.39, 2710.24, 37.22),    label = 'Eynak',          access = { 'glasses' } },
            { coords = vector3(1192.47, 2704.62, 37.22),    label = 'Kolah',          access = { 'helmet' } },
            { coords = vector3(1200.11, 2705.56, 37.22),    label = 'Kif,Gardanband', access = { 'bag', 'chain' } },
        },
    },
    { -- lebas forooshi maze bank (motovaset)
        blip = vector3(-1193.429, -772.262, 16.324),
        zones = {
            { coords = vector3(-1193.429, -772.262, 16.324), label = 'Lebas',          access = { 'arms', 'tshirt', 'torso', 'shoes', 'pants' } },
            { coords = vector3(-1189.21, -765.94, 16.32),    label = 'Eynak',          access = { 'glasses' } },
            { coords = vector3(-1204.58, -775.0, 16.32),     label = 'Kolah',          access = { 'helmet' } },
            { coords = vector3(-1199.64, -781.73, 16.33),    label = 'Kif,Gardanband', access = { 'bag', 'chain' } },
        },
    },
    { -- lebas forooshi bank sahel (motovaset)
        blip = vector3(-3172.496, 1048.133, 19.863),
        zones = {
            { coords = vector3(-3172.496, 1048.133, 19.863), label = 'Lebas',          access = { 'arms', 'tshirt', 'torso', 'shoes', 'pants' } },
            { coords = vector3(-3172.87, 1039.98, 19.86),    label = 'Eynak',          access = { 'glasses' } },
            { coords = vector3(-3164.38, 1055.27, 19.86),    label = 'Kolah',          access = { 'helmet' } },
            { coords = vector3(-3171.52, 1058.72, 19.86),    label = 'Kif,Gardanband', access = { 'bag', 'chain' } },
        },
    },
    { -- lebas forooshi roodkhune kenar khashkhash (koochik)
        blip = vector3(-1108.441, 2708.923, 18.107),
        zones = {
            { coords = vector3(-1108.441, 2708.923, 18.107), label = 'Lebas',          access = { 'arms', 'tshirt', 'torso', 'shoes', 'pants' } },
            { coords = vector3(-1100.84, 2710.89, 18.11),    label = 'Eynak',          access = { 'glasses' } },
            { coords = vector3(-1100.81, 2703.55, 18.11),    label = 'Kolah',          access = { 'helmet' } },
            { coords = vector3(-1095.79, 2709.41, 18.11),    label = 'Kif,Gardanband', access = { 'bag', 'chain' } },
        },
    },
    { -- Mask Frooshi
        blip = vector3(-1338.13, -1278.21, 3.87),
        mask = true,
        zones = {
            { coords = vector3(-1338.13, -1278.21, 3.87), label = 'Lebas', access = { 'mask' } },
        },
    },
    { -- javaheri (saat/gushvare/dastband) -- no explicit blip coord was
      -- ever set for this one in the original config, which meant this
      -- shop had no map marker at all and was effectively unfindable.
      -- Falls back to its own (only) sub-zone's coords below so it now
      -- gets a blip like every other shop. Set `noBlip = true` here
      -- instead if you actually want to keep it hidden.
        zones = {
            { coords = vector3(-622.19, -230.76, 37.06), label = 'Saat,Gushvare,Dastband', access = { 'watches', 'ears', 'bracelets' } },
        },
    },
}

-- bproof/decals are intentionally not sold anywhere above (no real
-- vest/tattoo garment catalog existed in the source data) -- add a
-- sub-zone with access = {'bproof'} / {'decals'} to any group if/when
-- you have real items for them; the shop code already supports both.

-- Real price copied from the shop this replaces
-- ([ESX]/esx_eden_clotheshop/config.lua -> Config.Price = 5000, flat
-- for every item/type). Kept as a per-type table so you can still
-- differentiate later.
Config.ShopPrice = {
    arms = 5000, tshirt = 5000, torso = 5000, pants = 5000, shoes = 5000,
    bag = 5000, chain = 5000, glasses = 5000, helmet = 5000, watches = 5000,
    ears = 5000, bracelets = 5000, mask = 5000, bproof = 5000, decals = 5000,
}
Config.DefaultShopPrice = 5000
