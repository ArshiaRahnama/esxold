Config = {}
Config.Locale = "en"

Config.Accounts = {"bank", "black_money"}
Config.AccountLabels = {bank = _U("bank"), black_money = _U("black_money")}
Config.TargetDistance = 4

Config.EnableSocietyPayouts = true -- pay from the society account that the player is employed at? Requirement: esx_society
Config.ShowDotAbovePlayer = false
Config.DisableWantedLevel = true
Config.EnableHud = false -- enable the default hud? Display current job and accounts (black, bank & cash)

Config.PaycheckInterval = 15 * 60000
Config.MaxPlayers = GetConvarInt("sv_maxclients", 64)

Config.EnableDebug = false

-- Added for sun-inventory-hud: default carry-weight limit for
-- xPlayer.canCarryItem / getMaxWeight (grams). Nothing existed for
-- this before, so any value here is new, not a change to an old one.
Config.DefaultMaxWeight = 24000
