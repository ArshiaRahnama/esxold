

local ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end
end)

local spawnedAt = GetGameTimer()

local spawnResetHooks = {}
local function registerSpawnReset(fn)
    table.insert(spawnResetHooks, fn)
end

RegisterNetEvent('esx:playerSpawned')
AddEventHandler('esx:playerSpawned', function()
    spawnedAt = GetGameTimer()
    for _, fn in ipairs(spawnResetHooks) do
        fn()
    end
end)

local function inSpawnProtection()
    return (GetGameTimer() - spawnedAt) < Config.GodmodeCheck.IgnoreDuringSpawnProtectionMs
end

local function report(kind, evidence)
    if Config.Debug then
        print(('[AntiCheat] flag=%s evidence=%s'):format(kind, json.encode(evidence)))
    end
    TriggerServerEvent('AntiCheat:flag', kind, evidence)
end

local Baseline = {
    foot    = { n = 0, mean = 0, m2 = 0 },
    vehicle = { n = 0, mean = 0, m2 = 0 },
}

local function welfordUpdate(state, sample)
    state.n = state.n + 1
    local delta = sample - state.mean
    state.mean = state.mean + delta / state.n
    local delta2 = sample - state.mean
    state.m2 = state.m2 + delta * delta2
end

local function welfordStdDev(state)
    if state.n < 2 then return 0 end
    return math.sqrt(state.m2 / (state.n - 1))
end

if Config.SpeedCheck.Enable then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(Config.SpeedCheck.SampleIntervalMs)
            local ped = PlayerPedId()
            if ped and ped ~= 0 and not IsEntityDead(ped) then
                local inVehicle = IsPedInAnyVehicle(ped, false)
                local entity = inVehicle and GetVehiclePedIsIn(ped, false) or ped

                local falling = IsPedFalling(ped) or IsPedRagdoll(ped)
                local parachuting = GetPedParachuteState(ped) ~= -1
                local skip = (Config.SpeedCheck.IgnoreIfFalling and (falling or parachuting))

                if inVehicle and Config.SpeedCheck.IgnoreIfInAircraft then
                    local vClass = GetVehicleClass(entity)
                    if vClass == 15 or vClass == 16 then
                        skip = true
                    end
                end

                if not skip and entity and entity ~= 0 then
                    local speed = GetEntitySpeed(entity)

                    local stateKey = inVehicle and 'vehicle' or 'foot'
                    local state = Baseline[stateKey]
                    local ceiling = inVehicle and Config.SpeedCheck.HardCeilingVehicle or Config.SpeedCheck.HardCeilingFoot

                    if state.n >= Config.SpeedCheck.MinSamplesForBaseline then
                        local sd = welfordStdDev(state)
                        local z = sd > 0 and ((speed - state.mean) / sd) or 0

                        if speed > ceiling and z > Config.SpeedCheck.ZScoreThreshold then
                            report('speed', {
                                speed = speed, ceiling = ceiling, zscore = z,
                                mean = state.mean, sd = sd, inVehicle = inVehicle,
                            })

                        else
                            welfordUpdate(state, speed)
                        end
                    else

                        if speed <= ceiling then
                            welfordUpdate(state, speed)
                        end
                    end
                end
            end
        end
    end)
end

