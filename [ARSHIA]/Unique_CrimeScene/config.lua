Config = {}

-- ============================================================
-- Departments (matches your server's real org structure)
-- ============================================================

-- Department Of Justice. Any of these jobs can walk up to a crime scene,
-- collect evidence, and expand a case (add investigative notes).
Config.DOJJobs = { 'cid', 'cia', 'marshal', 'fbi', 'judge', 'doa' }

-- Once a case has evidence in it, a DOJ member can formally refer it to one
-- of these jobs for prosecution / specialized follow-up. These jobs also
-- get a notification + can see the case in /cases once it's referred to
-- them, and are the only ones who can close a case with a verdict.
Config.ReferralJobs = { 'judge', 'cia', 'fbi' }

-- ============================================================
-- Crime scene generation
-- ============================================================

-- How long (minutes) a crime scene stays active before evidence goes cold
-- and the interaction points disappear. If nothing was found by then the
-- case is marked 'cold' instead of deleted (still visible in /cases).
Config.SceneLifetimeMinutes = 20

-- How far (meters) around the spot the robber finished the job at,
-- evidence points get scattered.
Config.SceneRadius = 15.0

-- Minimum distance (meters) required between a player and an evidence
-- point to be able to collect it (anti "collect from across the map").
Config.CollectDistance = 3.0

-- How far (meters) the system looks for a parked vehicle near the crime
-- scene to pull a plate from, for the 'vehicle' evidence roll.
Config.NearbyVehicleRadius = 25.0

-- How many evidence points spawn per crime scene, based on a rough
-- "family" guessed from the rob name (Shop_3 -> Shop, Palateo_Bank stays
-- Palateo_Bank, Jaw_Shahr/Jaw_BironShahr -> Jaw). Anything not listed here
-- uses `default`. Bigger jobs leave more evidence behind.
Config.EvidenceCountByFamily = {
	Shop         = 2,
	Minibank     = 3,
	Jaw          = 3,
	Life_Invader = 4,
	Palateo_Bank = 5,
	default      = 2,
}

-- ============================================================
-- Evidence rolls
-- ============================================================

-- Chance (0-1) that a collected evidence point turns out to be a "strong
-- lead" -- a partial real identifier of the actual robber. This is what
-- makes a case referable/prosecutable, not just flavor text.
Config.StrongLeadChance = 0.35

-- Chance (0-1, checked after strong lead) that it's a vehicle description
-- instead, IF a vehicle was found nearby when the scene was created.
Config.VehicleLeadChance = 0.30

-- Plain flavor-only suspect hints (the rest of the rolls). These never
-- point at a real player, just roleplay texture for the case file.
Config.SuspectHints = {
	'Yek Mard Ba Ghade Boland Va Hoodie Meshki Dide Shode',
	'Yek Nafar Ba Lahje Ajib Sohbat Mikard Hangame Farar',
	'Ye Khal Roye Dast Chape Fard Dide Shode',
	'Fard Mashkook Ba Sor\'at Be Samte Sharg Farar Kard',
	'Ye Kolah Ghermez Roye Sare Fard Bood',
	'Sedaye Fard Khaste Va Larzan Bood Hangame Sohbat',
	'Roye Daste Fard Yek Angoshtare Ajib Dide Shode',
	'Fard Yek Kif Khakestari Hamrahesh Bood',
	'Shahed Migoft Fard Ba Ye Nafar Dige Sohbat Mikard Ghabl Az Shoro',
}

-- ============================================================
-- Evidence collection minigame
-- ============================================================

-- Ran client-side (same lib.skillCheck used by Unique_Garage's lockpick)
-- when a DOJ member interacts with an evidence point. Failing it doesn't
-- lose the evidence outright -- it just downgrades a strong_lead/vehicle
-- roll down to a plain flavor hint (still worth collecting, just weaker).
Config.EvidenceSkillCheck = { 'easy', 'easy', { areaSize = 60, speedMultiplier = 1.4 } }

-- ============================================================
-- Fingerprint database match
-- ============================================================

-- How many times the SAME partial suspect code (from strong_lead evidence)
-- has to show up across ALL cases server-wide before "/runmatch" in a case
-- is allowed to reveal the actual current in-game name behind it. Keeps
-- the reveal earned through real repeat investigative work instead of
-- being handed out on the very first clue.
Config.FingerprintMatchThreshold = 2
