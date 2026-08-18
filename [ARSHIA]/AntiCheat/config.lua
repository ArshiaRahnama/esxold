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
