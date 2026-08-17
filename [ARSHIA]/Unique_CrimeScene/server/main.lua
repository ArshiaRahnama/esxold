--[[
    Unique_CrimeScene - DOJ Crime Scene Investigation System

    Hooks off Unique_RobSystem's 'Morphy_RobSystem:robberySuccess' event
    WITHOUT modifying that resource at all - it's just an extra
    AddEventHandler on an event that already fires. Unique_RobSystem
    doesn't need to know this resource exists.

    Flow:
      1. Robbery succeeds -> a crime scene with a few evidence points
         spawns around where the robber finished.
      2. DOJ members (Config.DOJJobs) walk up to evidence points and
         collect them. Each point rolls into a hint / vehicle plate /
         strong lead (partial real suspect identifier).
      3. DOJ members can add free-text notes to build the case out.
      4. Once there's something to work with, the case gets referred to
         Judge, CIA or FBI (Config.ReferralJobs) who prosecute/investigate
         further and close the case.
]]

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local ActiveScenes = {} -- [caseId] = { robname, family, coords, plate, suspectIdentifier, suspectName, points = { [pointId] = {coords, collected} }, createdAt }
local NextPointId = 0

-- ============================================================
-- Helpers
-- ============================================================

local function IsDOJJob(job)
    for i = 1, #Config.DOJJobs do
        if Config.DOJJobs[i] == job then return true end
    end
    return false
end

local function IsReferralJob(job)
    for i = 1, #Config.ReferralJobs do
        if Config.ReferralJobs[i] == job then return true end
    end
    return false
end

-- Shop_3 -> Shop, Palateo_Bank -> Palateo_Bank, Jaw_Shahr -> Jaw
local function GuessRobFamily(robname)
    if robname:find('^Jaw') then return 'Jaw' end
    local base = robname:gsub('_%d+$', '')
    return base
end

local function BroadcastToJobs(jobs, event, ...)
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer then
            for j = 1, #jobs do
                if xPlayer.job.name == jobs[j] then
                    TriggerClientEvent(event, xPlayers[i], ...)
                    break
                end
            end
        end
    end
end

local function NotifyJobs(jobs, msg, msgType)
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer then
            for j = 1, #jobs do
                if xPlayer.job.name == jobs[j] then
                    TriggerClientEvent('esx:showNotification', xPlayers[i], msg, msgType)
                    break
                end
            end
        end
    end
end

local function FindNearbyVehiclePlate(coords)
    local vehicles = GetAllVehicles()
    for i = 1, #vehicles do
        local v = vehicles[i]
        local vCoords = GetEntityCoords(v)
        if #(vCoords - coords) <= Config.NearbyVehicleRadius then
            return GetVehicleNumberPlateText(v)
        end
    end
    return nil
end

-- ============================================================
-- Crime scene creation
-- ============================================================

