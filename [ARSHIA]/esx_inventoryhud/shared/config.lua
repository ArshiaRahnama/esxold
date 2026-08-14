

Config = {}

-- keybind that opens the player's own inventory
Config.OpenInventoryKey = 'F2'

-- the main inventory panel appears to be a FIXED-size slot grid
-- (isEmpty(a) checks, per-index slot numbers in the template), not a
-- variable-length list of only-owned items -- this is how many total
-- slots to pad it out to
Config.MainInventorySlots = 40
Config.SecondInventorySlots = 40

-- how long (seconds) an item thrown on the ground stays before disappearing
Config.DroppedItemLifetime = 600

-- max distance (in units, same scale as GetEntityCoords) allowed
-- between two players for a direct item/weapon give to succeed
Config.GiveItemMaxDistance = 3.0

-- ACE permission required to use the admin "view another player's
-- inventory" feature (both online and offline)
Config.AdminInventoryAce = 'inventory.admin'

-- kif_1 .. kif_<MaxBagId> are registered as usable items so that
-- using one actually opens its bag
Config.MaxBagId = 300
Config.DefaultBagMaxWeight = 8000

-- ESX.getItem / ESX.getItemWeight / ESX.getWeaponWeight (used by
-- modules/trunk and others) aren't part of vanilla ESX Legacy --
-- these are the fallback weight values used since the originals
-- aren't recoverable from what's here. Override per item/weapon
-- as needed.
Config.DefaultItemWeight = 1
Config.DefaultWeaponWeight = 5
Config.ItemWeightOverrides = {
    -- ['bread'] = 2,
}
Config.WeaponWeights = {
    -- ['WEAPON_PISTOL'] = 10,
}

-- ============================================================
-- Clothing ownership/wearing system (replaces the missing
-- sunset_clothe resource). Clothing items are ESX inventory
-- items named 'clothe_<type>_<drawable>_<texture>'.
--
-- Mapping verified against real GTA ped customization slots:
-- component slots (SetPedComponentVariation) vs prop slots
-- (SetPedPropIndex) are two separate numbering systems that
-- happen to reuse some of the same numbers for different things.
-- ============================================================
Config.ClotheComponentTypes = {
    mask = 1, arms = 3, pants = 4, bag = 5,
    shoes = 6, chain = 7, tshirt = 8, bproof = 9, torso = 11
}
Config.ClothePropTypes = {
    helmet = 0, glasses = 1, ears = 2, watches = 6, bracelets = 7
}

-- pack_1 .. pack_<MaxPackId> get registered as usable items
Config.MaxPackId = 200
