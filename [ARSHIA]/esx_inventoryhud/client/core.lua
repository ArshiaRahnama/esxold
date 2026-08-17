
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
while ESX == nil do
    Citizen.Wait(0)
end

local isOpen = false
local secondActive = false
local secondCallback = nil
local activeDrops = {}
local blurEnabled = true -- toggled via the NUI 'blurState' callback (Settings)
local equippedWeaponsCache = {} -- kept in sync via inventory:weaponEquipChanged, read by sortItems() to label rows

-- ------------------------------------------------------------
-- ESX helpers other modules call but which may not exist on
-- every ESX build. Each is only added if genuinely missing, so a
-- real existing implementation (if this server's ESX has one) is
-- never clobbered.
-- ------------------------------------------------------------
if not ESX.getItem then
    function ESX.getItem(name)
        if not name then return nil end
        return (ESX.Items and ESX.Items[name]) or nil
    end
end

if not ESX.getItemWeight then
    function ESX.getItemWeight(name, trunk)
        if not name then return Config.DefaultItemWeight end
        if Config.ItemWeightOverrides[name] then
            return Config.ItemWeightOverrides[name]
        end
        local item = ESX.getItem(name)
        if item then
            if trunk and item.weightTrunk then
                return item.weightTrunk
            end
            if item.weight then
                return item.weight
            end
        end
        return Config.DefaultItemWeight
    end
end

if not ESX.getWeaponWeight then
    function ESX.getWeaponWeight(name, trunk)
        if not name then return Config.DefaultWeaponWeight end
        return Config.WeaponWeights[name] or Config.DefaultWeaponWeight
    end
end

-- another non-vanilla ESX extension some modules call (modules/bag
-- uses it to ask the player for a bag name via a keyboard dialog).
-- Simple named client-side callback registry.
if not ESX.RegisterClientCallback then
    local registeredClientCallbacks = {}

    function ESX.RegisterClientCallback(name, cb)
        registeredClientCallbacks[name] = cb
    end

    function ESX.TriggerClientCallback(name, resultCb, ...)
        if registeredClientCallbacks[name] then
            registeredClientCallbacks[name](resultCb, ...)
        else
            print(('^1[esx_inventoryhud] ESX.TriggerClientCallback: no callback registered for "%s"^0'):format(name))
        end
    end
end

-- more non-vanilla ESX extensions the modules call unconditionally in
-- normal gameplay (opening trunks/bags, job wardrobe checks, etc.) --
-- found by auditing every ESX.* call across all six modules, plus
-- client/clothe.lua and client/setting.lua.
if not ESX.isDead then
    function ESX.isDead()
        return IsEntityDead(PlayerPedId())
    end
end

if not ESX.GetDistance then
    function ESX.GetDistance(coordsA, coordsB)
        return #(vector3(coordsA.x, coordsA.y, coordsA.z) - vector3(coordsB.x, coordsB.y, coordsB.z))
    end
end

-- no custom alert/dialog UI here, so this degrades gracefully to the
-- standard ESX notification (loses the timeout/type styling, but the
-- message always gets shown instead of crashing)
if not ESX.Alert then
    function ESX.Alert(header, text, timeout, alertType)
        local prefix = (header and header ~= '') and (header .. ': ') or ''
        ESX.ShowNotification(prefix .. (text or ''))
    end
end

-- maps to FiveM's own player statebag, which is the natural
-- (and replicated-to-others) equivalent of a per-player state flag
if not ESX.SetPlayerState then
    function ESX.SetPlayerState(key, value)
        LocalPlayer.state:set(key, value, true)
    end
end

-- used by client/clothe.lua; thin wrapper around the native in case
-- this ESX build doesn't already have its own accounting version
if not ESX.SetPedArmour then
    function ESX.SetPedArmour(ped, armour)
        SetPedArmour(ped, armour)
    end
end

-- ------------------------------------------------------------
-- sortItems: normalizes whatever shape a module hands us into
-- the flat slot list the NUI (ui/js/app.js) expects to render.
-- Accepts either a flat array of {name,count,...} rows, or a
-- richer {items=[], weapons=[], slots=N} structure (job/trunk).
-- ------------------------------------------------------------
function sortItems(raw, isTrunk)
    local rows = {}

    local function addItem(entry)
        local item = ESX.getItem(entry.name)
        table.insert(rows, {
            unique = entry.name,
            name = entry.name, -- the NUI's own JS reads item.name (use/throw/drag/give), not just .unique
            label = entry.label or (item and item.label) or entry.name,
            image = 'img/items/' .. entry.name .. '.png',
            count = entry.count or 1,
            weight = ESX.getItemWeight(entry.name, isTrunk),
            limit = entry.limit,
            slot = entry.slot,
            locked = entry.locked or false,
            locked2 = entry.locked2 or false,
            quality = entry.quality,
            itemdata = { description = (item and item.description) or entry.label or entry.name },
            visible = entry.visible ~= false
        })
    end

    local function addWeapon(entry)
        local isEquipped = equippedWeaponsCache[entry.name] == true
        table.insert(rows, {
            unique = entry.name,
            name = entry.name,
            label = (entry.label or entry.name) .. (isEquipped and ' [Kashide Shode]' or ''),
            image = 'img/items/' .. entry.name .. '.png', -- icons are stored uppercase (WEAPON_PISTOL.png); lowercasing broke the match
            count = 1,
            ammo = entry.ammo or 0,
            weight = ESX.getWeaponWeight(entry.name, isTrunk),
            slot = entry.slot,
            locked = entry.locked or false,
            itemdata = { description = entry.label or entry.name },
            visible = true,
            weapon = true,
            equipped = isEquipped
        })
    end

    if raw and raw.items or raw and raw.weapons then
        for _, entry in ipairs(raw.items or {}) do addItem(entry) end
        for _, entry in ipairs(raw.weapons or {}) do addWeapon(entry) end
    else
        for _, entry in ipairs(raw or {}) do
            if entry.ammo ~= nil then
                addWeapon(entry)
            else
                addItem(entry)
            end
        end
    end

    table.sort(rows, function(a, b)
        return (a.slot or 999) < (b.slot or 999)
    end)

    return rows
end

local function padInventorySlots(rows, totalSlots)
    rows = rows or {}
    totalSlots = totalSlots or 40
    while #rows < totalSlots do
        table.insert(rows, 'empty')
    end
    return rows
end

local function buildMainInventoryItems()
    local playerData = ESX.GetPlayerData()
    local items, weapons = {}, {}
    for _, entry in pairs(playerData.inventory or {}) do
        if entry.count and entry.count > 0 then
            table.insert(items, entry)
        end
    end
    for _, entry in pairs(playerData.loadout or {}) do
        table.insert(weapons, entry)
    end
    local rows = sortItems({ items = items, weapons = weapons })
    return padInventorySlots(rows, Config.MainInventorySlots or 40)
end

local function currentWeight(rows)
    local total = 0
    for _, row in ipairs(rows) do
        total = total + ((row.weight or 0) * (row.count or 1))
    end
    return total
end

-- NOTE: plain `x or default` is broken for numeric fallbacks here because
-- 0 is truthy in Lua -- `0 or 24000` evaluates to 0, not 24000. That's
-- exactly what caused maxweight to show as "0 kg" in-game: ESX briefly
-- reports maxWeight as 0 before player data has fully synced, and the
-- old `playerData.maxWeight or 24000` never caught that since 0 is
-- truthy. A real weight limit is always a positive number, so treat
-- anything <= 0 the same as unset.
local function positiveOrDefault(value, default)
    if type(value) ~= 'number' or value <= 0 then
        return default
    end
    return value
end

-- ------------------------------------------------------------
-- Main inventory (the player's own panel)
-- ------------------------------------------------------------
function openMainInventory()
    if isOpen or secondActive then return end
    isOpen = true
    local playerData = ESX.GetPlayerData()
    local mainItems = buildMainInventoryItems()

    SetNuiFocus(true, true)
    if blurEnabled then TriggerScreenblurFadeIn(0.3) end

    -- verified against the real app.js: these are three separate
    -- messages, each read as FLAT top-level fields (no nesting), not
    -- one combined payload
    SendNUIMessage({ action = 'openInventory', data = {} })
    SendNUIMessage({
        action = 'setPlayerStaticData',
        maxweight = positiveOrDefault(playerData.maxWeight, 24000),
        name = playerData.name or (playerData.firstName and (playerData.firstName .. ' ' .. playerData.lastName)) or 'Player'
    })
    SendNUIMessage({
        action = 'updatePlayerInventory',
        inventory = mainItems,
        money = playerData.money or (playerData.accounts and playerData.accounts[1] and playerData.accounts[1].money) or 0
    })
end

-- always clears NUI focus AND the native screen blur, unconditionally --
-- this is the one place that MUST leave the player in a clean state no
-- matter what was open or what state got confused beforehand.
--
-- skipNuiMessage=true is used by the 'close' NUI callback below: the
-- NUI already knows it's closing (it's the one that asked), so
-- echoing SendNUIMessage({action='close'}) back to it would trigger
-- its OWN message handler's `action=='close' -> close()` branch,
-- which POSTs /close back to Lua again, which calls this function
-- again, forever -- an infinite Lua<->NUI ping-pong, roughly one
-- round-trip (~20ms) per cycle, with no error on either side because
-- both sides are doing exactly what they're written to do. That
-- loop, once started by the first-ever close, is why every open
-- after the first one immediately flashed and closed again.
function closeInventory(skipNuiMessage)

    if secondActive and secondCallback then
        secondCallback({ type = 'close' })
    end
    isOpen = false
    secondActive = false
    secondCallback = nil
    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(0.3)
    if not skipNuiMessage then
        SendNUIMessage({ action = 'close' })
    end
end

-- safety net: if the resource restarts while the inventory was open,
-- don't leave the player's screen permanently blurred/focus-locked
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(0.1)
end)

