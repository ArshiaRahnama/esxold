-- ============================================================
-- Unique_Hud / client / speedometer.lua
-- ============================================================
-- توضیح: چیزی که تو Sunset اسمش "carhud" بود، فقط کمربند بود (SimpleCarHUD_cl.lua
-- که واقعاً سرعت/بنزین/دنده رو نشون می‌داد اصلاً تو ریپازیتوری پابلیکشون نبود
-- - دقیقاً مثل باگ status). پس این ماژول کاملاً از صفر نوشته شده، با همون
-- الگوی خوندن بنزین که قبلاً تو Unique_Garage/client/vehiclehud_cl.lua خودتون
-- تأیید شده بود (exports['LegacyFuel']:GetFuel).

local UH_SPEEDO_isUiOpen = false

local function UH_GetFuelPercent(vehicle)
    local ok, fuel = pcall(function() return exports['LegacyFuel']:GetFuel(vehicle) end)
    if ok and fuel then
        return math.floor(fuel + 0.5)
    end
    return math.floor(GetVehicleFuelLevel(vehicle) + 0.5)
end

Citizen.CreateThread(function()
    while true do
        local sleep = 500
        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            local driverSeat = GetPedInVehicleSeat(veh, -1) == ped

            if driverSeat then
                sleep = 0

                if not UH_SPEEDO_isUiOpen then
                    SendNUIMessage({ action = 'speedo:show' })
                    UH_SPEEDO_isUiOpen = true
                end

                local speedMs = GetEntitySpeed(veh)
                local speedKmh = math.floor((speedMs * 3.6) + 0.5)
                local gear = GetVehicleCurrentGear(veh)
                local fuelPercent = UH_GetFuelPercent(veh)
                local engineHealth = math.floor((GetVehicleEngineHealth(veh) / 1000.0) * 100)
                if engineHealth < 0 then engineHealth = 0 end
                if engineHealth > 100 then engineHealth = 100 end

                SendNUIMessage({
                    action = 'speedo:update',
                    speed = speedKmh,
                    gear = gear,
                    fuel = fuelPercent,
                    engine = engineHealth,
                })
            elseif UH_SPEEDO_isUiOpen then
                SendNUIMessage({ action = 'speedo:hide' })
                UH_SPEEDO_isUiOpen = false
            end
        elseif UH_SPEEDO_isUiOpen then
            SendNUIMessage({ action = 'speedo:hide' })
            UH_SPEEDO_isUiOpen = false
        end

        Citizen.Wait(sleep)
    end
end)
