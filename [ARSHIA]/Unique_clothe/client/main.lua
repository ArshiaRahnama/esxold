ESX = nil
usedClothe = {}
clothes = {}
dataLoaded = false
playerLoaded = false
firstSpawn = true
Config = {}
Config.clothe2 = {}
Config.noneClotheNum = {}

-- ============================================================
-- Standalone replacement for the missing 'sunset_utils' resource.
--
-- The original line here was:
--   pcall(load(exports['sunset_utils']:loadScript('stuff','clothe_config_code')))
--   while Config.clothe == nil do Wait(1) end
--
-- sunset_utils isn't installed on this server, so that pcall silently
-- failed and Config.clothe was NEVER set -- the second line then
-- waited forever, meaning this whole resource never finished loading
-- for anyone (no clothes, no wearing, nothing).
--
-- BuildClotheCatalog() below builds the exact same Config.clothe /
-- Config.tempClothe shape directly from the game's own ped-variation
-- natives (both freemode models), so there's no external dependency
-- and the item list is always accurate to whatever's actually
-- installed (base game + any clothing DLC/mod).
-- ============================================================
local ComponentSlot = { tshirt = 8, torso = 11, pants = 4, shoes = 6, mask = 1, bproof = 9, chain = 7, bag = 5, arms = 3, decals = 10 }
local PropSlot = { helmet = 0, glasses = 1, watches = 6, bracelets = 7, ears = 2 }
local PedModels = { [0] = GetHashKey('mp_m_freemode_01'), [1] = GetHashKey('mp_f_freemode_01') }

function BuildClotheCatalog()
    Config.clothe = {}
    for k in pairs(ComponentSlot) do Config.clothe[k] = {} end
    for k in pairs(PropSlot) do Config.clothe[k] = {} end

    local noneVals = { [0] = {}, [1] = {} }

    for sex = 0, 1 do
        local hash = PedModels[sex]
        RequestModel(hash)
        local timeout = GetGameTimer() + 3000
        while not HasModelLoaded(hash) and GetGameTimer() < timeout do Citizen.Wait(0) end

        if HasModelLoaded(hash) then
            local ped = CreatePed(4, hash, 0.0, 0.0, -1000.0, 0.0, false, false)
            SetEntityVisible(ped, false, false)
            SetEntityCollision(ped, false, false)

            for clotheType, slot in pairs(ComponentSlot) do
                local drawCount = GetNumberOfPedDrawableVariations(ped, slot)
                for d = 0, drawCount - 1 do
                    local texCount = GetNumberOfPedTextureVariations(ped, slot, d)
                    if texCount < 1 then texCount = 1 end
                    table.insert(Config.clothe[clotheType], { sex = sex, num = { d, { 0, texCount - 1 } } })
                end
            end
            for clotheType, slot in pairs(PropSlot) do
                local drawCount = GetNumberOfPedPropDrawableVariations(ped, slot)
                for d = 0, drawCount - 1 do
                    local texCount = GetNumberOfPedPropTextureVariations(ped, slot, d)
                    if texCount < 1 then texCount = 1 end
                    table.insert(Config.clothe[clotheType], { sex = sex, num = { d, { 0, texCount - 1 } } })
                end
            end

            -- "nothing equipped" baseline for this sex: drawable 15 is the
            -- standard freemode "bare" variant for clothing slots, -1 clears props
            noneVals[sex] = {
                tshirt_1 = 15, tshirt_2 = 0, torso_1 = 15, torso_2 = 0, pants_1 = 15, pants_2 = 0,
                shoes_1 = 15, shoes_2 = 0, mask_1 = 0, mask_2 = 0, bproof_1 = 15, bproof_2 = 0,
                chain_1 = 0, chain_2 = 0, bags_1 = 0, bags_2 = 0, arms = 15, arms_2 = 0,
                decals_1 = 0, decals_2 = 0, helmet_1 = -1, helmet_2 = 0, glasses_1 = -1, glasses_2 = 0,
                watches_1 = -1, watches_2 = 0, ears_1 = -1, ears_2 = 0, bracelets_1 = -1, bracelets_2 = 0,
            }

            DeletePed(ped)
        end
        SetModelAsNoLongerNeeded(hash)
    end

    Config.tempClothe = { [0] = json.encode(noneVals[0]), [1] = json.encode(noneVals[1]) }
end

