

Config = {}

Config.SMS = {
    ApiUrl    = "https://api.sms.ir/v1/send/verify",



    ApiKey    = "v16gfSyyi7z23aw74j4GsQRrdgMvwVLUCepqyqBMPEGVQIIY",
    TemplateId = 461982,
}

-- How many SMS codes a single phone number / connecting IP can request
-- before being told to wait. Protects your sms.ir balance from being
-- drained by spam and stops phone-number bombing.
Config.SmsRateLimit = {
    MaxPerPhonePerHour = 3,
    MaxPerIpPerHour     = 5,
}

-- Username/password brute-force lockout.
Config.LoginLockout = {
    MaxAttempts  = 5,   -- failed attempts before locking
    LockMinutes  = 15,  -- how long the username stays locked
}

-- EXPANSION: how many DISTINCT new devices, within how many seconds, before
-- an account is put on security_hold (see sql/install.sql comment). Only
-- a successful SMS-OTP password reset clears the hold.
Config.SuspiciousDeviceLock = {
    MaxNewDevices = 3,
    WindowSeconds = 600, -- 10 minutes
}

-- EXPANSION: login_audit grows forever otherwise. Rows older than this get
-- deleted automatically once a day. Set to 0 to disable cleanup entirely.
Config.AuditLogRetentionDays = 90

-- EXPANSION: Discord webhook for security-relevant events (new device
-- login, password reset). Leave SecurityAlerts empty ("") to disable —
-- everything still gets written to the login_audit table either way.
-- Create your own webhook in a private admin channel; don't reuse a
-- webhook from another resource here.
Config.DiscordWebhook = {
    SecurityAlerts = "",
}

-- EXPANSION: username registration blacklist. Checked as a case-insensitive
-- SUBSTRING match, so "xAdminx" and "Owner123" get caught too, not just
-- exact matches. Add your own server-specific staff role names here.
Config.UsernameBlacklist = {
    "admin", "administrator", "owner", "founder", "support", "staff",
    "moderator", "mod", "gm", "developer", "dev", "system", "unique_rp",
    "uniquerp", "helper", "management", "ceo",
}
