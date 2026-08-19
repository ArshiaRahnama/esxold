cam = nil
isCameraActive = false
mode = 'none'
ped = PlayerPedId()

componentIds = {
    ['tshirt'] = {id = 8, Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200},
    ['torso'] = {id = 11, Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200},
    ['pants'] = {id = 4, Dict = "re@construction", Anim = "out_of_breath", Move = 51, Dur = 1300},
    ['shoes'] = {id = 6, Dict = "random@domestic", Anim = "pickup_low", Move = 0, Dur = 1200},
    ['helmet'] = {id = 0, Dict = "mp_masks@standard_car@ds@", Anim = "put_on_mask", Move = 51, Dur = 600},
    ['mask'] = {id = 1, Dict = "mp_masks@standard_car@ds@", Anim = "put_on_mask", Move = 51, Dur = 800},
    ['ears'] = {id = 2, Dict = "mp_cp_stolen_tut", Anim = "b_think", Move = 51, Dur = 900},
    ['bag'] = {id = 5, Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200},
    ['chain'] = {id = 7, Dict = "clothingtie", Anim = "try_tie_positive_a", Move = 51, Dur = 2100},
    ['glasses'] = {id = 1, Dict = "clothingspecs", Anim = "take_off", Move = 51, Dur = 1400},
    ['bproof'] = {id = 9, Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200},
    ['watches'] = {id = 6, Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200},
    ['bracelets'] = {id = 7, Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200},
    ['decals'] = {id = 7, Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200},
    ['arms'] = {id = 3, Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200},
}

-- ============================================================
-- Local clothing ownership/wearing system (replaces the missing
-- sunset_clothe resource). See server/clothe.lua for the
-- persistence/validation side. Item naming convention:
-- 'clothe_<type>_<drawable>_<texture>', e.g. 'clothe_mask_41_2'.
-- ============================================================

local wornClothes = {} -- type -> itemName, synced from the server

local function parseClotheItem(itemName)
    local clotheType, drawable, texture = itemName:match('^clothe_([a-z]+)_(%d+)_(%d+)$')
    if not clotheType then return nil end
    return clotheType, tonumber(drawable), tonumber(texture)
end

local function applyClotheType(clotheType, itemName)
    local playerPed = PlayerPedId()

    if Config.ClothePropTypes[clotheType] then
        local propId = Config.ClothePropTypes[clotheType]
        if itemName then
            local _, drawable, texture = parseClotheItem(itemName)
            if drawable then
                SetPedPropIndex(playerPed, propId, drawable, texture or 0, true)
            end
        else
            ClearPedProp(playerPed, propId)
        end
    elseif Config.ClotheComponentTypes[clotheType] then
        local compId = Config.ClotheComponentTypes[clotheType]
        if itemName then
            local _, drawable, texture = parseClotheItem(itemName)
            if drawable then
                SetPedComponentVariation(playerPed, compId, drawable, texture or 0, 0)
            end
        else
            SetPedComponentVariation(playerPed, compId, 0, 0, 0)
        end
    end
    -- 'decals' has no real handler here (tattoos use a completely
    -- separate SetPedDecoration/collection-hash system this framework
    -- gave no data for) -- it's tracked but has no visual effect.
end

-- fetch + apply whatever was worn last session, once on load
Citizen.CreateThread(function()
    while ESX == nil do Citizen.Wait(10) end
    local p = promise.new()
    ESX.TriggerServerCallback('sun-clothe:getWorn', function(worn) p:resolve(worn) end)
    wornClothes = Citizen.Await(p) or {}
    for clotheType, itemName in pairs(wornClothes) do
        applyClotheType(clotheType, itemName)
    end
end)

RegisterNetEvent('sun-clothe:appearanceUpdated')
AddEventHandler('sun-clothe:appearanceUpdated', function(worn)
    wornClothes = worn or {}
    for clotheType, itemName in pairs(wornClothes) do
        applyClotheType(clotheType, itemName)
    end
end)

-- character spawn / skin reload can reset ped components, so reapply
-- whatever was worn afterwards
AddEventHandler('esx:onPlayerSpawn', function()
    Citizen.Wait(1000)
    for clotheType, itemName in pairs(wornClothes) do
        applyClotheType(clotheType, itemName)
    end
end)

