-- ============================================================
-- ✅ فیکس شد: این فایل اصلاً وجود نداشت! تو fxmanifest.lua نوشته شده بود
-- server_script "server.lua" ولی خودِ فایلش تو ریسورس نبود.
-- ============================================================

ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
end)

-- ✅ فیکس ریس‌کاندیشن: صبر می‌کنیم ESX واقعاً آماده بشه (همون باگی که تو
-- achievements/server/main.lua هم داشتیم و فیکس کردیم)
while ESX == nil do Wait(0) end

-- ✅ فیکس مهم پیدا شد: این فایل قبلاً فقط منتظر ESX می‌موند، نه MySQL. اگه
-- MySQL هنوز آماده نبود، خط ساخت ستون account_num کرش می‌کرد و چون تو
-- pcall نبود، کل بقیه‌ی فایل (ثبت callback های getWorld/getAccountId/
-- getServerTime) هیچ‌وقت اجرا نمی‌شد - دقیقاً چرا هم World هم شماره‌ی اکانت
-- با هم خراب بودن. الان هم منتظر MySQL می‌مونیم هم با pcall محافظت می‌کنیم.
while MySQL == nil do Wait(0) end

-- ✅ ساخت ستون account_num دیگه اینجا نیست — به سیستم Migration مرکزی منتقل
-- شد (modules/bridge/server/migrations.lua)، که یه‌بار برای کل پروژه اجراش
-- می‌کنه، نه جدا جدا تو هر ماژولی که بهش نیاز داره.

-- ✅ فیکس شد: قبلاً world فقط با ایونت "esx:changeworld" آپدیت می‌شد که یه حدس
-- بود و ظاهراً تو فریم‌ورک شما هیچ‌وقت fire نمی‌شد (برای همین همیشه رو 0 می‌موند).
-- الان از native واقعی و همیشگی خودِ FiveM (GetPlayerRoutingBucket) استفاده
-- می‌کنیم که مطمئنه و به هیچ ایونت حدسی وابسته نیست.
ESX.RegisterServerCallback('sun-streetlabel:getWorld', function(source, cb)
    cb(GetPlayerRoutingBucket(source) or 0)
end)

ESX.RegisterServerCallback('sun-streetlabel:getAccountId', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.identifier then return cb(0) end

    local ok, row = pcall(function()
        return MySQL.single.await('SELECT account_num FROM users WHERE identifier = ?', { xPlayer.identifier })
    end)

    if ok and row and row.account_num then
        cb(row.account_num)
    else
        cb(0)
    end
end)

-- ✅ جایگزین exports['sunset_utils']:GetServerOSTime() (ریسورسی که نصب ندارید
-- و باعث "No such export GetServerOSTime" می‌شد). زمان واقعی سرور رو مستقیم با
-- os.time() خودِ Lua برمی‌گردونه - بدون نیاز به هیچ ریسورس اضافه‌ای.
ESX.RegisterServerCallback('sun-streetlabel:getServerTime', function(source, cb)
    cb(os.time())
end)
