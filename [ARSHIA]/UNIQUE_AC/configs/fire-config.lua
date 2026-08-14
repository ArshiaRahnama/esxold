-- UNIQUE_AC Configuration — customized by Arshia (arshiahub.ir)
-- Licensed under the GNU Affero General Public License v3.0

UNIQUE_AC              = {}

UNIQUE_AC.Version      = "9.4.0"

UNIQUE_AC.ServerConfig = {
    Name  = "YOUR SERVER NAME",

    Port  = "30120",

    Linux = false
}

-- White-Label: change how the panel identifies itself without touching any HTML/CSS.
-- Useful if you're reselling/rebranding UNIQUE_AC for a client under their own name.
UNIQUE_AC.Branding = {
    PanelName     = "UNIQUE_AC",
    FooterCredit  = "Developed by Arshia · arshiahub.ir",
    BuildLabel    = "" -- leave blank to show the real VERSION; set to override what's displayed
}

UNIQUE_AC.ACE = {
    Enable = false,
    Admin = "UNIQUE_AC.Admin",
    Whitelist = "UNIQUE_AC.Whitelist",
    Unban = "UNIQUE_AC.Unban"
}

UNIQUE_AC.ChatSettings             = {
    Enable      = true,
    PrivateWarn = true
}

UNIQUE_AC.ScreenShot               = {
    Enable  = true,
    Format  = "PNG",
    Quality = 1
}

-- Evidence Burst: on high-suspicion events (entering Quarantine), grabs a short sequence of
-- screenshots a couple seconds apart instead of one — the closest thing to "video" a FiveM
-- resource can realistically capture, since resources can't access the client's video encoder.
UNIQUE_AC.EvidenceBurst = {
    Enable      = true,
    ShotCount   = 4,
    IntervalMs  = 1500
}