-- F2 toggles open/close again. The earlier open-only restriction was
-- a workaround for the ping-pong bug now fixed in closeInventory()/
-- the 'close' NUI callback above -- with that fixed, F2 closing is
-- safe again (it just calls the same closeInventory(true) path ESC
-- already used).
local lastToggleAt = 0
RegisterCommand('inventory_toggle', function()
    local now = GetGameTimer()
    if now - lastToggleAt < 250 then return end -- debounce against double-fire
    lastToggleAt = now

    if isOpen or secondActive then
        closeInventory() -- Lua-initiated (F2): NUI doesn't know yet, must send the close message
    else
        openMainInventory()
    end
end, false)
RegisterKeyMapping('inventory_toggle', 'Baz/Baste Kardan Inventory', 'keyboard', Config.OpenInventoryKey)

-- keep the NUI in sync with real inventory/weapon changes. This
-- framework's ESX.SetPlayerData() is a plain assignment with no
-- event of its own (confirmed against the real client/functions.lua),
-- so 'esx:setPlayerData' never actually fires here -- these four
-- events are what genuinely change inventory/loadout on this build.
function refreshMainInventoryIfOpen()
    if not isOpen then return end
    local playerData = ESX.GetPlayerData()
    SendNUIMessage({
        action = 'updatePlayerInventory',
        inventory = buildMainInventoryItems(),
        money = playerData.money or (playerData.accounts and playerData.accounts[1] and playerData.accounts[1].money) or 0
    })
