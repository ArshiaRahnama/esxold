-- ============================================================
-- Unique_clotheshop / server / main.lua
--
-- Server-authoritative purchase: validates the item name + price,
-- charges the player, and registers+gives the item using the EXACT
-- name Unique_clothe's own catalog generated for it
-- (<type>_<m|f>_<drawable>_<texture>, e.g. 'tshirt_m_12_5') --
-- guaranteed to match since the client pulled it straight from
-- exports['Unique_clothe']:getClothe2() rather than building it here.
--
-- essentialmode only knows items that exist in ESX.Items (loaded from
-- the DB `items` table on boot -- see [BASE]/essentialmode/server/
-- common.lua). Clothing items are generated on the fly per
-- drawable/texture combo, so they can never be pre-seeded in the DB;
-- instead this fires essentialmode's runtime 'esx:CreateItem' event
-- the first time each specific item is bought, which adds straight
-- into ESX.Items without touching the database (same pattern used
-- for kif_1..300 in esx_inventoryhud/server/bag.lua).
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local registered = {} -- itemName -> true, avoids re-firing esx:CreateItem on every purchase

local function ensureItemRegistered(itemName, clotheType)
    if registered[itemName] then return end
    local label = clotheType:sub(1, 1):upper() .. clotheType:sub(2) .. ' ' .. (itemName:match('_(%d+_%d+)$') or '')
    TriggerEvent('esx:CreateItem', itemName, label, -1, false, true)
    registered[itemName] = true
end

ESX.RegisterServerCallback('Unique_clotheshop:buy', function(source, cb, itemName, price, clotheType)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then cb(false, 'No player') return end

    -- sanity-check the shape (type_m|f_digits_digits) without trusting the
    -- client-supplied clotheType blindly for anything except the label/price lookup
    if not (itemName and itemName:match('^[a-z]+_[mf]_%d+_%d+$')) then
        cb(false, 'Invalid item')
        return
    end
    clotheType = clotheType or itemName:match('^([a-z]+)_')

    price = tonumber(price) or (Config.ShopPrice and Config.ShopPrice[clotheType]) or Config.DefaultShopPrice or 150
    if price < 0 then price = 0 end

    if (xPlayer.money or 0) < price then
        cb(false, 'Pool Kafi Nadarid')
        return
    end

    ensureItemRegistered(itemName, clotheType)

    xPlayer.removeMoney(price)
    xPlayer.addInventoryItem(itemName, 1)
    cb(true)
end)
