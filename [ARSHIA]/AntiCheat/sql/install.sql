-- AntiCheat — run this once. Fully separate from UNIQUE_AC's own tables
-- (no shared table names, no foreign keys into UNIQUE_AC) so installing or
-- removing this module never touches UNIQUE_AC's own data.

CREATE TABLE IF NOT EXISTS `anticheat_flags` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(128) NOT NULL,
  `player_name` varchar(128) DEFAULT NULL,
  `kind` varchar(32) NOT NULL,
  `score_after` int NOT NULL,
  `evidence` longtext,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_anticheat_identifier` (`identifier`),
  KEY `idx_anticheat_kind` (`kind`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
