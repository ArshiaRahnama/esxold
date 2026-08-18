-- ESX is already initialized globally by server.lua; no need to re-fetch it here.
--
-- SECURITY NOTE (fixed):
-- Previously "CarLock:ToggleKey" / "CarLock:ToggleKey2" trusted whatever plate
-- (and, for ToggleKey2, whatever target id) the client sent, with zero
-- server-side validation. Any player could fire those net events directly
-- (no game UI required) and mint themselves a permanent CarKey for ANY
-- plate -- including police/FBI/other players' cars -- fully bypassing the
-- lock system. Every path below now re-checks ownership/context on the
-- server before granting or revoking a key.

local RESTRICTED_HOTWIRE_PREFIXES = {
    ["FBI"] = true,
    ["PD"]  = true,
    ["MT"]  = true,
    ["SH"]  = true,
    ["TX"]  = true,
    ["MD"]  = true,
    ["MC"]  = true,
    ["WZ"]  = true,
}

local JOB_PLATE_ACCESS = {
    taxi      = "TX",
    police    = "PD",
    ambulance = "MD",
    fbi       = "FBI",
    sheriff   = "SH",
    mechanic  = "MC",
    weazel    = "WZ",
}

local function IsStaff(xPlayer)
    return xPlayer ~= nil and xPlayer.permission_level ~= nil and xPlayer.permission_level >= 1
end

-- Does this job/plate combo grant organizational (job) access, regardless of items?
local function HasJobPlateAccess(xPlayer, plate)
    local jobName = xPlayer.job and xPlayer.job.name
    if not jobName then return false end

    local requiredPrefix = JOB_PLATE_ACCESS[jobName]
    if not requiredPrefix then return false end

    local prefix = string.upper(string.sub(plate, 1, #requiredPrefix))
    return prefix == requiredPrefix
end

-- Async DB ownership check: personal owner OR gang owner. cb(isOwner, rowExists)
local function CheckDbOwnership(xPlayer, plate, cb)
    local gangName = xPlayer.gang and xPlayer.gang.name or nil
    MySQL.Async.fetchScalar('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function(owner)
        if owner == nil then
            cb(false, false)
            return
        end
        if owner == xPlayer.identifier then
            cb(true, true)
        elseif gangName and owner == gangName then
            cb(true, true)
        else
            cb(false, true)
        end
    end)
end

ESX.RegisterServerCallback('CarLock:haskey', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not plate then cb(false) return end

    plate = ESX.Math.Trim(plate)
    local item = "CarKey|" .. plate

    if HasJobPlateAccess(xPlayer, plate) then
        cb(true)
        return
    end

    local inventoryItem = xPlayer.getInventoryItem(item)
    if inventoryItem and inventoryItem.count >= 1 then
        cb(true)
        return
    end

    -- Fallback: personal or gang ownership in the DB, even without the item
    -- (covers desync cases -- previously only gang ownership was checked here).
    CheckDbOwnership(xPlayer, plate, function(isOwner)
        cb(isOwner)
    end)
end)

RegisterCommand('givekey', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not IsStaff(xPlayer) then return end

    local targetId = tonumber(args[1])
    if not targetId or not ESX.GetPlayerFromId(targetId) then
        print('Id Eshtbah Ast')
        return
    end

    if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(targetId))) <= 15 then
        TriggerClientEvent('givekey_Cl', targetId, targetId)
    else
        print('Fasle Shoma Ba Player Mored Nazar Zeyad Ast')
    end
end)

RegisterNetEvent("CarLock:CheckKeys")
AddEventHandler("CarLock:CheckKeys", function(KEYS)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or #KEYS <= 0 then return end

    local liveKeys = {}
    for i = 1, #KEYS do
        liveKeys[KEYS[i]] = true
    end

    for i = 1, #xPlayer.inventory do
        local invItem = xPlayer.inventory[i]
        if invItem and invItem.name and string.find(invItem.name, "CarKey") and invItem.count > 0 then
            if not liveKeys[invItem.name] then
                xPlayer.removeInventoryItem(invItem.name, invItem.count)
            end
        end
    end
end)

