-- ============================================================
-- BRANDING MODULE - پیام استارتاپ تو کنسول سرور
-- ============================================================

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    CreateThread(function()
        Wait(500) -- کمی صبر تا بقیه‌ی ماژول‌ها هم لود بشن، بعد پیام بیاد آخر

        local version = LoadResourceFile(GetCurrentResourceName(), 'VERSION')
        version = version and version:gsub('%s+', '') or 'unknown'

        print('^3--------------------------------------------------^7')
        print(('^6UI System Runing Fix ^7-> ^5arshiahub.ir^7 ^0(v%s)^7'):format(version))
        print('^6★^7 This resource is Owner by ^5arshiahub.ir^7')
        print('^3--------------------------------------------------^7')
    end)
end)
