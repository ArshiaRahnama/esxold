-- ============================================================
-- ACHIEVEMENTS MODULE - SERVER
-- ============================================================
-- این فایل به‌جای ساختن یه NUI جدید، مستقیم داده رو با همون فرمتی که خودِ
-- ماژول "skill" شما (React کامپایل‌شده تو ui/skill) انتظار داره می‌فرسته.
-- این فرمت رو از خودِ باندل main.js (خط addEventListener("message")) استخراج کردم:
--
--   { id = "skill", display = true, focus = true,
--     profile = { img, name, tc, level, xp, maxXp, timePlay, achevePoint,
--                 job, jobImg, gang, gangImg },
--     achievements = { { max, count, label, point, description, finishedDate }, ... },
--     skills       = { { percent, name, color={hex} }, ... },
--     pets         = { { img, label, owned }, ... },
--     vehicles     = { { img2, img, label, owned }, ... } }
--
-- برای همین دیگه نیازی به هیچ فایل HTML/CSS/JS جدیدی نیست؛ همون UI اصلی خودتون
-- استفاده میشه، این فایل فقط داده‌ی واقعی بازیکن رو براش آماده می‌کنه.

ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
end)

-- ✅ فیکس ریس‌کاندیشن: صبر می‌کنیم ESX واقعاً آماده بشه قبل از این‌که ادامه‌ی
-- فایل (شامل ensureColumn و RegisterServerCallback) اجرا بشه. قبلاً این خط‌ها
-- بلافاصله بعد از تعریف ترد بالا اجرا می‌شدن، بدون اینکه منتظر بمونن ESX واقعاً
-- ست شده باشه (باعث "attempt to index a nil value (global 'ESX')" می‌شد).
while ESX == nil do Wait(0) end

-- ✅ همین‌طور صبر می‌کنیم MySQL (از oxmysql) آماده باشه، چون بدون
-- '@oxmysql/lib/MySQL.lua' تو server_scripts این global هیچوقت ست نمیشه
-- (اون خط رو به fxmanifest.lua هم اضافه کردم).
while MySQL == nil do Wait(0) end

-- ============================================================
-- DISCORD AVATAR CONFIG (اختیاری)
-- ============================================================
-- برای خوندن خودکار آواتار دیسکورد وقتی Profile_Pic خالیه، توکن بات رو اینجا بذار.
-- اگه خالی بمونه فقط از عکس دیفالت استفاده میشه (کرش نمی‌ده).
local DISCORD_BOT_TOKEN = Config.DiscordBotToken

-- ============================================================
-- ✅ گسترش‌های جدید: وبهوک دیسکورد، پاداش سطحی Skill
-- ============================================================
-- لینک وبهوک کانال دیسکورد (Server Settings > Integrations > Webhooks).
-- اگه خالی بمونه، این فیچر غیرفعال میمونه (کرش نمی‌ده).
local DISCORD_WEBHOOK_URL = Config.DiscordWebhookURL
-- فقط Achievementهایی که point شون >= این عدد باشه به دیسکورد اعلام میشن
-- (که چت دیسکورد با هر Achievement کوچیک شلوغ نشه)
local WEBHOOK_MIN_POINT = Config.WebhookMinPoint

-- وقتی یه Skill به 100% برسه، این پاداش‌ها یه‌بار (فقط بار اول) داده میشن.
-- اگه یه Skill تو این جدول نباشه، پاداشی نداره (فقط توست نمایش داده میشه).
local SKILL_MAX_REWARDS = Config.SkillMaxRewards

-- ============================================================
-- JOB/DIVISION ICON OVERRIDES (اختیاری)
-- ============================================================
-- فایل‌های تو ui/skill/img/job با حروف بزرگ/کوچیک دقیق ذخیره شدن (مثلاً "K9.png",
-- "swat-40.png", "D-Vest.png"). اگه اسم جاب/دیویژن تو دیتابیستون دقیقاً با اسم
-- فایل یکی نیست، اینجا override بذار: ["اسم تو دیتابیس"] = "اسم دقیق فایل (بدون .png)"
local ICON_OVERRIDES = Config.IconOverrides

