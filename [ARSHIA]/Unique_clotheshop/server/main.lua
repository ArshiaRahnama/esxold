-- ============================================================
-- Unique_ClotheShop / server / main.lua
--
-- Server-authoritative purchase only. Wearing, weight, persistence and
-- packs are ALL already handled by esx_inventoryhud (server/clothe.lua,
-- tables player_worn_clothes / player_clothe_packs) -- this resource
-- only needs to charge the player and hand over an item shaped
-- 'clothe_<type>_<drawable>_<texture>', which esx_inventoryhud already
-- recognises. That naming match is what actually keeps this shop in
-- sync with the inventory; nothing else needs to be duplicated here.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local registered = {} -- itemName -> true, avoids re-firing esx:CreateItem every purchase

local function ensureItemRegistered(itemName, clotheType)
    if registered[itemName] then return end
    local label = (Config.TypeLabel and Config.TypeLabel[clotheType]) or clotheType
    local suffix = itemName:match('_(%d+_%d+)$') or ''
    TriggerEvent('esx:CreateItem', itemName, ('%s %s'):format(label, suffix), -1, false, true)
    registered[itemName] = true
end

ESX.RegisterServerCallback('Unique_ClotheShop:buy', function(source, cb, itemName, clotheType)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then cb(false, 'No player') return end

    -- exact same item-name shape esx_inventoryhud's own wear code
    -- expects ('clothe_<type>_<drawable>_<texture>') -- reject anything
    -- else outright rather than trust the client's string blindly
    local matchedType = itemName and itemName:match('^clothe_([a-z]+)_%d+_%d+$')
    if not matchedType then
        cb(false, 'Invalid item')
        return
    end

    clotheType = clotheType or matchedType
    if clotheType ~= matchedType then
        cb(false, 'Invalid item')
        return
    end

    -- only sell types this shop is actually configured to sell
    if not (Config.ComponentSlot[clotheType] or Config.PropSlot[clotheType]) then
        cb(false, 'Invalid item')
        return
    end

    local price = (Config.ShopPrice and Config.ShopPrice[clotheType]) or Config.DefaultShopPrice or 5000
    if price < 0 then price = 0 end

    if (xPlayer.getMoney and xPlayer.getMoney() or xPlayer.money or 0) < price then
        cb(false, 'Pool kafi nadarid')
        return
    end

    ensureItemRegistered(itemName, clotheType)

    xPlayer.removeMoney(price)
    xPlayer.addInventoryItem(itemName, 1)
    cb(true)
end)
