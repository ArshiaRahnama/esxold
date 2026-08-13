ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


--------------  Khayat  -------------------

-- Callback برای ارسال اطلاعات آیتم‌ها (شامل تصویر)
ESX.RegisterServerCallback('getInventoryWithImagesTailor', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.inventory
    local itemsWithImages = {}

    for i=1, #inventory, 1 do
        local item = inventory[i]
        if item.count > 0 then
            -- بررسی و دریافت قیمت و تصویر از جدول تعریف شده
            local itemData = SellerConfig.itemsForSaleTailor[item.name]
            if itemData then
                table.insert(itemsWithImages, {
                    name = item.name,
                    count = item.count,
                    label = item.label,
                    price = itemData.price,
                    image = itemData.image -- مسیر تصویر
                })
            end
        end
    end

    cb(itemsWithImages)
end)

-- رویداد فروش آیتم
RegisterServerEvent('item_shop_tailor:handleSell')
AddEventHandler('item_shop_tailor:handleSell', function(itemName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Src = source

    -- بررسی اینکه آیا آیتم در لیست برای فروش است
    if SellerConfig.itemsForSaleTailor[itemName] then
        local pricePerItem = SellerConfig.itemsForSaleTailor[itemName].price
        local totalPrice = pricePerItem * amount
        local itemLabel = xPlayer.getInventoryItem(itemName).label
        
        -- بررسی اینکه آیا بازیکن مقدار کافی از آیتم دارد
        local itemCount = xPlayer.getInventoryItem(itemName).count
        if itemCount >= amount then
            -- کم کردن آیتم از موجودی بازیکن
            xPlayer.removeInventoryItem(itemName, amount)
            
            -- پرداخت پول به بازیکن
            xPlayer.addMoney(totalPrice)
            
            -- پیام موفقیت
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0}, -- رنگ پیام (قرمز)
                multiline = true,
                args = {
                    "[System]", 
                    'Shoma ^2$^2' .. totalPrice .. ' ^0Brai Froush ^1' .. amount .. '^1x ^1'.. itemLabel .. ' ^0Daryaft Kardid'
                }
            })
            TriggerClientEvent("Task_System:AddCompleteQuest", Src, tonumber(amount), tostring(itemName))
            
        else
            -- پیام عدم موجودی کافی
            TriggerClientEvent('esx:showNotification', source, "Shoma Item Kafi Brai Froush Nadarid")
        end
    else
        -- پیام اگر آیتم برای فروش موجود نباشد
        TriggerClientEvent('esx:showNotification', source, "In Item Ghabel Froush Nist")
    end
end)




--------------------    Choob Bor       ----------------------

-- Callback برای ارسال اطلاعات آیتم‌ها (شامل تصویر)
ESX.RegisterServerCallback('getInventoryWithImagesLumberjack', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.inventory
    local itemsWithImages = {}

    for i=1, #inventory, 1 do
        local item = inventory[i]
        if item.count > 0 then
            -- بررسی و دریافت قیمت و تصویر از جدول تعریف شده
            local itemData = SellerConfig.itemsForSaleLumberjack[item.name]
            if itemData then
                table.insert(itemsWithImages, {
                    name = item.name,
                    count = item.count,
                    label = item.label,
                    price = itemData.price,
                    image = itemData.image -- مسیر تصویر
                })
            end
        end
    end

    cb(itemsWithImages)
end)


RegisterServerEvent('item_shop_lumberjack:handleSell')
AddEventHandler('item_shop_lumberjack:handleSell', function(itemName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Src = source

    if SellerConfig.itemsForSaleLumberjack[itemName] then
        local pricePerItem = SellerConfig.itemsForSaleLumberjack[itemName].price
        local totalPrice = pricePerItem * amount
        local itemLabel = xPlayer.getInventoryItem(itemName).label
        

        local itemCount = xPlayer.getInventoryItem(itemName).count
        if itemCount >= amount then

            xPlayer.removeInventoryItem(itemName, amount)
            

            xPlayer.addMoney(totalPrice)
            
            -- پیام موفقیت
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0}, 
                multiline = true,
                args = {
                    "[System]", 
                    'Shoma ^2$^2' .. totalPrice .. ' ^0Brai Froush ^1' .. amount .. '^1x ^1' .. itemLabel .. ' ^0Daryaft Kardid'
                }
            })
            TriggerClientEvent("Task_System:AddCompleteQuest", Src, tonumber(amount), tostring(itemName))
            
        else
            -- پیام عدم موجودی کافی
            TriggerClientEvent('esx:showNotification', source, "Shoma Item Kafi Brai Froush Nadarid")
        end
    else
        -- پیام اگر آیتم برای فروش موجود نباشد
        TriggerClientEvent('esx:showNotification', source, "In Item Ghabel Froush Nist")
    end
