-- ============================================================
-- BRIDGE MODULE — لایه‌ی واسط مرکزی (Event Bus)
-- ============================================================
-- ✅ قبلاً هر اسکریپت خارجی که می‌خواست با Unique_Ui حرف بزنه، باید دقیقاً
-- می‌دونست کدوم export تو کدوم ماژول (achievements، ...) هست. الان یه
-- ورودی واحد و ساده داریم: exports['Unique_Ui']:trigger(...) — هر ماژول
-- جدیدی هم که بعداً اضافه بشه، فقط کافیه یه type جدید اینجا ثبت کنه.
--
-- استفاده (از یه اسکریپت دیگه، سمت سرور):
--   exports['Unique_Ui']:trigger(source, 'achievement:progress', { label = "10 Quest", amount = 1 })
--   exports['Unique_Ui']:trigger(source, 'skill:progress', { skill = "Police", amount = 0.5 })
--   exports['Unique_Ui']:trigger(source, 'notify', { kind = "info", title = "خوش اومدی", subtitle = "" })
--
-- استفاده (از کلاینت، بدون نیاز به export):
--   TriggerServerEvent('Unique_Ui:trigger', 'skill:progress', { skill = "Taxi", amount = 0.3 })

-- هر action-type که این‌جا ثبت میشه، به تابع مربوطه‌ش وصل میشه. ماژول‌های
-- دیگه (achievements و غیره) موقع لود شدن، خودشون رو اینجا ثبت می‌کنن —
-- یعنی این فایل نیازی نداره از قبل بدونه اون توابع کجان.
local handlers = {}

-- یه ماژول (مثلاً achievements) این تابع رو صدا می‌زنه تا یه type جدید ثبت کنه
local function registerHandler(actionType, fn)
    handlers[actionType] = fn
end

local function dispatch(source, actionType, payload)
    payload = payload or {}
    local fn = handlers[actionType]
    if not fn then
        print(('^1[Unique_Ui bridge]^7 نوع اکشن ناشناخته: "%s" — ماژولی که این رو پشتیبانی کنه لود نشده یا اسمش اشتباهه.'):format(tostring(actionType)))
        return false
    end

    local ok, err = pcall(fn, source, payload)
    if not ok then
        print(('^1[Unique_Ui bridge]^7 خطا تو اجرای "%s": %s'):format(tostring(actionType), tostring(err)))
        return false
    end
    return true
end

exports('trigger', dispatch)
exports('registerBridgeHandler', registerHandler) -- برای ماژول‌های خودِ Unique_Ui که خودشون رو ثبت می‌کنن

RegisterNetEvent('Unique_Ui:trigger', function(actionType, payload)
    dispatch(source, actionType, payload)
end)

-- ============================================================
-- ثبت هندلرهای پیش‌فرض (وصل به همون توابعی که از قبل تو achievements/hud هستن)
-- ============================================================
-- این‌ها با یه تاخیر کوچیک ثبت میشن تا مطمئن بشیم exportهای اصلی
-- (addAchievementProgress، addSkillProgress) قبلش لود شدن.
CreateThread(function()
    Wait(1000)

    registerHandler('achievement:progress', function(source, payload)
        exports['Unique_Ui']:addAchievementProgress(source, payload.label, payload.amount or 1)
    end)

    registerHandler('skill:progress', function(source, payload)
        exports['Unique_Ui']:addSkillProgress(source, payload.skill, payload.amount or 1)
    end)

    registerHandler('notify', function(source, payload)
        TriggerClientEvent('achievements:showToast', source, {
            kind = payload.kind or 'info',
            title = payload.title or '',
            subtitle = payload.subtitle or '',
        })
    end)

    print('^2[Unique_Ui bridge]^7 آماده — انواع اکشن فعال: achievement:progress, skill:progress, notify')
end)
