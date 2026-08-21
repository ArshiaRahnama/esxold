-- Unique_Login — run this once before starting the resource.

CREATE TABLE IF NOT EXISTS `login_users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL,
  `password` char(64) NOT NULL, -- SHA2-256 hex digest, never plaintext
  `phone` varchar(32) DEFAULT NULL,
  `license` varchar(128) NOT NULL,
  -- EXPANSION: the real FiveM `license:` identifier of the device that most
  -- recently logged into this account. Lets playerConnecting auto-login
  -- returning players (same PC) without showing the panel again.
  `device_license` varchar(128) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_login_users_username` (`username`),
  UNIQUE KEY `uq_login_users_license` (`license`),
  KEY `idx_login_users_phone` (`phone`),
  KEY `idx_login_users_device_license` (`device_license`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ─────────────────────────────────────────────────────────
-- If you already have this table from before (old installs), run this once
-- to add the new column instead of the CREATE TABLE above:
--
-- ALTER TABLE `login_users`
--   ADD COLUMN `device_license` varchar(128) DEFAULT NULL AFTER `license`,
--   ADD KEY `idx_login_users_device_license` (`device_license`);
-- ─────────────────────────────────────────────────────────

-- EXPANSION: used by both the in-game SMS rate limiter (as a MySQL-backed
-- fallback description only — the Lua side actually rate-limits in memory)
-- and by web/reset-password.php, which has no long-lived memory between
-- requests so it needs this table to track "N requests per phone/IP per
-- hour" across page loads.
CREATE TABLE IF NOT EXISTS `login_reset_throttle` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bucket_key` varchar(64) NOT NULL, -- e.g. "phone:9123456789" or "ip:1.2.3.4"
  `window_start` int unsigned NOT NULL,
  `count` int unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_bucket_key` (`bucket_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- EXPANSION: audit trail — every login attempt (success/fail), registration,
-- password reset, and new-device event gets a row here. Nothing in this
-- resource reads it back yet; it's there so an admin panel (or a plain
-- SELECT ... WHERE username = ?) can show "recent activity" on an account,
-- and so patterns like many failed logins across many IPs are visible.
CREATE TABLE IF NOT EXISTS `login_audit` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) DEFAULT NULL,
  `license` varchar(128) DEFAULT NULL,        -- this resource's own account id
  `device_license` varchar(128) DEFAULT NULL, -- real FiveM license: of the connecting device
  `ip` varchar(64) DEFAULT NULL,
  `action` enum('login_success','login_fail','register','password_reset','new_device') NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_login_audit_username` (`username`),
  KEY `idx_login_audit_device_license` (`device_license`),
  KEY `idx_login_audit_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
