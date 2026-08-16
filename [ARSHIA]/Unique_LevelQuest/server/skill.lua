-- ================================================================= --
-- Skill tracking (drives the Skill tab)
-- ================================================================= --
-- Same anti-spam pattern already used for quest triggers: a raw
-- RegisterServerEvent with no rate limit would let a client fire it in
-- a tight loop and max out a skill in seconds. Cooldown here matches
-- the real cadence (essentialmode's 15-minute paycheck interval).
-- ================================================================= --

local SKILL_TICK_MINUTES  = 15
local SKILL_TICK_COOLDOWN = 14 * 60 -- seconds; slightly under 15 min, small slack
local lastSkillTick = {} -- [source] = os.time()

RegisterServerEvent('skill-track:tick')
AddEventHandler('skill-track:tick', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return end

    local job = xPlayer.job.name
    if not Config.TrackedJobs[job] then return end

    local now = os.time()
    if lastSkillTick[_source] and (now - lastSkillTick[_source]) < SKILL_TICK_COOLDOWN then
        return
    end
    lastSkillTick[_source] = now

    MySQL.Async.execute([[
        INSERT INTO job_skill (identifier, job, minutes) VALUES (@identifier, @job, @minutes)
        ON DUPLICATE KEY UPDATE minutes = LEAST(@target, minutes + @minutes)
    ]], {
        ['@identifier'] = xPlayer.identifier,
        ['@job']        = job,
        ['@minutes']    = SKILL_TICK_MINUTES,
        ['@target']     = Config.SkillTargetMinutes,
    })
end)

ESX.RegisterServerCallback('HUD_Menu:GetSkills', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb({}) end

    MySQL.Async.fetchAll('SELECT job, minutes FROM job_skill WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        local minutesByJob = {}
        for i = 1, #result do
            minutesByJob[result[i].job] = result[i].minutes
        end

        local skills = {}
        for jobName, label in pairs(Config.TrackedJobs) do
            table.insert(skills, {
                label = label,
                minutes = minutesByJob[jobName] or 0,
                target = Config.SkillTargetMinutes,
            })
        end
        cb(skills)
    end)
end)

AddEventHandler('playerDropped', function()
    lastSkillTick[source] = nil
end)