AddEventHandler('Morphy_RobSystem:robberySuccess', function(robname, robberyCode)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return end

    local ped = GetPlayerPed(_source)
    if not ped or ped == 0 then return end
    local coords = GetEntityCoords(ped)

    local family = GuessRobFamily(robname)
    local evidenceCount = Config.EvidenceCountByFamily[family] or Config.EvidenceCountByFamily.default
    local plate = FindNearbyVehiclePlate(coords)

    MySQL.Async.insert(
        'INSERT INTO doj_cases (rob_name, rob_family, status, suspect_identifier, suspect_name, coords_x, coords_y, coords_z) VALUES (@rob_name, @rob_family, @status, @suspect_identifier, @suspect_name, @x, @y, @z)',
        {
            ['@rob_name']            = robname,
            ['@rob_family']          = family,
            ['@status']              = 'open',
            ['@suspect_identifier']  = xPlayer.identifier,
            ['@suspect_name']        = xPlayer.name,
            ['@x']                   = coords.x,
            ['@y']                   = coords.y,
            ['@z']                   = coords.z,
        },
        function(caseId)
            if not caseId or caseId == 0 then return end

            local points = {}
            local pointsForClient = {}
            for i = 1, evidenceCount do
                local angle = math.random(0, 359)
                local dist = math.random(2, math.floor(Config.SceneRadius))
                local rad = math.rad(angle)
                local px = coords.x + math.cos(rad) * dist
                local py = coords.y + math.sin(rad) * dist
                local pCoords = vector3(px, py, coords.z)

                NextPointId = NextPointId + 1
                local pointId = NextPointId
                points[pointId] = { coords = pCoords, collected = false }
                pointsForClient[#pointsForClient + 1] = { id = pointId, coords = pCoords }
            end

            ActiveScenes[caseId] = {
                robname            = robname,
                family             = family,
                coords             = coords,
                plate              = plate,
                suspectIdentifier  = xPlayer.identifier,
                suspectName        = xPlayer.name,
                points             = points,
                createdAt          = os.time(),
            }

            BroadcastToJobs(Config.DOJJobs, 'CrimeScene:sceneCreated', caseId, coords, pointsForClient)
            NotifyJobs(Config.DOJJobs, 'Yek Sahne Jorm Jadid Sabt Shod. Baraye Didan /cases Bezanid.', 'info')

            SetTimeout(Config.SceneLifetimeMinutes * 60000, function()
                if ActiveScenes[caseId] then
                    ActiveScenes[caseId] = nil
                    BroadcastToJobs(Config.DOJJobs, 'CrimeScene:sceneExpired', caseId)
                    MySQL.Async.execute(
                        "UPDATE doj_cases SET status = @newstatus WHERE id = @id AND status = @openstatus",
                        { ['@newstatus'] = 'cold', ['@id'] = caseId, ['@openstatus'] = 'open' }
                    )
                end
            end)
        end
    )
end)

-- ============================================================
-- Evidence collection
-- ============================================================

RegisterServerEvent('CrimeScene:collectEvidence')
AddEventHandler('CrimeScene:collectEvidence', function(caseId, pointId, skillCheckPassed)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer or not IsDOJJob(xPlayer.job.name) then return end

    local scene = ActiveScenes[caseId]
    if not scene then
        TriggerClientEvent('esx:showNotification', _source, 'In Sahne Digar Motabar Nist Ya Sard Shode', 'error')
        return
    end

    local point = scene.points[pointId]
    if not point or point.collected then return end

    local ped = GetPlayerPed(_source)
    local pCoords = GetEntityCoords(ped)
    if #(pCoords - point.coords) > Config.CollectDistance then
        TriggerClientEvent('esx:showNotification', _source, 'Shoma Be In Noghte Nazdik Nistid', 'error')
        return
    end

    point.collected = true

    local roll = math.random()
    local evType, content, hintId

    if roll < Config.StrongLeadChance then
        evType = 'strong_lead'
    elseif scene.plate and roll < (Config.StrongLeadChance + Config.VehicleLeadChance) then
        evType = 'vehicle'
    else
        evType = 'hint'
    end

    -- Failing the skillcheck downgrades the roll: a strong lead or vehicle
    -- description turns into a smudged/useless plain hint instead. Evidence
    -- is never lost entirely -- it just becomes weaker.
    if not skillCheckPassed and evType ~= 'hint' then
        evType = 'hint'
    end

    if evType == 'strong_lead' then
        hintId = scene.suspectIdentifier and scene.suspectIdentifier:sub(-6) or '??????'
        content = 'Sarnakh Ghavi: Yek Fard Ba Code Shenasaei Payan Be ^3' .. hintId .. '^0 Peida Shod'
    elseif evType == 'vehicle' then
        content = 'Pelake Khodroye Mashkook: ^3' .. scene.plate .. '^0'
    else
        content = Config.SuspectHints[math.random(1, #Config.SuspectHints)]
    end

    MySQL.Async.insert(
        'INSERT INTO doj_case_evidence (case_id, type, content, suspect_hint_id, found_by, found_by_name) VALUES (@case_id, @type, @content, @hint_id, @found_by, @found_by_name)',
        {
            ['@case_id']       = caseId,
            ['@type']          = evType,
            ['@content']       = content,
            ['@hint_id']       = hintId,
            ['@found_by']      = xPlayer.identifier,
            ['@found_by_name'] = xPlayer.name,
        }
    )

    TriggerClientEvent('CrimeScene:evidenceCollected', _source, caseId, pointId, evType, content, skillCheckPassed)
    BroadcastToJobs(Config.DOJJobs, 'CrimeScene:pointRemoved', caseId, pointId)

    TriggerEvent(
        'DiscordBot:ToDiscord', 'rob', "Crime Scene",
        "```css\n[Case] : " .. caseId ..
        "\n[Officer] : " .. xPlayer.name ..
        "\n[Type] : " .. evType ..
        "\n[Content] : " .. content .. "\n```",
        'user', _source, true, false
    )
end)

-- ============================================================
-- Case notes / expanding a case
-- ============================================================

RegisterServerEvent('CrimeScene:addNote')
AddEventHandler('CrimeScene:addNote', function(caseId, note)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer or not IsDOJJob(xPlayer.job.name) then return end
    if not note or note == '' then return end

    MySQL.Async.execute(
        'INSERT INTO doj_case_notes (case_id, author, author_name, note) VALUES (@case_id, @author, @author_name, @note)',
        {
            ['@case_id']    = caseId,
            ['@author']     = xPlayer.identifier,
            ['@author_name'] = xPlayer.name,
            ['@note']       = note,
        }
    )

    TriggerClientEvent('esx:showNotification', _source, 'Yaddasht Be Parvande Ezafe Shod', 'success')
    TriggerClientEvent('CrimeScene:refreshCase', _source, caseId)
end)

-- ============================================================
-- Referral (CID/DOJ field jobs -> Judge/CIA/FBI)
-- ============================================================

RegisterServerEvent('CrimeScene:referCase')
AddEventHandler('CrimeScene:referCase', function(caseId, targetJob)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer or not IsDOJJob(xPlayer.job.name) then return end
    if not IsReferralJob(targetJob) then return end

    MySQL.Async.execute(
        'UPDATE doj_cases SET status = @newstatus WHERE id = @id',
        { ['@newstatus'] = 'referred_' .. targetJob, ['@id'] = caseId },
        function(rowsChanged)
            if not rowsChanged or rowsChanged == 0 then return end

            NotifyJobs(
                { targetJob },
                'Yek Parvande Jadid Baraye Vahede Shoma Ersal Shod. /cases Bezanid.',
                'info'
            )
            TriggerClientEvent('esx:showNotification', _source, 'Parvande Ba Movafaghiat Ersal Shod', 'success')
            TriggerClientEvent('CrimeScene:refreshCase', _source, caseId)
            TriggerEvent(
                'DiscordBot:ToDiscord', 'rob', "Crime Scene",
                "```css\n[Case] : " .. caseId ..
                "\n[Referred By] : " .. xPlayer.name ..
                "\n[Referred To] : " .. targetJob .. "\n```",
                'user', _source, true, false
            )
        end
    )
end)

-- ============================================================
-- Closing a case (Judge/CIA/FBI only)
-- ============================================================

RegisterServerEvent('CrimeScene:closeCase')
AddEventHandler('CrimeScene:closeCase', function(caseId, verdict)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer or not IsReferralJob(xPlayer.job.name) then return end

    MySQL.Async.execute('UPDATE doj_cases SET status = @newstatus WHERE id = @id', { ['@newstatus'] = 'closed', ['@id'] = caseId })

    if verdict and verdict ~= '' then
        MySQL.Async.execute(
            'INSERT INTO doj_case_notes (case_id, author, author_name, note) VALUES (@case_id, @author, @author_name, @note)',
            {
                ['@case_id']     = caseId,
                ['@author']      = xPlayer.identifier,
                ['@author_name'] = xPlayer.name,
                ['@note']        = '[HOKM] ' .. verdict,
            }
        )
    end

    TriggerClientEvent('esx:showNotification', _source, 'Parvande Baste Shod', 'success')
    TriggerClientEvent('CrimeScene:refreshCase', _source, caseId)
end)

-- ============================================================
-- Fingerprint database match
-- ============================================================
-- Cross-references the strong_lead codes found in THIS case against every
-- strong_lead ever collected server-wide. If the same code shows up at
-- least Config.FingerprintMatchThreshold times, it's treated as a
-- confirmed match and the real current suspect name behind that case is
-- revealed as a note. This is the only place a real name ever gets
-- exposed, and only after real repeat investigative work.
RegisterServerEvent('CrimeScene:runFingerprintMatch')
AddEventHandler('CrimeScene:runFingerprintMatch', function(caseId)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer or not IsDOJJob(xPlayer.job.name) then return end

    MySQL.Async.fetchAll(
        'SELECT DISTINCT suspect_hint_id FROM doj_case_evidence WHERE case_id = @id AND type = @type AND suspect_hint_id IS NOT NULL',
        { ['@id'] = caseId, ['@type'] = 'strong_lead' },
        function(hints)
            if not hints or #hints == 0 then
                TriggerClientEvent('esx:showNotification', _source, 'In Parvande Hich Sarnakhe Ghavi Nadarad', 'error')
                return
            end

            local hintId = hints[1].suspect_hint_id

            MySQL.Async.fetchAll(
                'SELECT COUNT(*) as hits FROM doj_case_evidence WHERE suspect_hint_id = @hint_id',
                { ['@hint_id'] = hintId },
                function(countRows)
                    local hits = countRows and countRows[1] and countRows[1].hits or 0

                    if hits < Config.FingerprintMatchThreshold then
                        TriggerClientEvent('esx:showNotification', _source, 'Data Kafi Nist (' .. hits .. '/' .. Config.FingerprintMatchThreshold .. '). Edame Bede Tahghigh.', 'error')
                        return
                    end

                    MySQL.Async.fetchAll(
                        'SELECT c.suspect_name FROM doj_cases c JOIN doj_case_evidence e ON e.case_id = c.id WHERE e.suspect_hint_id = @hint_id ORDER BY e.created_at DESC LIMIT 1',
                        { ['@hint_id'] = hintId },
                        function(matchRows)
                            local suspectName = matchRows and matchRows[1] and matchRows[1].suspect_name or 'Nashenakhte'

                            MySQL.Async.execute(
                                'INSERT INTO doj_case_notes (case_id, author, author_name, note) VALUES (@case_id, @author, @author_name, @note)',
                                {
                                    ['@case_id']     = caseId,
                                    ['@author']      = 'SYSTEM',
                                    ['@author_name'] = 'Fingerprint DB',
                                    ['@note']        = 'MATCH PEIDA SHOD (' .. hits .. ' Sarnakh Motabegh): Fard Mashkook Ehtemalan ^2' .. suspectName .. '^0 Ast',
                                }
                            )

                            TriggerClientEvent('esx:showNotification', _source, 'Match Peida Shod! Parvande Update Shod.', 'success')
                            TriggerClientEvent('CrimeScene:refreshCase', _source, caseId)
                        end
                    )
                end
            )
        end
    )
end)

-- ============================================================
-- Wanted board -- repeat partial-code offenders across all cases
-- ============================================================

ESX.RegisterServerCallback('CrimeScene:getWantedBoard', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not IsDOJJob(xPlayer.job.name) then
        cb({})
        return
    end

    MySQL.Async.fetchAll([[
        SELECT suspect_hint_id, COUNT(*) as hits, MAX(created_at) as last_seen
        FROM doj_case_evidence
        WHERE type = 'strong_lead' AND suspect_hint_id IS NOT NULL
        GROUP BY suspect_hint_id
        ORDER BY hits DESC
        LIMIT 15
    ]], {}, function(result)
        cb(result or {})
    end)
end)

-- ============================================================
-- Callbacks for the /cases menu
-- ============================================================

ESX.RegisterServerCallback('CrimeScene:getCases', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not IsDOJJob(xPlayer.job.name) then
        cb({})
        return
    end

    if IsReferralJob(xPlayer.job.name) then
        MySQL.Async.fetchAll(
            "SELECT * FROM doj_cases WHERE status IN ('open','cold', @refstatus) ORDER BY created_at DESC LIMIT 50",
            { ['@refstatus'] = 'referred_' .. xPlayer.job.name },
            function(result) cb(result or {}) end
        )
    else
        MySQL.Async.fetchAll(
            "SELECT * FROM doj_cases WHERE status IN ('open','cold') ORDER BY created_at DESC LIMIT 50",
            {},
            function(result) cb(result or {}) end
        )
    end
end)

ESX.RegisterServerCallback('CrimeScene:getCaseDetail', function(source, cb, caseId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not IsDOJJob(xPlayer.job.name) then
        cb(nil)
        return
    end

    MySQL.Async.fetchAll('SELECT * FROM doj_cases WHERE id = @id', { ['@id'] = caseId }, function(caseRows)
        if not caseRows or not caseRows[1] then
            cb(nil)
            return
        end

        MySQL.Async.fetchAll('SELECT * FROM doj_case_evidence WHERE case_id = @id ORDER BY created_at ASC', { ['@id'] = caseId }, function(evidence)
            MySQL.Async.fetchAll('SELECT * FROM doj_case_notes WHERE case_id = @id ORDER BY created_at ASC', { ['@id'] = caseId }, function(notes)
                cb({ case = caseRows[1], evidence = evidence or {}, notes = notes or {} })
            end)
        end)
    end)
end)
