-- ============================================================
-- Unique_clotheshop / client / main.lua
--
-- Wires the existing html/app.js UI (unmodified) to real zones from
-- config.lua and to esx_inventoryhud's 'clothe_<type>_<drawable>_<texture>'
-- inventory-item convention. Component/prop slot numbers below are the
-- exact same ones esx_inventoryhud uses (client/clothe.lua,
-- shared/config.lua Config.ClotheComponentTypes / ClothePropTypes),
-- kept duplicated here so this resource has no hard load-order
-- dependency on esx_inventoryhud starting first.
--
-- Drawable/texture counts are read live from the game via
-- GetNumberOfPedDrawableVariations / GetNumberOfPedTextureVariations
-- (and the Prop equivalents) instead of a hardcoded catalog -- there
-- was no real item/name/price catalog anywhere in the uploaded files,
-- so this is always accurate to whatever's actually installed on the
-- server (base game + any clothing DLC/mod), but labels are generic
-- ("torso #12") rather than real garment names. Swap in Config.ShopPrice
-- / real labels if/when you have that data.
-- ============================================================

local ComponentSlot = { mask = 1, arms = 3, pants = 4, bag = 5, shoes = 6, chain = 7, tshirt = 8, bproof = 9, torso = 11 }
local PropSlot = { helmet = 0, glasses = 1, ears = 2, watches = 6, bracelets = 7 }

local ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
end)

-- Real item catalog, straight from Unique_clothe's own export (getClothe2) --
-- guarantees every item we sell is one Unique_clothe actually recognizes
-- (same exact name string, same sex/drawable/texture), instead of guessing
-- a naming convention that might not match.
local function GetCatalog()
    return exports['Unique_clothe']:getClothe2()
end

local function GetPlayerSex()
    local p = promise.new()
    TriggerEvent('skinchanger:getSkin', function(skin)
        p:resolve(skin and skin.sex or 0)
    end)
    return Citizen.Await(p)
end

-- browsing state for the current getData() call, keyed by the running
-- index (num2) the UI sends back into getColor()
local browseIndex = {}

local isShopOpen = false
local currentAccess = nil     -- access list for the zone the player used
local currentType = nil       -- clothe type currently being browsed (set by getData)
local currentPreview = nil    -- item currently shown in the buy modal
local previewColors = {}      -- last getColor() result, indexed 0..n
local previewIndex = 0
local originalAppearance = {} -- ped state before opening the shop, to revert on close

local function getSlot(clotheType)
    if ComponentSlot[clotheType] then
        return ComponentSlot[clotheType], false
    elseif PropSlot[clotheType] then
        return PropSlot[clotheType], true
    end
    return nil, false
end

local function snapshotAppearance()
    originalAppearance = {}
    local ped = PlayerPedId()
    for t, id in pairs(ComponentSlot) do
        originalAppearance[t] = { drawable = GetPedDrawableVariation(ped, id), texture = GetPedTextureVariation(ped, id), isProp = false }
    end
    for t, id in pairs(PropSlot) do
        originalAppearance[t] = { drawable = GetPedPropIndex(ped, id), texture = GetPedPropTextureIndex(ped, id), isProp = true }
    end
end

local function restoreAppearance()
    local ped = PlayerPedId()
    for t, data in pairs(originalAppearance) do
        if data.isProp then
            if data.drawable == -1 then
                ClearPedProp(ped, PropSlot[t])
            else
                SetPedPropIndex(ped, PropSlot[t], data.drawable, data.texture, true)
            end
        else
            SetPedComponentVariation(ped, ComponentSlot[t], data.drawable, data.texture, 0)
        end
    end
end

-- ============================================================
-- Zones (from config.lua) -> ox_target, one option per sub-zone,
-- opening the shop scoped to that sub-zone's `access` list
-- ============================================================
CreateThread(function()
    for _, zoneGroup in ipairs(Config.Zones) do
        if zoneGroup.blip then
            local blip = AddBlipForCoord(zoneGroup.blip.x, zoneGroup.blip.y, zoneGroup.blip.z)
            SetBlipSprite(blip, zoneGroup.mask and 366 or 73)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.7)
            SetBlipColour(blip, 47)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(zoneGroup.mask and 'Mask Shop' or 'Clothe Shop')
            EndTextCommandSetBlipName(blip)
        end

        for _, zone in ipairs(zoneGroup.zones) do
            exports.ox_target:addBoxZone({
                coords = zone.coords,
                size = vec3(1.5, 1.5, 2.0),
                rotation = 0,
                debug = false,
                options = {
                    {
                        label = zone.label,
                        icon = 'fa-solid fa-shirt',
                        onSelect = function()
                            OpenShop(zone.access, zone.label)
                        end,
                    },
                },
            })
        end
    end
end)

-- ============================================================
-- Shop open/close
-- ============================================================

function OpenShop(access, shopLabel)
    if isShopOpen then return end
    isShopOpen = true
    currentAccess = access
    snapshotAppearance()

    SetNuiFocus(true, true)
    SendNUIMessage({ clear = true })
    SendNUIMessage({ server = ('nui://%s/html'):format(GetCurrentResourceName()) })
    SendNUIMessage({ display = true })

    for _, clotheType in ipairs(access) do
        SendNUIMessage({
            type = 1,
            name = clotheType,
            label = clotheType,
            imglink = ('nui://%s/html/img/menu/%s.png'):format(GetCurrentResourceName(), clotheType),
        })
    end