labelTemp = {
    ['tshirt'] = 'T-shirt',
    ['torso'] = 'Lebas',
    ['pants'] = 'Shalvar',
    ['shoes'] = 'Kafsh',
    ['mask'] = 'Mask',
    ['bproof'] = 'Jelighe',
    ['chain'] = 'Gardan band',
    ['helmet'] = 'Kolah',
    ['glasses'] = 'Eynak',
    ['watches'] = 'Sa\'at',
    ['bracelets'] = 'Dastband',
    ['bag'] = 'Kif',
    ['ears'] = 'Gush',
    ['arms'] = 'Dastkesh',
    ['decals'] = 'Neshan',
}
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    BuildClotheCatalog()
    local tempMale = json.decode(Config.tempClothe[0])
    local tempFemale = json.decode(Config.tempClothe[1])
    Config.noneClotheNum[0] = tempMale
    Config.noneClotheNum[1] = tempFemale
    for k , v in pairs(Config.clothe) do
        if not Config.clothe2[k] then
            Config.clothe2[k] = {}
        end
        for k2 , v2 in pairs(v) do
            if type(v2.num[2]) == 'table' then
                for i = v2.num[2][1],v2.num[2][2] do
                    local new = ESX.CopyTable(v2)
                    new.num[2] = i
                    table.insert(Config.clothe2[k],new)
                end
            else
                table.insert(Config.clothe2[k],v2)
            end
        end
    end
    for k , v in pairs(Config.clothe2) do
        for k2 , v2 in pairs(v) do
            local name = k .. '_' .. (v2.sex == 0 and 'm' or 'f').. '_' .. v2.num[1] .. '_' .. v2.num[2]
            v2.type = k
            v2.name = name
            local label = nil
            if v2.label then
                label = v2.label .. '('.. (v2.sex == 0 and 'M' or 'F') ..')'
            else
                label = labelTemp[k] .. ' '.. v2.num[1] ..' '.. v2.num[2] ..' ('.. (v2.sex == 0 and 'M' or 'F') ..')'
            end
            v2.label = label
            local num = v2.num
            v2.num2 = {v2.num[1],v2.num[2]}
            if k == 'tshirt' then
                -- v2.num = {
                --     {
                --         key = 'tshirt_1',
                --         value = v2.num[1]
                --     },
                --     {
                --         key = 'tshirt_2',
                --         value = v2.num[2]
                --     }
                -- }
                v2.num = {
                    ['tshirt_1'] = v2.num[1],
                    ['tshirt_2'] = v2.num[2],
                }
            elseif k == 'torso' then
                v2.num = {
                    ['torso_1'] = v2.num[1],
                    ['torso_2'] = v2.num[2],
                }
            elseif k == 'pants' then
                v2.num = {
                    ['pants_1'] = v2.num[1],
                    ['pants_2'] = v2.num[2],
                }
            elseif k == 'shoes' then
                v2.num = {
                    ['shoes_1'] = v2.num[1],
                    ['shoes_2'] = v2.num[2],
                }
            elseif k == 'mask' then
                v2.num = {
                    ['mask_1'] = v2.num[1],
                    ['mask_2'] = v2.num[2],
                }
            elseif k == 'bproof' then
                v2.num = {
                    ['bproof_1'] = v2.num[1],
                    ['bproof_2'] = v2.num[2],
                }
            elseif k == 'helmet' then
                v2.num = {
                    ['helmet_1'] = v2.num[1],
                    ['helmet_2'] = v2.num[2],
                }
            elseif k == 'glasses' then
                v2.num = {
                    ['glasses_1'] = v2.num[1],
                    ['glasses_2'] = v2.num[2],
                }
            elseif k == 'watches' then
                v2.num = {
                    ['watches_1'] = v2.num[1],
                    ['watches_2'] = v2.num[2],
                }
            elseif k == 'bracelets' then
                v2.num = {
                    ['bracelets_1'] = v2.num[1],
                    ['bracelets_2'] = v2.num[2],
                }
            elseif k == 'bag' then
                v2.num = {
                    ['bags_1'] = v2.num[1],
                    ['bags_2'] = v2.num[2],
                }
            elseif k == 'ears' then
                v2.num = {
                    ['ears_1'] = v2.num[1],
                    ['ears_2'] = v2.num[2],
                }
            elseif k == 'arms' then
                v2.num = {
                    ['arms'] = v2.num[1],
                    ['arms_2'] = v2.num[2],
                }
            elseif k == 'chain' then
                v2.num = {
                    ['chain_1'] = v2.num[1],
                    ['chain_2'] = v2.num[2],
                }
            elseif k == 'decals' then
                v2.num = {
                    ['decals_1'] = v2.num[1],
                    ['decals_2'] = v2.num[2],
                }
            end
            clothes[name] = v2
        end
    end
    dataLoaded = true
end)