end)



------------------------------------  Ghassab ----------------------

-- Callback برای ارسال اطلاعات آیتم‌ها (شامل تصویر)
ESX.RegisterServerCallback('getInventoryWithImagesSlaughterer', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.inventory
    local itemsWithImages = {}

    for i=1, #inventory, 1 do
        local item = inventory[i]
        if item.count > 0 then
            -- بررسی و دریافت قیمت و تصویر از جدول تعریف شده
            local itemData = SellerConfig.itemsForSaleSlaughterer[item.name]
            if itemData then
                table.insert(itemsWithImages, {
                    name = item.name,
                    count = item.count,
                    label = item.label,
                    price = itemData.price,
                    image = itemData.image -- مسیر تصویر
                })
            end
        end
    end

    cb(itemsWithImages)
end)

-- رویداد فروش آیتم
RegisterServerEvent('item_shop_slaughterer:handleSell')
AddEventHandler('item_shop_slaughterer:handleSell', function(itemName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Src = source

    -- بررسی اینکه آیا آیتم در لیست برای فروش است
    if SellerConfig.itemsForSaleSlaughterer[itemName] then
        local pricePerItem = SellerConfig.itemsForSaleSlaughterer[itemName].price
        local totalPrice = pricePerItem * amount
        local itemLabel = xPlayer.getInventoryItem(itemName).label  -- دریافت لیبل آیتم
        
        -- بررسی اینکه آیا بازیکن مقدار کافی از آیتم دارد
        local itemCount = xPlayer.getInventoryItem(itemName).count
        if itemCount >= amount then
            -- کم کردن آیتم از موجودی بازیکن
            xPlayer.removeInventoryItem(itemName, amount)
            
            -- پرداخت پول به بازیکن
            xPlayer.addMoney(totalPrice)
            
            -- پیام موفقیت
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0}, -- رنگ پیام (قرمز)
                multiline = true,
                args = {
                    "[System]", 
                    'Shoma ^2$^2' .. totalPrice .. ' ^0Brai Froush ^1' .. amount .. '^1x ^1' .. itemLabel .. ' ^0Daryaft Kardid'
                }
            })
            TriggerClientEvent("Task_System:AddCompleteQuest", Src, tonumber(amount), tostring(itemName))
            
        else
            -- پیام عدم موجودی کافی
            TriggerClientEvent('esx:showNotification', source, "Shoma Item Kafi Brai Froush Nadarid")
        end
    else
        -- پیام اگر آیتم برای فروش موجود نباشد
        TriggerClientEvent('esx:showNotification', source, "In Item Ghabel Froush Nist")
    end
end)



------------------------  Sherkat naft ---------------

-- Callback برای ارسال اطلاعات آیتم‌ها (شامل تصویر)
ESX.RegisterServerCallback('getInventoryWithImagesFueler', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.inventory
    local itemsWithImages = {}

    for i=1, #inventory, 1 do
        local item = inventory[i]
        if item.count > 0 then
            -- بررسی و دریافت قیمت و تصویر از جدول تعریف شده
            local itemData = SellerConfig.itemsForSaleFueler[item.name]
            if itemData then
                table.insert(itemsWithImages, {
                    name = item.name,
                    count = item.count,
                    label = item.label,
                    price = itemData.price,
                    image = itemData.image -- مسیر تصویر
                })
            end
        end
    end

    cb(itemsWithImages)
end)