function EnumerateVehicles()
    return coroutine.wrap(function()
        local handle, vehicle = FindFirstVehicle()
        if not vehicle then
            return
        end
        local finished = false
        repeat
            coroutine.yield(vehicle)
            finished, vehicle = FindNextVehicle(handle)
        until not finished
        EndFindVehicle(handle)
    end)
end

--- Grants (op=true) or revokes (op=false) the CarKey item for `plate` to the
--- CALLING player (source). Validated against, in order: staff, DB
--- ownership (personal/gang), or actually sitting in a vehicle bearing that
--- exact plate while the plate has no DB owner yet (covers freshly spawned /
--- not-yet-registered vehicles -- dealership test drives, admin spawns,
--- job vehicles, etc).
RegisterNetEvent("CarLock:ToggleKey")
AddEventHandler("CarLock:ToggleKey", function(op, plate)
    local src = source
    if not plate then return end

    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    plate = ESX.Math.Trim(plate)
    if plate == "" or #plate > 12 then return end

    local item = "CarKey|" .. plate

    local function applyGrant()
        if xPlayer.getInventoryItem(item) == nil or xPlayer.getInventoryItem(item).count <= 0 then
            xPlayer.addInventoryItem(item, 1, nil, nil, 0)
        end
    end

    local function applyRevoke()
        local xPlayers = ESX.GetPlayers()
        for i = 1, #xPlayers, 1 do
            local xPlayerr = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayerr and xPlayerr.getInventoryItem(item) ~= nil and xPlayerr.getInventoryItem(item).count > 0 then
                xPlayerr.removeInventoryItem(item, 1)
            end
        end
    end

    if op then
        if IsStaff(xPlayer) then
            applyGrant()
            return
        end

        CheckDbOwnership(xPlayer, plate, function(isOwner, rowExists)
            if isOwner then
                applyGrant()
                return
            end

            if rowExists then
                -- Someone else owns this plate in the DB. Refuse.
                print(("[CarLock] Blocked suspicious key grant: player %s (%s) requested CarKey for plate '%s' which is DB-owned by someone else.")
                    :format(GetPlayerName(src) or "?", xPlayer.identifier or "?", plate))
                return
            end

            -- Not registered in owned_vehicles at all yet -- only allow if the
            -- player is actually sitting in a vehicle bearing this exact plate
            -- right now (e.g. it was just spawned by SpawnVehicle/dealer/admin
            -- and hasn't been saved to the DB yet).
            --
            -- NOTE: a freshly client-created vehicle can take a tick or two to
            -- fully replicate to the server, so GetVehiclePedIsIn() right here
            -- can briefly return 0 even for a 100% legit spawn. Retry a few
            -- times over ~1.5s before giving up, instead of rejecting instantly.
            local granted = false
            for attempt = 1, 15 do
                local ped = GetPlayerPed(src)
                local vehicle = ped and ped ~= 0 and GetVehiclePedIsIn(ped, false) or 0
                if vehicle ~= 0 and ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)) == plate then
                    applyGrant()
                    granted = true
                    break
                end
                Wait(100)
            end
            if not granted then
                print(("[CarLock] Blocked suspicious key grant: player %s (%s) requested CarKey for plate '%s' with no ownership and not in that vehicle.")
                    :format(GetPlayerName(src) or "?", xPlayer.identifier or "?", plate))
            end
        end)
    else
        -- Revoking is lower-risk (it only removes access), but still gate it
        -- so a random player can't grief-wipe someone else's key on a whim.
        if IsStaff(xPlayer) or (xPlayer.getInventoryItem(item) and xPlayer.getInventoryItem(item).count > 0) then
            applyRevoke()
        else
            CheckDbOwnership(xPlayer, plate, function(isOwner)
                if isOwner then applyRevoke() end
            end)
        end
    end
end)