exports('getClothe2',function()
    while not dataLoaded do Wait(1) end
    return Config.clothe2
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    --xPlayer.data.usedClothe = xPlayer.data.usedClothe or {}
    usedClothe = xPlayer.data.usedClothe or {}
    playerLoaded = true
end)


RegisterNetEvent('clothe:useClothe',function(name)
    toggleClothe(name,nil,true)
    exports['sun-inventory-hud']:loadPlayerInventory()
end)

RegisterNetEvent('esx:removeInventoryItemss',function(label,count,name,newcount)
    if usedClothe[name] and newcount <= 0 then
        removeClothe(name)
    end
end)

function toggleClothe(name,force,anim)
    if not doesHave(name) and not force then return end
    local sex = getSex()
    if sex ~= clothes[name].sex then
        return ESX.Alert('Error','In lebas '.. (sex == 0 and 'zanane' or 'mardane') .. ' ast',5000,'error')
    end
    local add = true
    if usedClothe[name] then
        add = false
    end
    if add then
        addClothe(name)
    else
        removeClothe(name)
    end
    if anim then
        exports['sun-inventory-hud']:playClotheAnim(clothes[name].type)
    end
end
exports('toggleClothe', toggleClothe)
function addClothe(name,notsend,addUsed)
    if not doesHave(name) then return end
    local type = clothes[name].type
    unUseByType(type,name)
    local sex = getSex()
    if sex ~= clothes[name].sex then
        return ESX.Alert('Error','In lebas '.. (sex == 0 and 'zanae' or 'mardane') .. ' ast',5000,'error')
    end
    if addUsed then
        usedClothe[name] = true
    end
    if not notsend then
        ESX.TriggerServerCallback('clothe:setUsed',function(__)
            usedClothe = __
            if not doesHave(name) then return end
            local data = clothes[name]
            if data then
                --if data.type == 'tshirt' then
                local num = data.num
                -- local load = {}
                -- for k , v in pairs(num) do
                --     load[k] = v
                -- end
                TriggerEvent('skinchanger:loadStuff',num)
                --end
            end
        end,name,true)
    else
        if not doesHave(name) then return end
        local data = clothes[name]
        if data then
            local num = data.num
            TriggerEvent('skinchanger:loadStuff',num)
        end
    end
end

function removeClothe(name,notsend)
    local sex = getSex()
    if sex ~= clothes[name].sex then
        return ESX.Alert('Error','In lebas '.. (sex == 0 and 'zanane' or 'mardane') .. ' ast',5000,'error')
    end
    if not notsend then
        ESX.TriggerServerCallback('clothe:setUsed',function(__)
            usedClothe = __
            local data = clothes[name]
            if data then
                local load = {}
                for k ,v in pairs(data.num) do
                    local num = Config.noneClotheNum[sex][k]
                    if num then
                        load[k] = num
                    end
                end
                TriggerEvent('skinchanger:loadStuff',load)
            end
        end,name,false)
    else
        usedClothe[name] = nil
        local data = clothes[name]
        if data then
            local load = {}
            for k ,v in pairs(data.num) do
                local num = Config.noneClotheNum[sex][k]
                if num then
                    load[k] = num
                end
            end
            TriggerEvent('skinchanger:loadStuff',load)
        end
    end
end

RegisterNetEvent('clothe:load', function()
    while not dataLoaded or not playerLoaded do
        Citizen.Wait(0)
    end
    if firstSpawn then
        firstSpawn = false
        local save = false
        for k , v in pairs(usedClothe) do
            if not clothes[k] or not doesHave(k) or clothes[k].sex ~= getSex() then
                usedClothe[k] = nil
                save = true
            end
        end
        loadPack(usedClothe,true)
        if save then
            Citizen.Wait(500)
            saveUsed()
        end
        local job = exports['esx_jobs']:getLastJob()
        if job and job ~= '' and job ~= 'nojob' then
            local data = exports['sunset_helper']:getJobsClothe()
            TriggerEvent('skinchanger:getSkin', function(skin)
                if skin.sex == 0 then
                    TriggerEvent('skinchanger:loadClothes', skin, data[job].skin_male)
                else
                    TriggerEvent('skinchanger:loadClothes', skin, data[job].skin_female)
                end
            end)
        end
        Citizen.Wait(3000)
        DoScreenFadeIn(3000)
        TriggerEvent('esx:restoreLoadout')
        TriggerEvent('sun:clotheLoaded')
        local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()),vector3(0,0,0))
        local distance2 = ESX.GetDistance(GetEntityCoords(PlayerPedId()),vector3(-542.6, -216.61, 37.65))
        local distance3 = ESX.GetDistance(GetEntityCoords(PlayerPedId()),vector3(-2000.36, 3194.38, 32.81))
        if distance < 10 or distance2 < 10 or distance3 < 70 then
            ESX.Game.Teleport(PlayerPedId(),vector3(215,-809,30))
        end
        ESX.TriggerServerCallback('esx_skin:getped', function(data)
            for k , v in pairs(data) do
                if v then
                    if v.used then
                        TriggerEvent("resetpedHandler",k)
                        Wait(500)
                        TriggerEvent("esx:restoreLoadout")
                        TriggerServerEvent('esx_skin:useped',k)
                        break
                    end
                end
            end
        end)
    end
