-- ============================================================
-- Unique_Hud / server / streetlabel.lua  (از sun-streetlabel ادغام شد)
-- ============================================================

local UH_ESX = nil
CreateThread(function()
    while UH_ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) UH_ESX = obj end)
        Wait(0)
    end
end)

while UH_ESX == nil do Wait(0) end
while MySQL == nil do Wait(0) end

UH_ESX.RegisterServerCallback('sun-streetlabel:getWorld', function(source, cb)
    cb(GetPlayerRoutingBucket(source) or 0)
end)

-- account_num: ستون AUTO_INCREMENT موجود تو جدول users؛ هر بار اکانت جدید
-- ساخته میشه MySQL خودش شماره‌ی بعدی رو میده، پس نیازی به migration نیست.
UH_ESX.RegisterServerCallback('sun-streetlabel:getAccountId', function(source, cb)
    local xPlayer = UH_ESX.GetPlayerFromId(source)
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

UH_ESX.RegisterServerCallback('sun-streetlabel:getServerTime', function(source, cb)
    cb(os.time())
end)
