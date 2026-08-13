-- ============================================================
-- STREET LABEL MODULE (از sun-streetlabel ادغام و فیکس شد)
-- ============================================================
-- ✅ فیکس‌های اعمال‌شده نسبت به نسخه‌ی اصلی:
-- 1) ESX.GetPlayerData().rawid وجود نداشت (nil) → کرش "attempt to concatenate
--    a nil value". الان از سرور، شماره‌ی ثبت‌نام واقعی حساب (ستون id تو
--    جدول users) گرفته میشه.
-- 2) exports['sunset_utils']:GetServerOSTime() چون ریسورس sunset_utils نصب
--    نیست، کرش می‌داد. الان زمان از خودِ سرور (os.time() سمت سرور) گرفته میشه.
-- 3) SendNUIMessage با فرمت مشترک Unique_Ui (id) هماهنگ شد چون این ماژول الان
--    تو همون صفحه‌ی مشترک UI ادغام شده.
-- 4) ✅ os.time() مستقیم تو همین فایل (کلاینت) استفاده شده بود که کرش می‌داد،
--    چون کتابخانه‌ی os اصلاً سمت کلاینت FiveM وجود نداره (فقط سمت سرور در
--    دسترسه). مقدار اولیه الان 0 هست و چند لحظه بعد از سرور جایگزین میشه.

ESX = nil
local world = 0
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
end)

RegisterNetEvent('esx:changeworld', function(w)
    world = w
end)

-- ✅ فیکس شد: چون ایونت "esx:changeworld" ظاهراً تو فریم‌ورک شما فایر نمیشه
-- (برای همین world همیشه رو 0 می‌موند)، علاوه بر گوش‌دادن بهش، هر ۲ ثانیه هم
-- از سرور world واقعی رو با native خودِ FiveM (GetPlayerRoutingBucket) می‌پرسیم
-- - این یکی حدسی نیست و همیشه درست کار می‌کنه.
CreateThread(function()
    while ESX == nil do Wait(0) end
    while true do
        ESX.TriggerServerCallback('sun-streetlabel:getWorld', function(w)
            world = w or 0
        end)
        Wait(2000)
    end
end)

local directions = {
    N = 360, NE = 315, E = 270, SE = 225, S = 180, SW = 135, W = 90, NW = 45,
}

local isGpsOn = true
local isLoaded = false
local streetHash1, streetHash2, playerDirection
local accountId = 0 -- ✅ از سرور گرفته میشه، جایگزین rawid
local ts = 0 -- ✅ فیکس شد: کتابخانه‌ی os سمت کلاینت FiveM اصلاً وجود نداره (فقط سرور)؛ مقدار واقعی چند لحظه بعد از سرور میاد

local function sendUIMessage(data)
    data.id = 'streetlabel'
    SendNUIMessage(data)
end

RegisterCommand('gps', function()
    if GetResourceKvpInt('gps') == 1 then
        SetResourceKvpInt('gps', 0)
        isLoaded = false
    else
        SetResourceKvpInt('gps', 1)
        isLoaded = true
    end
end, false)

CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/gps', 'Toggle street label', {})
    isLoaded = GetResourceKvpInt('gps') == 1

    while ESX == nil do Wait(0) end

    -- ✅ فیکس شد: شماره‌ی ثبت‌نام واقعی از سرور گرفته میشه (نه ESX.GetPlayerData().rawid که وجود نداشت)
    ESX.TriggerServerCallback('sun-streetlabel:getAccountId', function(id)
        accountId = id or 0
    end)
    ESX.TriggerServerCallback('sun-streetlabel:getServerTime', function(time)
        ts = time or ts
    end)

    local svID = GetPlayerServerId(PlayerId())

    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local zone = GetNameOfZone(coords.x, coords.y, coords.z)
        local zoneLabel = GetLabelText(zone)
        local street2 = ''

        if isGpsOn then
            local var1, var2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
            streetHash1 = GetStreetNameFromHashKey(var1)
            streetHash2 = GetStreetNameFromHashKey(var2)
            playerDirection = GetEntityHeading(ped)

            for k, v in pairs(directions) do
                if math.abs(playerDirection - v) < 22.5 then
                    playerDirection = k
                    break
                end
            end

            street2 = (streetHash2 == '') and zoneLabel or (streetHash2 .. ', ' .. zoneLabel)
        end

        sendUIMessage({
            active = isLoaded,
            direction = playerDirection,
            zone = streetHash1,
            street = street2,
            time = GetClockHours() .. ':' .. GetClockMinutes(),
            ts = ts .. ' | ' .. accountId .. ' | W' .. world .. ' | ID : ',
            src = svID,
            server = (ESX.serverNum == 1) and '*' or '**',
            hud = true,
        })

        Wait(1000)
    end
end)

-- ✅ فیکس شد: به‌جای فراخوانی export ناموجود هر ۱ ثانیه، فقط محلی +۱ میشه
-- (بار سرور رو هم کم می‌کنه). هر ۶۰ ثانیه یه‌بار با سرور دوباره سینک میشه که
-- drift نداشته باشه.
CreateThread(function()
    while true do
        Wait(1000)
        ts = ts + 1
    end
end)

CreateThread(function()
    while true do
        Wait(60000)
        if ESX then
            ESX.TriggerServerCallback('sun-streetlabel:getServerTime', function(time)
                if time then ts = time end
            end)
        end
    end
end)
