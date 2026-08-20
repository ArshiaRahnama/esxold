<?php
declare(strict_types=1);

// ============================================================================
//  Unique_Login — web password-reset panel — configuration
//
//  Same pattern as UNIQUE_AC/central-hub: real secrets go in
//  local-config.php (create it yourself, next to this file), which is NOT
//  part of the zip/repo. This file only supplies safe fallback defaults.
//
//  local-config.php should look like:
//
//    <?php
//    define('RESET_DB_HOST', '127.0.0.1');
//    define('RESET_DB_NAME', 'essentialmode');
//    define('RESET_DB_USER', 'unique_login_web');   -- see README, do NOT use root
//    define('RESET_DB_PASS', 'a-strong-password');
//    define('RESET_SMS_API_KEY', 'the-real-sms.ir-key');
// ============================================================================

if (file_exists(__DIR__ . '/local-config.php')) {
    require __DIR__ . '/local-config.php';
}

if (!defined('RESET_DB_HOST')) define('RESET_DB_HOST', '127.0.0.1');
if (!defined('RESET_DB_NAME')) define('RESET_DB_NAME', 'essentialmode');
if (!defined('RESET_DB_USER')) define('RESET_DB_USER', 'change-me');
if (!defined('RESET_DB_PASS')) define('RESET_DB_PASS', 'change-me');

if (!defined('RESET_SMS_API_URL'))     define('RESET_SMS_API_URL', 'https://api.sms.ir/v1/send/verify');
if (!defined('RESET_SMS_API_KEY'))     define('RESET_SMS_API_KEY', 'change-me');
if (!defined('RESET_SMS_TEMPLATE_ID')) define('RESET_SMS_TEMPLATE_ID', 461982);

// Same limits as the in-game Config.SmsRateLimit / OTP expiry in config.lua —
// keep these two in sync by hand, they're separate apps hitting the same DB.
if (!defined('RESET_MAX_PER_PHONE_PER_HOUR')) define('RESET_MAX_PER_PHONE_PER_HOUR', 3);
if (!defined('RESET_MAX_PER_IP_PER_HOUR'))    define('RESET_MAX_PER_IP_PER_HOUR', 5);
if (!defined('RESET_CODE_TTL_SECONDS'))       define('RESET_CODE_TTL_SECONDS', 120);
