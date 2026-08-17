-- ============================================================
-- Unique_ClotheShop / client / main.lua
--
-- Replaces Unique_clothe + Unique_clotheshop with a single resource.
--
-- Why Unique_clothe was dropped instead of merged in as-is:
--   - Its own wear system (clothe:useClothe / clothe:setUsed) was never
--     triggered from ANYWHERE in the entire codebase (confirmed by
--     searching every .lua file) -- so it never actually equipped
--     anything a player bought.
--   - The ONLY thing that really equips clothes in-game is
--     esx_inventoryhud (client/clothe.lua + server/clothe.lua), which
--     has its own working, DB-persisted wear/pack system already
--     (tables player_worn_clothes, player_clothe_packs) using item
--     names shaped 'clothe_<type>_<drawable>_<texture>'.
--   - Unique_clotheshop was selling items shaped
--     '<type>_<m|f>_<drawable>_<texture>' instead -- a DIFFERENT name
--     format esx_inventoryhud's wear code does not recognise at all.
--     That mismatch is why bought clothes never showed up as wearable
--     in the inventory: this was the actual inventory-sync bug.
--
-- Fix: this shop now sells items using the SAME name format
-- esx_inventoryhud already expects. Buying an item just gives it via
-- xPlayer.addInventoryItem -- esx_inventoryhud picks it up immediately
-- (it reads xPlayer's real inventory), and its own "wear" button in the
-- inventory UI equips/persists it. No second wear system needed.
-- ============================================================

local ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
end)

-- ============================================================
-- Live clothing catalog, built once from the game's own ped-variation
-- natives (both freemode models) -- always accurate to whatever's
-- actually installed (base game + any clothing DLC/mod), no external
-- dependency, no hardcoded item count that can go stale.
-- ============================================================
local catalogReady = false
-- Catalog[type][sex] = { {drawable=d, texture=t, name='clothe_type_d_t', label=...}, ... }
local Catalog = {}

local function buildCatalog()
    for t in pairs(Config.ComponentSlot) do Catalog[t] = { [0] = {}, [1] = {} } end
    for t in pairs(Config.PropSlot) do Catalog[t] = { [0] = {}, [1] = {} } end

    local pedModels = { [0] = `mp_m_freemode_01`, [1] = `mp_f_freemode_01` }

    for sex = 0, 1 do
        local hash = pedModels[sex]
        RequestModel(hash)
        local timeout = GetGameTimer() + 3000
        while not HasModelLoaded(hash) and GetGameTimer() < timeout do Wait(0) end
        if HasModelLoaded(hash) then
            local ped = CreatePed(4, hash, 0.0, 0.0, -1000.0, 0.0, false, false)
            SetEntityVisible(ped, false, false)
            SetEntityCollision(ped, false, false)

            for clotheType, slot in pairs(Config.ComponentSlot) do
                local drawCount = GetNumberOfPedDrawableVariations(ped, slot)
                for d = 0, drawCount - 1 do
                    local texCount = GetNumberOfPedTextureVariations(ped, slot, d)
                    if texCount < 1 then texCount = 1 end
                    for tex = 0, texCount - 1 do
                        local name = ('clothe_%s_%d_%d'):format(clotheType, d, tex)
                        table.insert(Catalog[clotheType][sex], {
                            drawable = d,
                            texture = tex,
                            name = name,
                            label = ('%s #%d (%d)'):format(Config.TypeLabel[clotheType] or clotheType, d, tex),
                        })
                    end
                end
            end
            for clotheType, slot in pairs(Config.PropSlot) do
                local drawCount = GetNumberOfPedPropDrawableVariations(ped, slot)
                for d = 0, drawCount - 1 do
                    local texCount = GetNumberOfPedPropTextureVariations(ped, slot, d)
                    if texCount < 1 then texCount = 1 end
                    for tex = 0, texCount - 1 do
                        local name = ('clothe_%s_%d_%d'):format(clotheType, d, tex)
                        table.insert(Catalog[clotheType][sex], {
                            drawable = d,
                            texture = tex,
                            name = name,
                            label = ('%s #%d (%d)'):format(Config.TypeLabel[clotheType] or clotheType, d, tex),
                        })
                    end
                end
            end

            DeletePed(ped)
        end
        SetModelAsNoLongerNeeded(hash)
    end

    catalogReady = true
end

CreateThread(function()
    while ESX == nil do Wait(0) end
    buildCatalog()
end)

local function getSex()
    local p = promise.new()
    TriggerEvent('skinchanger:getSkin', function(skin)
        p:resolve(skin and skin.sex or 0)
    end)
    return Citizen.Await(p)
end

-- ============================================================
-- Zones (from config.lua) -> ox_target, one option per sub-zone.
-- Every shop group gets a blip unless explicitly marked noBlip.
-- ============================================================
CreateThread(function()
    for _, zoneGroup in ipairs(Config.Zones) do
        if not zoneGroup.noBlip then
            local blipCoords = zoneGroup.blip or (zoneGroup.zones[1] and zoneGroup.zones[1].coords)
            if blipCoords then
                local blip = AddBlipForCoord(blipCoords.x, blipCoords.y, blipCoords.z)
                SetBlipSprite(blip, zoneGroup.mask and 366 or 73)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 0.7)
                SetBlipColour(blip, 47)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString(zoneGroup.mask and 'Mask Shop' or 'Clothe Shop')
                EndTextCommandSetBlipName(blip)
            end
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
-- Shop open/close + live preview on the player's own ped
-- ============================================================
local isShopOpen = false
local currentAccess = nil
local currentType = nil
local currentPreview = nil
local previewList = {}
local originalAppearance = {}

