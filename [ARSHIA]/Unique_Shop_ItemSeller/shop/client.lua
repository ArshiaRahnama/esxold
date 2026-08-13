ESX = nil


Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
    end
end)


function OpenBuyMenuShops()
    local options = {}

    -- دریافت آیتم‌های موجود برای فروش
    ESX.TriggerServerCallback('getitemsForSaleShops', function(itemsForSaleShops)
        for _, item in ipairs(itemsForSaleShops) do
            -- اضافه کردن هر آیتم به لیست گزینه‌ها
            table.insert(options, {
                title = ("%s ($%s)"):format(item.label, item.price),
                description = 'Click to Buy',
                icon = item.image,
                image = item.image,
                onSelect = function()
                    -- درخواست وارد کردن مقدار خرید
                    local input = lib.inputDialog('Meghdar Baraye Kharid', {
                        {
                            type = 'number',
                            label = 'Meghdar',
                            description = 'Chand ta mikhay bekhari?',
                            min = 1,
                            required = true
                        }
                    })

                    if input and tonumber(input[1]) and tonumber(input[1]) > 0 then
                        -- ارسال درخواست خرید به سرور
                        TriggerServerEvent('shops_item:buy_shops', item.name, tonumber(input[1]), item.price)
                    else
                        lib.notify({ position = 'center-right', title = "", description = "Meghdar Na Motabar", type = 'error', duration = 5000 })
                    end
                end
            })
        end

        if #options > 0 then
            lib.registerContext({
                id = 'buy_item_shops_menu',
                title = 'Buy Item',
                options = options
            })

            -- نمایش منوی خرید
            lib.showContext('buy_item_shops_menu')
        else
            lib.notify({ position = 'center-right', title = "", description = "Item Baraye Kharid Mojod Nist", type = 'error', duration = 5000 })
        end
    end)
end


RegisterNetEvent('shops_openmenu')
AddEventHandler("shops_openmenu", function()
    OpenBuyMenuShops()
end)


Citizen.CreateThread(function()
    for k,v in pairs(ShopConfig.sellingLocationShops) do
        RequestModel(GetHashKey(v.pedname))
        while not HasModelLoaded(GetHashKey(v.pedname)) do
            Wait(500)
        end
        Ped = CreatePed(v.pedtype,  GetHashKey(v.pedname), v.x, v.y, v.z-1, v.h, false, false)
        SetEntityHeading(Ped, v.h)
        FreezeEntityPosition(Ped, true)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, true)
    end

    for k,v in pairs(ShopConfig.sellingLocationShops) do 
        exports.ox_target:addBoxZone({
            coords = vec3(v.x, v.y, v.z),
            size = vec3(1.5, 1.5, 1.5),
            rotation = 45,
            debug = drawZones,
            options = {
                {
                    name = 'Shop',
                    event = 'shops_openmenu',
                    icon = 'fa-solid fa-cart-shopping',
                    label = 'Shop',
                }
            }
        })
    end
end)



--------------  MC


function OpenBuyMenuMC()
    local options = {}

    -- دریافت آیتم‌های موجود برای فروش
    ESX.TriggerServerCallback('getitemsForSaleMC', function(itemsForSaleMC)
        for _, item in ipairs(itemsForSaleMC) do
            -- اضافه کردن هر آیتم به لیست گزینه‌ها
            table.insert(options, {
                title = ("%s ($%s)"):format(item.label, item.price),
                description = 'Click to Buy',
                icon = item.image,
                image = item.image,
                onSelect = function()
                    -- درخواست وارد کردن مقدار خرید
                    local input = lib.inputDialog('Meghdar Baraye Kharid', {
                        {
                            type = 'number',
                            label = 'Meghdar',
                            description = 'Chand ta mikhay bekhari?',
                            min = 1,
                            required = true
                        }
                    })

                    if input and tonumber(input[1]) and tonumber(input[1]) > 0 then
                        -- ارسال درخواست خرید به سرور
                        TriggerServerEvent('mc_item:buy_mc', item.name, tonumber(input[1]), item.price)
                    else
                        lib.notify({ position = 'center-right', title = "", description = "Meghdar Na Motabar", type = 'error', duration = 5000 })
                    end
                end
            })
        end

        if #options > 0 then
            lib.registerContext({
                id = 'buy_item_mc_menu',
                title = 'Buy Item',
                options = options
            })

            -- نمایش منوی خرید
            lib.showContext('buy_item_mc_menu')
        else
            lib.notify({ position = 'center-right', title = "", description = "Item Baraye Kharid Mojod Nist", type = 'error', duration = 5000 })
        end
    end)
