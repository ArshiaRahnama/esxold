-- ============================================================
-- LEADERBOARD MODULE - SERVER
-- ============================================================
ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
end)
while ESX == nil do Wait(0) end
while MySQL == nil do Wait(0) end

local function decodeOrNil(v)
    if not v or v == '' then return nil end
    local ok, res = pcall(json.decode, v)
    if ok then return res end
    return nil
end

local function formatPlaytimeFromMinutes(minutes)
    minutes = tonumber(minutes) or 0
    if minutes < 0 then minutes = 0 end
    local d = math.floor(minutes / 1440)
    local h = math.floor((minutes % 1440) / 60)
    return string.format("%dD %02dH", d, h)
end

-- ✅ آواتار + isMe (برای هایلایت ردیف خودِ پلیر) رو می‌سازه، و identifier خام
-- رو قبل از فرستادن به NUI حذف می‌کنه (نباید تو کلاینت افشا بشه).
local function buildRow(rank, name, value, profilePic, rowIdentifier, myIdentifier)
    return {
        rank = rank,
        name = name,
        value = value,
        img = (profilePic and profilePic ~= '') and profilePic or './skill/img/no_photo.png',
        isMe = (myIdentifier ~= nil and rowIdentifier == myIdentifier),
    }
end

local function getTopByScore(myIdentifier)
    local ok, rows = pcall(function()
        return MySQL.query.await('SELECT playerName, identifier, Profile_Pic, score FROM users WHERE score > 0 ORDER BY score DESC LIMIT 10', {})
    end)
    if not ok or not rows then return {} end

    local out = {}
    for i, r in ipairs(rows) do
        table.insert(out, buildRow(i, r.playerName or '???', tostring(r.score or 0), r.Profile_Pic, r.identifier, myIdentifier))
    end
    return out
end

local function getTopByPlaytime(myIdentifier)
    local ok, rows = pcall(function()
        return MySQL.query.await('SELECT playerName, identifier, Profile_Pic, timePlay FROM users WHERE timePlay > 0 ORDER BY timePlay DESC LIMIT 10', {})
    end)
    if not ok or not rows then return {} end

    local out = {}
    for i, r in ipairs(rows) do
        table.insert(out, buildRow(i, r.playerName or '???', formatPlaytimeFromMinutes(r.timePlay), r.Profile_Pic, r.identifier, myIdentifier))
    end
    return out
end

local function getTopBySkill(skillName, myIdentifier)
    local ok, rows = pcall(function()
        return MySQL.query.await(
            'SELECT playerName, identifier, Profile_Pic, skills FROM users WHERE skills IS NOT NULL ORDER BY last_seen DESC LIMIT 500',
            {}
        )
    end)
    if not ok or not rows then
        ok, rows = pcall(function()
            return MySQL.query.await('SELECT playerName, identifier, Profile_Pic, skills FROM users WHERE skills IS NOT NULL LIMIT 500', {})
        end)
    end
    if not ok or not rows then return {} end

    local list = {}
    for _, r in ipairs(rows) do
        local data = decodeOrNil(r.skills)
        if type(data) == 'table' and type(data.skills) == 'table' then
            for _, item in ipairs(data.skills) do
                if item.name == skillName then
                    table.insert(list, {
                        name = r.playerName or '???',
                        identifier = r.identifier,
                        img = r.Profile_Pic,
                        percent = tonumber(item.percent) or 0,
                    })
                    break
                end
            end
        end
    end

    table.sort(list, function(a, b) return a.percent > b.percent end)

    local out = {}
    for i = 1, math.min(10, #list) do
        local item = list[i]
        table.insert(out, buildRow(i, item.name, string.format("%.1f%%", item.percent), item.img, item.identifier, myIdentifier))
    end
    return out
end

ESX.RegisterServerCallback('leaderboard:getData', function(source, cb, mode, skillName)
    local xPlayer = ESX.GetPlayerFromId(source)
    local myIdentifier = xPlayer and xPlayer.identifier or nil

    if mode == 'playtime' then
        cb(getTopByPlaytime(myIdentifier))
    elseif mode == 'skill' then
        cb(getTopBySkill(skillName or 'Police', myIdentifier))
    else
        cb(getTopByScore(myIdentifier))
    end
end)
