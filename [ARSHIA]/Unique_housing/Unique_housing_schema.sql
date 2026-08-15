-- ============================================================================
-- Sunset Housing (Unique_housing) - Database Schema
-- ============================================================================
-- این جدول‌ها رو خودِ server/db.lua موقع استارت ریسورس هم اتومات با
-- CREATE TABLE IF NOT EXISTS می‌سازه، پس ایمپورت دستی این فایل اختیاریه -
-- ولی اگه می‌خوای از قبل رو دیتابیس داشته باشیش یا بهش نگاه بندازی، اینه.
-- ایمپورت چند باره‌اش هم مشکلی نداره (همه‌جا IF NOT EXISTS داره).
--
-- روی همون دیتابیسی اجرا کن که essentialmode/سرورت روشه (USE دستی بزن یا
-- از phpMyAdmin/HeidiSQL روی دیتابیس درست انتخابش کن).
-- ============================================================================

-- ----------------------------------------------------------------------------
-- sh_houses: خونه‌های تکی (غیر آپارتمانی)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `sh_houses` (
  `id`             INT(11)      NOT NULL AUTO_INCREMENT,
  `owner`          VARCHAR(60)  DEFAULT NULL,
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

-- ----------------------------------------------------------------------------
-- sh_apartments: ساختمان‌های آپارتمانی (نقطه‌ی ورودی/بلیپ)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `sh_apartments` (
  `id`          INT(11)      NOT NULL AUTO_INCREMENT,
  `label`       VARCHAR(100) DEFAULT NULL,
  `entercoords` LONGTEXT     DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------------------------------------------------------
-- sh_apartment_units: واحدهای تکی داخل هر ساختمان آپارتمانی
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `sh_apartment_units` (
  `id`             INT(11)      NOT NULL AUTO_INCREMENT,
  `apartment_id`   INT(11)      NOT NULL,
  `floor`          INT(11)      NOT NULL DEFAULT 1,
  `owner`          VARCHAR(60)  DEFAULT NULL,
  `shell`          VARCHAR(100) DEFAULT NULL,
  `price`          INT(11)      NOT NULL DEFAULT 0,
  `inventorylevel` INT(11)      NOT NULL DEFAULT 1,
  `safelevel`      INT(11)      NOT NULL DEFAULT 1,
  `furniture`      LONGTEXT     DEFAULT '[]',
  `storage_data`   VARCHAR(100) DEFAULT 'housing',
  PRIMARY KEY (`id`),
  KEY `apartment_id` (`apartment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------------------------------------------------------
-- sh_storage: انبار/گاوصندوق/صندوق‌پستی هر خونه (یه ردیف به ازای هر stash)
-- name مثلاً: house_12 / house_safe_12 / house_postbox_12
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `sh_storage` (
  `name`    VARCHAR(64) NOT NULL PRIMARY KEY,
  `items`   LONGTEXT    NOT NULL DEFAULT ('[]'),
  `weapons` LONGTEXT    NOT NULL DEFAULT ('[]')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------------------------------------------------------
-- sh_garage_vehicles: ماشین‌های پارک‌شده تو گاراژ اختصاصی هر خونه
-- (جدا از owned_vehicles شغلی Unique_Garage، عمداً)
-- ----------------------------------------------------------------------------
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
-- نمونه‌ی تست: یه خونه‌ی تکی واقعی که مستقیم بعد از ایمپورت رو مپ می‌بینی
-- (Shell = 'shell_apartment1' چون تو config.lua پیش‌فرض تعریف شده بود -
-- اگه اسم شل دیگه‌ای استفاده می‌کنی، این مقدار رو عوض کن)
-- ============================================================================
INSERT INTO `sh_houses` (`owner`, `entercoords`, `garagecoords`, `shell`, `shellgarage`, `price`)
VALUES (
  NULL,
  '{"x": -269.482, "y": -955.936, "z": 31.22, "w": 0}',
  NULL,
  'shell_apartment1',
  NULL,
  150000
);