end


RegisterNetEvent('mc_openmenu')
AddEventHandler("mc_openmenu", function()
    OpenBuyMenuMC()
end)


Citizen.CreateThread(function()
    for k,v in pairs(ShopConfig.sellingLocationMC) do
        RequestModel(GetHashKey(v.pedname))
        while not HasModelLoaded(GetHashKey(v.pedname)) do
            Wait(500)
        end
        Ped = CreatePed(v.pedtype,  GetHashKey(v.pedname), v.x, v.y, v.z-1, v.h, false, false)
        SetEntityHeading(Ped, v.h)
        FreezeEntityPosition(Ped, true)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, true)
    end

    for k,v in pairs(ShopConfig.sellingLocationMC) do 
        exports.ox_target:addBoxZone({
            coords = vec3(v.x, v.y, v.z),
            size = vec3(1.5, 1.5, 1.5),
            rotation = 45,
            debug = drawZones,
            options = {
                {
                    name = 'Mechanic Shop',
                    event = 'mc_openmenu',
                    icon = 'fa-solid fa-cart-shopping',
                    label = 'Mechanic Shop',
                }
            }
        })
    end
end)




-------------------- Narekshop attachment GunShop ------------------------

function OpenBuyMenuNarekshop()
    local options = {}

    -- دریافت آیتم‌های موجود برای فروش
    ESX.TriggerServerCallback('getitemsForSaleNarekshop', function(itemsForSaleNarekshop)
        for _, item in ipairs(itemsForSaleNarekshop) do
            -- اضافه کردن هر آیتم به لیست گزینه‌ها
            table.insert(options, {
                title = ("%s ($%s)"):format(item.label, item.price),
                description = 'Click to Buy',
                icon = item.image,
                image = item.image,
                onSelect = function()
                    -- درخواست وارد کردن مقدار خرید
                    local input = lib.inputDialog('Meghdar Baraye Kharid', {
                        {
                            type = 'number',
                            label = 'Meghdar',
                            description = 'Chand ta mikhay bekhari?',
                            min = 1,
                            required = true
                        }
                    })

                    if input and tonumber(input[1]) and tonumber(input[1]) > 0 then
                        -- ارسال درخواست خرید به سرور
                        TriggerServerEvent('narekshop_item:buy_narekshop', item.name, tonumber(input[1]), item.price)
                    else
                        lib.notify({ position = 'center-right', title = "", description = "Meghdar Na Motabar", type = 'error', duration = 5000 })
                    end
                end
            })
        end

        if #options > 0 then
            lib.registerContext({
                id = 'buy_item_narekshop_menu',
                title = 'Buy Item',
                options = options
            })

            -- نمایش منوی خرید
            lib.showContext('buy_item_narekshop_menu')
        else
            lib.notify({ position = 'center-right', title = "", description = "Item Baraye Kharid Mojod Nist", type = 'error', duration = 5000 })
        end
    end)
end

RegisterNetEvent('narekshop_openmenu')
AddEventHandler("narekshop_openmenu", function()
    OpenBuyMenuNarekshop()
end)


