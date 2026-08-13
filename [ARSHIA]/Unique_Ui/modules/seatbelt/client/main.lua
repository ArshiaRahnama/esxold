-- ============================================================
-- SEATBELT MODULE (از carhud ادغام و فیکس شد)
-- ============================================================
-- ✅ فیکس‌های اعمال‌شده نسبت به نسخه‌ی اصلی:
-- 1) AddEventHandler("onKeyDown", ...) به یه ریسورس جانبی نیاز داره که این
--    ایونت رو fire کنه؛ اگه اون ریسورس نصب نباشه، دکمه‌ی کمربند هیچ‌وقت کار
--    نمی‌کنه (بدون خطا، فقط ساکت). به‌جاش RegisterKeyMapping استفاده شده که
--    مستقل و مطمئنه.
-- 2) بخش "جلوگیری از پیاده‌شدن با کمربند بسته" قبلاً فقط داخل onKeyDown بود
--    (یعنی فقط یه فریم اجرا می‌شد، عملاً بی‌اثر). الان داخل حلقه‌ی اصلی و
--    پیوسته اجرا میشه.
-- 3) ESX.SetEntityCoords وجود نداره تو اکثر نسخه‌های ESX؛ با native
--    SetEntityCoords جایگزین شد.
-- 4) SendNUIMessage مستقیم به‌جای فرمت مشترک Unique_Ui (id/display) می‌فرستاد؛
--    چون الان تو همون صفحه‌ی مشترک Unique_Ui ادغام شده، با فرمت درست ({id =
--    'seatbelt', display = true/false}) هماهنگ شد.

local isUiOpen  = false
local speedBuffer = {}
local velBuffer   = {}
local beltOn      = false
local wasInCar    = false
local vehData     = { active = false }

ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
end)

local function setSeatbeltUI(show)
    SendNUIMessage({ id = 'seatbelt', display = show })
end

local function IsCar(veh)
    local vc = GetVehicleClass(veh)
    return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 15 and vc <= 20)
end

local function Fwv(entity)
    local hr = GetEntityHeading(entity) + 90.0
    if hr < 0.0 then hr = 360.0 + hr end
    hr = hr * 0.0174533
    return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end

-- ============================================================
-- حلقه‌ی اصلی: نمایش UI + شبیه‌سازی پرت‌شدن بدون کمربند + قفل خروج با کمربند
-- ============================================================
CreateThread(function()
    while true do
        Wait(10)

        if vehData.active then
            wasInCar = true

            if not isUiOpen and not IsPlayerDead(PlayerId()) then
                setSeatbeltUI(true)
                isUiOpen = true
            end

            -- ✅ فیکس شد: این بخش قبلاً فقط داخل onKeyDown بود (تقریباً بی‌اثر).
            -- الان تا وقتی کمربند بسته‌ست، پیوسته کلید پیاده‌شدن رو غیرفعال می‌کنه.
            if beltOn then
                DisableControlAction(0, 75, true)  -- پیاده شدن (ایستاده)
                DisableControlAction(27, 75, true) -- پیاده شدن (در حال حرکت)
            end

            if not beltOn then
                speedBuffer[2] = speedBuffer[1]
                speedBuffer[1] = GetEntitySpeed(vehData.vehicle)
                if speedBuffer[2] ~= nil
                    and GetEntitySpeedVector(vehData.vehicle, true).y > 1.0
                    and speedBuffer[1] > 19.25
                    and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.255) then

                    local co = GetEntityCoords(vehData.ped)
                    local fw = Fwv(vehData.ped)
                    -- ✅ فیکس شد: ESX.SetEntityCoords وجود نداشت
                    SetEntityCoords(vehData.ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true, false)
                    if velBuffer[2] then
                        SetEntityVelocity(vehData.ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
                    end
                    Wait(1)
                    SetPedToRagdoll(vehData.ped, 1000, 1000, 0, 0, 0, 0)
                end

                velBuffer[2] = velBuffer[1]
                velBuffer[1] = GetEntityVelocity(vehData.vehicle)
            else
                Wait(500)
            end

        elseif wasInCar then
            wasInCar = false
            beltOn = false
            speedBuffer[1], speedBuffer[2] = 0.0, 0.0
            if isUiOpen then
                setSeatbeltUI(false)
                isUiOpen = false
            end
        else
            Wait(500)
        end
    end
end)