-- رویداد فروش آیتم
RegisterServerEvent('item_shop_fueler:handleSell')
AddEventHandler('item_shop_fueler:handleSell', function(itemName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Src = source

    -- بررسی اینکه آیا آیتم در لیست برای فروش است
    if SellerConfig.itemsForSaleFueler[itemName] then
        local pricePerItem = SellerConfig.itemsForSaleFueler[itemName].price
        local totalPrice = pricePerItem * amount
        local itemLabel = xPlayer.getInventoryItem(itemName).label  -- دریافت لیبل آیتم
        
        -- بررسی اینکه آیا بازیکن مقدار کافی از آیتم دارد
        local itemCount = xPlayer.getInventoryItem(itemName).count
        if itemCount >= amount then
            -- کم کردن آیتم از موجودی بازیکن
            xPlayer.removeInventoryItem(itemName, amount)
            
            -- پرداخت پول به بازیکن
            xPlayer.addMoney(totalPrice)
            
            -- پیام موفقیت
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0}, -- رنگ پیام (قرمز)
                multiline = true,
                args = {
                    "[System]", 
                    'Shoma ^2$^2' .. totalPrice .. ' ^0Brai Froush ^1' .. amount .. '^1x ^1' .. itemLabel .. ' ^0Daryaft Kardid'
                }
            })
            TriggerClientEvent("Task_System:AddCompleteQuest", Src, tonumber(amount), tostring(itemName))
            
        else
            -- پیام عدم موجودی کافی
            TriggerClientEvent('esx:showNotification', source, "Shoma Item Kafi Brai Froush Nadarid")
        end
    else
        -- پیام اگر آیتم برای فروش موجود نباشد
        TriggerClientEvent('esx:showNotification', source, "In Item Ghabel Froush Nist")
    end
end)



------------------------------ Laster -------------------------

ESX.RegisterServerCallback('getInventoryWithImagesLaster', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.inventory
    local itemsWithImages = {}

    for _, item in ipairs(inventory) do
        if item.count > 0 then
            local itemData = SellerConfig.itemsForSaleLaster[item.name]
            if itemData then
                table.insert(itemsWithImages, {
                    name = item.name,
                    count = item.count,
                    label = item.label,
                    price = itemData.price,
                    image = itemData.image
                })
            end
        end
    end

    cb(itemsWithImages)
end)

RegisterServerEvent('item_shop_laster:handleSell')
AddEventHandler('item_shop_laster:handleSell', function(itemName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Src = source

    if SellerConfig.itemsForSaleLaster[itemName] then
        local pricePerItem = SellerConfig.itemsForSaleLaster[itemName].price
        local totalPrice = pricePerItem * amount
        local itemLabel = xPlayer.getInventoryItem(itemName).label
        local itemCount = xPlayer.getInventoryItem(itemName).count

        if itemCount >= amount then
            xPlayer.removeInventoryItem(itemName, amount)
            xPlayer.addInventoryItem('eskenas', totalPrice)

            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {
                    "[System]",
                    'Shoma ^2' .. totalPrice .. ' X ^0Eskenas ^0Brai Froush ^1' .. amount .. '^1x ^1' .. itemLabel .. ' ^0Daryaft Kardid'
                }
            })

            TriggerClientEvent("Task_System:AddCompleteQuest", Src, tonumber(amount), tostring(itemName))
        else
            TriggerClientEvent('esx:showNotification', source, "Shoma Item Kafi Brai Froush Nadarid")
        end
    else
        TriggerClientEvent('esx:showNotification', source, "In Item Ghabel Froush Nist")
    end
end)





------------------------ Miner ------------------------

-- Callback برای ارسال اطلاعات آیتم‌ها (شامل تصویر)
ESX.RegisterServerCallback('getInventoryWithImagesMiner', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.inventory
    local itemsWithImages = {}

    for i=1, #inventory, 1 do
        local item = inventory[i]
        if item.count > 0 then
            -- بررسی و دریافت قیمت و تصویر از جدول تعریف شده
            local itemData = SellerConfig.itemsForSaleMiner[item.name]
            if itemData then
                table.insert(itemsWithImages, {
                    name = item.name,
                    count = item.count,
                    label = item.label,
                    price = itemData.price,
                    image = itemData.image -- مسیر تصویر
                })
            end
        end
    end

    cb(itemsWithImages)
end)

-- رویداد فروش آیتم
RegisterServerEvent('item_miner:handleSell')
AddEventHandler('item_miner:handleSell', function(itemName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Src = source

    -- بررسی اینکه آیا آیتم در لیست برای فروش است
    if SellerConfig.itemsForSaleMiner[itemName] then
        local pricePerItem = SellerConfig.itemsForSaleMiner[itemName].price
        local totalPrice = pricePerItem * amount
        local itemLabel = xPlayer.getInventoryItem(itemName).label  
        
        local itemCount = xPlayer.getInventoryItem(itemName).count
        if itemCount >= amount then

            xPlayer.removeInventoryItem(itemName, amount)
            

            xPlayer.addMoney(totalPrice)
            

            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0}, 
                multiline = true,
                args = {
                    "[System]", 
                    'Shoma ^2$^2' .. totalPrice .. ' ^0Brai Froush ^1' .. amount .. '^1x ^1' .. itemLabel .. ' ^0Daryaft Kardid'
                }
            })
            TriggerClientEvent("Task_System:AddCompleteQuest", Src, tonumber(amount), tostring(itemName))
            
        else

            TriggerClientEvent('esx:showNotification', source, "Shoma Item Kafi Brai Froush Nadarid")
        end
    else
        TriggerClientEvent('esx:showNotification', source, "In Item Ghabel Froush Nist")
    end