Citizen.CreateThread(function()
    for k,v in pairs(ShopConfig.sellingLocationNarekshop) do
        RequestModel(GetHashKey(v.pedname))
        while not HasModelLoaded(GetHashKey(v.pedname)) do
            Wait(500)
        end
        Ped = CreatePed(v.pedtype,  GetHashKey(v.pedname), v.x, v.y, v.z-1, v.h, false, false)
        SetEntityHeading(Ped, v.h)
        FreezeEntityPosition(Ped, true)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, true)
    end

    for k,v in pairs(ShopConfig.sellingLocationNarekshop) do 
        exports.ox_target:addBoxZone({
            coords = vec3(v.x, v.y, v.z),
            size = vec3(1.5, 1.5, 1.5),
            rotation = 45,
            debug = drawZones,
            options = {
                {
                    name = 'Attachment Shop',
                    event = 'narekshop_openmenu',
                    icon = 'fa-solid fa-cart-shopping',
                    label = 'Attachment Shop',
                },
                {
                    name = 'Gun Shop',
                    event = 'gunshop_openmenu',
                    icon = 'fa-solid fa-gun',
                    label = 'Gun Shop',
                }, 
            }
        })
    end
end)


function CreateShopBlip()
    for _, v in pairs(ShopConfig.sellingLocationNarekshop) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)

        SetBlipSprite (blip, 110)
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, 0.8)
        SetBlipColour (blip, 81)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Gun Shop") 
        EndTextCommandSetBlipName(blip)


        if v.displayBlip == true then
            SetBlipAlpha(blip, 255) 
        else
            SetBlipAlpha(blip, 0) 
        end
    end
end


Citizen.CreateThread(function()
    CreateShopBlip()
end)


-------------------- GunShop ------------------------


function OpenBuyMenuGunshop()
    local options = {}

    -- دریافت آیتم‌های موجود برای فروش
    ESX.TriggerServerCallback('getitemsForSaleGunshop', function(itemsForSaleGunshop)
        for _, item in ipairs(itemsForSaleGunshop) do
            -- اضافه کردن هر آیتم به لیست گزینه‌ها
            table.insert(options, {
                title = ("%s ($%s)"):format(item.label, item.price),
                description = 'Click to Buy',
                icon = item.image,
                image = item.image,
                onSelect = function()
                    -- ارسال درخواست خرید به سرور
                    TriggerServerEvent('gunshop_item:buy_gunshop', item.name, 1, item.price)
                end
            })
        end

        if #options > 0 then
            lib.registerContext({
                id = 'buy_item_gunshop_menu',
                title = 'Buy Item',
                options = options
            })

            -- نمایش منوی خرید
            lib.showContext('buy_item_gunshop_menu')
        else
            lib.notify({ position = 'center-right', title = "", description = "Item Baraye Kharid Mojod Nist", type = 'error', duration = 5000 })
        end
    end)
end

RegisterNetEvent('gunshop_openmenu')
AddEventHandler("gunshop_openmenu", function()
    OpenBuyMenuGunshop()
end)


Citizen.CreateThread(function()
    for k,v in pairs(ShopConfig.sellingLocationGunshop) do
        RequestModel(GetHashKey(v.pedname))
        while not HasModelLoaded(GetHashKey(v.pedname)) do
            Wait(500)
        end
        Ped = CreatePed(v.pedtype,  GetHashKey(v.pedname), v.x, v.y, v.z-1, v.h, false, false)
        SetEntityHeading(Ped, v.h)
        FreezeEntityPosition(Ped, true)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, true)
    end

    for k,v in pairs(ShopConfig.sellingLocationGunshop) do 
        exports.ox_target:addBoxZone({
            coords = vec3(v.x, v.y, v.z),
            size = vec3(1.5, 1.5, 1.5),
            rotation = 45,
            debug = drawZones,
            options = {
                {
                    name = 'Gun Shop',
                    event = 'gunshop_openmenu',
                    icon = 'fa-solid fa-cart-weapon',
                    label = 'Gun Shop',
                },
            }
        })
    end
end)