end

AddEventHandler('esx:addInventoryItem', function(item, count) refreshMainInventoryIfOpen() end)
AddEventHandler('esx:removeInventoryItem', function(item, count) refreshMainInventoryIfOpen() end)

-- ------------------------------------------------------------
-- Weapon equip toggle: only weapons the server confirms as
-- "equipped" (max Config.WeaponSlots count, server-enforced) are
-- actually given to the ped natively, so only THOSE show up in the
-- game's own weapon wheel. Everything else stays fully owned (still
-- in your inventory, still shows in the panel, just not drawable
-- until you use it again). This never touches essentialmode's own
-- addWeapon/removeWeapon -- it purely corrects the ped's actual
-- weapon set after the fact, client-side, on top of whatever
-- essentialmode already did.
-- ------------------------------------------------------------
local currentlyGiven = {} -- [weaponName] = true, mirrors what's actually on the ped right now

RegisterNetEvent('inventory:weaponEquipChanged')
AddEventHandler('inventory:weaponEquipChanged', function(equippedSet)
    local ped = PlayerPedId()
    equippedSet = equippedSet or {}

    for weaponName in pairs(currentlyGiven) do
        if not equippedSet[weaponName] then
            RemoveWeaponFromPed(ped, GetHashKey(weaponName))
            currentlyGiven[weaponName] = nil
        end
    end

    for weaponName in pairs(equippedSet) do
        if not currentlyGiven[weaponName] then
            local weapon = nil
            for _, w in ipairs((ESX.GetPlayerData() or {}).loadout or {}) do
                if w.name == weaponName then weapon = w break end
            end
            GiveWeaponToPed(ped, GetHashKey(weaponName), (weapon and weapon.ammo) or 0, false, false)
            currentlyGiven[weaponName] = true
        end
    end

    equippedWeaponsCache = equippedSet
    refreshMainInventoryIfOpen()
end)

