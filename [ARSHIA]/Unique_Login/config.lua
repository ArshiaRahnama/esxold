-- Unique_Login/config.lua
-- Secrets pulled out of server.lua so this file (and NOT the source code)
-- is the one thing you keep out of git / don't share when asking for help.

Config = {}

Config.SMS = {
    ApiUrl    = "https://api.sms.ir/v1/send/verify",
    -- ⚠️ SECRET — was hardcoded directly in server.lua before. Rotate this
    -- key if this project has ever been shared/committed publicly with the
    -- old value still in it.
    ApiKey    = "v16gfSyyi7z23aw74j4GsQRrdgMvwVLUCepqyqBMPEGVQIIY",
    TemplateId = 461982,
}