-- ============================================================
-- SKILL AUTO-TRACKING CONFIG (اختیاری، برای فعال‌سازی درخواستی)
-- ============================================================
-- هر آیتم تو DEFAULT_SKILLS با یه اسم جاب واقعی (اسمی که تو ESX دارید، نه
-- لیبل نمایشی) مچ میشه. اگه اسم جاب سرورتون با این‌ها فرق داره، همینجا
-- تصحیحش کن: کلید = اسم واقعی جاب (xPlayer.job.name)، مقدار = اسم دقیق
-- همون آیتم تو DEFAULT_SKILLS (باید حرف‌به‌حرف یکی باشه).
local JOB_SKILL_MAP = Config.JobSkillMap

-- هر چند دقیقه‌ی کار تو یه جاب، به ۱۰۰٪ می‌رسه (پیش‌فرض: ۳۰۰۰ دقیقه = ۵۰ ساعت)
local SKILL_TARGET_MINUTES = Config.SkillTargetMinutes

local function jobIconPath(key)
    if not key or key == '' then return nil end
    local fileName = ICON_OVERRIDES[key] or key
    return ('./skill/img/job/%s.png'):format(fileName)
end

-- ✅ فیکس شد: عکس جاب‌های پایه (police, taxi, mechanic, ...) تو پوشه‌ی شما
-- همه با حروف کوچیک ذخیره شدن (police.png نه Police.png)، ولی اسم جاب از ESX
-- ممکنه با حروف دیگه بیاد. برای همین برای جاب پایه حروف رو کوچیک می‌کنیم؛
-- برای دیویژن (jobIconPath معمولی) دست‌نخورده می‌مونه چون فایل‌هاش حساس به
-- حروف بزرگ/کوچیکن (K9.png, SWAT-Command.png, ...).
local function baseJobIconPath(jobName)
    if not jobName or jobName == '' then return jobIconPath('nojob') end
    local lowerName = string.lower(jobName)
    local fileName = ICON_OVERRIDES[jobName] or ICON_OVERRIDES[lowerName] or lowerName
    return ('./skill/img/job/%s.png'):format(fileName)
end

-- ============================================================
-- UTILS
-- ============================================================

local function decodeOrNil(v)
    if not v or v == '' then return nil end
    local ok, res = pcall(json.decode, v)
    if ok then return res end
    return nil
end

-- ✅ فیکس باگ: قبلاً `skillsData = DEFAULT_SKILLS_OBJ` مستقیم رفرنس جدول پیش‌فرض
-- رو می‌ذاشت، و خط‌های بعدی روش می‌نوشتن (`skillsData.achievements = ...`)،
-- یعنی داشتیم خودِ جدول DEFAULT_SKILLS_OBJ مشترک بین همه‌ی پلیرها رو دستکاری
-- می‌کردیم! این باعث رفتار عجیب/خطا در فراخوانی‌های همزمان می‌شد. الان هر بار
-- یه کپی مستقل ازش می‌سازیم.
local function deepCopy(v)
    if type(v) ~= 'table' then return v end
    local out = {}
    for k, val in pairs(v) do out[k] = deepCopy(val) end
    return out
end

local function encodeSafe(v)
    local ok, res = pcall(json.encode, v)
    if ok then return res end
    return '{}'
end

local function formatPlaytimeFromMinutes(minutes)
    minutes = tonumber(minutes) or 0
    if minutes < 0 then minutes = 0 end
    local d = math.floor(minutes / 1440)
    local h = math.floor((minutes % 1440) / 60)
    local m = math.floor(minutes % 60)
    return string.format("%dD : %02dH : %02dM", d, h, m)
end

local function ensureColumn(tableName, columnName, columnDef)
    local exists = MySQL.single.await([[
        SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = ? LIMIT 1
    ]], { tableName, columnName })

    if not exists then
        MySQL.query.await(('ALTER TABLE `%s` ADD COLUMN `%s` %s'):format(tableName, columnName, columnDef))
    end
end

-- ✅ ساخت ستون‌های token/coin دیگه اینجا نیست — به سیستم Migration مرکزی
-- منتقل شد (modules/bridge/server/migrations.lua).
-- توجه: ستون `divisions` طبق دیتابیس واقعی شما از قبل روی users هست، ساخته نمیشه

-- ============================================================
-- DEFAULT DATA (فقط برای بار اول که بازیکن هنوز رکورد skills نداره)
-- ============================================================

local DEFAULT_ACHIEVEMENTS = Config.DefaultAchievements

local DEFAULT_SKILLS = Config.DefaultSkills

