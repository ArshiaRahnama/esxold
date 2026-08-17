local ESX = nil
local PlayerJob = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    PlayerJob = ESX.PlayerData.job and ESX.PlayerData.job.name or nil
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerJob = job and job.name or nil
end)

local function IsDOJJob()
    if not PlayerJob then return false end
    for i = 1, #Config.DOJJobs do
        if Config.DOJJobs[i] == PlayerJob then return true end
    end
    return false
end

local function IsReferralJob()
    if not PlayerJob then return false end
    for i = 1, #Config.ReferralJobs do
        if Config.ReferralJobs[i] == PlayerJob then return true end
    end
    return false
end

-- ============================================================
-- Scene tracking: blips + ox_target zones per case
-- ============================================================

local SceneBlips = {}  -- [caseId] = blip
local PointZones = {}  -- [caseId][pointId] = zoneId

local function UpdateSceneBlipColor(caseId)
    if not SceneBlips[caseId] or not PointZones[caseId] then return end
    local remaining = 0
    for _ in pairs(PointZones[caseId]) do remaining = remaining + 1 end
    -- 5 = red/yellow (fresh scene), 3 = blue-ish, 2 = green (almost cleared)
    if remaining >= 3 then
        SetBlipColour(SceneBlips[caseId], 5)
    elseif remaining >= 1 then
        SetBlipColour(SceneBlips[caseId], 46)
    else
        SetBlipColour(SceneBlips[caseId], 2)
    end
end

local function RemoveScene(caseId)
    if SceneBlips[caseId] then
        RemoveBlip(SceneBlips[caseId])
        SceneBlips[caseId] = nil
    end
    if PointZones[caseId] then
        for _, zoneId in pairs(PointZones[caseId]) do
            if GetResourceState('ox_target') == 'started' then
                exports.ox_target:removeZone(zoneId)
            end
        end
        PointZones[caseId] = nil
    end
end

RegisterNetEvent('CrimeScene:sceneCreated')
AddEventHandler('CrimeScene:sceneCreated', function(caseId, coords, points)
    if not IsDOJJob() then return end

    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 60)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.9)
    SetBlipColour(blip, 5)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Sahne Jorm')
    EndTextCommandSetBlipName(blip)
    SceneBlips[caseId] = blip

    PointZones[caseId] = {}
    for _, point in ipairs(points) do
        local pointId = point.id
        local pCoords = point.coords

        local zoneId = exports.ox_target:addSphereZone({
            coords = pCoords,
            radius = 1.5,
            debug = false,
            options = {
                {
                    name = 'crimescene_evidence_' .. caseId .. '_' .. pointId,
                    icon = 'fa-solid fa-magnifying-glass',
                    label = 'Baresi Mahal',
                    canInteract = function() return IsDOJJob() end,
                    onSelect = function()
                        local passed = lib.skillCheck(Config.EvidenceSkillCheck)
                        TriggerServerEvent('CrimeScene:collectEvidence', caseId, pointId, passed and true or false)
                    end,
                }
            }
        })
        PointZones[caseId][pointId] = zoneId
    end

    UpdateSceneBlipColor(caseId)
end)

RegisterNetEvent('CrimeScene:pointRemoved')
AddEventHandler('CrimeScene:pointRemoved', function(caseId, pointId)
    if PointZones[caseId] and PointZones[caseId][pointId] then
        if GetResourceState('ox_target') == 'started' then
            exports.ox_target:removeZone(PointZones[caseId][pointId])
        end
        PointZones[caseId][pointId] = nil
        UpdateSceneBlipColor(caseId)
    end
end)

RegisterNetEvent('CrimeScene:sceneExpired')
AddEventHandler('CrimeScene:sceneExpired', function(caseId)
    RemoveScene(caseId)
end)

RegisterNetEvent('CrimeScene:evidenceCollected')
AddEventHandler('CrimeScene:evidenceCollected', function(caseId, pointId, evType, content, skillCheckPassed)
    lib.notify({
        title = skillCheckPassed and 'Madrak Peida Shod' or 'Madrak Peida Shod (Kamyfiat Payin)',
        description = content,
        type = skillCheckPassed and 'success' or 'warning',
        duration = 8000,
        position = 'center-right',
    })
end)

-- ============================================================
-- NUI Case Board
-- ============================================================

local function RefreshCaseList()
    ESX.TriggerServerCallback('CrimeScene:getCases', function(cases)
        SendNUIMessage({ action = 'cases', cases = cases })
    end)
end

local function RefreshCaseDetail(caseId)
    ESX.TriggerServerCallback('CrimeScene:getCaseDetail', function(detail)
        SendNUIMessage({ action = 'caseDetail', data = detail })
    end, caseId)
end

RegisterNetEvent('CrimeScene:refreshCase')
AddEventHandler('CrimeScene:refreshCase', function(caseId)
    RefreshCaseList()
    RefreshCaseDetail(caseId)
end)

local function OpenBoard()
    if not IsDOJJob() then
        lib.notify({ title = '', description = 'Shoma Dastresi Be In Panel Ra Nadarid', type = 'error' })
        return
    end

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open',
        isReferralJob = IsReferralJob(),
        playerJob = PlayerJob,
        referralJobs = Config.ReferralJobs,
    })
    RefreshCaseList()
end

RegisterCommand('cases', function()
    OpenBoard()
end, false)

RegisterNUICallback('selectCase', function(data, cb)
    RefreshCaseDetail(data.id)
    cb({})
end)

RegisterNUICallback('addNote', function(data, cb)
    TriggerServerEvent('CrimeScene:addNote', data.id, data.note)
    cb({})
end)

RegisterNUICallback('referCase', function(data, cb)
    TriggerServerEvent('CrimeScene:referCase', data.id, data.job)
    cb({})
end)

RegisterNUICallback('closeCase', function(data, cb)
    TriggerServerEvent('CrimeScene:closeCase', data.id, data.verdict)
    cb({})
end)

RegisterNUICallback('runMatch', function(data, cb)
    TriggerServerEvent('CrimeScene:runFingerprintMatch', data.id)
    cb({})
end)

RegisterNUICallback('loadWanted', function(data, cb)
    ESX.TriggerServerCallback('CrimeScene:getWantedBoard', function(list)
        SendNUIMessage({ action = 'wanted', list = list })
        cb({})
    end)
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    cb({})
end)
