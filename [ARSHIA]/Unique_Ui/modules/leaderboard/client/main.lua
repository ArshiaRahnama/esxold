-- ============================================================
-- LEADERBOARD MODULE - CLIENT
-- ============================================================
local isOpen = false
local currentMode = 'score'
local currentSkill = 'Police'

local SKILL_LIST = { "Police", "Medic", "Taxi", "Mechanic", "Robbery", "Farm", "Job Azad" }

local function loadData()
    ESX.TriggerServerCallback('leaderboard:getData', function(rows)
        SendNUIMessage({
            id = 'leaderboard',
            display = true,
            mode = currentMode,
            skill = currentSkill,
            skillList = SKILL_LIST,
            rows = rows,
        })
    end, currentMode, currentSkill)
end

local function openLeaderboard()
    if isOpen then return end
    isOpen = true
    loadData()
end

local function closeLeaderboard()
    if not isOpen then return end
    isOpen = false
    SendNUIMessage({ id = 'leaderboard', display = false })
end

RegisterNUICallback('leaderboard:setMode', function(data, cb)
    currentMode = data.mode or 'score'
    currentSkill = data.skill or currentSkill
    loadData()
    cb('ok')
end)

RegisterNUICallback('leaderboard:close', function(data, cb)
    closeLeaderboard()
    cb('ok')
end)

RegisterNUICallback('leaderboard:openFromButton', function(data, cb)
    openLeaderboard()
    cb('ok')
end)

exports('openLeaderboard', openLeaderboard)
exports('closeLeaderboard', closeLeaderboard)
