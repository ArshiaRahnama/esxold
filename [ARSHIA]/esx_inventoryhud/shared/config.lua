

Config = {}

-- keybind that opens the player's own inventory
Config.OpenInventoryKey = 'F2'

-- Weapon equip toggle: right-click ("Use") any weapon in your
-- inventory to toggle whether it's actually drawable (shows up in
-- the game's own weapon-select wheel). Owning a weapon no longer
-- automatically makes it drawable -- only up to this many can be
-- equipped at once; equipping past the limit unequips the oldest one.
--
-- Confirmed against the real repo (ArshiaRahnama/Sunset,
-- sun-inventory-hud/client/config.lua): reservedSlotForWeapon = 3 --
-- same "3" limit, same underlying idea (only some weapons are ever
-- actually drawable). That version enforces it through real per-slot
-- reservation in client/main.lua, which isn't published (empty file
-- in the repo) -- this click-toggle version reaches the same end
-- result (max 3 drawable at once) without needing that missing file.
Config.WeaponSlots = { 1, 2, 3 }

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