AddEventHandler('esx:addWeapon', function(weaponName, ammo)
    refreshMainInventoryIfOpen()
    -- a freshly-acquired weapon is native-given automatically by
    -- essentialmode; immediately reconcile against the server's real
    -- equipped set so a newly picked-up weapon doesn't stay drawable
    -- unless it's actually one of the equipped slots
    ESX.TriggerServerCallback('inventory:getEquippedWeapons', function(equippedSet)
        TriggerEvent('inventory:weaponEquipChanged', equippedSet)
    end)
end)
AddEventHandler('esx:removeWeapon', function(weaponName, ammo)
    refreshMainInventoryIfOpen()
    currentlyGiven[weaponName] = nil
end)

-- on spawn/relog, correct the ped to match the server's real equipped
-- set (a freshly-spawned ped starts with no weapons regardless of what
-- was equipped before, essentialmode re-gives everything from loadout
-- on load, so this immediately strips back down to just the equipped ones)
RegisterNetEvent('inventory:core:refreshInventory')
AddEventHandler('inventory:core:refreshInventory', function()
    refreshMainInventoryIfOpen()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    ESX.TriggerServerCallback('inventory:getEquippedWeapons', function(equippedSet)
        TriggerEvent('inventory:weaponEquipChanged', equippedSet)
    end)
end)

-- client/clothe.lua's ChangeClothe callback (kept from the original
-- code) calls this exact name after equipping/unequipping something;
-- it was never actually defined anywhere, causing a NUI callback
-- crash every time a clothing item was toggled.
function loadPlayerInventory()
    refreshMainInventoryIfOpen()
end
exports('loadPlayerInventory', loadPlayerInventory) -- called by Unique_clothe after equipping/using clothes

-- ------------------------------------------------------------
-- Generic second inventory (bag / trunk / job / public / admin)
-- config: { items, timeout, maxWeight, label, type, disableExitCheck }
-- callback receives { type = 'close'|'update'|'moveInside'|'moveToOther'|'moveToMain', data = {...} }
-- ------------------------------------------------------------
function openOtherInventory(cfg, callback)
    if isOpen or secondActive then return end
    secondActive = true
    secondCallback = callback

    local playerData = ESX.GetPlayerData()
    SetNuiFocus(true, true)
    if blurEnabled then TriggerScreenblurFadeIn(0.3) end

    SendNUIMessage({
        action = 'setPlayerStaticData',
        maxweight = positiveOrDefault(playerData.maxWeight, 24000),
        name = playerData.name or 'Player'
    })
    SendNUIMessage({
        action = 'updatePlayerInventory',
        inventory = buildMainInventoryItems(),
        money = playerData.money or (playerData.accounts and playerData.accounts[1] and playerData.accounts[1].money) or 0
    })
    SendNUIMessage({
        action = 'secondOpen',
        inventory = padInventorySlots(cfg.items, Config.SecondInventorySlots or 40),
        maxWeight = positiveOrDefault(cfg.maxWeight, 24000),
        label = cfg.label or 'Inventory',
        type = cfg.type
    })