-- ============================================================
-- توگل کمربند (✅ کیبایند مستقل، بدون نیاز به ریسورس جانبی)
-- ============================================================
RegisterCommand('togglebelt', function()
    if not vehData.active then return end
    if ESX.GetPlayerData()['IsDead'] == 1 then return end

    beltOn = not beltOn

    if beltOn then
        TriggerEvent("pNotify:SendNotification", { text = "!کمربند شما بسته شد", type = "success", timeout = 1400, layout = "centerLeft" })
        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.9, 'buckle', 0.9)
        setSeatbeltUI(false)
    else
        speedBuffer = {}
        velBuffer = {}
        TriggerEvent("pNotify:SendNotification", { text = "!کمربند شما باز شد", type = "error", timeout = 1400, layout = "centerRight" })
        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.9, 'unbuckle', 0.9)
        setSeatbeltUI(true)
    end
end, false)
RegisterKeyMapping('togglebelt', 'بستن/باز کردن کمربند', 'keyboard', Config.SeatbeltKey)

RegisterNetEvent('seatbelt:beband', function()
    beltOn = true
    isUiOpen = true
    setSeatbeltUI(false)
    TriggerEvent("pNotify:SendNotification", { text = "!کمربند شما بسته شد", type = "success", timeout = 1400, layout = "centerLeft" })
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.9, 'buckle', 0.9)
end)

-- ============================================================
-- آژیر هشدار سرعت بالا بدون کمربند
-- ============================================================
CreateThread(function()
    while true do
        local player = PlayerPedId()
        local speed = GetEntitySpeed(player)
        local kmh = speed * 3.6
        local car = GetVehiclePedIsIn(player, false)
        if not beltOn and IsPedInAnyVehicle(player, false) and kmh > 100 and car ~= 0 and (wasInCar or IsCar(car)) then
            TriggerEvent('InteractSound_CL:PlayOnOne', 'seatbeltalarm', 0.5)
            Wait(20000)
        end
        Wait(5000)
    end
end)

-- ============================================================
-- محدودیت دوربین برای ماشین‌های خاص (بلک‌لیست)
-- ============================================================
local blackList = {
    [GetHashKey("RIOT")] = { smaller = -145, bigger = 100, passengerRestrict = true },
    [GetHashKey("INSURGENT2")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("ZENTORNO")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("VAGNER")] = { smaller = -140, bigger = 170, passengerRestrict = false },
    [GetHashKey("VISIONE")] = { smaller = -165, bigger = 120, passengerRestrict = false },
    [GetHashKey("TYRUS")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("TYRANT")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("TIGON")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("TAIPAN")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("T20")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("SC1")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("REAPER")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("PROTOTIPO")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("PFISTER811")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("LE7B")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("KRIEGER")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("INFERNUS")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("ENTITYXF")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("ENTITY2")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("BULLET")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("AUTARCH")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("RMODLP750")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("RMODLP770")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("CHIRON17")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("SHEAVA")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("hellion")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    -- vip cars
    [GetHashKey("eyd")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("divo")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("16ss")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("mvisiongt")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    -- vic car
    [GetHashKey("918")] = { smaller = -150, bigger = 100, passengerRestrict = false },
    [GetHashKey("hummer")] = { smaller = -150, bigger = 100, passengerRestrict = false },
}

CreateThread(function()
    while true do
        Wait(500)
        local ped = PlayerPedId()
        local car = GetVehiclePedIsIn(ped, false)
        local isBlackList = blackList[GetEntityModel(car)]

        if car ~= 0 and IsCar(car) then
            vehData.ped = ped
            vehData.vehicle = car
            vehData.blacklist = isBlackList

            if vehData.blacklist then
                if (vehData.blacklist.passengerRestrict and GetPedInVehicleSeat(car, 0) == ped)
                    or (not vehData.blacklist.passengerRestrict) then
                    local camHeading = GetGameplayCamRelativeHeading()
                    vehData.lookingBack = camHeading < vehData.blacklist.smaller or camHeading > vehData.blacklist.bigger
                end
            end

            vehData.active = true
        else
            vehData = { active = false }
        end
    end
end)

CreateThread(function()
    while true do
        if vehData.active and (vehData.blacklist and vehData.lookingBack) then
            Wait(10)
            DisableControlAction(2, 25, true)
            DisableControlAction(2, 24, true)
            DisableControlAction(0, 69, true)
            DisableControlAction(0, 70, true)
            DisableControlAction(0, 68, true)
            DisableControlAction(0, 66, true)
            DisableControlAction(0, 67, true)
            DisableControlAction(2, 257, true)
            DisableControlAction(0, 92, true)
            DisableControlAction(0, 114, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 331, true)
        else
            Wait(500)
        end
    end
end)
