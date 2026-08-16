Config = {}

-- Main Section
Config.KillersWebhook = "https://discord.com/api/webhooks/1290638682130481183/2Qc2ihDsTEc0Fkw-DcVgTcQAo9Ti7iYInJekYwxrdxLeWQodD1LOUCOma0yWKLEACDf1"
Config.GangsWebhook = "https://discord.com/api/webhooks/1290638682130481183/2Qc2ihDsTEc0Fkw-DcVgTcQAo9Ti7iYInJekYwxrdxLeWQodD1LOUCOma0yWKLEACDf1"

-- ============================================================================
-- Full Discord Logging — set any of these to your own webhook URL to enable
-- that specific log category. Leave "" to disable just that one. You can point
-- several categories at the SAME webhook if you want it all in one channel, or
-- split them across different channels — totally up to you.
-- ============================================================================
Config.EnableDetailedLogging = true -- master on/off switch for everything below
Config.LogUsername = "Unique Capture System"
Config.LogAvatarUrl = "" -- put a logo image URL here if you want, else Discord's default is used

Config.Webhooks = {
    RoundStart  = "", -- a round starts (/startCap)
    RoundEnd    = "", -- a round ends, short summary (separate from the existing Killers/Gangs webhooks above)
    ZoneCapture = "", -- a zone changes hands mid-round
    Kills       = "", -- every individual kill (can get noisy on a busy server - that's the point)
    Season      = "", -- season warnings, season end, Hall of Fame inductions
    Medals      = "", -- every scarce medal claimed
    Admin       = "", -- theme changes, forced season resets, dry-run results, zone import/export
}


Config.getSharedObjectTrigger = "esx:getSharedObject"
Config.CaptureWorld = 50
Config.ReviveTrigger = "esx_ambulancejob:revivex"

-- Gang System Table (change these if you switch gang systems / your table or column names differ)
Config.GangsTable = "gangs_data"
Config.GangsNameColumn = "gang_name"
Config.GangsBossColumn = "boss"
Config.GangsLogoColumn = "logo"
Config.DefaultGangLogo = "defaultlogo"
-- How to turn the `logo` DB value into an actual image URL for the UI.
-- If the DB value already starts with http(s):// it's used as-is.
-- Otherwise it's inserted into this template. Adjust to match your gang menu's asset path.
Config.GangLogoUrlTemplate = "nui://gangmenu/img/logos/%s.png"

-- Player Profile Pictures (Top Killers list)
Config.UsersTable = "users"
Config.UsersIdentifierColumn = "identifier"
Config.UsersProfilePicColumn = "Profile_Pic"
-- If the DB value already starts with http(s):// it's used as-is.
-- Otherwise it's inserted into this template. Adjust to match how your server serves profile pics.
Config.PlayerPhotoUrlTemplate = "%s"
Config.DefaultPlayerPhoto = "imgs/no_photo.png" -- shown if the player has no pic, or the pic fails to load
Config.SplitZonesKillLog = false


-- Commands
Config.CommandPerm = 10 --PermCreateAndStart Capture
Config.JoinCaptureCommand = "joinCap" 
Config.StartCaptureCommand = "startCap"-- with perm
Config.EndCaptureCommand = "endCap"-- with perm
Config.EditCaptureCommand = "editCap" -- with perm
Config.LeaveCaptureCommand = "leaveCap"
Config.ReSpawnCaptureCommand = "reCap"
Config.HistoryCommand = "captureHistory" -- with perm, shows past rounds
Config.StatsCommand = "captureStats" -- anyone can use, shows personal K/D

-- "Top 5 Player All Cap" - all-time composite leaderboard shown live during capture
Config.AllTimeScoreWeights = {
    Kills = 2,       -- points per kill
    GangPoints = 1,  -- points per gang-point contributed
    DeathPenalty = 1 -- points subtracted per death (fewer deaths = better)
}
Config.AllTimeRefreshInterval = 15 -- seconds between DB refreshes of this board while a capture is active

-- Permanent rank badges (shown in kill log chat + NUI), based on the same composite score formula
Config.RankThresholds = {
    {Name = "Bronze", Min = 0},
    {Name = "Silver", Min = 50},
    {Name = "Gold", Min = 150},
    {Name = "Legend", Min = 400},
}

-- Escape penalty: leaving via /leaveCap while actively defending a zone blocks you from
-- re-entering that specific zone for this many seconds.
Config.LeaveZonePenaltySeconds = 180

-- Season Reset: capture_player_stats archives + resets automatically after N days,
-- and the season's #1 player (by the same composite score) gets a money reward.
Config.SeasonResetCommand = "captureSeasonReset" -- admin command to force a reset early
Config.SeasonHistoryCommand = "captureSeasons" -- anyone can use, shows past season winners
Config.SeasonAutoResetDays = 30

-- Extra safety net: dump a raw JSON backup of the stat tables to disk right before
-- a season reset wipes them, separate from the in-database archive tables.
Config.BackupBeforeSeasonReset = true
Config.BackupFolder = "backups"


-- Zone And Landing Config
Config.zToAutoTeleport = 300.0
Config.ZoneSize = 150.0
Config.ParchuteSpawnHeight = 700.0 -- this will be bigger than zToAutoTeleport
Config.ParchuteSpawnDistance = {min = 50.0, max = 100.0}
Config.OutOfZoneDamage = 15 -- Damage Per Second if player is out of zone
Config.TimeToCaptureZone = 10
-- Marker
Config.ZoneMarkerColor = {
    Default = {R = 0, G = 255, B = 0, Alpha = 60},
    Owned = {R = 0, G = 255, B = 0, Alpha = 60}
}
Config.CapturePointMarkerColor = {
    Default = {R = 255, G = 0, B = 0, Alpha = 20},
    Owned = {R = 255, G = 255, B = 0, Alpha = 20}
}

-- Event Themes: change zone marker colors for holidays/special events, no gameplay impact.
-- Switch live with /captureTheme [name] (admin), or change Config.ActiveTheme and restart.
Config.ThemeCommand = "captureTheme"
Config.ActiveTheme = "Default"
Config.Themes = {
    Default = {
        Zone = {Default = {R = 0, G = 255, B = 0, Alpha = 60}, Owned = {R = 0, G = 255, B = 0, Alpha = 60}},
        Point = {Default = {R = 255, G = 0, B = 0, Alpha = 20}, Owned = {R = 255, G = 255, B = 0, Alpha = 20}},
    },
    Halloween = {
        Zone = {Default = {R = 255, G = 100, B = 0, Alpha = 70}, Owned = {R = 128, G = 0, B = 200, Alpha = 70}},
        Point = {Default = {R = 255, G = 60, B = 0, Alpha = 30}, Owned = {R = 150, G = 0, B = 220, Alpha = 30}},
    },
    Christmas = {
        Zone = {Default = {R = 220, G = 0, B = 0, Alpha = 65}, Owned = {R = 0, G = 200, B = 60, Alpha = 65}},
        Point = {Default = {R = 220, G = 0, B = 0, Alpha = 25}, Owned = {R = 255, G = 255, B = 255, Alpha = 25}},
    },
    Bloodmoon = {
        Zone = {Default = {R = 180, G = 0, B = 0, Alpha = 80}, Owned = {R = 255, G = 0, B = 0, Alpha = 80}},
        Point = {Default = {R = 150, G = 0, B = 0, Alpha = 35}, Owned = {R = 255, G = 0, B = 0, Alpha = 35}},
    },
}
-- Blip
Config.ZoneBlip = {
    Color = 37,
    Alpha = 50
}
Config.CapturePointBlip = {
    Model = 310,
    Color = 1,    
}

Config.DefaultZones = {
    ["Bime"] = vector3(-1085.34, -253.7799, 37.76331),
    ["Shekar Gah"] = {x = -673.389, y = 5646.052, z = 30.31661},
    ["Mineri"] = vector3(2954.27, 2787.458, 41.49114),
    ["Sherkat Naft"] = vector3(2751.597, 1551.137, 24.50097),
    ["Bandar"] = vector3(959.5748, -3097.387, 5.90076),
    ["Paleto"] = vector3(73.2504, 6573.741, 28.4357),
    ["Airport"] = vector3(-898.6442, -2491.075, 14.54905),
}
Config.DefaultTime = 60

-- Weapons Config (Weapons Label are get from ESX)
Config.UsePersonalWeapons = true
Config.Weapons = { -- If UsePersonalWeapons == false | access will compare group of players and nill is default 
    {
        Names = {"WEAPON_CARBINERIFLE","WEAPON_PISTOL50"},
        access = nil
    },
    {
        Names = {"WEAPON_COMBATPISTOL","WEAPON_APPISTOL"},
        access = nil
    },
    {
        Names = {"WEAPON_MACHINEPISTOL","WEAPON_HEAVYPISTOL"},
        access = "vip"
    },
    {
        Names = {"WEAPON_MILITARYRIFLE","WEAPON_PISTOL_MK2"},
        access = "vip+"
    },
    {
        Names = {"WEAPON_PISTOL_MK2","WEAPON_SNSPISTOL_MK2"},
        access = "vip+"
    }
}

-- Armor Config
Config.DefaultArmor = 100
Config.UseGroupForArmor = false
Config.Armor = { -- is very easy and simple if UseGroupForArmor == true armor will compare group of players and if not found player group DefaultArmor will set as player armor
    ["user"] = 50,
    ["vip"] = 70,
    ["vip+"] = 100,
}

-- ============================================================================
-- Dry-Run Config Validator
-- ============================================================================
Config.EnableDryRun = true
Config.DryRunCommand = "captureDryRun" -- admin

-- ============================================================================
-- 24h Season-End Warning
-- ============================================================================
Config.EnableSeasonWarning = true
Config.SeasonWarningHoursBefore = 24

-- ============================================================================
-- Admin Command Rate Limiting
-- ============================================================================
Config.EnableAdminRateLimit = true
Config.AdminCommandCooldown = 5 -- seconds, per-admin per-command

-- ============================================================================
-- Health Check
-- ============================================================================
Config.EnableHealthCheck = true
Config.HealthCheckCommand = "captureHealth" -- admin

-- ============================================================================
-- Zone Import/Export
-- ============================================================================
Config.EnableExternalZonesFile = false -- off by default: keeps using Config.DefaultZones above
Config.ZonesFileName = "zones.json" -- lives in this resource's own folder
Config.ExportZonesCommand = "captureExportZones" -- admin
Config.ImportZonesCommand = "captureImportZones" -- admin

-- ============================================================================
-- Public Read-Only Status API
-- ============================================================================
-- WARNING: SetHttpHandler can only have ONE handler active per server. If another
-- resource on your server already uses SetHttpHandler (custom APIs, some admin
-- panels, etc.), turning this on WILL conflict with it. Leave this off unless you
-- know nothing else on your server sets an HTTP handler.
Config.EnablePublicAPI = false
Config.PublicAPIPath = "/uniquecapture/status" -- GET this path on your server's game port

-- ============================================================================
-- League Mode (Season Standings, Playoffs, Comeback Award)
-- Off by default. Flip to true if you want a full football-style league layer
-- on top of the normal season system.
-- ============================================================================
Config.EnableLeagueMode = false
Config.StandingsCommand = "captureStandings" -- anyone, shows the live current-season gang table
Config.EnablePlayoffs = false -- requires EnableLeagueMode = true too
Config.PlayoffResultCommand = "capturePlayoffResult" -- admin, records a playoff match winner manually

-- ============================================================================
-- Scarcity Engine — limited, numbered, never-reproduced rewards
-- ============================================================================
-- The moment a player's rank first crosses into Config.ScarceMedalRank during a
-- season, they get a shot at a numbered medal from that season's fixed pool.
-- Once the pool is empty, NOBODY else gets one that season - no exceptions, no
-- refills - even if they earned it. First come, first served, forever.
Config.EnableScarcityEngine = true
Config.ScarceMedalName = "Legend Medal"
Config.ScarceMedalRank = "Legend" -- must match a name in Config.RankThresholds
Config.ScarceMedalSupplyPerSeason = 100
Config.ScarcityStatusCommand = "captureMedals" -- anyone, shows remaining supply this season
Config.MyMedalsCommand = "mymedals" -- anyone, shows your own claimed medals across all seasons

-- ============================================================================
-- Full Stats Dashboard (one command, shows everything - no more command hunting)
-- ============================================================================
Config.DashboardCommand = "capture"

-- ============================================================================
-- Hall of Fame — permanent honor for long-inactive Legends, no score attached
-- ============================================================================
Config.EnableHallOfFame = true
Config.HallOfFameInactivityDays = 60 -- how long a Legend must be inactive before induction
Config.HallOfFameCommand = "hallOfFame" -- anyone

-- ============================================================================
-- Training Academy — practice capture vs NPCs, no stats/points ever recorded
-- ============================================================================
Config.EnableAcademy = true
Config.AcademyCommand = "captureAcademy"
Config.AcademyLeaveCommand = "leaveAcademy"
Config.AcademyWorld = 51 -- separate routing bucket, different from Config.CaptureWorld (50) and the main world (0)
Config.AcademyCoord = vector3(0.0, 0.0, 72.0) -- CHANGE THIS to a safe, out-of-the-way spot on your map
Config.AcademyNPCCount = 4
Config.AcademyNPCModel = "g_m_y_lost_01"
Config.AcademyWeapon = "WEAPON_CARBINERIFLE"
Config.AcademyKillCheckInterval = 500 -- ms between checking if an academy NPC died

-- Difficulty scales with your total (permanent) academy kills
Config.AcademyDifficultyStep = 5 -- every N kills, NPCs get tougher
Config.AcademyBaseAccuracy = 20
Config.AcademyMaxAccuracy = 80
Config.AcademyBaseArmor = 0
Config.AcademyMaxArmor = 100

-- Entry is restricted to specific real-world locations only (radius in units).
-- CHANGE THESE to real coords on your map — the vector4's 4th value is heading.
Config.AcademyEntryPoints = {
    vector4(0.0, 0.0, 72.0, 0.0), -- placeholder - replace with real spots
}
Config.AcademyEntryRadius = 10.0
Config.AcademyInstructorPedModel = "s_m_y_cop_01"

-- In-academy practice capture point that teaches the real capture flow
Config.AcademyTutorialPointOffset = vector3(10.0, 10.0, 0.0) -- relative to Config.AcademyCoord

-- Safe zone inside the academy where NPCs stop attacking you
Config.AcademySafeZoneOffset = vector3(-8.0, -8.0, 0.0) -- relative to Config.AcademyCoord
Config.AcademySafeZoneRadius = 5.0

-- Permanent Academy titles (shown in the dashboard, based on all-time Academy kills)
Config.AcademyMilestones = {
    {Kills = 100,  Title = "Sharpshooter"},
    {Kills = 500,  Title = "Marksman Elite"},
    {Kills = 1000, Title = "Academy Legend"},
}

-- Reminder to go play a real round if someone stays in the Academy too long
Config.AcademyTimeLimitMinutes = 20
Config.AcademyReminderIntervalMinutes = 20 -- repeats every N minutes after the first reminder

-- ============================================================================
-- Spectator Mode — free camera over an active capture round, zero interference
-- ============================================================================
Config.EnableSpectate = true
Config.SpectateCommand = "captureSpectate"
Config.SpectateLeaveCommand = "leaveSpectate"
Config.SpectateSpeed = 1.0