end

-- reflects a completed move back into the currently visible NUI
-- state (both modules call this after a successful moveToMain)
function moveInsideHandler(data)
    if not data then return end
    if data.inventoryType == 'main' then
        SendNUIMessage({
            action = 'updatePlayerInventory',
            mainInventory = buildMainInventoryItems()
        })
    end
end

-- online admin inventory search (modules/admin calls this indirectly
-- via inventory:admin:openInventory -> openOtherPlayerInventory)
function openOtherPlayerInventory(target, isAdmin)
    local function fetchItems()
        local p = promise.new()
        ESX.TriggerServerCallback('inventory:core:getPlayerInventory', function(data)
            if data then
                p:resolve(sortItems({ items = data.items, weapons = data.weapons }))
            else
                p:resolve({})
            end
        end, target)
        return Citizen.Await(p)
    end

    local items = fetchItems()
    openOtherInventory({ items = items, timeout = 1000, label = 'Player #' .. target }, function(evt)
        if evt.type == 'close' then
            return
        elseif evt.type == 'update' then
            return fetchItems()
        elseif evt.type == 'moveToOther' then
            TriggerServerEvent('inventory:admin:put', target, evt.data)
        elseif evt.type == 'moveToMain' then
            TriggerServerEvent('inventory:admin:get', target, evt.data)
            Citizen.Wait(500)
            if evt.data.droppedTo then
                evt.data.inventoryType = 'main'
                moveInsideHandler(evt.data)
            end
        end
    end)
end

-- NOTE: modules/admin/client/main.lua already registers
-- 'inventory:admin:openInventory' itself and calls
-- openOtherPlayerInventory(target, true) directly -- so it is NOT
-- registered again here to avoid firing it twice.

-- ------------------------------------------------------------
-- NUI callbacks (the UI -> Lua side of things)
-- ------------------------------------------------------------
-- useItem()/throwItem() are called with NO arguments in the actual
-- NUI template (@mouseup="useItem()") -- whatever item they act on
-- comes from internal Vue state we can't read (app.js is obfuscated).
-- Our own item rows use 'unique' as the identifier (matching the
-- template's :key="a.unique"), so accept either that or 'name' (or
-- a nested .item), rather than gambling on exactly one.
local function getNuiItemName(data)
    if not data then return nil end
    return data.name or data.unique
        or (data.item and (data.item.name or data.item.unique))
        or (data.draggedItem and (data.draggedItem.name or data.draggedItem.unique))
        or (data.draggedData and (data.draggedData.name or data.draggedData.unique))
        or nil
end

RegisterNUICallback('close', function(_, cb)
    closeInventory(true) -- NUI already knows it's closing; don't echo the message back
    cb('ok')
end)

RegisterNUICallback('inventory:mounted', function(_, cb)
    cb('ok')
end)

-- inventory:useItem's payload is the item name as a plain STRING
-- (JS does sendEvent('inventory:useItem', itemName), not an object) --
-- confirmed by reading html/js/app.js directly, not guessed.
local weaponNameSet = {}
CreateThread(function()
    for _, w in ipairs(ESX.GetWeaponList() or {}) do
        weaponNameSet[w.name] = true
    end
end)

RegisterNUICallback('inventory:useItem', function(data, cb)
    -- confirmed via console: JS sends a raw item-name string here, but
    -- can send [] (empty) if item.name was undefined client-side (now
    -- fixed by adding a name field alongside unique in sortItems())
    local itemName = (type(data) == 'string' and data) or getNuiItemName(data)
    if type(itemName) == 'string' then
        itemName = itemName:gsub('^"(.*)"$', '%1') -- defensive: strip stray JSON quotes if not fully decoded
    end
    if itemName then
        if weaponNameSet[itemName] then
            -- weapons aren't real inventory items in essentialmode (no
            -- ESX.Items entry, no RegisterUsableItem) -- esx:useItem
            -- would just no-op for them. "Use" on a weapon instead
            -- toggles whether it's actually drawable (max 3 at once).
            TriggerServerEvent('inventory:toggleWeaponEquip', itemName)
        else
            TriggerServerEvent('esx:useItem', itemName)
        end
    end
    cb('ok')