local function getSlot(clotheType)
    if Config.ComponentSlot[clotheType] then return Config.ComponentSlot[clotheType], false end
    if Config.PropSlot[clotheType] then return Config.PropSlot[clotheType], true end
    return nil, false
end

local function snapshotAppearance()
    originalAppearance = {}
    local ped = PlayerPedId()
    for t, id in pairs(Config.ComponentSlot) do
        originalAppearance[t] = { drawable = GetPedDrawableVariation(ped, id), texture = GetPedTextureVariation(ped, id), isProp = false }
    end
    for t, id in pairs(Config.PropSlot) do
        originalAppearance[t] = { drawable = GetPedPropIndex(ped, id), texture = GetPedPropTextureIndex(ped, id), isProp = true }
    end
end

local function restoreAppearance()
    local ped = PlayerPedId()
    for t, data in pairs(originalAppearance) do
        if data.isProp then
            if data.drawable == -1 then
                ClearPedProp(ped, Config.PropSlot[t])
            else
                SetPedPropIndex(ped, Config.PropSlot[t], data.drawable, data.texture, true)
            end
        else
            SetPedComponentVariation(ped, Config.ComponentSlot[t], data.drawable, data.texture, 0)
        end
    end
end

local function applyPreview(item, clotheType)
    local ped = PlayerPedId()
    local slot, isProp = getSlot(clotheType)
    if not slot then return end
    if isProp then
        SetPedPropIndex(ped, slot, item.drawable, item.texture, true)
    else
        SetPedComponentVariation(ped, slot, item.drawable, item.texture, 0)
    end
end

function OpenShop(access, shopLabel)
    if isShopOpen then return end
    if not catalogReady then
        ESX.ShowNotification('~y~Shop dare load mishe, chand sanie sabr kon...')
        return
    end
    isShopOpen = true
    currentAccess = access
    snapshotAppearance()

    SetNuiFocus(true, true)
    SendNUIMessage({ clear = true })
    SendNUIMessage({ display = true, shopLabel = shopLabel })

    for _, clotheType in ipairs(access) do
        SendNUIMessage({
            type = 1,
            name = clotheType,
            label = Config.TypeLabel[clotheType] or clotheType,
        })
    end
end

function CloseShopClient()
    if not isShopOpen then return end
    isShopOpen = false
    SetNuiFocus(false, false)
    restoreAppearance()
    SendNUIMessage({ display = false })
    currentType, previewList, currentPreview = nil, {}, nil
end

RegisterNUICallback('focusOff', function(_, cb)
    CloseShopClient()
    cb('ok')
end)

-- type -> list of items for the player's current sex
RegisterNUICallback('getData', function(data, cb)
    local clotheType = data.name
    currentType = clotheType
    if not Catalog[clotheType] then cb({}) return end

    local sex = getSex()
    local rows = {}
    for i, item in ipairs(Catalog[clotheType][sex]) do
        rows[#rows + 1] = {
            type = clotheType,
            name = item.name,
            label = item.label,
            idx = i,
        }
    end
    cb(rows)
end)

-- single-item "colour" step, kept so the buy flow always shows one
-- preview + price card before purchase
RegisterNUICallback('getColor', function(data, cb)
    local idx = tonumber(data.num)
    local sex = getSex()
    local item = currentType and idx and Catalog[currentType][sex][idx]
    if not item then cb({}) return end

    local price = (Config.ShopPrice and Config.ShopPrice[currentType]) or Config.DefaultShopPrice or 5000
    previewList = {
        [0] = {
            type = currentType,
            name = item.name,
            drawable = item.drawable,
            texture = item.texture,
            label = item.label,
            price = price,
        },
    }
    cb(previewList)
end)

RegisterNUICallback('preview', function(data, cb)
    local item = data.data
    if not item or not item.type then cb('ok') return end
    currentPreview = item
    applyPreview(item, item.type)
    cb('ok')
end)

RegisterNUICallback('reload', function(_, cb)
    currentType = nil
    restoreAppearance()
    SendNUIMessage({ clear = true })
    for _, clotheType in ipairs(currentAccess or {}) do
        SendNUIMessage({ type = 1, name = clotheType, label = Config.TypeLabel[clotheType] or clotheType })
    end
    cb('ok')
end)

-- ============================================================
-- Purchase: server validates price + money + item shape, registers
-- the item into ESX.Items on first sale, then gives it via the
-- player's real inventory -- esx_inventoryhud picks it up and lets the
-- player equip it immediately, no extra plumbing needed here.
-- ============================================================
RegisterNUICallback('buyItem', function(_, cb)
    local item = currentPreview
    if not item then cb('ok') return end

    ESX.TriggerServerCallback('Unique_ClotheShop:buy', function(success, reason)
        if success then
            ESX.ShowNotification('Kharid movafagh: ' .. item.label)
            restoreAppearance()
        else
            ESX.ShowNotification('~r~' .. (reason or 'Khata'))
        end
    end, item.name, item.type)
    cb('ok')
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() and isShopOpen then
        CloseShopClient()
    end
end)