if Config.NoclipCheck.Enable then
    local lastPos = nil
    registerSpawnReset(function() lastPos = nil end)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(Config.NoclipCheck.SampleIntervalMs)
            local ped = PlayerPedId()
            if ped and ped ~= 0 and not IsEntityDead(ped) and not inSpawnProtection() then
                local inVehicle = IsPedInAnyVehicle(ped, false)
                local skip = (Config.NoclipCheck.IgnoreIfInVehicle and inVehicle)
                    or (Config.NoclipCheck.IgnoreIfSwimming and IsPedSwimming(ped))
                    or (Config.NoclipCheck.IgnoreIfOnLadder and IsPedClimbing(ped))
                    or (Config.NoclipCheck.IgnoreIfParachuting and GetPedParachuteState(ped) ~= -1)

                if not skip then
                    local pos = GetEntityCoords(ped)
                    local signals = 0
                    local detail = {}


                    if GetEntityCollisionDisabled(ped) then
                        signals = signals + 1
                        detail.collisionDisabled = true
                    end


                    local heightAboveGround = GetEntityHeightAboveGround(ped)
                    if not inVehicle and heightAboveGround and heightAboveGround > 3.0
                        and not IsPedFalling(ped) and not IsPedRagdoll(ped)
                        and not IsPedJumping(ped) then
                        signals = signals + 1
                        detail.hovering = heightAboveGround
                    end



                    if Config.NoclipCheck.RaycastThroughWorld and lastPos then
                        local rayHandle = StartShapeTestRay(
                            lastPos.x, lastPos.y, lastPos.z,
                            pos.x, pos.y, pos.z,
                            1, ped, 0)
                        local _, hit = GetShapeTestResult(rayHandle)
                        if hit == 1 then
                            signals = signals + 1
                            detail.raycastThroughWorld = true
                        end
                    end

                    if signals >= Config.NoclipCheck.RequireSignals then
                        report('noclip', detail)
                    end

                    lastPos = pos
                end
            end
        end
    end)
end

if Config.GodmodeCheck.Enable then
    Citizen.CreateThread(function()
        local wasDamagedFlag = false
        local pendingChecks = {}
        local noDamageStreak = 0
        local lastFlagAt = 0

        while true do
            Citizen.Wait(250)
            local ped = PlayerPedId()
            if ped and ped ~= 0 and not IsEntityDead(ped) and not inSpawnProtection() then
                local damagedNow = HasEntityBeenDamagedByAnyPed(ped)
                local health = GetEntityHealth(ped)

                if damagedNow and not wasDamagedFlag then
                    table.insert(pendingChecks, { atHealth = health, time = GetGameTimer() })
                end
                wasDamagedFlag = damagedNow


                local now = GetGameTimer()
                for i = #pendingChecks, 1, -1 do
                    local chk = pendingChecks[i]
                    if now - chk.time > 600 then
                        if health >= chk.atHealth then
                            noDamageStreak = noDamageStreak + 1
                        else
                            noDamageStreak = 0
                        end
                        table.remove(pendingChecks, i)
                    end
                end

                if noDamageStreak >= Config.GodmodeCheck.RequiredNoDamageHits
                    and (now - lastFlagAt) > Config.GodmodeCheck.WindowMs then
                    report('godmode', { streak = noDamageStreak, health = health })
                    lastFlagAt = now
                    noDamageStreak = 0
                end
            end
        end
    end)
end

if Config.TeleportCheck.Enable then
    local lastPos, lastTime = nil, nil
    registerSpawnReset(function() lastPos, lastTime = nil, nil end)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(Config.TeleportCheck.SampleIntervalMs)
            local ped = PlayerPedId()
            if ped and ped ~= 0 and not IsEntityDead(ped) and not inSpawnProtection() then
                local pos = GetEntityCoords(ped)
                local now = GetGameTimer()

                if lastPos and lastTime then
                    local dt = (now - lastTime) / 1000.0
                    if dt > 0 then
                        local dist = #(pos - lastPos)
                        local mps = dist / dt

                        local skip = false
                        if Config.TeleportCheck.IgnoreIfInAircraft and IsPedInAnyVehicle(ped, false) then
                            local veh = GetVehiclePedIsIn(ped, false)
                            local vClass = GetVehicleClass(veh)
                            if vClass == 15 or vClass == 16 then skip = true end
                        end

                        if not skip and mps > Config.TeleportCheck.MaxMetersPerSecond then
                            report('teleport', { distance = dist, seconds = dt, mps = mps })
                        end
                    end
                end

                lastPos = pos
                lastTime = now
            end
        end
    end)
end