end)

RegisterNUICallback('inventory:throwItem', function(data, cb)
    local itemName = getNuiItemName(data)
    if itemName then
        local coords = GetEntityCoords(PlayerPedId())
        TriggerServerEvent('inventory:core:throwItem', itemName, (data and data.count) or 1, coords)
    end
    cb('ok')
end)

RegisterNUICallback('getNearbyPlayers', function(_, cb)
    local players = {}
    local myPed = PlayerPedId()
    local myCoords = GetEntityCoords(myPed)
    for _, playerId in ipairs(GetActivePlayers()) do
        if playerId ~= PlayerId() then
            local ped = GetPlayerPed(playerId)
            if DoesEntityExist(ped) and #(GetEntityCoords(ped) - myCoords) <= (Config.GiveItemMaxDistance or 3.0) then
                table.insert(players, {
                    src = GetPlayerServerId(playerId),
                    name = GetPlayerName(playerId)
                })
            end
        end
    end
    cb(players)
end)

RegisterNUICallback('inventory:giveItemToTarget', function(data, cb)
    local itemName = getNuiItemName(data)
    if data and data.targetSrc and itemName then
        if data.isWeapon then
            TriggerServerEvent('inventory:core:giveWeapon', data.targetSrc, itemName)
        else
            TriggerServerEvent('inventory:core:giveItem', data.targetSrc, itemName, data.count or 1)
        end
    end
    cb('ok')
end)

-- moveInside / moveToSecond / moveToMain / instantToMain / instantToSecond:
-- when a second inventory is active these all forward to whichever
-- module opened it; when only the main inventory is open, 'moveInside'
-- is purely a cosmetic reorder (ESX's own inventory has no slot concept)
-- so there's nothing to tell the server.
local function forwardToSecond(kind, data)
    if secondActive and secondCallback then
        local result = secondCallback({ type = kind, data = data })
        if kind == 'update' and result then
            SendNUIMessage({ action = 'updateSecondInventory', inventory = padInventorySlots(result, Config.SecondInventorySlots or 40) })
        end
    end
end

RegisterNUICallback('inventory:moveInside', function(data, cb)
    if secondActive then
        forwardToSecond('moveInside', data)
    elseif data and data.index and data.droppedTo then
        -- reordering within the main inventory itself: swap the slot
        -- numbers of whatever's currently at these two UI positions
        -- (confirmed via app.js: index/droppedTo are 1-based)
        local current = buildMainInventoryItems()
        local fromItem = current[tonumber(data.index)]
        local toItem = current[tonumber(data.droppedTo)]
        if fromItem and fromItem.unique then
            TriggerServerEvent('inventory:core:swapItemSlots', fromItem.unique, fromItem.weapon or false,
                toItem and toItem.unique or nil, toItem and toItem.weapon or false,
                tonumber(data.droppedTo))
        end
    end
    cb('ok')
end)

RegisterNUICallback('inventory:moveToSecond', function(data, cb)
    forwardToSecond('moveToOther', data)
    cb('ok')
end)

RegisterNUICallback('inventory:moveToMain', function(data, cb)
    forwardToSecond('moveToMain', data)
    cb('ok')
end)

RegisterNUICallback('inventory:instantToMain', function(data, cb)
    forwardToSecond('moveToMain', data)
    cb('ok')
end)

RegisterNUICallback('inventory:instantToSecond', function(data, cb)
    forwardToSecond('moveToOther', data)
    cb('ok')
end)

RegisterNUICallback('onSearch', function(data, cb)
    -- purely a client-side filter concern in the UI itself; nothing
    -- for Lua to do, just acknowledge
    cb('ok')
end)

RegisterNUICallback('inventory:swapMoney', function(data, cb)
    -- money handling is entirely ESX's own account system; if you want
    -- this to do something specific (e.g. cash<->bank), wire it here
    cb('ok')
end)

-- Settings-menu toggle for the background blur effect. Respected by
-- openMainInventory/openOtherInventory (blurEnabled), and applied
-- immediately if toggled while already open.
RegisterNUICallback('inventory:blurState', function(data, cb)
    if data and data.value ~= nil then
        blurEnabled = data.value
        if blurEnabled then
            if blurEnabled then TriggerScreenblurFadeIn(0.3) end
        else
            TriggerScreenblurFadeOut(0.3)
        end
    end
    cb('ok')
end)

-- ------------------------------------------------------------
-- Dropped items (thrown from the inventory)
-- ------------------------------------------------------------
local activeDropObjects = {} -- [id] = object handle

local function spawnDropProp(id, coords)
    local model = GetHashKey('prop_cs_package_01') -- generic small pickup-able package prop
    RequestModel(model)
    local timeout = GetGameTimer() + 3000
    while not HasModelLoaded(model) and GetGameTimer() < timeout do Citizen.Wait(0) end
    if not HasModelLoaded(model) then return end

    local groundZ = coords.z
    local found, z = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z + 5.0, false)
    if found then groundZ = z end

    local obj = CreateObject(model, coords.x, coords.y, groundZ, false, false, false)
    PlaceObjectOnGroundProperly(obj)
    FreezeEntityPosition(obj, true)
    SetEntityAsMissionEntity(obj, true, true)
    SetModelAsNoLongerNeeded(model)
    activeDropObjects[id] = obj
