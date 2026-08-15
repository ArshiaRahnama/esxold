-- ============================================================================
-- Sunset Housing (Unique_housing) - Database Schema + دیتاست ۴۲ خونه‌ی واقعی
-- ============================================================================
-- این فایل هم جدول‌ها رو می‌سازه (دقیقاً هماهنگ با نسخه‌ی آخر server/db.lua،
-- شامل ستون `label` که تازه به sh_houses و sh_apartment_units اضافه شد)
-- و هم همون ۴۲ خونه‌ای که تو فایل khohne.sql فرستاده بودی رو داخلش می‌ریزه.
--
-- تفکیک دیتای اصلی (خودم از روی فیلد gateway/is_gateway تشخیص دادم):
--   • 11 خونه‌ی تکی (بدون gateway)              -> جدول sh_houses
--   • 3 ساختمان آپارتمانی (is_gateway=1)          -> جدول sh_apartments
--   • 28 واحد آپارتمانی داخل اون 3 ساختمان        -> جدول sh_apartment_units
--
-- چون Unique_housing (بر خلاف esx_property قدیمی) از یه سری "Shell" ثابت و
-- از پیش‌طراحی‌شده برای داخل خونه‌ها استفاده می‌کنه (shell_apartment1/2/3 که
-- تو config.lua تعریف شدن)، دیگه فیلدهای inside/outside/exit قدیمی معنی
-- ندارن - فقط entercoords (نقطه‌ی ورود بیرون خونه) لازمه، و داخل خونه همیشه
-- یکی از این 3 شل مشترکه. برای تنوع، شل‌ها رو به‌ترتیب بین خونه‌ها/واحدها
-- می‌چرخونم (1، 2، 3، 1، 2، 3، ...).
--
-- برای apartment_id واحدهای آپارتمانی، به‌جای فرض کردن id=1/2/3 برای سه
-- ساختمون، از SET @gw1/@gw2/@gw3 = LAST_INSERT_ID() استفاده کردم - یعنی
-- این فایل درست کار می‌کنه حتی اگه از قبل چندتا ساختمون دیگه تو
-- sh_apartments داشته باشی.
--
-- نحوه‌ی اجرا: کل فایل رو یکجا (نه تکه‌تکه) رو همون دیتابیسی که
-- essentialmode/سرورت روشه اجرا کن. اگه از قبل sh_houses/sh_apartment_units
-- رو (نسخه‌ی بدون label) ساخته بودی، اول resource رو یه‌بار ری‌استارت کن تا
-- server/db.lua خودش ستون label رو با ALTER TABLE ADD COLUMN IF NOT EXISTS
-- اضافه کنه، بعد این فایل رو ایمپورت کن.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- ساختار جدول‌ها (اگه از قبل ساخته شدن، این خط‌ها بی‌اثرن)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `sh_houses` (
  `id`             INT(11)      NOT NULL AUTO_INCREMENT,
  `owner`          VARCHAR(60)  DEFAULT NULL,
  `label`          VARCHAR(150) DEFAULT NULL,
  `entercoords`    LONGTEXT     DEFAULT NULL,
  `garagecoords`   LONGTEXT     DEFAULT NULL,
  `shell`          VARCHAR(100) DEFAULT NULL,
  `shellgarage`    VARCHAR(100) DEFAULT NULL,
  `price`          INT(11)      NOT NULL DEFAULT 0,
  `inventorylevel` INT(11)      NOT NULL DEFAULT 1,
  `safelevel`      INT(11)      NOT NULL DEFAULT 1,
  `furniture`      LONGTEXT     DEFAULT '[]',
  `storage_data`   VARCHAR(100) DEFAULT 'housing',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `sh_apartments` (
  `id`          INT(11)      NOT NULL AUTO_INCREMENT,
  `label`       VARCHAR(100) DEFAULT NULL,
  `entercoords` LONGTEXT     DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `sh_apartment_units` (
  `id`             INT(11)      NOT NULL AUTO_INCREMENT,
  `apartment_id`   INT(11)      NOT NULL,
  `floor`          INT(11)      NOT NULL DEFAULT 1,
  `owner`          VARCHAR(60)  DEFAULT NULL,
  `label`          VARCHAR(150) DEFAULT NULL,
  `shell`          VARCHAR(100) DEFAULT NULL,
  `price`          INT(11)      NOT NULL DEFAULT 0,
  `inventorylevel` INT(11)      NOT NULL DEFAULT 1,
  `safelevel`      INT(11)      NOT NULL DEFAULT 1,
  `furniture`      LONGTEXT     DEFAULT '[]',
  `storage_data`   VARCHAR(100) DEFAULT 'housing',
  PRIMARY KEY (`id`),
  KEY `apartment_id` (`apartment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `sh_storage` (
  `name`    VARCHAR(64) NOT NULL PRIMARY KEY,
  `items`   LONGTEXT    NOT NULL DEFAULT ('[]'),
  `weapons` LONGTEXT    NOT NULL DEFAULT ('[]')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `sh_garage_vehicles` (
  `id`       INT(11)     NOT NULL AUTO_INCREMENT,
  `house_id` INT(11)     NOT NULL,
  `owner`    VARCHAR(60) NOT NULL,
  `plate`    VARCHAR(12) NOT NULL,
  `vehicle`  LONGTEXT    DEFAULT NULL,
  `stored`   TINYINT(4)  NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plate` (`plate`),
  KEY `house_id` (`house_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ============================================================================
-- 11 خونه‌ی تکی
-- ============================================================================
INSERT INTO `sh_houses` (`owner`, `label`, `entercoords`, `garagecoords`, `shell`, `shellgarage`, `price`, `inventorylevel`, `safelevel`, `furniture`, `storage_data`) VALUES
	(NULL, '2677 Whispymound Drive', '{"y": 564.89, "z": 182.959, "x": 119.384, "w": 0}', NULL, 'shell_apartment1', NULL, 1500000, 1, 1, '[]', 'housing'),
	(NULL, '2045 North Conker Avenue', '{"x": 372.796, "y": 428.327, "z": 144.685, "w": 0}', NULL, 'shell_apartment2', NULL, 1500000, 1, 1, '[]', 'housing'),
	(NULL, 'Richard Majestic, Apt 2', '{"y": -379.165, "z": 37.961, "x": -936.363, "w": 0}', NULL, 'shell_apartment3', NULL, 1700000, 1, 1, '[]', 'housing'),
	(NULL, '2044 North Conker Avenue', '{"y": 440.8, "z": 146.702, "x": 346.964, "w": 0}', NULL, 'shell_apartment1', NULL, 1500000, 1, 1, '[]', 'housing'),
	(NULL, '3655 Wild Oats Drive', '{"y": 502.696, "z": 136.421, "x": -176.003, "w": 0}', NULL, 'shell_apartment2', NULL, 1500000, 1, 1, '[]', 'housing'),
	(NULL, '2862 Hillcrest Avenue', '{"y": 596.58, "z": 142.641, "x": -686.554, "w": 0}', NULL, 'shell_apartment3', NULL, 1500000, 1, 1, '[]', 'housing'),
	(NULL, 'Appartement de base', '{"y": -1078.735, "z": 28.4031, "x": 292.528, "w": 0}', NULL, 'shell_apartment1', NULL, 1500000, 1, 1, '[]', 'housing'),
	(NULL, '2113 Mad Wayne Thunder', '{"y": 454.955, "z": 96.462, "x": -1294.433, "w": 0}', NULL, 'shell_apartment2', NULL, 1500000, 1, 1, '[]', 'housing'),
	(NULL, '2874 Hillcrest Avenue', '{"x": -853.346, "y": 696.678, "z": 147.782, "w": 0}', NULL, 'shell_apartment3', NULL, 1500000, 1, 1, '[]', 'housing'),
	(NULL, '2868 Hillcrest Avenue', '{"y": 620.494, "z": 141.588, "x": -752.82, "w": 0}', NULL, 'shell_apartment1', NULL, 1500000, 1, 1, '[]', 'housing'),
	(NULL, 'Tinsel Towers, Apt 42', '{"y": 37.025, "z": 42.58, "x": -618.299, "w": 0}', NULL, 'shell_apartment2', NULL, 1700000, 1, 1, '[]', 'housing');

-- ============================================================================
-- 3 ساختمان آپارتمانی: Milton Drive, 4 Integrity Way, Dell Perro Heights
-- (id واقعی‌شون رو تو @gw1/@gw2/@gw3 نگه می‌داریم، فرض ثابتی رو id نمی‌کنیم)
-- ============================================================================
INSERT INTO `sh_apartments` (`label`, `entercoords`) VALUES
	('Milton Drive', '{"x": -775.17, "y": 312.01, "z": 84.658, "w": 0}');
SET @gw1 = LAST_INSERT_ID();
INSERT INTO `sh_apartments` (`label`, `entercoords`) VALUES
	('4 Integrity Way', '{"x": -47.804, "y": -585.867, "z": 36.956, "w": 0}');
SET @gw2 = LAST_INSERT_ID();
INSERT INTO `sh_apartments` (`label`, `entercoords`) VALUES
	('Dell Perro Heights', '{"x": -1447.06, "y": -538.28, "z": 33.74, "w": 0}');
SET @gw3 = LAST_INSERT_ID();

-- ============================================================================
-- 28 واحد آپارتمانی
-- ============================================================================
INSERT INTO `sh_apartment_units` (`apartment_id`, `floor`, `shell`, `price`, `label`, `inventorylevel`, `safelevel`, `furniture`, `storage_data`) VALUES
	(@gw1,  1, 'shell_apartment1', 1500000, 'Appartement Moderne 1', 1, 1, '[]', 'housing'),
	(@gw1,  1, 'shell_apartment2', 1500000, 'Appartement Moderne 2', 1, 1, '[]', 'housing'),
	(@gw1,  1, 'shell_apartment3', 1500000, 'Appartement Moderne 3', 1, 1, '[]', 'housing'),
	(@gw1,  1, 'shell_apartment1', 1500000, 'Appartement Mode 1', 1, 1, '[]', 'housing'),
	(@gw1,  1, 'shell_apartment2', 1500000, 'Appartement Mode 2', 1, 1, '[]', 'housing'),
	(@gw1,  1, 'shell_apartment3', 1500000, 'Appartement Mode 3', 1, 1, '[]', 'housing'),
	(@gw1,  1, 'shell_apartment1', 1500000, 'Appartement Vibrant 1', 1, 1, '[]', 'housing'),
	(@gw1,  1, 'shell_apartment2', 1500000, 'Appartement Vibrant 2', 1, 1, '[]', 'housing'),
	(@gw1,  1, 'shell_apartment3', 1500000, 'Appartement Vibrant 3', 1, 1, '[]', 'housing'),
	(@gw1,  1, 'shell_apartment1', 1500000, 'Appartement Persan 1', 1, 1, '[]', 'housing'),
	(@gw1,  1, 'shell_apartment2', 1500000, 'Appartement Persan 2', 1, 1, '[]', 'housing'),
	(@gw1,  1, 'shell_apartment3', 1500000, 'Appartement Persan 3', 1, 1, '[]', 'housing'),
	(@gw1,  1, 'shell_apartment1', 1500000, 'Appartement Monochrome 1', 1, 1, '[]', 'housing'),
	(@gw1,  1, 'shell_apartment2', 1500000, 'Appartement Monochrome 2', 1, 1, '[]', 'housing'),
	(@gw1,  1, 'shell_apartment3', 1500000, 'Appartement Monochrome 3', 1, 1, '[]', 'housing'),
	(@gw1,  1, 'shell_apartment1', 1500000, 'Appartement Séduisant 1', 1, 1, '[]', 'housing'),
	(@gw1,  1, 'shell_apartment2', 1500000, 'Appartement Séduisant 2', 1, 1, '[]', 'housing'),
	(@gw1,  1, 'shell_apartment3', 1500000, 'Appartement Séduisant 3', 1, 1, '[]', 'housing'),
	(@gw1,  1, 'shell_apartment1', 1500000, 'Appartement Royal 1', 1, 1, '[]', 'housing'),
	(@gw1,  1, 'shell_apartment2', 1500000, 'Appartement Royal 2', 1, 1, '[]', 'housing'),
	(@gw1,  1, 'shell_apartment3', 1500000, 'Appartement Royal 3', 1, 1, '[]', 'housing'),
	(@gw1,  1, 'shell_apartment1', 1500000, 'Appartement Aqua 1', 1, 1, '[]', 'housing'),
	(@gw1,  1, 'shell_apartment2', 1500000, 'Appartement Aqua 2', 1, 1, '[]', 'housing'),
	(@gw1,  1, 'shell_apartment3', 1500000, 'Appartement Aqua 3', 1, 1, '[]', 'housing'),
	(@gw2,  1, 'shell_apartment1', 1700000, '4 Integrity Way - Apt 28', 1, 1, '[]', 'housing'),
	(@gw2,  1, 'shell_apartment2', 1700000, '4 Integrity Way - Apt 30', 1, 1, '[]', 'housing'),
	(@gw3,  1, 'shell_apartment3', 1700000, 'Dell Perro Heights - Apt 28', 1, 1, '[]', 'housing'),
	(@gw3,  1, 'shell_apartment1', 1700000, 'Dell Perro Heights - Apt 30', 1, 1, '[]', 'housing');
