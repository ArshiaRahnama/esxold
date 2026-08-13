-- ============================================================
-- ACHIEVEMENTS MODULE - CLIENT
-- ============================================================
-- ✅ برگشت به همون UI اصلی خودتون (باندل React واقعی تو ui/skill) طبق
-- درخواست صریح شما. دیگه از UI سفارشی من استفاده نمیشه.
-- از exports['Unique_Ui']:sendMessage با فرمت id="skill" استفاده می‌کنه - همون
-- فرمتی که از خودِ باندل کامپایل‌شده استخراج کرده بودم.

local isOpen = false

local function openAchievements()
    if isOpen then return end

    ESX.TriggerServerCallback('achievements:getProfile', function(data)
        if not data then return end

        isOpen = true

        -- طبق main.lua واقعی شما: موقع باز شدن منو ایموت "think3" پخش میشه.
        pcall(function()
            exports['esx_dpemote']:PlayEmote('think3')
        end)

        exports['Unique_Ui']:sendMessage({
            id = 'skill',
            display = true,
            focus = true,
            profile = data.profile,
            achievements = data.achievements,
            skills = data.skills,
            pets = data.pets,
            vehicles = data.vehicles,
        })

        -- ✅ دکمه‌ی شناور لیدربورد فقط وقتی این منو بازه نمایش داده میشه
        SendNUIMessage({ id = 'lbButton', show = true })
    end)
end

local function closeAchievements()
    if not isOpen then return end
    isOpen = false
    exports['Unique_Ui']:sendMessage({ id = 'skill', display = false })

    -- ✅ اگه لیدربورد هم روش باز بود، با بسته‌شدن منو خودش هم بسته میشه
    pcall(function() exports['Unique_Ui']:closeLeaderboard() end)
    SendNUIMessage({ id = 'lbButton', show = false })

    local ped = PlayerPedId()
    ClearPedTasks(ped)
    ClearPedTasksImmediately(ped)
end

-- ✅ خودِ index.html شما با ESC، از main.lua یه callback به اسم "close" میگیره
-- و ایونت "ui:menuClosed" رو با id="skill" فایر می‌کنه.
AddEventHandler('ui:menuClosed', function(id)
    if id == 'skill' then
        isOpen = false
        pcall(function() exports['Unique_Ui']:closeLeaderboard() end)
        SendNUIMessage({ id = 'lbButton', show = false })
        ClearPedTasks(PlayerPedId())
    end
end)

-- کیبایند باز کردن منو (کلید I)
RegisterCommand('achievements', function()
    if isOpen then
        closeAchievements()
    else
        openAchievements()
    end
end, false)
RegisterKeyMapping('achievements', 'باز کردن منوی Achievements/Skill', 'keyboard', Config.AchievementsKey)

exports('openAchievements', openAchievements)
exports('closeAchievements', closeAchievements)

-- ✅ توست/نوتیفیکیشن لحظه‌ای (Achievement تکمیل شد / Skill به 100% رسید)
RegisterNetEvent('achievements:showToast', function(data)
    SendNUIMessage({
        id = 'toast',
        kind = data.kind,
        title = data.title,
        subtitle = data.subtitle,
    })
end)