end

local function deleteDropProp(id)
    local obj = activeDropObjects[id]
    if obj and DoesEntityExist(obj) then
        DeleteObject(obj)
    end
    activeDropObjects[id] = nil
end

RegisterNetEvent('inventory:core:spawnDrop')
AddEventHandler('inventory:core:spawnDrop', function(id, itemName, coords)
    activeDrops[id] = coords
    spawnDropProp(id, coords)
end)

RegisterNetEvent('inventory:core:removeDrop')
AddEventHandler('inventory:core:removeDrop', function(id)
    activeDrops[id] = nil
    deleteDropProp(id)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local playerCoords = GetEntityCoords(PlayerPedId())
        for id, coords in pairs(activeDrops) do
            if #(playerCoords - vector3(coords.x, coords.y, coords.z)) <= 3.0 then
                ESX.ShowHelpNotification('Baraye Bardashtan ~INPUT_CONTEXT~ Bezanid')
                if IsControlJustReleased(0, 51) then -- INPUT_CONTEXT (E)
                    TriggerServerEvent('inventory:core:pickupThrown', id)
                end
            end
        end
    end
end)

--[[
    NUI CONTRACT (for reference / for anyone touching ui/js/app.js later)

    Lua -> NUI (SendNUIMessage action):
        openInventory          { mainInventory, playerStaticData, money }
        secondOpen              { mainInventory, playerStaticData, secondInventory, secondInventoryStaticData, showLimitInSecondInventory }
        updatePlayerInventory   { mainInventory, money? }
        updateSecondInventory   { secondInventory }
        close                   {}

    NUI -> Lua (RegisterNUICallback):
        mounted, close, useItem{name}, throwItem{name,count},
        getNearbyPlayers -> [{src,name}], giveItemToTarget{src,name,count,isWeapon},
        moveInside/moveToOther/moveToMain/instantToMain/instantToSecond
            { name, count, slot, droppedTo, ammo? },
        onSearch, swapMoney, blurState
]]

