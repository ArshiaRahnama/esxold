-- ============================================================
-- Unique_Ui — تنظیمات مرکزی پروژه
-- ============================================================
-- همه‌ی تنظیماتی که قبلاً پخش بودن تو فایل‌های مختلف (achievements،
-- streetlabel، ...) الان همه‌شون اینجان. برای نصب یا شخصی‌سازی سرورتون،
-- فقط همین یه فایل رو باز کنید.

Config = {}

-- ============================================================
-- دیسکورد
-- ============================================================
-- توکن بات دیسکورد، برای خوندن خودکار آواتار پلیر وقتی Profile_Pic خالیه.
-- اگه خالی بمونه، فقط عکس دیفالت استفاده میشه (کرش نمی‌ده).
Config.DiscordBotToken = ""

-- لینک وبهوک کانال دیسکورد (Server Settings > Integrations > Webhooks) برای
-- اعلام خودکار Achievement های بزرگ. اگه خالی بمونه، این فیچر غیرفعال میمونه.
Config.DiscordWebhookURL = ""

-- فقط Achievementهایی که point شون >= این عدد باشه به دیسکورد اعلام میشن.
Config.WebhookMinPoint = 100

-- ============================================================
-- Skill — ردیابی خودکار + پاداش
-- ============================================================
-- هر آیتم اینجا با یه اسم جاب واقعی (اسمی که تو ESX دارید، نه لیبل نمایشی)
-- مچ میشه. اگه اسم جاب سرورتون با این‌ها فرق داره، همینجا تصحیحش کن:
-- کلید = اسم واقعی جاب (xPlayer.job.name)، مقدار = اسم دقیق همون Skill
-- (باید حرف‌به‌حرف با Config.DefaultSkills یکی باشه).
Config.JobSkillMap = {
    police = "Police",
    ambulance = "Medic",
    medic = "Medic",
    taxi = "Taxi",
    mechanic = "Mechanic",
    robbery = "Robbery",
    farmer = "Farm",
    farm = "Farm",
}

-- هر چند دقیقه‌ی کار تو یه جاب، به ۱۰۰٪ می‌رسه (پیش‌فرض: ۳۰۰۰ دقیقه = ۵۰ ساعت)
Config.SkillTargetMinutes = 3000

-- وقتی یه Skill برای اولین بار به 100% برسه، این پاداش‌ها یه‌بار داده میشن.
-- اگه یه Skill تو این جدول نباشه، پاداشی نداره (فقط توست نمایش داده میشه).
Config.SkillMaxRewards = {
    Police    = { coin = 100 },
    Medic     = { coin = 100 },
    Taxi      = { coin = 50 },
    Mechanic  = { coin = 50 },
    Robbery   = { coin = 100 },
    Farm      = { coin = 50 },
    ["Job Azad"] = { coin = 50 },
}

-- ============================================================
-- آیکون جاب/دیویژن
-- ============================================================
-- فایل‌های تو ui/skill/img/job با حروف بزرگ/کوچیک دقیق ذخیره شدن (مثلاً
-- "K9.png", "swat-40.png", "D-Vest.png"). اگه اسم جاب/دیویژن تو دیتابیستون
-- دقیقاً با اسم فایل یکی نیست، اینجا override بذار:
-- ["اسم تو دیتابیس"] = "اسم دقیق فایل (بدون .png)"
Config.IconOverrides = {
    -- ["police"] = "police",
    -- ["swat"]   = "swat-40",
}

-- ============================================================
-- کیبایندها
-- ============================================================
Config.AchievementsKey = "I"     -- کلید باز کردن منوی Achievements/Skill
Config.SeatbeltKey = "L"         -- کلید بستن/باز کردن کمربند

-- ============================================================
-- لیست پیش‌فرض Achievements (فقط بار اولی که پلیر هنوز رکوردی نداره)
-- ============================================================
Config.DefaultAchievements = {
    { count = 0, max = 1,   label = "+1 Players",      point = 1 },
    { count = 0, max = 100, label = "+100 Players",    point = 50 },
    { count = 0, max = 1,   label = "Organ Services",  point = 700 },
    { count = 0, max = 1,   label = "Police Master",   point = 300 },
    { count = 0, max = 1,   label = "Farm Master",     point = 500 },
    { count = 0, max = 1,   label = "Job Azad Master", point = 300 },
    { count = 0, max = 10,  label = "10 Quest",        point = 20 },
    { count = 0, max = 100, label = "100 Quest",       point = 50 },
    { count = 0, max = 500, label = "500 Quest",       point = 100 },
}

-- ============================================================
-- لیست پیش‌فرض Skill ها
-- ============================================================
Config.DefaultSkills = {
    { percent = 0, name = "Police",    color = {"#9cfcf8"} },
    { percent = 0, name = "Medic",     color = {"#9cfcf8"} },
    { percent = 0, name = "Taxi",      color = {"#9cfcf8"} },
    { percent = 0, name = "Mechanic",  color = {"#9cfcf8"} },
    { percent = 0, name = "Robbery",   color = {"#9cfcf8"} },
    { percent = 0, name = "Farm",      color = {"#9cfcf8"} },
    { percent = 0, name = "Job Azad",  color = {"#9cfcf8"} },
}
