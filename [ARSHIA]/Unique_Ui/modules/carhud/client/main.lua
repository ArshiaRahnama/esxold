-- ============================================================
-- CARHUD MODULE - نمایشگر سرعت/دور موتور/دنده/بنزین
-- ============================================================
local isShowing = false
local lastSpeedUnit = 'kmh' -- می‌تونید 'mph' هم بذارید

local function getSpeed(veh)
    local speed = GetEntitySpeed(veh) -- m/s
    if lastSpeedUnit == 'mph' then
        return math.floor(speed * 2.236936)
    end
    return math.floor(speed * 3.6)
end

local function getFuelLevel(veh)
    -- ✅ اکثر فریم‌ورک‌ها (ESX/QB) این native رو ساپورت می‌کنن. اگه فریم‌ورک
    -- شما بنزین رو جای دیگه‌ای نگه می‌داره (مثلاً یه statebag سفارشی)، همینجا عوضش کنید.
    local ok, val = pcall(GetVehicleFuelLevel, veh)
    if ok and val then return math.floor(val) end
    return nil
end

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)

        if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped then
            if not isShowing then
                isShowing = true
                SendNUIMessage({ id = 'carhud', display = true })
            end

            local speed = getSpeed(veh)
            local rpm = GetVehicleCurrentRpm(veh) or 0
            local fuel = getFuelLevel(veh)
            local maxSpeed = 220 -- برای پر شدن نوار سرعت؛ دلخواه قابل تنظیمه

            SendNUIMessage({
                id = 'carhud',
                display = true,
                speed = speed,
                unit = lastSpeedUnit,
                rpm = math.floor((rpm or 0) * 100),
                fuel = fuel,
                speedPercent = math.min(100, math.floor((speed / maxSpeed) * 100)),
            })

            Wait(0)
        else
            if isShowing then
                isShowing = false
                SendNUIMessage({ id = 'carhud', display = false })
            end
            Wait(500)
        end
    end
end)
