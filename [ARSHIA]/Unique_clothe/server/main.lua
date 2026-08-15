-- ============================================================
-- Unique_clothe / server / main.lua  (minimal, hand-written stand-in)
--
-- I never saw the real server/main.lua this resource shipped with on
-- the live server -- it was never uploaded, only client/main.lua and
-- fxmanifest.lua were. This is a deliberately small, conservative
-- replacement that answers every server call client/main.lua actually
-- makes (clothe:setUsed, clothe:usePack, clothe:createPack), with:
--   - no new DB tables (in-memory only, so it can't collide with or
--     duplicate whatever the real DB schema for this was)
--   - no dependency on litesql/ghmattimysql/oxmysql -- nothing here
--     touches a database at all, so it can't fail to start over a
--     missing mysql resource the way the sunset_utils bug did
--   - ownership checked server-side before trusting anything the
--     client claims to be wearing or packing
--
-- If you still have the real server/main.lua, use that instead --
-- this is a safe fallback, not a guaranteed match for whatever pack/
-- persistence design it originally had.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local usedClothe = {} -- [source] = { [itemName] = true, ... }
local packs = {}      -- [packItemName] = { [itemName] = true, ... }
local packCounter = 0

local function ownsItem(xPlayer, itemName)
    local item = xPlayer.getInventoryItem(itemName)
    return item and item.count and item.count > 0
end

-- ------------------------------------------------------------
-- Worn-clothes state. The client sends its FULL desired
-- {itemName -> true} table every time something is toggled (see
-- saveUsed() in client/main.lua) -- only entries the player actually
-- owns are accepted; the validated table is echoed back so the
-- client's usedClothe stays in sync with what the server allowed.
-- ------------------------------------------------------------
ESX.RegisterServerCallback('clothe:setUsed', function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        if cb then cb({}) end
        return
    end

    local validated = {}
    if type(data) == 'table' then
        for itemName, isUsed in pairs(data) do
            if isUsed and ownsItem(xPlayer, itemName) then
                validated[itemName] = true
            end
        end
    end
    usedClothe[source] = validated
    if cb then cb(validated) end
end)

AddEventHandler('playerDropped', function()
    usedClothe[source] = nil
end)

-- ------------------------------------------------------------
-- Packs: bundle the player's currently-worn items (sent from
-- createPack()) into one new carryable item; using that item later
-- hands the exact same items back out. Contents are kept in this
-- table only (mirrors how kif_/pack_ items are registered on the fly
-- in esx_inventoryhud/server/bag.lua rather than DB-seeded) -- if the
-- resource restarts, existing pack ITEMS still exist in players'
-- inventories, but this server losing the process means their
-- contents can no longer be looked up; each pack is one-time-use
-- (unpacked immediately), so this only matters for packs sitting
-- unopened across a restart.
-- ------------------------------------------------------------
RegisterServerEvent('clothe:createPack')
AddEventHandler('clothe:createPack', function(items, packName)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or type(items) ~= 'table' then return end

    local contents = {}
    local anyOwned = false
    for itemName, isUsed in pairs(items) do
        if isUsed and ownsItem(xPlayer, itemName) then
            contents[itemName] = true
            anyOwned = true
        end
    end
    if not anyOwned then return end

    packCounter = packCounter + 1
    local packItemName = 'clothe_pack_' .. src .. '_' .. packCounter
    local label = (packName and tostring(packName) ~= '') and tostring(packName) or 'Baste Lebas'

    TriggerEvent('esx:CreateItem', packItemName, label, -1, false, true)

    for itemName in pairs(contents) do
        xPlayer.removeInventoryItem(itemName, 1)
    end
    packs[packItemName] = contents
    xPlayer.addInventoryItem(packItemName, 1)
end)

ESX.RegisterServerCallback('clothe:usePack', function(source, cb, packItemName)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not packItemName then cb(nil) return end

    local contents = packs[packItemName]
    if not contents or not ownsItem(xPlayer, packItemName) then
        cb(nil)
        return
    end

    xPlayer.removeInventoryItem(packItemName, 1)
    for itemName in pairs(contents) do
        TriggerEvent('esx:CreateItem', itemName, itemName, -1, false, true)
        xPlayer.addInventoryItem(itemName, 1)
    end
    packs[packItemName] = nil
    cb(contents)
end)

-- ------------------------------------------------------------
-- Named outfit presets (ported from esx_eden_clotheshop's
-- saveOutfit/deleteOutfit/getPlayerDressing/getPlayerOutfit).
-- Same esx_datastore 'property' namespace, keyed by identifier, as
-- eden used -- so existing saved presets from before eden is deleted
-- are still readable here, and esx_datastore itself is unaffected by
-- removing eden (other resources use the same store). Each entry now
-- holds an {itemName -> true} table (owned items that were worn)
-- instead of a full skin snapshot.
-- ------------------------------------------------------------
RegisterServerEvent('clothe:saveOutfit')
AddEventHandler('clothe:saveOutfit', function(label, items)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or type(items) ~= 'table' then return end

    local worn = {}
    for itemName, isUsed in pairs(items) do
        if isUsed and ownsItem(xPlayer, itemName) then
            worn[itemName] = true
        end
    end

    TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
        local dressing = store.get('dressing') or {}
        table.insert(dressing, { label = label, items = worn })
        store.set('dressing', dressing)
    end)
end)

RegisterServerEvent('clothe:deleteOutfit')
AddEventHandler('clothe:deleteOutfit', function(num)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
        local dressing = store.get('dressing') or {}
        table.remove(dressing, num)
        store.set('dressing', dressing)
    end)
end)

ESX.RegisterServerCallback('clothe:getOutfits', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then cb({}) return end

    TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
        local dressing = store.get('dressing') or {}
        local labels = {}
        for _, entry in ipairs(dressing) do
            table.insert(labels, entry.label)
        end
        cb(labels)
    end)
end)

ESX.RegisterServerCallback('clothe:loadOutfit', function(source, cb, num)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then cb(nil) return end

    TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
        local dressing = store.get('dressing') or {}
        local entry = dressing[num]
        if not entry then cb(nil) return end

        -- only hand back items the player still actually owns --
        -- ownership may have changed since the preset was saved
        local valid = {}
        for itemName in pairs(entry.items or {}) do
            if ownsItem(xPlayer, itemName) then
                valid[itemName] = true
            end
        end
        cb(valid)
    end)
end)