--- Give-your-key-to-a-nearby-player. Sender must actually have legitimate
--- access to the plate themselves (item, DB ownership, or staff) before they
--- can hand it to someone else, and the target must be a real, nearby player.
RegisterNetEvent("CarLock:ToggleKey2")
AddEventHandler("CarLock:ToggleKey2", function(op, plate, targetId)
    local src = source
    if not plate then return end

    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    targetId = tonumber(targetId)
    local xTarget = targetId and ESX.GetPlayerFromId(targetId)
    if not xTarget then return end

    local targetPed = GetPlayerPed(targetId)
    local senderPed = GetPlayerPed(src)
    if not targetPed or targetPed == 0 or not senderPed or senderPed == 0 then return end
    if #(GetEntityCoords(senderPed) - GetEntityCoords(targetPed)) > 20.0 then
        print(("[CarLock] Blocked ToggleKey2: %s tried to give a key to a player %s far away.")
            :format(GetPlayerName(src) or "?", GetPlayerName(targetId) or "?"))
        return
    end

    plate = ESX.Math.Trim(plate)
    local item = "CarKey|" .. plate

    local function senderHasAccess(cb)
        if IsStaff(xPlayer) then cb(true) return end
        local invItem = xPlayer.getInventoryItem(item)
        if invItem and invItem.count > 0 then cb(true) return end
        CheckDbOwnership(xPlayer, plate, function(isOwner) cb(isOwner) end)
    end

    senderHasAccess(function(allowed)
        if not allowed then
            print(("[CarLock] Blocked ToggleKey2: %s (%s) has no access to plate '%s' and tried to hand out a key for it.")
                :format(GetPlayerName(src) or "?", xPlayer.identifier or "?", plate))
            return
        end

        if op then
            if xTarget.getInventoryItem(item) == nil or xTarget.getInventoryItem(item).count <= 0 then
                xTarget.addInventoryItem(item, 1, nil, nil, 0)
            end
        else
            if xTarget.getInventoryItem(item) ~= nil then
                xTarget.removeInventoryItem(item, 1)
            end
        end
    end)
end)

ESX.RegisterServerCallback('CarLock:hasHotwireItem', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local hotwireItem = xPlayer.getInventoryItem(Customize.HotwireItem)
    cb(hotwireItem ~= nil and hotwireItem.count >= 1)
end)

--- SECURITY NOTE (fixed): the restricted-plate-prefix check (no hotwiring
--- police/FBI/ambulance/etc) previously existed ONLY on the client, so any
--- exploit could skip straight to firing this event and hotwire a
--- restricted vehicle anyway. The prefix check is now enforced here too,
--- and we verify the player is actually sitting in the vehicle whose plate
--- they claim, instead of trusting a bare "give me a hotwire" ping.
RegisterNetEvent('CarLock:useHotwireKit')
AddEventHandler('CarLock:useHotwireKit', function(plate)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or not plate then return end

    plate = ESX.Math.Trim(plate)

    local ped = GetPlayerPed(src)
    local vehicle = ped and ped ~= 0 and GetVehiclePedIsIn(ped, false) or 0
    if vehicle == 0 or ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)) ~= plate then
        return
    end

    local prefix3 = string.upper(string.sub(plate, 1, 3))
    local prefix2 = string.upper(string.sub(plate, 1, 2))
    if RESTRICTED_HOTWIRE_PREFIXES[prefix3] or RESTRICTED_HOTWIRE_PREFIXES[prefix2] then
        print(("[CarLock] Blocked hotwire attempt: %s (%s) tried to hotwire restricted plate '%s'.")
            :format(GetPlayerName(src) or "?", xPlayer.identifier or "?", plate))
        return
    end

    local hotwireItem = xPlayer.getInventoryItem(Customize.HotwireItem)
    if hotwireItem and hotwireItem.count >= 1 then
        xPlayer.removeInventoryItem(Customize.HotwireItem, 1)
        TriggerClientEvent('CarLock:enableVehicleTemporarily', src)
    end
end)

ESX.RegisterServerCallback('CarLock:canHotwire', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not plate then cb(false) return end

    plate = ESX.Math.Trim(plate)
    local item = "CarKey|" .. plate
    local hasKey = xPlayer.getInventoryItem(item) and xPlayer.getInventoryItem(item).count >= 1

    if hasKey then
        cb(false) -- already has a key, no need to hotwire
        return
    end

    CheckDbOwnership(xPlayer, plate, function(isOwner)
        cb(not isOwner)
    end)
end)