if Config.SuperJumpCheck.Enable then
    local occurrences = {}
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(Config.SuperJumpCheck.SampleIntervalMs)
            local ped = PlayerPedId()
            if ped and ped ~= 0 and not IsEntityDead(ped) and not IsPedInAnyVehicle(ped, false) then
                if IsPedJumping(ped) then
                    local vel = GetEntityVelocity(ped)
                    if vel.z > Config.SuperJumpCheck.MaxVerticalVelocity then
                        local now = GetGameTimer()
                        table.insert(occurrences, now)
                        for i = #occurrences, 1, -1 do
                            if now - occurrences[i] > Config.SuperJumpCheck.WindowMs then
                                table.remove(occurrences, i)
                            end
                        end
                        if #occurrences >= Config.SuperJumpCheck.RequiredOccurrences then
                            report('superjump', { verticalVelocity = vel.z, occurrences = #occurrences })
                            occurrences = {}
                        end
                    end
                end
            end
        end
    end)
end

if Config.InvisibilityCheck.Enable then
    Citizen.CreateThread(function()
        local streak = 0
        while true do
            Citizen.Wait(Config.InvisibilityCheck.SampleIntervalMs)
            local ped = PlayerPedId()
            if ped and ped ~= 0 and not IsEntityDead(ped) and not inSpawnProtection() then
                if not IsEntityVisible(ped) then
                    streak = streak + 1
                    if streak >= Config.InvisibilityCheck.RequiredOccurrences then
                        report('invisibility', { streak = streak })
                        streak = 0
                    end
                else
                    streak = 0
                end
            end
        end
    end)
end

if Config.InfiniteAmmoCheck.Enable or Config.FireRateCheck.Enable then
    Citizen.CreateThread(function()
        local wasShooting = false
        local lastAmmo = nil
        local lastWeapon = nil
        local lastShotTime = nil

        local ammoOccurrences = {}
        local fireRateOccurrences = {}

        local function isIgnoredAmmoWeapon(weaponHash)
            for _, w in ipairs(Config.InfiniteAmmoCheck.IgnoreWeapons) do
                if w == weaponHash then return true end
            end
            return false
        end

        while true do
            Citizen.Wait(0)
            local ped = PlayerPedId()
            if ped and ped ~= 0 and not IsEntityDead(ped) then
                local shooting = IsPedShooting(ped)

                if shooting and not wasShooting then

                    local hasWeapon, weaponHash = GetCurrentPedWeapon(ped, true)
                    local now = GetGameTimer()

                    if hasWeapon and weaponHash and weaponHash ~= GetHashKey('WEAPON_UNARMED') then

                        if Config.FireRateCheck.Enable and lastShotTime and lastWeapon == weaponHash then
                            local gap = now - lastShotTime
                            local minCycle = Config.FireRateCheck.WeaponMinCycleMs[weaponHash] or Config.FireRateCheck.DefaultMinCycleMs
                            if gap < minCycle then
                                table.insert(fireRateOccurrences, now)
                                for i = #fireRateOccurrences, 1, -1 do
                                    if now - fireRateOccurrences[i] > Config.FireRateCheck.WindowMs then
                                        table.remove(fireRateOccurrences, i)
                                    end
                                end
                                if #fireRateOccurrences >= Config.FireRateCheck.RequiredOccurrences then
                                    report('firerate', { weapon = weaponHash, gapMs = gap, minCycleMs = minCycle })
                                    fireRateOccurrences = {}
                                end
                            end
                        end


                        if Config.InfiniteAmmoCheck.Enable and not isIgnoredAmmoWeapon(weaponHash) then
                            local ammoNow = GetAmmoInPedWeapon(ped, weaponHash)
                            if lastWeapon == weaponHash and lastAmmo ~= nil and ammoNow >= lastAmmo and lastAmmo > 0 then
                                table.insert(ammoOccurrences, now)
                                for i = #ammoOccurrences, 1, -1 do
                                    if now - ammoOccurrences[i] > Config.InfiniteAmmoCheck.WindowMs then
                                        table.remove(ammoOccurrences, i)
                                    end
                                end
                                if #ammoOccurrences >= Config.InfiniteAmmoCheck.RequiredOccurrences then
                                    report('infiniteammo', { weapon = weaponHash, ammo = ammoNow })
                                    ammoOccurrences = {}
                                end
                            end
                            lastAmmo = ammoNow
                        end

                        lastWeapon = weaponHash
                        lastShotTime = now
                    end
                end

                wasShooting = shooting
            end
        end
    end)
end

if Config.WeaponBlacklistCheck.Enable then
    Citizen.CreateThread(function()
        local alreadyFlagged = {}
        while true do
            Citizen.Wait(Config.WeaponBlacklistCheck.SampleIntervalMs)
            local ped = PlayerPedId()
            if ped and ped ~= 0 and not IsEntityDead(ped) then
                for _, weaponHash in ipairs(Config.WeaponBlacklistCheck.Weapons) do
                    if HasPedGotWeapon(ped, weaponHash, false) then
                        if not alreadyFlagged[weaponHash] then
                            report('weaponblacklist', { weapon = weaponHash })
                            alreadyFlagged[weaponHash] = true
                        end
                    else
                        alreadyFlagged[weaponHash] = nil
                    end
                end
            end
        end
    end)
end

if Config.VehicleHandlingCheck.Enable then
    local lastSpeed, lastTime = nil, nil
    local occurrences = {}
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(Config.VehicleHandlingCheck.SampleIntervalMs)
            local ped = PlayerPedId()
            if ped and ped ~= 0 and IsPedInAnyVehicle(ped, false) then
                local veh = GetVehiclePedIsIn(ped, false)
                local speed = GetEntitySpeed(veh)
                local now = GetGameTimer()

                if lastSpeed ~= nil and lastTime ~= nil and GetPedInVehicleSeat(veh, -1) == ped then
                    local dt = (now - lastTime) / 1000.0
                    if dt > 0 then
                        local accel = (speed - lastSpeed) / dt
                        if accel > Config.VehicleHandlingCheck.MaxAccelMPS2 then
                            table.insert(occurrences, now)
                            for i = #occurrences, 1, -1 do
                                if now - occurrences[i] > Config.VehicleHandlingCheck.WindowMs then
                                    table.remove(occurrences, i)
                                end
                            end
                            if #occurrences >= Config.VehicleHandlingCheck.RequiredOccurrences then
                                report('vehiclehandling', { accel = accel, speed = speed })
                                occurrences = {}
                            end
                        end
                    end
                end

                lastSpeed = speed
                lastTime = now
            else
                lastSpeed, lastTime = nil, nil
            end
        end
    end)