end)



----------------------- Mahi  -------------------------



ESX.RegisterServerCallback('getInventoryWithImagesSeparated', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.inventory
    local itemsWithImages = {}

    for i=1, #inventory, 1 do
        local item = inventory[i]
        if item.count > 0 then

            local itemData = SellerConfig.itemsForSaleSeparated[item.name]
            if itemData then
                table.insert(itemsWithImages, {
                    name = item.name,
                    count = item.count,
                    label = item.label,
                    price = itemData.price,
                    image = itemData.image 
                })
            end
        end
    end

    cb(itemsWithImages)
end)


RegisterServerEvent('item_shop_separated:handleSell')
AddEventHandler('item_shop_separated:handleSell', function(itemName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Src = source


    if SellerConfig.itemsForSaleSeparated[itemName] then
        local pricePerItem = SellerConfig.itemsForSaleSeparated[itemName].price
        local totalPrice = pricePerItem * amount
        local itemLabel = xPlayer.getInventoryItem(itemName).label  
        
  
        local itemCount = xPlayer.getInventoryItem(itemName).count
        if itemCount >= amount then
 
            xPlayer.removeInventoryItem(itemName, amount)
            

            xPlayer.addMoney(totalPrice)
            
            -- پیام موفقیت
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0}, 
                multiline = true,
                args = {
                    "[System]", 
                    'Shoma ^2$^2' .. totalPrice .. ' ^0Brai Froush ^1' .. amount .. '^1x ^1' .. itemLabel .. ' ^0Daryaft Kardid'
                }
            })
            TriggerClientEvent("Task_System:AddCompleteQuest", Src, tonumber(amount), tostring(itemName))
            
        else

            TriggerClientEvent('esx:showNotification', source, "Shoma Item Kafi Brai Froush Nadarid")
        end
    else

        TriggerClientEvent('esx:showNotification', source, "In Item Ghabel Froush Nist")
    end
end)



----------------------- DrugDealer  -------------------------



ESX.RegisterServerCallback('getInventoryWithImagesdrugdealer2', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.inventory
    local itemsWithImages = {}

    for i=1, #inventory, 1 do
        local item = inventory[i]
        if item.count > 0 then

            local itemData = SellerConfig.itemsForSaleDrugdealer2[item.name]
            if itemData then
                table.insert(itemsWithImages, {
                    name = item.name,
                    count = item.count,
                    label = item.label,
                    price = itemData.price,
                    image = itemData.image 
                })
            end
        end
    end

    cb(itemsWithImages)
end)


RegisterServerEvent('item_shop_drugdealer2:handleSell')
AddEventHandler('item_shop_drugdealer2:handleSell', function(itemName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Src = source


    if SellerConfig.itemsForSaleDrugdealer2[itemName] then
        local pricePerItem = SellerConfig.itemsForSaleDrugdealer2[itemName].price
        local totalPrice = pricePerItem * amount
        local itemLabel = xPlayer.getInventoryItem(itemName).label  
        

        local itemCount = xPlayer.getInventoryItem(itemName).count
        if itemCount >= amount then

            xPlayer.removeInventoryItem(itemName, amount)
            

            xPlayer.addMoney(totalPrice)
            

            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0}, 
                multiline = true,
                args = {
                    "[System]", 
                    'Shoma ^2$^2' .. totalPrice .. ' ^0Brai Froush ^1' .. amount .. '^1x ^1' .. itemLabel .. ' ^0Daryaft Kardid'
                }
            })
            TriggerClientEvent("Task_System:AddCompleteQuest", Src, tonumber(amount), tostring(itemName))
            
        else

            TriggerClientEvent('esx:showNotification', source, "Shoma Item Kafi Brai Froush Nadarid")
        end
    else

        TriggerClientEvent('esx:showNotification', source, "In Item Ghabel Froush Nist")
    end
end)