local DEFAULT_SKILLS_OBJ = { achievements = DEFAULT_ACHIEVEMENTS, skills = DEFAULT_SKILLS }

-- ============================================================
-- MIGRATION: نسخه‌ی قبلی (Unique_Skills) با اسم فیلدهای متفاوت ذخیره می‌کرد
-- ============================================================
-- ✅ فیکس باگ "undefined / 1": اگه بازیکن قبلاً با ریسورس قبلی بازی کرده باشه،
-- ستون `skills` توش JSON‌ای با فیلدهای current/title/reward داره، نه
-- count/label/point که ماژول Unique_Ui انتظار داره. این تابع هر دو فرمت رو
-- می‌فهمه و همیشه خروجی رو با فیلدهای درست برمی‌گردونه.

local function normalizeAchievements(list)
    if type(list) ~= 'table' then return DEFAULT_ACHIEVEMENTS end
    local out = {}
    for _, item in ipairs(list) do
        table.insert(out, {
            count = item.count ~= nil and item.count or (item.current ~= nil and item.current or 0),
            max = item.max or 1,
            label = item.label or item.title or "Achievement",
            point = item.point ~= nil and item.point or (item.reward ~= nil and item.reward or 0),
            description = item.description,
            finishedDate = item.finishedDate,
        })
    end
    return out
end

-- ============================================================
-- ✅ فیکس مهم: merge با لیست پیش‌فرض جدید
-- ============================================================
-- قبلاً اگه پلیر از قبل یه رکورد achievements ذخیره‌شده تو دیتابیس داشت (حتی
-- قدیمی، با لیست کوچیک‌تر)، هروقت به DEFAULT_ACHIEVEMENTS اچیومنت جدید اضافه
-- می‌کردم، پلیرهای قدیمی هیچ‌وقت اونا رو نمی‌دیدن (چون کد فقط لیست ذخیره‌شده‌ی
-- قبلی رو می‌خوند، نه پیش‌فرض جدید). الان هر اچیومنتی که تو DEFAULT هست ولی تو
-- دیتای ذخیره‌شده‌ی پلیر نیست، اضافه میشه؛ پیشرفت اچیومنت‌های موجود دست‌نخورده می‌مونه.
local function mergeAchievements(existing)
    local existingByLabel = {}
    for _, item in ipairs(existing or {}) do
        existingByLabel[item.label] = item
    end

    local merged = {}
    for _, def in ipairs(DEFAULT_ACHIEVEMENTS) do
        local found = existingByLabel[def.label]
        if found then
            table.insert(merged, found) -- پیشرفت قبلی حفظ میشه
        else
            table.insert(merged, { count = 0, max = def.max, label = def.label, point = def.point })
        end
    end
    return merged
end

local function mergeSkills(existing)
    local existingByName = {}
    for _, item in ipairs(existing or {}) do
        existingByName[item.name] = item
    end

    local merged = {}
    for _, def in ipairs(DEFAULT_SKILLS) do
        local found = existingByName[def.name]
        if found then
            table.insert(merged, found)
        else
            table.insert(merged, { percent = 0, name = def.name, color = def.color })
        end
    end
    return merged
end
local function normalizeSkills(list)
    if type(list) ~= 'table' then return DEFAULT_SKILLS end
    local out = {}
    for _, item in ipairs(list) do
        local percent = item.percent
        if percent == nil then
            local current = tonumber(item.current) or 0
            local max = tonumber(item.max) or 1
            percent = (max > 0) and (current / max * 100) or 0
        end
        table.insert(out, {
            percent = percent,
            name = item.name or item.label or item.title or "Skill",
            color = item.color or {"#9cfcf8"},
        })
    end
    return out
end

local function getDiscordId(source)
    if not source or source <= 0 then return nil end
    for _, id in ipairs(GetPlayerIdentifiers(source) or {}) do
        local discordId = string.match(id, "^discord:(%d+)$")
        if discordId then return discordId end
    end
    return nil
end

