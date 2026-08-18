-- Unique_Login — run this once before starting the resource.

CREATE TABLE IF NOT EXISTS `login_users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL,
  `password` char(64) NOT NULL, -- SHA2-256 hex digest, never plaintext
  `phone` varchar(32) DEFAULT NULL,
  `license` varchar(128) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_login_users_username` (`username`),
  UNIQUE KEY `uq_login_users_license` (`license`),
  KEY `idx_login_users_phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