end

function CloseShopClient()
    if not isShopOpen then return end
    isShopOpen = false
    SetNuiFocus(false, false)
    restoreAppearance()
    SendNUIMessage({ display = false })
    currentType, previewColors, previewIndex, currentPreview = nil, {}, 0, nil
end

RegisterNUICallback('focusOff', function(_, cb)
    CloseShopClient()
    cb('ok')
end)

-- ============================================================
-- Browsing: type -> real item list (from Unique_clothe's own
-- catalog) -> single-item "color" step so the existing app.js
-- flow (which always drills drawable -> color before buying)
-- keeps working without touching the UI files.
-- ============================================================

RegisterNUICallback('getData', function(data, cb)
    local clotheType = data.name
    currentType = clotheType
    browseIndex = {}

    local catalog = GetCatalog()
    local items = catalog and catalog[clotheType]
    if not items then cb({}) return end

    local sex = GetPlayerSex()
    local rows = {}
    local i = 0
    for _, item in ipairs(items) do
        if item.sex == sex then
            browseIndex[i] = item
            table.insert(rows, {
                type = clotheType,
                name = item.name,
                label = item.label,
                num2 = i,
            })
            i = i + 1
        end
    end
    cb(rows)
end)

RegisterNUICallback('getColor', function(data, cb)
    local idx = tonumber(data.num)
    local item = idx and browseIndex[idx]
    if not item then cb({}) return end

    local price = (Config.ShopPrice and Config.ShopPrice[currentType]) or Config.DefaultShopPrice or 150

    previewColors = {
        [0] = {
            type = currentType,
            name = item.name,          -- real item/inventory name, e.g. 'tshirt_m_12_5'
            drawable = item.num2[1],
            texture = item.num2[2],
            label = item.label,
            price = price,
        },
    }
    cb(previewColors)
end)

-- Live preview on the player's own ped while the buy modal is open.
-- Never saved/worn -- reverted by restoreAppearance() on close or
-- after a successful purchase (esx_inventoryhud's own wear toggle,
-- not this shop, is what actually equips a bought item).
RegisterNUICallback('preview', function(data, cb)
    local item = data.data
    if not item or not item.type then cb('ok') return end
    currentPreview = item
    previewIndex = item.texture or 0

    local ped = PlayerPedId()
    local slot, isProp = getSlot(item.type)
    if not slot then cb('ok') return end

    if isProp then
        SetPedPropIndex(ped, slot, item.drawable, item.texture, true)
    else
        SetPedComponentVariation(ped, slot, item.drawable, item.texture, 0)
    end
    cb('ok')
end)

-- key4 / key6: cycle back/forward through the current drawable's
-- texture ("color") variants while the buy modal is open
local function cyclePreview(step)
    if not currentPreview then return end
    local total = 0
    for _ in pairs(previewColors) do total = total + 1 end
    if total == 0 then return end

    previewIndex = (previewIndex + step) % total
    local item = previewColors[previewIndex]
    if not item then return end
    currentPreview = item

    local ped = PlayerPedId()
    local slot, isProp = getSlot(item.type)
    if not slot then return end
    if isProp then
        SetPedPropIndex(ped, slot, item.drawable, item.texture, true)
    else
        SetPedComponentVariation(ped, slot, item.drawable, item.texture, 0)
    end
end

RegisterNUICallback('key4', function(_, cb) cyclePreview(-1) cb('ok') end)
RegisterNUICallback('key6', function(_, cb) cyclePreview(1) cb('ok') end)

RegisterNUICallback('reload', function(_, cb)
    currentType = nil
    restoreAppearance()
    SendNUIMessage({ clear = true })
    for _, clotheType in ipairs(currentAccess or {}) do
        SendNUIMessage({
            type = 1,
            name = clotheType,
            label = clotheType,
            imglink = ('nui://%s/html/img/menu/%s.png'):format(GetCurrentResourceName(), clotheType),
        })
    end
    cb('ok')
end)

-- ============================================================
-- Purchase: server validates price + money, registers the item into
-- ESX.Items on demand (essentialmode doesn't know these items ahead
-- of time -- see server/main.lua), then gives it to the player's
-- real inventory using the exact name Unique_clothe's own catalog
-- uses, so Unique_clothe recognizes it (doesHave/wear) immediately.
-- ============================================================
RegisterNUICallback('buyItem', function(_, cb)
    local item = currentPreview
    if not item then cb('ok') return end

    local itemName = item.name -- real name from Unique_clothe's catalog, e.g. 'tshirt_m_12_5'
    ESX.TriggerServerCallback('Unique_clotheshop:buy', function(success, reason)
        if success then
            ESX.ShowNotification('Kharid Movafagh: ' .. itemName)
            restoreAppearance()
        else
            ESX.ShowNotification('~r~' .. (reason or 'Khata'))
        end
    end, itemName, item.price, item.type)
    cb('ok')
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() and isShopOpen then
        CloseShopClient()
    end
end)