local function fetchDiscordAvatar(discordId)
    if not discordId or DISCORD_BOT_TOKEN == "" then return nil end
    local p = promise.new()
    PerformHttpRequest('https://discord.com/api/v10/users/' .. discordId, function(errCode, resultData)
        if errCode == 200 and resultData then
            local ok, data = pcall(json.decode, resultData)
            if ok and data and data.avatar then
                local ext = (string.sub(data.avatar, 1, 2) == "a_") and "gif" or "png"
                p:resolve(("https://cdn.discordapp.com/avatars/%s/%s.%s"):format(discordId, data.avatar, ext))
                return
            end
        end
        p:resolve(nil)
    end, 'GET', '', { ['Authorization'] = 'Bot ' .. DISCORD_BOT_TOKEN })
    return Citizen.Await(p)
end

local function resolveProfilePic(source, identifier, currentPic)
    if currentPic and currentPic ~= '' and currentPic ~= 'nil' and currentPic ~= 'null' then
        return currentPic
    end
    local avatarUrl = fetchDiscordAvatar(getDiscordId(source))
    if avatarUrl then
        MySQL.update.await('UPDATE users SET Profile_Pic = ? WHERE identifier = ?', { avatarUrl, identifier })
        return avatarUrl
    end
    return './skill/img/no_photo.png' -- عکس دیفالت پروفایل (همونی که خودتون فرستادید)
end

-- ============================================================
-- DIVISION HELPERS (✅ فرمت دقیق و تأییدشده از خودِ esx_society شما)
-- ============================================================
-- تو server/main.lua واقعیِ esx_society دیدم که users.divisions یه آرایه‌ی
-- JSON از این شکله: { label=..., status=true/false, job=..., name=... }
-- هر پلیر می‌تونه چندتا دیویژن (حتی برای جاب‌های مختلف) داشته باشه، ولی فقط
-- یکی‌شون برای جاب فعلیش status=true داره (یعنی دیویژن فعال/انتخاب‌شده‌ست).
-- دیگه نیازی به حدس زدن فرمت نبود - این دقیقاً همون چیزیه که esx_society
-- خودتون می‌نویسه و می‌خونه.

local function getDivisionInfo(jobName, divisionsRaw)
    if not divisionsRaw or divisionsRaw == '' then return nil end

    local ok, divisions = pcall(json.decode, divisionsRaw)
    if not ok or type(divisions) ~= 'table' then return nil end

    for _, div in ipairs(divisions) do
        if type(div) == 'table' and div.job == jobName and div.status == true then
            local divisionKey = div.name
            local label = (div.label and div.label ~= '') and div.label or divisionKey
            return {
                key = divisionKey,
                label = label,
                icon = jobIconPath(divisionKey)
            }
        end
    end

    return nil
end

-- ============================================================
-- PETS / VEHICLES
-- ============================================================

local petsWarned = false

local function getOwnedPets(identifier)
    local ok, rows = pcall(function()
        return MySQL.query.await('SELECT * FROM owned_pets WHERE identifier = ?', { identifier })
    end)

    if not ok or not rows then
        if not petsWarned then
            petsWarned = true
            print('^1[achievements]^7 نتونستم owned_pets رو بخونم. اسم ستون‌های واقعی جدولتون رو بررسی کن (pet_model/pet_name یا اسم‌های دیگه) و تو modules/achievements/server/main.lua تابع getOwnedPets رو باهاش هماهنگ کن.')
        end
        return {}
    end

    local out = {}
    for _, r in ipairs(rows) do
        local modelRaw = r.pet_model or r.model or r.ped or r.type
        local model = modelRaw and string.lower(tostring(modelRaw)) or nil
        table.insert(out, {
            label = r.pet_name or r.name or modelRaw or "Pet",
            img = model and ('./skill/img/pets/%s.png'):format(model) or './skill/testImg.svg',
            owned = true
        })
    end
    return out
end

local vehiclesWarned = false

