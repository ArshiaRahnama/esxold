

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
while ESX == nil do
    Citizen.Wait(0)
end

local isOpen = false
local secondActive = false
local secondCallback = nil
local activeDrops = {}
local blurEnabled = true
local equippedWeaponsCache = {}

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

if not ESX.Alert then
    function ESX.Alert(header, text, timeout, alertType)
        local prefix = (header and header ~= '') and (header .. ': ') or ''
        ESX.ShowNotification(prefix .. (text or ''))
    end
end

if not ESX.SetPlayerState then
    function ESX.SetPlayerState(key, value)
        LocalPlayer.state:set(key, value, true)
    end
end

if not ESX.SetPedArmour then
    function ESX.SetPedArmour(ped, armour)
        SetPedArmour(ped, armour)
    end
end

function sortItems(raw, isTrunk)
    local rows = {}

    local function addItem(entry)
        local item = ESX.getItem(entry.name)
        table.insert(rows, {
            unique = entry.name,
            name = entry.name,
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
            image = 'img/items/' .. entry.name .. '.png',
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

local function positiveOrDefault(value, default)
    if type(value) ~= 'number' or value <= 0 then
        return default
    end
    return value
end

function openMainInventory()
    if isOpen or secondActive then return end
    isOpen = true
    local playerData = ESX.GetPlayerData()
    local mainItems = buildMainInventoryItems()

    SetNuiFocus(true, true)
    if blurEnabled then TriggerScreenblurFadeIn(0.3) end




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

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(0.1)
end)

local lastToggleAt = 0
RegisterCommand('inventory_toggle', function()
    local now = GetGameTimer()
    if now - lastToggleAt < 250 then return end
    lastToggleAt = now

    if isOpen or secondActive then
        closeInventory()
    else
        openMainInventory()
    end
end, false)
RegisterKeyMapping('inventory_toggle', 'Baz/Baste Kardan Inventory', 'keyboard', Config.OpenInventoryKey)

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

local currentlyGiven = {}

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




    ESX.TriggerServerCallback('inventory:getEquippedWeapons', function(equippedSet)
        TriggerEvent('inventory:weaponEquipChanged', equippedSet)
    end)
end)
AddEventHandler('esx:removeWeapon', function(weaponName, ammo)
    refreshMainInventoryIfOpen()
    currentlyGiven[weaponName] = nil
end)

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

function loadPlayerInventory()
    refreshMainInventoryIfOpen()
end
exports('loadPlayerInventory', loadPlayerInventory)

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

function moveInsideHandler(data)
    if not data then return end
    if data.inventoryType == 'main' then
        SendNUIMessage({
            action = 'updatePlayerInventory',
            mainInventory = buildMainInventoryItems()
        })
    end
end

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

local function getNuiItemName(data)
    if not data then return nil end
    return data.name or data.unique
        or (data.item and (data.item.name or data.item.unique))
        or (data.draggedItem and (data.draggedItem.name or data.draggedItem.unique))
        or (data.draggedData and (data.draggedData.name or data.draggedData.unique))
        or nil
end

RegisterNUICallback('close', function(_, cb)
    closeInventory(true)
    cb('ok')
end)

RegisterNUICallback('inventory:mounted', function(_, cb)
    cb('ok')
end)

local weaponNameSet = {}
CreateThread(function()
    for _, w in ipairs(ESX.GetWeaponList() or {}) do
        weaponNameSet[w.name] = true
    end
end)

RegisterNUICallback('inventory:useItem', function(data, cb)



    local itemName = (type(data) == 'string' and data) or getNuiItemName(data)
    if type(itemName) == 'string' then
        itemName = itemName:gsub('^"(.*)"$', '%1')
    end
    if itemName then
        if weaponNameSet[itemName] then




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


    cb('ok')
end)

RegisterNUICallback('inventory:swapMoney', function(data, cb)


    cb('ok')
end)

local activeDropObjects = {}

local function spawnDropProp(id, coords)
    local model = GetHashKey('prop_cs_package_01')
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
                if IsControlJustReleased(0, 51) then
                    TriggerServerEvent('inventory:core:pickupThrown', id)
                end
            end
        end
    end
end)

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

RegisterNetEvent('esx_inventoryhud:incuffhas')
AddEventHandler('esx_inventoryhud:incuffhas', function(isCuffed)
    if isCuffed then
        closeInventory()
    end
end)