function getOwnedClotheByType(clotheType)
    local playerData = ESX.GetPlayerData()
    local rows = {}
    for _, entry in pairs(playerData.inventory or {}) do
        if entry.count and entry.count > 0 then
            local itemType = select(1, parseClotheItem(entry.name))
            if itemType == clotheType then
                table.insert(rows, {
                    name = entry.name,
                    label = entry.label or entry.name,
                    image = ESX.GetItemImagePath(entry.name),
                    type = clotheType,
                    used = wornClothes[clotheType] == entry.name
                })
            end
        end
    end
    return rows
end

function getUsedType()
    return wornClothes
end

function unUseByType(clotheType)
    wornClothes[clotheType] = nil
    TriggerServerEvent('sun-clothe:setWorn', clotheType, nil)
    applyClotheType(clotheType, nil)
end

function getClotheData(itemName)
    local clotheType, drawable, texture = parseClotheItem(itemName)
    return { name = itemName, type = clotheType, drawable = drawable, texture = texture }
end

function toggleClothe(itemName)
    local data = getClotheData(itemName)
    if not data.type then return end

    if wornClothes[data.type] == itemName then
        wornClothes[data.type] = nil
        TriggerServerEvent('sun-clothe:setWorn', data.type, nil)
        applyClotheType(data.type, nil)
    else
        wornClothes[data.type] = itemName
        TriggerServerEvent('sun-clothe:setWorn', data.type, itemName)
        applyClotheType(data.type, itemName)
    end
end

function getOwnedPack()
    local playerData = ESX.GetPlayerData()
    local packIds, packItems = {}, {}
    for _, entry in pairs(playerData.inventory or {}) do
        if entry.count and entry.count > 0 then
            local id = entry.name:match('^pack_(%d+)$')
            if id then
                table.insert(packIds, tonumber(id))
                table.insert(packItems, entry)
            end
        end
    end
    if #packIds == 0 then return {} end

    local p = promise.new()
    ESX.TriggerServerCallback('sun-clothe:getPackLabels', function(labels) p:resolve(labels) end, packIds)
    local labels = Citizen.Await(p) or {}

    local rows = {}
    for _, entry in ipairs(packItems) do
        local id = tonumber(entry.name:match('^pack_(%d+)$'))
        table.insert(rows, {
            name = entry.name,
            label = labels[id] or entry.name,
            image = 'img/items/pack.png'
        })
    end
    return rows
end

function createPack(label)
    TriggerServerEvent('sun-clothe:createPack', label)
end

-- ============================================================
-- NUI callbacks (unchanged behaviour, now backed by the local
-- functions above instead of the missing sunset_clothe exports)
-- ============================================================

RegisterNUICallback('Select', function(data, cb)
    mode = data.mode
    SendNuiMessage(json.encode({
        action = "loadClothe",
        obj = getOwnedClotheByType(mode),
        mode = mode,
        used = getUsedType()
    }))
    cb('ok')
end)

RegisterNUICallback('LoadPack', function(_, cb)
    SendNuiMessage(json.encode({
        action = 'loadClothe',
        obj = getOwnedPack(),
        mode = 'pack'
    }))
    cb('ok')
end)



local spam = false
RegisterNUICallback('ChangeClothe', function(data, cb)
    if spam then cb('ok') return end
    spam = true
    Citizen.SetTimeout(2000,function()
        spam = false
    end)
    TriggerEvent('removeSwatHelmet')
    if componentIds[data.name] then
		unUseByType(data.name)
		playClotheAnim(data.name)
        if data.name == 'bproof' and GetPedArmour(PlayerPedId()) > 0 then
            TriggerEvent('esx:spawnObject', 'prop_bodyarmour_03')
            ESX.SetPedArmour(PlayerPedId(),0)
            -- SetPedComponentVariation(PlayerPedId(), 9, 0,  0, 2)
            TriggerEvent('skinchanger:loadStuff',{bproof_1 = 0,bproof_2 = 0})
        end
	else
		toggleClothe(data.name)
		local clotheType = getClotheData(data.name).type
		if clotheType and componentIds[clotheType] then
			playClotheAnim(clotheType)
		end
    end
	Citizen.Wait(300)
    SendNuiMessage(json.encode({
        action = "update",
        obj = getUsedType()
    }))
    refreshPedScreen()
    loadPlayerInventory()
    cb('ok')
end)

