

Config = {}

Config.Debug = false

Config.TrustScore = {
    StartingScore     = 100,
    RecoverPerMinute  = 2,
    KickAtScore       = 35,
    WebhookAtScore    = 60,
    MinScore          = 0,
    MaxScore          = 100,






    MinReflagIntervalMs = 4000,
}

Config.SpeedCheck = {
    Enable            = true,
    SampleIntervalMs  = 1000,
    MinSamplesForBaseline = 12,
    ZScoreThreshold   = 4.2,
    HardCeilingFoot   = 14.0,
    HardCeilingVehicle= 130.0,
    IgnoreIfFalling   = true,
    IgnoreIfInAircraft= true,
    ScorePenalty      = 18,
}

Config.NoclipCheck = {
    Enable                 = true,
    SampleIntervalMs       = 800,
    RequireSignals         = 2,
    RaycastThroughWorld    = true,
    IgnoreIfInVehicle      = false,
    IgnoreIfSwimming       = true,
    IgnoreIfOnLadder       = true,
    IgnoreIfParachuting    = true,
    ScorePenalty           = 30,
}

Config.GodmodeCheck = {
    Enable              = true,
    RequiredNoDamageHits = 3,
    WindowMs            = 15000,
    IgnoreDuringSpawnProtectionMs = 10000,
    ScorePenalty        = 35,
}

Config.TeleportCheck = {
    Enable            = true,
    SampleIntervalMs  = 1000,
    MaxMetersPerSecond = 140.0,
    IgnoreIfInAircraft = true,
    ScorePenalty      = 40,
}

Config.SuperJumpCheck = {
    Enable              = true,
    SampleIntervalMs    = 250,
    MaxVerticalVelocity = 9.0,
    RequiredOccurrences = 3,
    WindowMs            = 20000,
    ScorePenalty        = 22,
}

Config.InvisibilityCheck = {
    Enable                = true,
    SampleIntervalMs      = 1000,
    RequiredOccurrences   = 5,
    IgnoreDuringSpawnProtectionMs = 10000,
    ScorePenalty          = 25,
}

Config.InfiniteAmmoCheck = {
    Enable              = true,
    RequiredOccurrences = 6,
    WindowMs            = 15000,
    IgnoreWeapons       = { GetHashKey('WEAPON_STUNGUN'), GetHashKey('WEAPON_FIREEXTINGUISHER'), GetHashKey('WEAPON_PETROLCAN') },
    ScorePenalty        = 28,
}

Config.FireRateCheck = {
    Enable               = true,
    DefaultMinCycleMs    = 80,
    WeaponMinCycleMs = {
        [GetHashKey('WEAPON_PISTOL')]     = 260,
        [GetHashKey('WEAPON_COMBATPISTOL')] = 220,
        [GetHashKey('WEAPON_MICROSMG')]   = 90,
        [GetHashKey('WEAPON_SMG')]        = 90,
        [GetHashKey('WEAPON_ASSAULTRIFLE')] = 95,
        [GetHashKey('WEAPON_CARBINERIFLE')] = 95,
        [GetHashKey('WEAPON_PUMPSHOTGUN')] = 700,
        [GetHashKey('WEAPON_SNIPERRIFLE')] = 900,
    },
    RequiredOccurrences  = 4,
    WindowMs             = 8000,
    ScorePenalty         = 24,
}

Config.WeaponBlacklistCheck = {
    Enable          = true,
    SampleIntervalMs = 3000,
    Weapons = {
        GetHashKey('WEAPON_RPG'), GetHashKey('WEAPON_MINIGUN'), GetHashKey('WEAPON_RAILGUN'),
        GetHashKey('WEAPON_HOMINGLAUNCHER'), GetHashKey('WEAPON_GRENADELAUNCHER'),
        GetHashKey('WEAPON_COMPACTLAUNCHER'), GetHashKey('WEAPON_RAYMINIGUN'),
    },
    ScorePenalty    = 45,
}

Config.VehicleHandlingCheck = {
    Enable              = true,
    SampleIntervalMs    = 300,
    MaxAccelMPS2        = 22.0,
    RequiredOccurrences = 3,
    WindowMs            = 10000,
    ScorePenalty        = 20,
}

Config.InstantRefillCheck = {
    Enable              = true,
    SampleIntervalMs    = 500,
    MinJump             = 80,
    RequiredOccurrences = 3,
    WindowMs            = 15000,
    ScorePenalty         = 12,
}

Config.ResourceWhitelistCheck = {
    Enable          = true,
    SampleIntervalMs = 60000,
    ScorePenalty    = 15,


    ExtraAllowed = {},
}

Config.Correlation = {
    Enable      = true,
    WindowMs    = 300000,
    MinPlayers  = 2,
}

Config.Persistence = {
    Enable = false,
}

Config.Actions = {
    KickMessage = "متاسفانه سیستم امنیتی رفتار مشکوکی رو در حساب شما تشخیص داد. اگه فکر می‌کنید اشتباه شده، تیکت بزنید.",


    DiscordWebhook = "",
    DiscordUsername = "AntiCheat",
}