end

if Config.InstantRefillCheck.Enable then
    local lastHealth, lastArmor = nil, nil
    local occurrences = {}
    registerSpawnReset(function() lastHealth, lastArmor = nil, nil end)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(Config.InstantRefillCheck.SampleIntervalMs)
            local ped = PlayerPedId()
            if ped and ped ~= 0 and not IsEntityDead(ped) and not inSpawnProtection() then
                local health = GetEntityHealth(ped)
                local armor = GetPedArmour(ped)

                if lastHealth ~= nil and (health - lastHealth) >= Config.InstantRefillCheck.MinJump then
                    local now = GetGameTimer()
                    table.insert(occurrences, now)
                elseif lastArmor ~= nil and (armor - lastArmor) >= Config.InstantRefillCheck.MinJump then
                    local now = GetGameTimer()
                    table.insert(occurrences, now)
                end

                local now = GetGameTimer()
                for i = #occurrences, 1, -1 do
                    if now - occurrences[i] > Config.InstantRefillCheck.WindowMs then
                        table.remove(occurrences, i)
                    end
                end
                if #occurrences >= Config.InstantRefillCheck.RequiredOccurrences then
                    report('instantrefill', { health = health, armor = armor })
                    occurrences = {}
                end

                lastHealth, lastArmor = health, armor
            end
        end
    end)
end

if Config.ResourceWhitelistCheck.Enable then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(Config.ResourceWhitelistCheck.SampleIntervalMs)
            local list = {}
            local count = GetNumResources()
            for i = 0, count - 1 do
                local name = GetResourceByFindIndex(i)
                if name then table.insert(list, name) end
            end
            TriggerServerEvent('AntiCheat:resourceList', list)
        end
    end)
end
