-- AntiCheat — Statistical anomaly-detection add-on for UNIQUE_AC
-- by Arshia | arshiahub.ir | Unique RP
--
-- HONEST LABELING: "ML" here means lightweight *online/unsupervised statistics*
-- (per-player rolling mean/variance + z-score anomaly scoring, exactly like the
-- existing UNIQUE_AC.AimbotWatch / BehavioralClustering features already do).
-- There is no neural network, no training data, no GPU — Lua on a game server
-- can't realistically run heavy ML, and pretending otherwise would just make the
-- detector harder to tune. What you get instead is something genuinely useful:
-- each player gets their OWN learned baseline (their normal sprint speed, their
-- normal vehicle top speed, etc.) instead of one fixed number for everyone, so
-- it catches subtler cheats and produces fewer false positives on legit players
-- with movement-affecting perks (agility skills, fast cars, jetpacks, etc.).

Config = {}

Config.Debug = false -- print flag reasoning to server console

-- ============================================================
-- Trust Score
-- Every category below raises/lowers a 0-100 trust score per player.
-- Nothing here ever bans by itself — only KICK (soft) and WEBHOOK (report)
-- are wired to score thresholds. Real bans stay a human/admin decision,
-- exactly like UNIQUE_AC's own AimbotWatch/BehavioralClustering philosophy.
-- ============================================================
Config.TrustScore = {
    StartingScore     = 100,
    RecoverPerMinute  = 2,      -- slowly heals if the player behaves
    KickAtScore       = 35,
    WebhookAtScore    = 60,     -- report to Discord for a human to review
    MinScore          = 0,
    MaxScore          = 100,
    -- Safety net: the SAME kind can never re-penalize the SAME player more
    -- than once within this window, no matter what any individual check
    -- does. This exists so a bug/edge-case in any one detector (present or
    -- future) can never drain a clean 100 to a kick in a handful of
    -- seconds by itself -- it caps the worst-case drain rate server-side,
    -- on top of whatever debouncing each check does on its own.
    MinReflagIntervalMs = 4000,
}