-- ============================================================
-- Backwards-compatibility layer: this resource is now literally
-- named 'esx_inventoryhud', which several OTHER resources on this
-- server already fire events at directly (mining, uwucafejob,
-- gangprop, gangs, esx_lockpick, the 'openproperty' admin command).
-- These make sure those keep showing something real instead of
-- silently doing nothing now that a different implementation is
-- the one actually named esx_inventoryhud.
--
-- These are read/display-oriented: whatever put the items there in
-- the first place (its own external datastore) still owns storing
-- them. Moving items around inside these panels is forwarded back
-- generically via 'esx_inventoryhud:put' / ':get' -- if a specific
-- one of these needs to reach a particular external system's own
-- event instead, tell me which one and I'll wire that exact path.
-- ============================================================

RegisterNetEvent('esx_inventoryhud:closeHud')
AddEventHandler('esx_inventoryhud:closeHud', function()
    closeInventory()
end)

RegisterNetEvent('esx_inventoryhud:refreshTrunkInventory')
AddEventHandler('esx_inventoryhud:refreshTrunkInventory', function(data, blackMoney, items, weapons)
    local plate = data and data.plate
    if secondActive then
        SendNUIMessage({ action = 'updateSecondInventory', inventory = padInventorySlots(sortItems({ items = items or {}, weapons = weapons or {} }, true), Config.SecondInventorySlots or 40) })
        return
    end
    openOtherInventory({
        items = sortItems({ items = items or {}, weapons = weapons or {} }, true),
        maxWeight = data and data.max,
        label = 'Trunk ' .. (plate or '')
    }, function(evt)
        if evt.type == 'moveToOther' then
            TriggerServerEvent('esx_inventoryhud:put', 'trunk', plate, evt.data)
        elseif evt.type == 'moveToMain' then
            TriggerServerEvent('esx_inventoryhud:get', 'trunk', plate, evt.data)
        end
    end)
end)

RegisterNetEvent('esx_inventoryhud:openuwInventory')
AddEventHandler('esx_inventoryhud:openuwInventory', function(invent)
    openOtherInventory({
        items = sortItems({ items = (invent and invent.items) or {}, weapons = (invent and invent.weapons) or {} }),
        label = 'Cafe'
    }, function(evt)
        if evt.type == 'moveToOther' then
            TriggerServerEvent('esx_inventoryhud:put', 'uwucafe', nil, evt.data)
        elseif evt.type == 'moveToMain' then
            TriggerServerEvent('esx_inventoryhud:get', 'uwucafe', nil, evt.data)
        end
    end)
end)

RegisterNetEvent('esx_inventoryhud:openGangInventory')
AddEventHandler('esx_inventoryhud:openGangInventory', function(inventory)
    openOtherInventory({
        items = sortItems({ items = (inventory and inventory.items) or {}, weapons = (inventory and inventory.weapons) or {} }),
        label = 'Gang'
    }, function(evt)
        if evt.type == 'moveToOther' then
            TriggerServerEvent('esx_inventoryhud:put', 'gang', nil, evt.data)
        elseif evt.type == 'moveToMain' then
            TriggerServerEvent('esx_inventoryhud:get', 'gang', nil, evt.data)
        end
    end)
end)

RegisterNetEvent('esx_inventoryhud:openPropertyInventory')
AddEventHandler('esx_inventoryhud:openPropertyInventory', function(inventory)
    openOtherInventory({
        items = sortItems({ items = (inventory and inventory.items) or {}, weapons = (inventory and inventory.weapons) or {} }),
        label = 'Property'
    }, function(evt)
        if evt.type == 'moveToOther' then
            TriggerServerEvent('esx_inventoryhud:put', 'property', nil, evt.data)
        elseif evt.type == 'moveToMain' then
            TriggerServerEvent('esx_inventoryhud:get', 'property', nil, evt.data)
        end
    end)
end)

-- 'incuffhas' toggles whether the player is currently in cuffs --
-- not really an inventory display concern, but registered so the
-- TriggerEvent call always finds a handler. Force-close the
-- inventory when cuffed, matching how most cuff systems expect
-- menus to behave.
RegisterNetEvent('esx_inventoryhud:incuffhas')
AddEventHandler('esx_inventoryhud:incuffhas', function(isCuffed)
    if isCuffed then
        closeInventory()
    end
end)
