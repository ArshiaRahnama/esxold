local minimize, minimizeCD, isSprinting, foodHide, waterHide, vehicleHide, stressHide, staminaHide, oxygenHide = false, false, false, false, false, true, true, true, true
local stress = 0
local pauseMenu = false

-- ✅ فیکس شد: قبلاً با AddEventHandler('KeyDown:oem_3', ...) کار می‌کرد که به یه
-- ریسورس جانبی نیاز داره تا ایونت "KeyDown:X" رو فایر کنه؛ اگه اون ریسورس نصب/فعال
-- نباشه، دکمه بدون هیچ خطایی فقط کار نمی‌کنه. به‌جاش از RegisterKeyMapping استفاده
-- می‌کنیم که خودِ FiveM مدیریتش می‌کنه و به هیچی جز خودِ این ریسورس نیاز نداره.
-- کلید پیش‌فرض همون گریو/بک‌تیک (`) هست؛ از تنظیمات کیبایند بازی قابل تغییره.
local function toggleMinimizeHud()
    if minimizeCD then return end
    minimizeCD = true
    SetTimeout(500, function()
        minimizeCD = false
    end)
    minimize = not minimize

    -- ✅ طبق درخواست: فقط درصد هیل/آرمور توگل میشه، هیچ‌چیز دیگه‌ای (آب/غذا/
    -- استرس/استامینا/آکسیژن/انجین) با این دکمه مخفی/تغییر نمی‌کنه.
    sendMessage({
        id = 'hud',
        event = 'toggleDisplay3',
        key = '#healthBarIcon',
        state = minimize,
    })
    sendMessage({
        id = 'hud',
        event = 'toggleDisplay3',
        key = '#armorBarIcon',
        state = minimize,
    })
end

RegisterCommand('togglehud', toggleMinimizeHud, false)
RegisterKeyMapping('togglehud', 'نمایش درصد هیل/آرمور', 'keyboard', 'GRAVE')

CreateThread(function()
    local player = PlayerId()
    local unarmed = `WEAPON_UNARMED`
    while true do
        Wait(250)
        local ped = PlayerPedId()
        if IsPauseMenuActive() then
            if not pauseMenu and GetSelectedPedWeapon(ped) == unarmed and not LocalPlayer.state.vanish then
                pauseMenu = true
                -- ⚠️ غیرفعال شد: exports['esx_dpemote']:PlayEmote('map') روی سرور شما
                -- همیشه شکست می‌خورد ("attempt to get length of a nil value" چون
                -- DP.Emotes['map'] اونجا nil برمی‌گرده، با اینکه تو سورسی که فرستادید
                -- این کلید تعریف شده - احتمالاً نسخه‌ی فعال رو سرورتون فرق داره).
                -- pcall جلوی کرش شدنِ خودِ ریسورس Unique_Ui رو می‌گرفت، ولی FiveM جدا از
                -- pcall، خطای داخلی خودِ esx_dpemote رو مستقل چاپ می‌کنه (رفتار خودِ
                -- موتوره، قابل جلوگیری از بیرون نیست) - برای همین کل این ایموت رو
                -- غیرفعال کردم که کنسول اسپم نشه. اگه بعداً فهمیدید چرا DP.Emotes['map']
                -- روی سرورتون خالیه (مثلاً نسخه‌ی متفاوت esx_dpemote)، این خط رو باز کنید:
                -- exports['esx_dpemote']:PlayEmote('map')
            end
        elseif pauseMenu then
            pauseMenu = false
            -- ⚠️ نکته: تابع EmoteCancel داخل esx_dpemote شما export نشده (فقط
            -- PlayEmote export داره)، برای همین نمی‌تونیم از بیرون مستقیم صداش
            -- بزنیم. به‌جاش مستقیم با native انیمیشن رو پاک می‌کنیم که تصویری
            -- درست قطع بشه (حالت داخلی خودِ dpemote دست نمی‌خوره، ولی برای
            -- ایموت مپ که پراپ نداره مشکلی ایجاد نمی‌کنه).
            ClearPedTasks(ped)
            ClearPedTasksImmediately(ped)
        end
        -- ✅ فیکس شد: ESX.isVehicleDriver() تو این نسخه ESX وجود نداره (باعث SCRIPT ERROR می‌شد).
        -- به‌جاش مستقیم با نیتیوهای بازی چک می‌کنیم که پلیر داخل ماشینه و راننده‌شه یا نه.
        local inVeh = IsPedInAnyVehicle(ped, false)
        local vehicle = inVeh and GetVehiclePedIsIn(ped, false) or false
        if vehicle and GetPedInVehicleSeat(vehicle, -1) ~= ped then
            vehicle = false
        end
        if vehicle then
            if vehicleHide then
                vehicleHide = false
                sendMessage({
                    id = 'hud',
                    event = 'toggleDisplay3',
                    key = '#engine',
                    state = true,
                })
            end
        elseif not vehicleHide then
            vehicleHide = true
            sendMessage({
                id = 'hud',
                event = 'toggleDisplay3',
                key = '#engine',
                state = false,
            })
        end   
        if IsPedSprinting(ped) then
            if staminaHide then
                staminaHide = false
                toggleDisplay3('stamina', true)
            end
        elseif not staminaHide then
            staminaHide = true
            toggleDisplay3('stamina', false)
        end
        if IsPedSwimming(ped) then
            if oxygenHide then
                oxygenHide = false
                toggleDisplay3('oxygen', true)
            end
        elseif not oxygenHide then
            oxygenHide = true
            toggleDisplay3('oxygen', false)
        end
        
        local oxygen = GetPlayerUnderwaterTimeRemaining(player) * 10
        sendMessage({
            id = 'hud',
            event = 'setData',
            health = GetEntityHealth(ped),
            armor = GetPedArmour(ped),
            talking = MumbleIsPlayerTalking(player),
            engine = vehicle and GetVehicleEngineHealth(vehicle) / 10,
            stamina = GetPlayerStamina(player),
            oxygen = oxygen > 0 and oxygen or 0
        })
    end
end)

local function handleStatusUpdate(data)
    local sendData = {
        id = 'hud',
        event = 'setData',
    }
    if not minimize then
        for k, v in pairs(data) do
            if v.name == 'thirst' then
                local val = v.val / 10000
                sendData.thirst = val
                if val > 80 then
                    if not waterHide then
                        waterHide = true
                        sendMessage({
                            id = 'hud',
                            event = 'toggleDisplay3',
                            key = '#thirst',
                            state = false,
                        })
                    end
                elseif waterHide then
                    waterHide = false
                    sendMessage({
                        id = 'hud',
                        event = 'toggleDisplay3',
                        key = '#thirst',
                        state = true,
                    })
                end
            elseif v.name == 'hunger' then
                local val = v.val / 10000
                sendData.hunger = val
                if val > 80 then
                    if not foodHide then
                        foodHide = true
                        sendMessage({
                            id = 'hud',
                            event = 'toggleDisplay3',
                            key = '#hunger',
                            state = false,
                        })
                    end
                elseif foodHide then
                    foodHide = false
                    sendMessage({
                        id = 'hud',
                        event = 'toggleDisplay3',
                        key = '#hunger',
                        state = true,
                    })
                end
            end
        end
        sendMessage(sendData)
    end
end

-- ✅ فیکس شد: esx_status استاندارد این ایونت رو با پیشوند "esx_status:" می‌فرسته،
-- نه فقط "status:" — قبلاً کد فقط به "status:updateStatus" گوش می‌داد که احتمالاً
-- هیچ‌وقت از esx_status واقعی فایر نمی‌شد (برای همین آب/غذا هیچ‌وقت واقعی آپدیت
-- نمی‌شد). الان هر دو رو پوشش می‌ده تا مطمئن باشیم.
-- ✅ فیکس قطعی: با خودِ سورس واقعی esx_status شما چک کردم (client/main.lua خط ۱۳۱)،
-- اسم واقعی ایونتش "esx_customui:updateStatus"ه، نه "esx_status:updateStatus" و نه
-- "status:updateStatus" (هردو حدس‌های قبلی اشتباه بودن). این ایونت هر ۱ ثانیه
-- (Config.TickTime) به‌صورت محلی (نه از سرور) با TriggerEvent فایر میشه، برای
-- همین AddEventHandler درسته (نه RegisterNetEvent که مخصوص ایونت‌های شبکه‌ست).
-- فرمت داده هم دقیقاً با چیزی که این کد از قبل انتظار داشت match می‌کنه:
-- {name, val, percent} با Config.StatusMax=1000000 → val/10000 = درصد ۰ تا ۱۰۰.
AddEventHandler('esx_customui:updateStatus', handleStatusUpdate)

AddEventHandler('pma-voice:setTalkingMode', function(mode)
    local percent = 25
    if mode == 2 then
        percent = 50
    elseif mode == 3 then
        percent = 100
    end
    sendMessage({
        id = 'hud',
        event = 'setData',
        microphone = percent,
    })
end)

function updateIndicators(type, data)
    sendMessage({
        id = 'hud',
        event = 'setData',
        indicator = convertData(type, data),
    })
end
exports("updateIndicators", updateIndicators)

function convertData(type, data)
    local newData = {}
    for id,talking in pairs(data) do
        if talking then
            table.insert(newData, {id = id, type = type})
        end
    end
    return newData
end

AddEventHandler('stress:update', function(_stress)
    stress = _stress
    if stress >= 10 then
        if stressHide then
            stressHide = false
            toggleDisplay3('stress', true)
        end
    elseif not stressHide then
        stressHide = false
        toggleDisplay3('stress', false)
    end
    sendMessage({
        id = 'hud',
        event = 'setData',
        stress = stress,
    })
end)

function toggleDisplay3(k, v)
    sendMessage({
        id = 'hud',
        event = 'toggleDisplay3',
        key = '#'.. k,
        state = v,
    })
end