-- ============================================================
-- Speed Hack (on-foot + vehicle)
-- Online anomaly detection: each player builds their own rolling
-- mean/variance (Welford's algorithm) of observed speed per movement
-- state. A sample is flagged if it's an extreme outlier from THEIR OWN
-- recent baseline AND above a hard sanity ceiling (so a single lucky
-- sample right after spawn/teleport never triggers anything).
-- ============================================================
Config.SpeedCheck = {
    Enable            = true,
    SampleIntervalMs  = 1000,
    MinSamplesForBaseline = 12,   -- don't judge anyone until we've learned their normal pace
    ZScoreThreshold   = 4.2,      -- how many std-deviations above their OWN baseline counts as an outlier
    HardCeilingFoot   = 14.0,     -- m/s sanity ceiling on foot (sprint is ~7-8 m/s), regardless of baseline
    HardCeilingVehicle= 130.0,    -- m/s sanity ceiling in a vehicle (~468 km/h)
    IgnoreIfFalling   = true,     -- parachute/falling gives huge vertical speed, not a cheat
    IgnoreIfInAircraft= true,     -- planes/helis legitimately exceed the vehicle ceiling
    ScorePenalty      = 18,
}

-- ============================================================
-- Noclip
-- Combines 3 independent, cheap signals into one weighted vote instead
-- of trusting any single check (this is what keeps the false-positive
-- rate low): moving through solid geometry, no vertical/gravity
-- response while airborne, and zero collision entities nearby along
-- the travel path. All 3 must roughly agree before it counts.
-- ============================================================
Config.NoclipCheck = {
    Enable                 = true,
    SampleIntervalMs       = 800,
    RequireSignals         = 2,   -- how many of the 3 signals must fire together
    RaycastThroughWorld    = true,
    IgnoreIfInVehicle      = false,
    IgnoreIfSwimming       = true,
    IgnoreIfOnLadder       = true,
    IgnoreIfParachuting    = true,
    ScorePenalty           = 30,
}

-- ============================================================
-- God Mode
-- Correlates "did this player take damage" (weapon hit / explosion /
-- fall event) against "did their health actually go down". A single
-- missed tick is ignored (network jitter, armor absorbing a shot);
-- only a repeated pattern within a short window is flagged.
-- ============================================================
Config.GodmodeCheck = {
    Enable              = true,
    RequiredNoDamageHits = 3,   -- this many "should've taken damage" events in a row with 0 hp loss
    WindowMs            = 15000,
    IgnoreDuringSpawnProtectionMs = 10000, -- matches most spawn-invincibility windows
    ScorePenalty        = 35,
}

-- ============================================================
-- Teleport / Position Desync
-- Independent from the Speed check above: this one doesn't care what
-- GetEntitySpeed() *reports*, it just measures raw straight-line
-- distance between two samples and compares it to the maximum any
-- legit ped/vehicle could possibly cover in that time. Catches
-- teleport-style hacks that jump position without ever "moving"
-- through intermediate speed.
-- ============================================================
Config.TeleportCheck = {
    Enable            = true,
    SampleIntervalMs  = 1000,
    MaxMetersPerSecond = 140.0, -- generous ceiling above even a fast plane
    IgnoreIfInAircraft = true,
    ScorePenalty      = 40,
}

-- ============================================================
-- Super Jump
-- Legit jumps (even with sprint-jump momentum) have a fairly bounded
-- apex vertical velocity. A sustained pattern of way-higher-than-normal
-- jump velocity is the classic "super jump" mod.
-- ============================================================
Config.SuperJumpCheck = {
    Enable              = true,
    SampleIntervalMs    = 250,
    MaxVerticalVelocity = 9.0,   -- m/s, normal jump peak is roughly 4-5
    RequiredOccurrences = 3,     -- need a pattern, not one lucky ledge-grab
    WindowMs            = 20000,
    ScorePenalty        = 22,
}

-- ============================================================
-- Invisibility
-- IsEntityVisible() is normally true for a controlled, alive ped.
-- A handful of legit exceptions (character creation/cutscenes) are
-- excluded via the ignore flags below.
-- ============================================================
Config.InvisibilityCheck = {
    Enable                = true,
    SampleIntervalMs      = 1000,
    RequiredOccurrences   = 5,   -- consecutive samples, not one loading-screen frame
    IgnoreDuringSpawnProtectionMs = 10000,
    ScorePenalty          = 25,
}

-- ============================================================
-- Infinite Ammo
-- Tracks total ammo for the currently-held weapon; every time a shot
-- is confirmed fired (IsPedShooting edge), ammo should go down by
-- exactly 1 (or stay the same only for unlimited-ammo weapons like
-- the stun gun, which are excluded). A repeated "fired but ammo
-- unchanged" pattern is infinite ammo.
-- ============================================================
Config.InfiniteAmmoCheck = {
    Enable              = true,
    RequiredOccurrences = 6,
    WindowMs            = 15000,
    IgnoreWeapons       = { GetHashKey('WEAPON_STUNGUN'), GetHashKey('WEAPON_FIREEXTINGUISHER'), GetHashKey('WEAPON_PETROLCAN') },
    ScorePenalty        = 28,
}

-- ============================================================
-- Weapon Fire Rate
-- Every weapon has a natural minimum time between shots (its cycle
-- time). This just measures the gap between consecutive confirmed
-- shots and flags a sustained pattern of firing faster than that.
-- Values are intentionally generous (well above real cycle times) to
-- absorb network jitter — tune per-weapon in WeaponMinCycleMs if you
-- get false positives on a specific gun.
-- ============================================================
Config.FireRateCheck = {
    Enable               = true,
    DefaultMinCycleMs    = 80,   -- generic floor for anything not listed below
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

-- ============================================================
-- Weapon Blacklist
-- Weapons a civilian on an RP server shouldn't be carrying at all
-- (military-grade weapons). Purely a possession check — doesn't care
-- how they got it, since the server is the only source of truth on
-- what a player is holding.
-- ============================================================
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

-- ============================================================
-- Vehicle Handling Anomaly
-- Compares tick-to-tick SPEED CHANGE (acceleration), not top speed
-- (already covered by Speed/Teleport checks above), against a
-- generous ceiling by vehicle class. Catches "speedo" style handling
-- mods that let a car hit 100km/h in half a second.
-- ============================================================
Config.VehicleHandlingCheck = {
    Enable              = true,
    SampleIntervalMs    = 300,
    MaxAccelMPS2        = 22.0,  -- m/s^2 — a supercar is roughly 8-10
    RequiredOccurrences = 3,
    WindowMs            = 10000,
    ScorePenalty        = 20,
}

-- ============================================================
-- Instant Armor/Health Refill
-- A jump from low to (near) max armor or health with no matching
-- pickup/heal action in the same window is suspicious. This is a
-- soft signal (armor pickups are legitimately instant too), so the
-- penalty is low and it mainly feeds correlation rather than kicking
-- alone.
-- ============================================================
Config.InstantRefillCheck = {
    Enable              = true,
    SampleIntervalMs    = 500,
    MinJump             = 80,    -- ignore small top-ups
    RequiredOccurrences = 3,
    WindowMs            = 15000,
    ScorePenalty         = 12,
}

-- ============================================================
-- Resource Whitelist (HONESTLY LIMITED — read this)
-- GetNumResources()/GetResourceByFindIndex() only sees resources
-- registered through the normal FiveM resource system. Popular
-- memory-injected mod menus do NOT show up here at all — this check
-- only catches someone running an actual unauthorized *resource*
-- (a leftover debug/dev resource, a leaked script someone dropped in
-- their own resources folder, etc). It's a free, low-risk extra
-- layer, not a replacement for the real detections above.
-- ============================================================
Config.ResourceWhitelistCheck = {
    Enable          = true,
    SampleIntervalMs = 60000,
    ScorePenalty    = 15,
    -- resources allowed to be client-side-active that this list doesn't
    -- need to know about individually (add your own exceptions here)
    ExtraAllowed = {},
}
-- ============================================================
-- Cross-player correlation (same idea as UNIQUE_AC.BehavioralClustering):
-- if 2+ different players trip the SAME category within a short window,
-- it's likely a shared/leaked tool spreading on the server. Only raises
-- webhook priority, never punishes by itself.
-- ============================================================
Config.Correlation = {
    Enable      = true,
    WindowMs    = 300000, -- 5 minutes
    MinPlayers  = 2,
}

-- ============================================================
-- Persistence (optional) — logs every flag to its own MySQL table
-- (see sql/install.sql) so admins can review history even after a
-- restart. Requires oxmysql, which is already loaded earlier in
-- server.cfg for the rest of the server.
-- ============================================================
Config.Persistence = {
    Enable = false, -- set true after running sql/install.sql
}

-- ============================================================
-- Actions
-- ============================================================
Config.Actions = {
    KickMessage = "متاسفانه سیستم امنیتی رفتار مشکوکی رو در حساب شما تشخیص داد. اگه فکر می‌کنید اشتباه شده، تیکت بزنید.",
    -- Set your own webhook here — intentionally NOT shared with UNIQUE_AC's
    -- own Webhooks table, since this is a separate resource/environment.
    DiscordWebhook = "",
    DiscordUsername = "AntiCheat",
}