local function getOwnedVehicles(identifier)
    -- ✅ فیکس شد با اسکیمای واقعی جدول شما (از عکس HeidiSQL):
    -- owned_vehicles(owner, plate, vehicle, type, job, stored, WantedLevel, Profile_Pic,
    --                 engine, police, parkmeter, parkmeternum, damage, garagenum, steamowned, buyer)
    -- ستونی به اسم `model` یا `identifier` اصلاً وجود نداره؛ ماشین معمولاً تو ستون
    -- `vehicle` به‌صورت JSON ذخیره میشه (مدل داخلش هست) و `type` هم می‌تونه اسم
    -- مدل باشه. چون الان جدول شما خالیه نمی‌تونم فرمت دقیق `vehicle` رو تست کنم،
    -- برای همین چند حالت رو امتحان می‌کنه.
    local ok, rows = pcall(function()
        return MySQL.query.await('SELECT * FROM owned_vehicles WHERE owner = ?', { identifier })
    end)

    if not ok or not rows then
        if not vehiclesWarned then
            vehiclesWarned = true
            print('^1[achievements]^7 نتونستم owned_vehicles رو بخونم. خطا رو تو کنسول سرور چک کن.')
        end
        return {}
    end

    local out = {}
    for _, r in ipairs(rows) do
        local modelRaw = nil

        -- حالت ۱: ستون `vehicle` یه JSON‌ه و مدل داخلش هست (مثلاً {"model":"adder",...})
        local decodedVehicle = r.vehicle and decodeOrNil(r.vehicle) or nil
        if type(decodedVehicle) == 'table' and type(decodedVehicle.model) == 'string' then
            modelRaw = decodedVehicle.model
        end

        -- حالت ۲: ستون `type` مستقیم اسم مدله
        if not modelRaw and r.type and type(r.type) == 'string' and r.type ~= '' then
            modelRaw = r.type
        end

        local model = modelRaw and string.lower(tostring(modelRaw)) or nil
        table.insert(out, {
            label = r.plate or modelRaw or "Vehicle",
            -- docs.fivem.net عکس واقعی اکثر ماشین‌های GTA رو بر اساس اسم مدل داره
            img2 = model and ('https://docs.fivem.net/vehicles/%s.webp'):format(model) or './skill/testImg.svg',
            img = './skill/testImg.svg', -- فال‌بک اگه img2 لود نشد
            owned = true
        })
    end
    return out
end

-- ============================================================
-- MAIN CALLBACK
-- ============================================================

-- ============================================================
-- ✅ ACHIEVEMENT PROGRESS ENGINE (فعال‌سازی درخواستی)
-- ============================================================
-- این تابع پیشرفت یه اچیومنت خاص رو برای یه پلیر اضافه می‌کنه، و اگه به max
-- برسه خودکار تکمیلش می‌کنه، تاریخ تکمیل رو ثبت می‌کنه، و امتیازش (point) رو
-- به ستون score اضافه می‌کنه.
--
-- ⚠️ نکته‌ی مهم: من به سیستم کوئست/جاب/رابری/کشتن خودتون دسترسی ندارم (اسم
-- ایونت‌هاشون رو نمی‌دونم)، برای همین این تابع رو به‌صورت export + event عمومی
-- گذاشتم. هرجا تو کد خودتون یه کوئست/کار تموم میشه، همین یه خط رو اضافه کنید:
--
--   TriggerEvent('achievements:addProgress', source, "10 Quest", 1)
--
-- (source = آیدی پلیر، "10 Quest" = دقیقاً همون label تو DEFAULT_ACHIEVEMENTS،
-- 1 = چقدر بهش اضافه بشه). یا از سرور یه ریسورس دیگه:
--
--   exports['Unique_Ui']:addAchievementProgress(source, "Police Master", 1)

-- ============================================================
-- ✅ وبهوک دیسکورد (برای Achievement های بزرگ/نادر)
-- ============================================================
local function sendDiscordWebhook(playerName, label, point)
    if DISCORD_WEBHOOK_URL == "" then return end
    PerformHttpRequest(DISCORD_WEBHOOK_URL, function() end, 'POST', json.encode({
        embeds = {{
            title = "🏆 Achievement Unlocked",
            description = ("**%s** اچیومنت **%s** رو کامل کرد! (+%s امتیاز)"):format(playerName, label, point),
            color = 15844367, -- طلایی
        }}
    }), { ['Content-Type'] = 'application/json' })
end

-- ✅ توست/نوتیفیکیشن لحظه‌ای (به‌جای فقط پیام چت). کلاینت خودش رندرش می‌کنه.
local function notifyClient(source, kind, title, subtitle)
    TriggerClientEvent('achievements:showToast', source, {
        kind = kind, -- 'achievement' | 'skill'
        title = title,
        subtitle = subtitle,
    })
end

