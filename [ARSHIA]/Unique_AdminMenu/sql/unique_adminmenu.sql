-- Run this once against your database before starting the updated
-- Unique_AdminMenu. Uses `banlist` / `banlisthistory` (already in your
-- database.sql) for bans - no new table needed for those.

CREATE TABLE IF NOT EXISTS `admin_warnings` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `identifier` VARCHAR(60) NOT NULL,
  `playername` VARCHAR(100) DEFAULT NULL,
  `admin_identifier` VARCHAR(60) DEFAULT NULL,
  `admin_name` VARCHAR(100) DEFAULT NULL,
  `reason` VARCHAR(255) DEFAULT NULL,
  `created_at` DATETIME DEFAULT NULL,
  INDEX (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `admin_saved_locations` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `x` FLOAT NOT NULL,
  `y` FLOAT NOT NULL,
  `z` FLOAT NOT NULL,
  `created_by` VARCHAR(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
