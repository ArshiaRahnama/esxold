# 📖 راهنمای کامل Unique_Ui (منوی I) — از صفر تا صد

این فایل همه‌چیز رو درباره‌ی منوی Achievements/Skill/Collections (کلید `I`)
توضیح میده: چی خودکاره، چی باید دستی تریگر کنید، و چطور گسترشش بدید.

---

## فهرست
1. [باز/بستن منو](#1-بازبستن-منو)
2. [بخش Achievements](#2-بخش-achievements)
3. [بخش Skill](#3-بخش-skill)
4. [بخش Collections (Pets/Vehicles)](#4-بخش-collections)
5. [پروفایل بالای منو (جاب، دیویژن، آواتار)](#5-پروفایل-بالای-منو)
6. [اضافه‌کردن Achievement/Skill جدید](#6-اضافه‌کردن-جدید)
7. [تنظیمات اولیه که باید انجام بدید](#7-تنظیمات-اولیه)
8. [رفع اشکال سریع](#8-رفع-اشکال)

---

## 1) باز/بستن منو

- کلید پیش‌فرض: `I` (تو `modules/achievements/client/main.lua`، `RegisterKeyMapping`)
- اگه می‌خواید از یه جای دیگه (مثلاً یه دکمه‌ی تو یه منوی دیگه) بازش کنید:
```lua
exports['Unique_Ui']:openAchievements()
exports['Unique_Ui']:closeAchievements()
```
- وقتی پلیر با `ESC` می‌بندتش، ایونت زیر فایر میشه (می‌تونید هرجای دیگه گوش بدید):
```lua
AddEventHandler('ui:menuClosed', function(id)
    if id == 'skill' then
        -- منوی I بسته شد
    end
end)
```

---

## 2) بخش Achievements

### چطور کار می‌کنه
هر Achievement یه `label` (اسم)، `max` (هدف)، `point` (جایزه‌ی امتیاز) داره.
پیشرفتش (`count`) **دستی** باید تریگر بشه — خودکار نیست (چون فقط شما می‌دونید
کِی یه پلیر مثلاً یه کوئست رو تموم کرده).

### تریگر کردن پیشرفت
```lua
-- سرور-ساید (پیشنهادی):
exports['Unique_Ui']:addAchievementProgress(source, "دقیقاً همون label", 1)

-- یا از کلاینت (که خودش میره سمت سرور):
TriggerServerEvent('achievements:addProgress', "دقیقاً همون label", 1)
```
- `source` = آیدی پلیری که این کارو کرده (همیشه از خودِ ایونت بگیرید، نه از کلاینت)
- `1` = چقدر اضافه بشه (می‌تونید هر عددی بدید، مثلاً برای «۱۰۰۰ بار ضربه زدن» هر بار 1 اضافه کنید)
- وقتی `count` به `max` برسه: خودکار `point` به ستون `score` پلیر (تو جدول `users`) اضافه میشه، تاریخ تکمیل ثبت میشه، و یه پیام تو چت پلیر میاد.

### لیست کامل Achievement های فعلی
(تو `modules/achievements/server/main.lua`، جدول `DEFAULT_ACHIEVEMENTS`)

| Label | Max | Point | باید کجا تریگر بشه |
|---|---|---|---|
| `+1 Players` | 1 | 1 | خودکاره (بر اساس تعداد واقعی اکانت‌های سرور) |
| `+100 Players` | 100 | 50 | خودکاره (بر اساس تعداد واقعی اکانت‌های سرور) |
| `Organ Services` | 1 | 700 | دستی — مثلاً بعد از تحویل موفق ارگان تو اسکریپت بیمارستان |
| `Police Master` | 1 | 300 | دستی — مثلاً رسیدن به بالاترین رتبه‌ی پلیس |
| `Farm Master` | 1 | 500 | دستی — مثلاً تکمیل یه مقدار مشخص برداشت محصول |
| `Job Azad Master` | 1 | 300 | دستی — هرچی که برای شما «جاب آزاد» حساب میشه |
| `10 Quest` | 10 | 20 | دستی — هر بار یه کوئست کامل میشه صداش بزنید |
| `100 Quest` | 100 | 50 | همون، هر ۳ تا با هم صدا زده بشن مشکلی نیست (هرکدوم که به max نرسیده پیشرفت می‌کنه) |
| `500 Quest` | 500 | 100 | همون |

### مثال کامل: سیستم کوئست
```lua
-- تو سرور اسکریپت کوئست خودتون:
RegisterNetEvent('yourQuestSystem:questCompleted', function(questId)
    local source = source
    exports['Unique_Ui']:addAchievementProgress(source, "10 Quest", 1)
    exports['Unique_Ui']:addAchievementProgress(source, "100 Quest", 1)
    exports['Unique_Ui']:addAchievementProgress(source, "500 Quest", 1)
end)
```

---

## 3) بخش Skill

### دو روش پیشرفت داره:

**الف) خودکار (از قبل فعاله، کاری لازم نیست)**
هر ۱ دقیقه که پلیر با یه جاب خاص آنلاینه، درصدش بالا میره. تنظیماتش تو
`modules/achievements/server/main.lua`:
```lua
local JOB_SKILL_MAP = {
    police = "Police",
    ambulance = "Medic",
    -- اسم جاب واقعی ESX خودتون رو اینجا به اسم Skill نگاشت کنید
}
local SKILL_TARGET_MINUTES = 3000 -- چند دقیقه کار = ۱۰۰٪ (پیش‌فرض ۵۰ ساعت)
```
⚠️ اگه اسم جاب‌های سرورتون با این‌ها فرق داره، همین جدول رو ویرایش کنید.

**ب) دستی (برای اکشن‌های خاص، جدا از زمان کارکرد)**
```lua
exports['Unique_Ui']:addSkillProgress(source, "Police", 0.5)
```
مثلاً هر بار دستبند می‌زنه ۰.۵٪ اضافه بشه، نه فقط بر اساس زمان.

### مثال کامل: دستبند پلیس
```lua
RegisterNetEvent('police:handcuffPlayer', function(targetId)
    local source = source
    -- ... کد فعلی خودتون ...
    exports['Unique_Ui']:addSkillProgress(source, "Police", 0.5)
end)
```

### مثال: پزشک درمان کرده
```lua
exports['Unique_Ui']:addSkillProgress(source, "Medic", 1)
```

### مثال: تاکسی مسافر رسونده
```lua
exports['Unique_Ui']:addSkillProgress(source, "Taxi", 0.3)
```

### مثال: مکانیک تعمیر کرده
```lua
exports['Unique_Ui']:addSkillProgress(source, "Mechanic", 0.5)
```

### لیست کامل Skill های فعلی
```
Police, Medic, Taxi, Mechanic, Robbery, Farm, Job Azad
```

---

## 4) بخش Collections

**کاملاً خودکاره — هیچ تریگری لازم نداره.**

- **Pets**: مستقیم از جدول `owned_pets` (ستون‌های `identifier`, `pet_model`, `pet_name`) خونده میشه. همین که یه پت تو اون جدول ثبت بشه، خودش تو منو ظاهر میشه.
- **Vehicles**: از جدول `owned_vehicles` (ستون‌های `owner`, `plate`, `vehicle`, `type`) خونده میشه.

اگه پت/ماشین جدید تو دیتابیس اضافه کنید، همون لحظه که پلیر منو رو باز کنه می‌بینتش — نیازی به هیچ تریگری نیست.

---

## 5) پروفایل بالای منو

همه‌ی این‌ها **کاملاً خودکارن**، کاری لازم نیست:

| فیلد | از کجا میاد |
|---|---|
| اسم، سطح (Level)، XP، Coin/Token | ستون‌های `playerName`, `rank`, `xp`, `coin`, `token` جدول `users` |
| ساعت بازی (Time Play) | ستون `timePlay` |
| عکس پروفایل | ستون `Profile_Pic`؛ اگه خالی بود، خودکار از دیسکورد می‌گیره (نیاز به تنظیم توکن، بخش ۷) |
| جاب و آیکونش | از ESX + پوشه‌ی `ui/skill/img/job/` |
| دیویژن | از `esx_society` (ستون `users.divisions`) — نیازی به تریگر نیست، خودکار خونده میشه |
| گنگ | ستون‌های `gang`, `gang_grade` |
| امتیاز Achievements | ستون `score` |

---

## 6) اضافه‌کردن جدید

می‌خواید یه Achievement یا Skill جدید اضافه کنید؟

**Achievement جدید:**
تو `modules/achievements/server/main.lua`، تو جدول `DEFAULT_ACHIEVEMENTS` یه خط اضافه کنید:
```lua
{ count = 0, max = 5, label = "اسم جدید", point = 100 },
```
بعد از هرجای اسکریپتتون که می‌خواید، صداش بزنید:
```lua
exports['Unique_Ui']:addAchievementProgress(source, "اسم جدید", 1)
```

**Skill جدید:**
تو همون فایل، جدول `DEFAULT_SKILLS`:
```lua
{ percent = 0, name = "اسم جدید", color = {"#9cfcf8"} },
```

✅ برای پلیرهایی که از قبل بازی کردن هم کار می‌کنه — یه سیستم merge خودکار
داره که هرچی جدیده رو بدون از‌دست‌رفتن پیشرفت قبلی، اضافه می‌کنه.

---

## 7) تنظیمات اولیه

قبل از استفاده، این‌ها رو تو `modules/achievements/server/main.lua` چک/تنظیم کنید:

1. **`DISCORD_BOT_TOKEN`** (بالای فایل) — برای خوندن خودکار آواتار دیسکورد. اگه خالی بمونه، فقط عکس دیفالت نشون داده میشه (کرش نمی‌ده).
2. **`ICON_OVERRIDES`** — اگه اسم جاب/دیویژن تو دیتابیستون با اسم فایل عکسش تو `ui/skill/img/job/` یکی نیست، اینجا map کنید.
3. **`JOB_SKILL_MAP`** — اسم جاب واقعی ESX رو به اسم Skill نگاشت کنید (بخش ۳).
4. **کلید `I`** — اگه با یه ریسورس دیگه تداخل داشت، تو `modules/achievements/client/main.lua` عوضش کنید یا از تنظیمات کیبایند بازی خودتون یکیشونو دستی تغییر بدید.

---

## 8) رفع اشکال

- **منو باز نمیشه**: مطمئن شید `esx_society` و `oxmysql` هردو نصب و روشنن (تو `fxmanifest.lua` به‌عنوان dependency ثبت شدن).
- **عکس پروفایل/آیکون جاب خراب**: مسیرهاش نسبت به `ui/index.html` حساب میشن؛ اگه فایل عکس رو جابه‌جا کردید، مسیرش تو کد هم باید عوض بشه.
- **Achievement/Skill پیشرفت نمی‌کنه**: مطمئن شید `label`/`name` که تو export می‌فرستید **دقیقاً حرف‌به‌حرف** (بزرگی/کوچکی حروف هم مهمه) با چیزی که تو جدول تعریف کردید یکیه.
- **خطای کنسول با پیشوند `[achievements]`**: این‌ها همه‌شون محافظت‌شده‌ن (pcall) و کرش نمی‌دن؛ فقط بخونیدشون تا بفهمید کجای اسکریپت شما اسم اشتباه فرستاده.
