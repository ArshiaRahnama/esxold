-- ============================================================
-- sun-inventory-hud.sql
--
-- Every table the new server code (server/*.lua) uses. Each one
-- also gets auto-created on resource start via
-- "CREATE TABLE IF NOT EXISTS", so importing this by hand is
-- optional -- it's here so you can inspect the schema up front
-- or set it up before the resource ever runs, for testing.
-- Safe to import multiple times (IF NOT EXISTS everywhere).
-- ============================================================

-- server/bag.lua : one row per physical bag (item 'kif_<bag_id>')
CREATE TABLE IF NOT EXISTS `bag_inventories` (
    `bag_id` INT NOT NULL PRIMARY KEY,
    `items` LONGTEXT NOT NULL DEFAULT ('[]'),
    `slots` INT NOT NULL DEFAULT 41
);

-- server/trunk.lua : one row per (plate, glovebox) pair
CREATE TABLE IF NOT EXISTS `trunk_inventories` (
    `plate` VARCHAR(32) NOT NULL,
    `glove_box` TINYINT(1) NOT NULL DEFAULT 0,
    `items` LONGTEXT NOT NULL DEFAULT ('[]'),
    `weapons` LONGTEXT NOT NULL DEFAULT ('[]'),
    PRIMARY KEY (`plate`, `glove_box`)
);

-- server/job.lua : one row per job (society stash)
CREATE TABLE IF NOT EXISTS `job_inventories` (
    `job_name` VARCHAR(64) NOT NULL PRIMARY KEY,
    `items` LONGTEXT NOT NULL DEFAULT ('[]'),
    `weapons` LONGTEXT NOT NULL DEFAULT ('[]'),
    `slots` INT NOT NULL DEFAULT 50
);

-- server/public.lua : one row per named public/shared stash
-- (names starting with 'recycle:' are treated as recycle bins by
-- the code and never actually get a row inserted/read here)
CREATE TABLE IF NOT EXISTS `public_inventories` (
    `name` VARCHAR(64) NOT NULL PRIMARY KEY,
    `items` LONGTEXT NOT NULL DEFAULT ('[]')
);

-- server/clothe.lua : what each player currently has worn,
-- keyed by their ESX identifier
CREATE TABLE IF NOT EXISTS `player_worn_clothes` (
    `identifier` VARCHAR(64) NOT NULL PRIMARY KEY,
    `worn` LONGTEXT NOT NULL DEFAULT ('{}')
);

-- server/clothe.lua : saved clothing presets ("packs"); each row
-- also becomes a real usable item named 'pack_<pack_id>'
CREATE TABLE IF NOT EXISTS `player_clothe_packs` (
    `pack_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(64) NOT NULL,
    `label` VARCHAR(64) NOT NULL,
    `contents` LONGTEXT NOT NULL DEFAULT ('{}')
);
