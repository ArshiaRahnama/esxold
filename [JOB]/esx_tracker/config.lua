Config = {}

Config.selfBlip = true -- use classic arrow or job specified blip?
Config.useRflxMulti = false -- server specific init
Config.useBaseEvents = false -- F for optimisation
Config.prints = false -- server side prints (on/off duty)

-- looks
Config.font = {
    useCustom = false, -- use custom font? Has to be specified below, also can be buggy with player tags
    name = 'Russo One', -- > this being inserted into <font face='nameComesHere'> eg. (<font face='Russo One'>) --> Your font has to be streamed and initialized on ur server
}
Config.notifications = {
    enable = true,
    useMythic = true,
    onDutyText = 'OnDuty', -- pretty straight foward
    offDutyText = 'OffDuty', -- pretty straight foward
}
Config.blipGroup = {
    renameGroup = false,
    groupName = '~b~Other units'
}

-- blips
Config.bigmapTags = false -- Playername tags when bigmap enabled?
Config.blipCone = true -- use that wierd FOV indicators thing?

Config.useCharacterName = true -- use IC name or OOC name, chose your warrior
Config.usePrefix = false
Config.namePrefix = { 
}

-- ─────────────────────────────────────────────────────────────────────────
-- Department hierarchy (matches Config.JobGroups in esx_society / the boss
-- menu branch-switcher). Visibility rule you asked for:
--   • Department Of Justice (top of the org chart) sees EVERY job.
--   • Law Enforcement sees its own 3 jobs + Medic (ambulance).
--   • Organ Services only sees its own job (e.g. Medic only sees Medic).
-- ─────────────────────────────────────────────────────────────────────────
local DOJ_JOBS   = { 'cid', 'cia', 'marshal', 'fbi', 'judge', 'doa' }
local LE_JOBS     = { 'police', 'sheriff', 'mt' }
local ORGAN_JOBS  = { 'taxi', 'mechanic', 'ambulance', 'weazel' }

local function toSet(list)
    local set = {}
    for _, v in ipairs(list) do set[v] = true end
    return set
end

local DOJ_SET, LE_SET, ORGAN_SET = toSet(DOJ_JOBS), toSet(LE_JOBS), toSet(ORGAN_JOBS)

local ALL_JOBS = {}
for _, j in ipairs(DOJ_JOBS) do ALL_JOBS[#ALL_JOBS + 1] = j end
for _, j in ipairs(LE_JOBS) do ALL_JOBS[#ALL_JOBS + 1] = j end
for _, j in ipairs(ORGAN_JOBS) do ALL_JOBS[#ALL_JOBS + 1] = j end
local ALL_SET = toSet(ALL_JOBS)

-- Ped-blip sprite / colour per job. GTA blip colours come from a fixed
-- palette (not free RGB), so "khaki"/"brown"/"purple" below are the closest
-- standard palette matches - tweak the `color` numbers in-game (F8 -> a blip
-- colour tester, or just trial and error) if you want a different exact shade.
local JOB_BLIPS = {
    -- Department Of Justice
    cid     = { pedSprite = 60,  vehSprite = 56,  color = 18 }, -- purple
    cia     = { pedSprite = 60,  vehSprite = 56,  color = 0  }, -- white
    fbi     = { pedSprite = 484, vehSprite = 56,  color = 40 }, -- black(ish)
    marshal = { pedSprite = 60,  vehSprite = 56,  color = 8  }, -- khaki / tan
    judge   = { pedSprite = 60,  vehSprite = 56,  color = 9  }, -- brown
    doa     = { pedSprite = 60,  vehSprite = 56,  color = 2  }, -- (you didn't give DOA a colour - defaulted to green, change freely)
    -- Law Enforcement
    police  = { pedSprite = 60,  vehSprite = 56,  color = 29 }, -- blue
    sheriff = { pedSprite = 58,  vehSprite = 56,  color = 28 }, -- grey
    mt      = { pedSprite = 480, vehSprite = 225, color = 40 }, -- black(ish)
    -- Organ Services
    taxi      = { pedSprite = 198, vehSprite = 198, color = 46 }, -- yellow
    mechanic  = { pedSprite = 402, vehSprite = 225, color = 56 }, -- orange
    ambulance = { pedSprite = 1,   vehSprite = 225, color = 1  }, -- red (medic)
    weazel    = { pedSprite = 402, vehSprite = 225, color = 31 }, -- pink
}

Config.emergencyJobs = {}

for _, job in ipairs(ALL_JOBS) do
    local canSee

    if DOJ_SET[job] then
        canSee = toSet(ALL_JOBS) -- DOJ outranks the whole chart -> sees everyone
    elseif LE_SET[job] then
        canSee = toSet(LE_JOBS)
        canSee['ambulance'] = true -- Law Enforcement also sees Medic
    else
        canSee = { [job] = true } -- Organ Services only sees its own job
    end

    local b = JOB_BLIPS[job]
    Config.emergencyJobs[job] = {
        ignoreDuty = true,
        blip = {
            sprite = b.pedSprite,
            color = b.color,
            flashColors = { 59, b.color },
        },
        vehBlip = {
            ['default'] = { sprite = b.vehSprite, color = b.color },
        },
        canSee = canSee,
    }
end