RegisterNUICallback('UsePack', function(data, cb)
    if spam then cb('ok') return end
    spam = true
    Citizen.SetTimeout(10000,function()
        spam = false
    end)
    closeInventory()
    -- ESX.TriggerServerEvent doesn't exist anywhere in essentialmode
    -- (same bug already found in Unique_clothe's createPack and
    -- skincreator's save) -- this silently errored every time, so
    -- using a pack never actually triggered anything server-side.
    TriggerServerEvent("esx:useItem", data.name)
    cb('ok')
end)

RegisterNUICallback('CreatePack', function(data, cb)
    closeInventory()
    cb('ok')
    Citizen.Wait(500)
    ESX.UI.Menu.Open(
    'dialog',
    GetCurrentResourceName(),
    'get_count',
    {
        title = "Esm pack ra vared konid"
    },
    function(data1,menu1)
        if data1.value and data1.value ~= '' then
            if data1.value:match("[^%w%s]") then
                ESX.ShowNotification("~h~Shoma faghat mojaz be vared kardan character englishi hastid!")
                return
            end
            menu1.close()
            TriggerScreenblurFadeOut(0.3)
            name = data1.value
            packAnim()
            createPack(name)
            Wait(300)
        end
    end, function(data1,menu1)
        menu1.close()
        TriggerScreenblurFadeOut(0.3)
    end)
end)

function playClotheAnim(mode)
    while not HasAnimDictLoaded(componentIds[mode].Dict) do RequestAnimDict(componentIds[mode].Dict) Wait(100) end
    if IsPedInAnyVehicle(PlayerPedId(), false) then componentIds[mode].Move = 51 end
    TaskPlayAnim(PlayerPedId(), componentIds[mode].Dict, componentIds[mode].Anim, 3.0, 3.0, componentIds[mode].Dur, componentIds[mode].Move, 0, false, false, false)

    Wait(componentIds[mode].Dur)
end
exports('playClotheAnim', playClotheAnim)
--

-- Citizen.CreateThread(Camera())

function packAnim()
    playClotheAnim('tshirt')
    playClotheAnim('pants')
    playClotheAnim('helmet')
    playClotheAnim('shoes')
    playClotheAnim('ears')
    playClotheAnim('glasses')
    playClotheAnim('bracelets')
end
exports('packAnim', packAnim)


function createPedScreen() 
    if not previewPed then
        CreateThread(function()
            SetFrontendActive(true)
            ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_EMPTY_NO_BACKGROUND"), true, -1)
            Wait(100)
            previewPed = ClonePed(PlayerPedId(), false, false, true)
            local x,y,z = table.unpack(GetEntityCoords(previewPed))
            SetEntityCoords(previewPed, x,y,z-10)
            FreezeEntityPosition(previewPed, true)
            SetEntityVisible(previewPed, false, false)
            NetworkSetEntityInvisibleToNetwork(previewPed, false)
            Wait(200)
            SetPedAsNoLongerNeeded(previewPed)
            GivePedToPauseMenu(previewPed, 2)
            SetPauseMenuPedLighting(true)
            SetPauseMenuPedSleepState(true)
            SetMouseCursorVisibleInMenus(false)
            if not isOpen then
                deletePedScreen()
            end
        end)
    end
end

function deletePedScreen()
    if previewPed then
        DeleteEntity(previewPed)
        SetFrontendActive(false)
        previewPed = nil
    end
end


function refreshPedScreen()
	deletePedScreen()
	Wait(200)
    if isOpen then
        createPedScreen()
    end
end

RegisterNUICallback('createPed', function(_, cb)
    createPedScreen() 
    cb('ok')
end)

RegisterNUICallback('deletePed', function(_, cb)
    deletePedScreen()
    cb('ok')
end)