end)

RegisterNetEvent('clothe:usePack',function(name)
    exports['sun-inventory-hud']:packAnim()
    ESX.TriggerServerCallback('clothe:usePack',function(data)
        Citizen.Wait(500)
        local _ = {}
        if data then
            loadPack(data,false,true)
        end
    end,name)
end)

function getSex()
    local p = promise.new()
    local sex = nil
    TriggerEvent('skinchanger:getSkin', function(skin)
        p:resolve(skin.sex)
    end)
    return Citizen.Await(p)
end

function doesHave(name)
    return ESX.DoesHaveItem(name,1,nil,nil,false)
end

function saveUsed()
    ESX.TriggerServerCallback('clothe:setUsed',nil,usedClothe)
end

exports('getUsed',function()
    return usedClothe
end)

function loadPack(_,notsave,pack)
    for k , v in pairs(_) do
        addClothe(k,true,true)
        -- usedClothe[k] = true
    end
    if not notsave then
        saveUsed()
    end
end

exports('loadPack',loadPack)

exports('loadUsed',function()
    loadPack(usedClothe,true)
end)

exports('removeStuff',function(_)
    for k , v in pairs(_) do
        for k2 , v2 in pairs(usedClothe) do
            local data = clothes[k2]
            if data and data.num[k] then
                usedClothe[k2] = nil
            end
        end
    end
    saveUsed()
end)

exports('removeStuffJob',function(_)
    if _ then
        local load = {}
        for k , v in pairs(_) do
            local num = Config.noneClotheNum[getSex()][k]
            if num then
                load[k] = num
            end
        end
        TriggerEvent('skinchanger:loadStuff',load)
    else
        TriggerEvent('skinchanger:getSkin', function(skin)
            TriggerEvent('skinchanger:loadClothes', skin,  json.decode(Config.tempClothe[skin.sex]))
        end)
    end
end)

function createPack(name)
    local __ = {}
    for k , v in pairs(usedClothe) do
        if not clothes[k].antiSearch then
            __[k] = v
        end
    end
    -- ESX.TriggerServerEvent doesn't exist anywhere in essentialmode
    -- (checked) -- this was silently erroring on every call, so
    -- createPack() never actually worked. Plain TriggerServerEvent is
    -- the real function.
    TriggerServerEvent('clothe:createPack',__,name)
end
exports('createPack', createPack)

-- function usePack(name)
--     ESX.TriggerServerEvent('clothe:unpack',name)
-- end

function getClotheData(name)
    return clothes[name]
end

exports('getClotheData',getClotheData)

function getUsedType()
    local __ = {}
    for k , v in pairs(usedClothe) do
        if clothes[k] then
            local type = clothes[k].type
            __[type] = true
        end
    end
    for k , v in pairs(Config.clothe) do
        if not __[k] then
            __[k] = false
        end
    end
    return __
end
exports('getUsedType', getUsedType)

function getOwnedClotheByType(type,sexCheck)
    local __ = {}
    local sex = getSex()
    local inventory = ESX.GetPlayerData().inventory
    for k, v in pairs(inventory) do
        local name = v.name:lower()
        local cData = clothes[name]
        if cData and cData.type == type and v.count > 0 and (not sexCheck or cData.sex == sex) then
            cData.name = name
            cData.used = usedClothe[name] == true
            table.insert(__,cData)
        end
    end
    return __
end
exports('getOwnedClotheByType', getOwnedClotheByType)
function unUseByType(_,name)
    for k , v in pairs(usedClothe) do
        if clothes[k] then
            local type = clothes[k].type
            if type == _ and (name == nil or k ~= name) then
                toggleClothe(k,true)
            end
        end
    end
end
exports('unUseByType', unUseByType)

function getOwnedPack()
    local pack = {}
    local inventory = ESX.GetPlayerData().inventory
    for k, v in pairs(inventory) do
        local name = v.name:lower()
        if string.find(name,'pack_') and v.count > 0 then
            table.insert(pack,v)
        end
    end
    return pack
end
exports('getOwnedPack',getOwnedPack)