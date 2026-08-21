

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

-- EXPANSION: Discord webhook for security-relevant events (new device
-- login, password reset). Leave SecurityAlerts empty ("") to disable —
-- everything still gets written to the login_audit table either way.
-- Create your own webhook in a private admin channel; don't reuse a
-- webhook from another resource here.
Config.DiscordWebhook = {
    SecurityAlerts = "",
}