-- Aimbot Pattern: a soft/statistical heuristic — tracks headshot ratio combined with sudden
-- camera-angle snaps right before a hit. Never bans/kicks directly (it isn't proof by itself),
-- only feeds Trust Score, and always pings admins in chat + Discord the moment it flags so a
-- human can look. Tune the thresholds if legitimately skilled players start tripping it.
UNIQUE_AC.AimbotWatch = {
    Enable            = true,
    MinSampleHits     = 8,
    HeadshotRatio     = 0.75,
    SnapAngleDegrees  = 35.0,
    SnapWindowMs      = 150,
    NotifyAdminsOnFlag = true
}

-- Resource Monitor: snapshots which resources are already running shortly after UNIQUE_AC
-- boots, then flags any resource that starts later and wasn't in that baseline. This is a
-- monitoring/awareness tool for admins, not a player punishment — starting a resource is a
-- server-owner action, so it only logs, it never bans or kicks anyone.
UNIQUE_AC.ResourceMonitor = {
    Enable          = true,
    BaselineDelayMs = 25000,
    NotifyAdminsOnFlag = true,
    IgnoreList      = {} -- resource names you expect to start/stop dynamically, e.g. minigames
}

-- Config Backup: keeps a timestamped copy of fire-config.lua every time it actually
-- changes since the last boot, so a bad edit can always be compared/restored.
UNIQUE_AC.ConfigBackup = {
    Enable = true,
    Keep   = 20 -- oldest backups beyond this count are deleted automatically
}

-- Known Conflicts: resource names that are either known-malicious (backdoors found in
-- leaked/cracked packs — esx_aduty below is a real one found during development, see
-- update.txt) or known to double-handle the same events as UNIQUE_AC and cause conflicts.
-- Checked once at boot against whatever's already running.
UNIQUE_AC.KnownConflicts = {
    Enable = true,
    Resources = {
        -- "esx_aduty" removed from this list: the RCE backdoor (the
        -- pcall(load(Code)) anti-dump trap in Server/carp_sv.lua and
        -- Client/carp_cl.lua) was manually stripped out of this project's
        -- copy. Several other resources (Admin_Menu, esx_jailwork,
        -- CoinSystem, esx_idoverhead) depend on esx_aduty:checkAduty /
        -- getAdminPerm / DutyHandlerForJail, so it stays installed. If you
        -- ever drop in a *different*/downloaded copy of esx_aduty, re-check
        -- Server/carp_sv.lua and Client/carp_cl.lua for a "Code"/load()
        -- pattern before trusting it, and add "esx_aduty" back to this list
        -- if you're not sure.
    }
}

UNIQUE_AC.Connection               = {
    AntiBlackListName = true,
    AntiVPN           = false,
    HideIP            = true,

    UseDeferrals      = true,
    DeferralMode      = "card",
    DeferralDelayMs   = 1200,
    DeferralStepMs    = 120,
    AdaptiveCard      = true,

    ShowConnectUI     = true,
    ShowProblemCard   = true,
    ProblemOnlyMode   = false,

    PresentCardOnce   = false,
    PresentCardHoldMs = 900,
    CardTitle         = "UNIQUE_AC SECURITY",
    VisualStepMs      = 320,
    ConnectHoldMs     = 1200
}

UNIQUE_AC.ServerRuntime            = {
    EntityCreatedMonitor = false,
    EntityCreatedDelayMs = 750
}

UNIQUE_AC.Detection = {
    RequirePlayerSpawned = true,
    RequireFrameworkLoaded = true,
    ReadyMaxWaitMs = 120000,
    MinimumClientReadyMs = 12000,
    ResourceRestartAssumeSpawnedMs = 8000,

    SpawnGraceMs = 20000,
    PostSpawnSettleMs = 18000,
    PostReadyGraceMs = 20000,
    FrameworkLoadGraceMs = 12000,
    RespawnGraceMs = 15000,
    PedChangeGraceMs = 12000,
    CameraGraceMs = 3500,
    GodmodeAfterReadyMs = 12000,

    EvidenceThreshold = 3,
    EvidenceWindowMs = 15000,
    GodmodeSamples = 6,
    ClientReportCooldownMs = 10000,
    ServerReportWindowMs = 10000,
    ServerReportLimit = 6
}

UNIQUE_AC.Message                  = {
    Kick = "⚡️ You've been kicked from the server protection by UNIQUE_AC®. Avoid cheating on this server.",
    Ban  = "⛔️ You've been banned from the server. Please create a support ticket for assistance.",
}

UNIQUE_AC.AdminMenu                = {
    Enable         = true,
    MenuPunishment = "BAN"
}

-- Framework Permission: recognizes admins directly from your own database's permission_level
-- column, so you don't have to add everyone twice (once in your framework, once in UNIQUE_AC).
UNIQUE_AC.FrameworkPermission = {
    Enable            = true,
    Table             = "users",
    IdentifierColumn  = "identifier",
    PermissionColumn  = "permission_level",
    MinLevel          = 1
}

UNIQUE_AC.AntiHealthHack           = true
UNIQUE_AC.MaxHealth                = 200
UNIQUE_AC.HealthPunishment         = "BAN"

UNIQUE_AC.AntiArmorHack            = true
UNIQUE_AC.MaxArmor                 = 100
UNIQUE_AC.ArmorPunishment          = "BAN"

UNIQUE_AC.AntiBlacklistTasks       = false
UNIQUE_AC.TasksPunishment          = "BAN"

UNIQUE_AC.AntiBlacklistAnims       = true
UNIQUE_AC.AnimsPunishment          = "BAN"

UNIQUE_AC.AntiInfinityAmmo         = true

UNIQUE_AC.AntiSpectate             = true
UNIQUE_AC.SpactatePunishment       = "BAN"
UNIQUE_AC.SpectatePunishment       = UNIQUE_AC.SpactatePunishment

UNIQUE_AC.AntiBlackListWeapon      = true
UNIQUE_AC.AntiAddWeapon            = false
UNIQUE_AC.AntiRemoveWeapon         = false
UNIQUE_AC.WeaponPunishment         = "BAN"

UNIQUE_AC.AntiGodMode              = true
UNIQUE_AC.GodPunishment            = "BAN"

UNIQUE_AC.AntiInvisible            = true
UNIQUE_AC.InvisiblePunishment      = "KICK"

UNIQUE_AC.AntiChangeSpeed          = true
UNIQUE_AC.SpeedPunishment          = "KICK"

UNIQUE_AC.AntiFreeCam              = false
UNIQUE_AC.CamPunishment            = "BAN"

UNIQUE_AC.AntiRainbowVehicle       = true
UNIQUE_AC.RainbowPunishment        = "BAN"

UNIQUE_AC.AntiPlateChanger         = true
UNIQUE_AC.AntiBlackListPlate       = true
UNIQUE_AC.PlatePunishment          = "BAN"

UNIQUE_AC.AntiNightVision          = true
UNIQUE_AC.AntiThermalVision        = true
UNIQUE_AC.VisionPunishment         = "BAN"

UNIQUE_AC.AntiSuperJump            = true
UNIQUE_AC.JumpPunishment           = "BAN"

UNIQUE_AC.AntiTeleport             = true
UNIQUE_AC.MaxFootDistance          = 200
UNIQUE_AC.MaxVehicleDistance       = 600
UNIQUE_AC.TeleportPunishment       = "BAN"

UNIQUE_AC.AntiNoclip               = false
UNIQUE_AC.NoclipPunishment         = "KICK"

UNIQUE_AC.AntiPedChanger           = true
UNIQUE_AC.PedChangePunishment      = "BAN"

UNIQUE_AC.AntiInfiniteStamina      = false
UNIQUE_AC.InfinitePunishment       = "WARN"


UNIQUE_AC.AntiTinyPed              = true
UNIQUE_AC.PedFlagPunishment        = "BAN"

UNIQUE_AC.AntiSuicide              = false
UNIQUE_AC.SuicidePunishment        = "WARN"

UNIQUE_AC.AntiPickupCollect        = false
UNIQUE_AC.PickupPunishment         = "BAN"

UNIQUE_AC.AntiSpamChat             = true
UNIQUE_AC.MaxMessage               = 10
UNIQUE_AC.CoolDownSec              = 3
UNIQUE_AC.ChatPunishment           = "BAN"

UNIQUE_AC.AntiBlackListCommands    = true
UNIQUE_AC.CMDPunishment            = "BAN"

UNIQUE_AC.AntiWeaponDamageChanger  = true
UNIQUE_AC.DamagePunishment         = "BAN"

UNIQUE_AC.AntiBlackListWord        = true
UNIQUE_AC.WordPunishment           = "KICK"

UNIQUE_AC.AntiBringAll             = false
UNIQUE_AC.BringAllPunishment       = "BAN"

UNIQUE_AC.AntiBlackListTrigger     = false
UNIQUE_AC.AntiSpamTrigger          = true
UNIQUE_AC.TriggerPunishment        = "BAN"

UNIQUE_AC.AntiClearPedTasks        = false
UNIQUE_AC.MaxClearPedTasks         = 5
UNIQUE_AC.CPTPunishment            = "BAN"

UNIQUE_AC.AntiTazePlayers          = true
UNIQUE_AC.MaxTazeSpam              = 3
UNIQUE_AC.TazePunishment           = "KICK"

UNIQUE_AC.AntiInject               = false
UNIQUE_AC.InjectPunishment         = "BAN"

UNIQUE_AC.AntiExplosionSpam        = true
UNIQUE_AC.MaxExplosion             = 10
UNIQUE_AC.ExplosionSpamPunishment  = "BAN"

UNIQUE_AC.AntiBlackListObject      = true
UNIQUE_AC.AntiBlackListPed         = true
UNIQUE_AC.AntiBlackListBuilding    = true
UNIQUE_AC.AntiBlackListVehicle     = true
UNIQUE_AC.EntityPunishment         = "BAN"


UNIQUE_AC.AntiSpamVehicle          = true
UNIQUE_AC.MaxVehicle               = 10

UNIQUE_AC.AntiSpamPed              = true
UNIQUE_AC.MaxPed                   = 4

UNIQUE_AC.AntiSpamObject           = true
UNIQUE_AC.MaxObject                = 15

UNIQUE_AC.SpamPunishment           = "KICK"

UNIQUE_AC.AntiChangePerm           = false
UNIQUE_AC.PermPunishment           = "BAN"

UNIQUE_AC.AntiPlaySound            = true
UNIQUE_AC.SoundPunishment          = "KICK"

-- ▼ New in this build ──────────────────────────────────────────

UNIQUE_AC.AntiWeaponComponent      = true
UNIQUE_AC.ComponentPunishment      = "BAN"

UNIQUE_AC.AntiUnderground          = true
UNIQUE_AC.UndergroundTolerance     = 6.0
UNIQUE_AC.UndergroundPunishment    = "KICK"
-- Custom safe zones for MLO/interior shells that GTA doesn't tag as a real interior.
-- Add entries like: { x = 123.4, y = 567.8, z = -20.0, radius = 60.0 }
UNIQUE_AC.UndergroundSafeZones     = {}

UNIQUE_AC.AntiVehicleGodMode       = true
UNIQUE_AC.VehicleGodPunishment     = "BAN"

UNIQUE_AC.AntiMacroFire            = true
UNIQUE_AC.MacroFirePunishment      = "KICK"
UNIQUE_AC.MacroFireMinShots        = 6
UNIQUE_AC.MacroFireMaxVarianceMs   = 9

UNIQUE_AC.AimbotPunishment         = "KICK"

-- Trust Score: soft/heuristic detections cost points instead of an instant punishment.
-- Deterministic detections (blacklist matches) always bypass this and act immediately.
UNIQUE_AC.TrustScore = {
    Enable        = true,
    Start         = 100,
    DeductWeight  = 20,
    RecoverOnRelease = 60
}

-- Sandbox Mode: logs everything the anticheat WOULD have done (console, Discord, admin
-- chat) but never actually kicks/bans anyone. Use this when tuning new thresholds so you
-- can see how they'd behave against real traffic before trusting them for real.
UNIQUE_AC.SandboxMode = {
    Enable        = false,
    NotifyAdmins  = true
}

-- Progressive Punishment Ladder: instead of jumping straight from a soft flag to
-- Quarantine, apply lighter consequences first as Trust Score crosses these
-- thresholds (checked high-to-low, each fires once per session). "WARN" only
-- sends a chat message; "KICK" disconnects them but they can rejoin (not a ban).
-- Quarantine at 0 trust still happens regardless — this just adds steps before it.
UNIQUE_AC.PunishmentLadder = {
    Enable = true,
    Steps = {
        { threshold = 70, action = "WARN", message = "Your recent activity looks suspicious. Play fair — further flags may get you kicked or reviewed." },
        { threshold = 40, action = "KICK", message = "Kicked as a precaution due to repeated suspicious activity. You may rejoin." },
    }
}

-- Quarantine: once trust hits 0, freeze + flag the player for admin review instead of auto-punishing.
UNIQUE_AC.Quarantine = {
    Enable = true
}

-- Integrity: periodically verifies UNIQUE_AC's own server files haven't been tampered with on disk.
UNIQUE_AC.Integrity = {
    Enable       = true,
    IntervalMs   = 300000,
    Files        = {
        "src/fire-server.lua",
        "src/fire-client.lua",
        "src/fire-menu.lua",
        "configs/fire-config.lua"
    }
}

-- Persistent Trust Score: carries a player's Trust Score across sessions (keyed by license),
-- so a repeat offender who disconnects and reconnects starts from where they left off instead
-- of a fresh 100. Turn off to keep the old per-session-only behavior.
UNIQUE_AC.PersistentTrust = {
    Enable   = true,
    SaveEveryMs = 60000
}

-- Player Transparency: lets a player check their own standing with a chat command,
-- in general terms only (no technical detection details, so it can't be used to
-- learn what specifically trips the detectors).
UNIQUE_AC.PlayerTransparency = {
    Enable  = true,
    Command = "mystatus"
}

-- Trust Recognition: a quiet, private "welcome back" message for players in good
-- standing. Deliberately NOT shown to other players — a public in-game badge could be
-- used to single out or socially-engineer "trusted" players, so this stays personal.
UNIQUE_AC.TrustRecognition = {
    Enable    = true,
    Threshold = 90
}

-- Risk Score: a 0-100 number combining several weak signals (low trust, past flags, past
-- quarantines, account age, rapid reconnects) into one glanceable figure shown in the Players
-- tab. It's informational only and never triggers punishment by itself.
UNIQUE_AC.RiskScore = {
    Enable              = true,
    WeightLowTrust      = 0.45,
    WeightFlagCount     = 6,
    WeightQuarantine    = 12,
    WeightNewAccount    = 15,
    NewAccountHours     = 6,
    WeightRapidReconnect = 10,
    RapidReconnectWindowMs = 120000
}

-- Player Notes: persistent, shared staff notes attached to a player's identifier. Visible to
-- every admin from that player's profile in the panel.
UNIQUE_AC.PlayerNotes = {
    Enable = true,
    MaxLength = 500
}

-- Admin Action Log: records who did what to whom (ban/kick/whitelist/admin changes/quarantine
-- review) for staff accountability. Viewable from the panel's Admin Log tab.
UNIQUE_AC.AdminLog = {
    Enable = true,
    Keep   = 500 -- rows returned in the panel view (table itself keeps full history)
}

-- Confirm Ban: requires the admin to type the target's exact current name before a ban goes
-- through, to prevent mis-clicks. Applies in the panel only; console/chat ban commands are
-- unaffected.
UNIQUE_AC.ConfirmBan = {
    Enable = true
}

-- Ban Appeals: players can submit an appeal (e.g. via the standalone PHP form in /appeal-form,
-- pointed at your own website) which lands in this table and shows up in the panel's Appeals
-- tab for an admin to approve (unban) or reject.
UNIQUE_AC.Appeals = {
    Enable = true,
    NotifyAdminsOnNew = true
}

-- Central Hub: optional. Reports live status (player count, Quarantine/Appeal counts, etc.) to
-- your own multi-server dashboard (see /central-hub in the package). Off by default — turn on
-- and paste in a license key generated from central-hub/admin/keys.php to enable it.
UNIQUE_AC.CentralHub = {
    Enable              = false,
    URL                 = "https://your-domain.example/central-hub",
    LicenseKey          = "",
    ServerName          = "",              -- shown on the hub dashboard; defaults to ServerConfig.Name if blank
    HeartbeatIntervalMs = 60000,
    NotifyOnQuarantine  = true              -- pings the hub (which forwards to Discord) on every Quarantine entry
}