local function addAchievementProgress(source, label, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    local identifier = xPlayer.identifier

    local row = MySQL.single.await('SELECT skills FROM users WHERE identifier = ? LIMIT 1', { identifier })
    local skillsData = row and decodeOrNil(row.skills) or nil
    if type(skillsData) ~= 'table' then skillsData = deepCopy(DEFAULT_SKILLS_OBJ) end
    skillsData.achievements = mergeAchievements(normalizeAchievements(skillsData.achievements or {}))
    skillsData.skills = mergeSkills(normalizeSkills(skillsData.skills or {}))

    local changed, completedNow = false, nil
    for _, item in ipairs(skillsData.achievements) do
        if item.label == label and item.count < item.max then
            item.count = math.min(item.max, item.count + (tonumber(amount) or 1))
            changed = true
            if item.count >= item.max and not item.finishedDate then
                item.finishedDate = os.date('%Y-%m-%d %H:%M')
                completedNow = item
            end
            break
        end
    end

    if not changed then return end

    MySQL.update.await('UPDATE users SET skills = ? WHERE identifier = ?', { encodeSafe(skillsData), identifier })

    if completedNow then
        MySQL.update.await('UPDATE users SET score = score + ? WHERE identifier = ?', { completedNow.point or 0, identifier })
        TriggerClientEvent('chat:addMessage', source, {
            args = { '^3[Achievement]', ('%s تکمیل شد! +%s امتیاز'):format(label, completedNow.point or 0) }
        })

        -- ✅ توست لحظه‌ای گوشه‌ی صفحه
        notifyClient(source, 'achievement', label, ('+%s امتیاز'):format(completedNow.point or 0))

        -- ✅ وبهوک دیسکورد فقط برای Achievement های بزرگ/نادر
        if (completedNow.point or 0) >= WEBHOOK_MIN_POINT then
            local playerName = GetPlayerName(source) or 'Unknown'
            local ok, err = pcall(sendDiscordWebhook, playerName, label, completedNow.point or 0)
            if not ok then print('^1[achievements]^7 خطا تو sendDiscordWebhook: ' .. tostring(err)) end
        end
    end
end

exports('addAchievementProgress', function(source, label, amount)
    local ok, err = pcall(addAchievementProgress, source, label, amount)
    if not ok then print('^1[achievements]^7 خطا تو addAchievementProgress: ' .. tostring(err)) end
end)
RegisterNetEvent('achievements:addProgress', function(label, amount)
    local ok, err = pcall(addAchievementProgress, source, label, amount)
    if not ok then print('^1[achievements]^7 خطا تو addAchievementProgress: ' .. tostring(err)) end
end)

-- ============================================================
-- ✅ SKILL PROGRESS ENGINE (برای درخواست جدید - افزایش دستی درصد Skill)
-- ============================================================
-- برخلاف ردیابی خودکار (که بر اساس زمان کارکرد تو یه جابه)، این تابع رو
-- می‌تونید از هر جای اسکریپت خودتون (مثلاً وقتی پلیس دستبند می‌زنه) صدا کنید
-- تا درصد یه Skill خاص رو مستقیم و فوری چندتا واحد بالا ببرید.
--
--   exports['Unique_Ui']:addSkillProgress(source, "Police", 0.5)
--
-- (source = آیدی پلیر، "Police" = دقیقاً همون name تو DEFAULT_SKILLS،
-- 0.5 = چند درصد اضافه بشه - بین 0 تا 100 محدود میشه)
-- ✅ وقتی یه Skill برای اولین بار به 100% می‌رسه، پاداشش رو میده (فقط یه‌بار،
-- با فلگ maxRewarded که رو خودِ آیتم ذخیره میشه که دوباره تکرار نشه).
local function applySkillMaxRewardIfNeeded(source, identifier, item)
    if (tonumber(item.percent) or 0) < 100 or item.maxRewarded then return end
    item.maxRewarded = true

    local reward = SKILL_MAX_REWARDS[item.name]
    if reward and reward.coin then
        MySQL.update.await('UPDATE users SET coin = coin + ? WHERE identifier = ?', { reward.coin, identifier })
        notifyClient(source, 'skill', item.name .. ' 100%', ('+%s سکه'):format(reward.coin))
    else
        notifyClient(source, 'skill', item.name .. ' 100%', 'به حداکثر رسید!')
    end

    TriggerClientEvent('chat:addMessage', source, {
        args = { '^3[Skill]', ('%s به ۱۰۰٪ رسید!'):format(item.name) }
    })
end

local function addSkillProgress(source, skillName, percentAmount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    local identifier = xPlayer.identifier

    local row = MySQL.single.await('SELECT skills FROM users WHERE identifier = ? LIMIT 1', { identifier })
    local skillsData = row and decodeOrNil(row.skills) or nil
    if type(skillsData) ~= 'table' then skillsData = deepCopy(DEFAULT_SKILLS_OBJ) end
    skillsData.achievements = mergeAchievements(normalizeAchievements(skillsData.achievements or {}))
    skillsData.skills = mergeSkills(normalizeSkills(skillsData.skills or {}))

    local changed = false
    for _, item in ipairs(skillsData.skills) do
        if item.name == skillName then
            local newPercent = (tonumber(item.percent) or 0) + (tonumber(percentAmount) or 0)
            item.percent = math.max(0, math.min(100, newPercent))
            changed = true
            applySkillMaxRewardIfNeeded(source, identifier, item)
            break
        end
    end

    if not changed then return end
    MySQL.update.await('UPDATE users SET skills = ? WHERE identifier = ?', { encodeSafe(skillsData), identifier })
end

exports('addSkillProgress', function(source, skillName, percentAmount)
    local ok, err = pcall(addSkillProgress, source, skillName, percentAmount)
    if not ok then print('^1[achievements]^7 خطا تو addSkillProgress: ' .. tostring(err)) end
end)
RegisterNetEvent('achievements:addSkillProgress', function(skillName, percentAmount)
    local ok, err = pcall(addSkillProgress, source, skillName, percentAmount)
    if not ok then print('^1[achievements]^7 خطا تو addSkillProgress: ' .. tostring(err)) end
end)

-- ============================================================
-- ✅ خودکارِ کاملاً آماده: "+1 Players" / "+100 Players"
-- ============================================================
-- بر اساس تعداد واقعی اکانت‌های ثبت‌شده تو دیتابیس محاسبه میشه؛ نیازی به هیچ
-- هوکی نداره. هر بار پروفایل یه پلیر لود میشه، همگام میشه.
local function syncPlayerCountAchievements(source)
    local totalRow = MySQL.single.await('SELECT COUNT(*) as c FROM users', {})
    local totalPlayers = (totalRow and totalRow.c) or 0
    if totalPlayers >= 1 then addAchievementProgress(source, "+1 Players", 999999) end
    if totalPlayers >= 100 then addAchievementProgress(source, "+100 Players", 999999) end
end

-- ============================================================
-- ✅ خودکارِ کاملاً آماده: درصد Skill بر اساس ساعت کار واقعی
-- ============================================================
CreateThread(function()
    while true do
        Wait(60000) -- هر ۱ دقیقه
        for _, playerId in ipairs(GetPlayers()) do
            local source = tonumber(playerId)
            local ok, err = pcall(function()
                local xPlayer = ESX.GetPlayerFromId(source)
                if xPlayer and xPlayer.job and xPlayer.job.name and xPlayer.job.name ~= '' and xPlayer.job.name ~= 'unemployed' then
                    local skillName = JOB_SKILL_MAP[string.lower(xPlayer.job.name)]
                    if skillName then
                        local identifier = xPlayer.identifier
                        local row = MySQL.single.await('SELECT skills FROM users WHERE identifier = ? LIMIT 1', { identifier })
                        local skillsData = row and decodeOrNil(row.skills) or nil
                        if type(skillsData) ~= 'table' then skillsData = deepCopy(DEFAULT_SKILLS_OBJ) end
                        skillsData.achievements = mergeAchievements(normalizeAchievements(skillsData.achievements or {}))
                        skillsData.skills = mergeSkills(normalizeSkills(skillsData.skills or {}))

                        for _, item in ipairs(skillsData.skills) do
                            if item.name == skillName then
                                item.minutes = (item.minutes or 0) + 1
                                item.percent = math.min(100, (item.minutes / SKILL_TARGET_MINUTES) * 100)
                                applySkillMaxRewardIfNeeded(source, identifier, item)
                                break
                            end
                        end

                        MySQL.update.await('UPDATE users SET skills = ? WHERE identifier = ?', { encodeSafe(skillsData), identifier })
                    end
                end
            end)
            if not ok then
                print('^1[achievements]^7 خطا تو ردیابی skill برای پلیر ' .. tostring(source) .. ': ' .. tostring(err))
            end
        end
    end
end)


ESX.RegisterServerCallback('achievements:getProfile', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb(nil) end

    local identifier = xPlayer.identifier
    if not identifier then return cb(nil) end

    -- ✅ محافظت‌شده با pcall: اگه تو محاسبه‌ی +1/+100 Players هر مشکلی پیش بیاد،
    -- کل منو کرش نمی‌کنه و پروفایل عادی لود میشه.
    local syncOk, syncErr = pcall(syncPlayerCountAchievements, source)
    if not syncOk then
        print('^1[achievements]^7 خطا تو syncPlayerCountAchievements: ' .. tostring(syncErr))
    end

    local row = MySQL.single.await([[
        SELECT money, coin, token, xp, rank, timePlay, gang, gang_grade, job, job_grade, skills, score, playerName, Profile_Pic, divisions
        FROM users WHERE identifier = ? LIMIT 1
    ]], { identifier })

    local jobName  = (xPlayer.job and xPlayer.job.name) or (row and row.job) or ""
    local jobLabel = (xPlayer.job and (xPlayer.job.label or xPlayer.job.name)) or (row and row.job) or "NoJob"
    local jobGrade = (xPlayer.job and (xPlayer.job.grade_label or tostring(xPlayer.job.grade))) or (row and tostring(row.job_grade)) or "0"

    local gangName  = (row and row.gang) or "nogang"
    local gangGrade = (row and row.gang_grade) or 0
    local hasGang   = gangName ~= '' and gangName:lower() ~= 'nogang' and gangName:lower() ~= 'none'

    local division = nil
    if jobName ~= '' and jobName ~= 'unemployed' then
        division = getDivisionInfo(jobName, row and row.divisions)
    end

    local jobText = ('%s (%s)'):format(jobLabel, jobGrade)
    if division then jobText = jobText .. ' - ' .. division.label end

    local playerName = (row and row.playerName and row.playerName ~= '') and row.playerName or GetPlayerName(source)
    local profilePic = resolveProfilePic(source, identifier, row and row.Profile_Pic)

    local skillsData = row and decodeOrNil(row.skills) or nil
    if not skillsData or type(skillsData) ~= 'table' then
        skillsData = deepCopy(DEFAULT_SKILLS_OBJ)
        MySQL.update.await('UPDATE users SET skills = ? WHERE identifier = ?', { encodeSafe(skillsData), identifier })
    else
        -- ✅ فیکس شد: قبلاً اگه skillsData از قبل جدول بود، فیلدهای قدیمی
        -- (current/title/reward, یا کلیدهای skill/weapon به‌جای skills) رو
        -- دست‌نخورده می‌فرستاد که باعث "undefined / X" تو UI می‌شد.
        local rawAchievements = skillsData.achievements or DEFAULT_ACHIEVEMENTS
        local rawSkills = skillsData.skills
        if not rawSkills then
            -- نسخه‌ی قبلی این دیتا رو زیر کلیدهای skill/weapon جدا ذخیره می‌کرد
            rawSkills = {}
            for _, v in ipairs(skillsData.skill or {}) do table.insert(rawSkills, v) end
            for _, v in ipairs(skillsData.weapon or {}) do table.insert(rawSkills, v) end
            if #rawSkills == 0 then rawSkills = DEFAULT_SKILLS end
        end
        skillsData.achievements = mergeAchievements(normalizeAchievements(rawAchievements))
        skillsData.skills = mergeSkills(normalizeSkills(rawSkills))
    end

    -- ✅ برگشت به فرمت واقعی باندل skill خودتون (نه فرمت سفارشی من).
    cb({
        profile = {
            img = profilePic,
            name = playerName,
            tc = tonumber(row and row.coin) or 0,
            level = (row and row.rank) or 1,
            xp = (row and row.xp) or 0,
            maxXp = 1000,
            timePlay = formatPlaytimeFromMinutes(row and row.timePlay or 0),
            achevePoint = (row and row.score) or 0,
            job = jobText,
            jobImg = division and division.icon or baseJobIconPath(jobName),
            gang = hasGang and ('%s (%s)'):format(gangName, gangGrade) or nil,
            gangImg = hasGang and jobIconPath('gang') or nil,
        },
        achievements = skillsData.achievements,
        skills = skillsData.skills,
        pets = getOwnedPets(identifier),
        vehicles = getOwnedVehicles(identifier),
    })
end)
