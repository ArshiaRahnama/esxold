--[[
    UNIQUE RP — OFFICIAL DOCUMENTS — Client
    Author: Arshia | arshiahub.ir

    This rebuilds the missing runtime logic for the resource. The previous
    Client.lua only did this:

        RegisterNetEvent('doc:initialize')
        AddEventHandler('doc:initialize', function(data)
            load(data)()          -- runs a string of Lua sent by the server
        end)

    That pattern (server sends a string, client `load()`s and executes it)
    is a code-injection foot-gun and isn't needed — it's replaced below with
    normal, readable client code that talks to the NUI (html/) exactly the
    way the compiled front-end expects (verified from its own sourcemap):

        NUI -> Lua callbacks : close, getdata, saveModel, saveDocument
        Lua -> NUI messages  : openCreateModel, openCreateDocument,
                                openEditModel,  openEditDocument,
                                openViewDocument (each carries infos_document)

    Menu (list / search / edit / delete / close / copy / give) is handled
    entirely here via the `icon_menu` resource already required in
    fxmanifest.lua, using its documented API:
        IconMenu.OpenMenu(items, config)
]]

ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
end)

-- ---------------------------------------------------------------------
-- local state for whatever item is currently open in the NUI
-- ---------------------------------------------------------------------
local currentItemId    = nil   -- nil while creating something new
local currentItemType  = nil   -- 'model' | 'document'
local currentItemName  = nil   -- name shown in the list menu
local currentModelId   = nil   -- which model a new document was based on

local function ResetCurrentItem()
    currentItemId   = nil
    currentItemType = nil
    currentItemName = nil
    currentModelId  = nil
end

local function HasJob(list)
    if not ESX or not ESX.PlayerData or not ESX.PlayerData.job then return false end
    for _, job in ipairs(list) do
        if ESX.PlayerData.job.name == job then return true end
    end
    return false
end

-- mysql-async can return TINYINT(1) columns as a Lua boolean, a number,
-- or a numeric string depending on driver config — normalize all of
-- them here instead of trusting tonumber() alone (tonumber(true) is
-- nil, which silently breaks a plain `== 1` check).
local function IsFlagTrue(v)
    return v == true or v == 1 or v == "1"
end

-- Standard on-screen keyboard input helper
local function KeyboardInput(title, default)
    -- icon_menu keeps listening for Enter/click in the background even
    -- while this is open (it doesn't know we've moved on), so the same
    -- Enter press that confirms typing here could also re-trigger
    -- whatever menu item was last highlighted. Close it first.
    IconMenu.ForceCloseMenu()

    default = default or ""
    AddTextEntry('DOC_KB_ENTRY', title)
    DisplayOnscreenKeyboard(1, 'DOC_KB_ENTRY', "", default, "", "", "", 128)

    local status = 0
    while status == 0 do
        status = UpdateOnscreenKeyboard()
        Wait(0)
    end

    -- let the confirming key press fully clear before anything else
    -- (menu, NUI, another prompt) starts reading input again
    Wait(300)

    if status == 1 then
        return GetOnscreenKeyboardResult()
    end
    return nil
end

-- Closest other player (used for "give document")
local function GetClosestPlayer()
    local closestDistance = -1
    local closestPlayer   = -1
    local myCoords = GetEntityCoords(PlayerPedId())

    for _, player in ipairs(GetActivePlayers()) do
        if player ~= PlayerId() then
            local dist = #(myCoords - GetEntityCoords(GetPlayerPed(player)))
            if closestDistance == -1 or dist < closestDistance then
                closestDistance = dist
                closestPlayer   = player
            end
        end
    end

    return closestPlayer, closestDistance
end

RegisterNetEvent('Documents:notify')
AddEventHandler('Documents:notify', function(msg)
    ESX.ShowNotification(msg)
end)

-- ---------------------------------------------------------------------
-- NUI <-> Lua bridge
-- ---------------------------------------------------------------------
local function PushConfigToNUI()
    SendNUIMessage({
        config       = true,
        translate    = translate,
        NameResource = GetCurrentResourceName(),
        logo         = logo,
    })
end

local function OpenNUI(kind, infos_document)
    IconMenu.ForceCloseMenu() -- icon_menu doesn't auto-hide itself on selection
    SetNuiFocus(true, true)
    PushConfigToNUI()

    local msg = {}
    msg[kind] = true
    if infos_document ~= nil then
        msg.infos_document = infos_document
    end
    SendNUIMessage(msg)
end

RegisterNUICallback('close', function(_, cb)
    SetNuiFocus(false, false)
    ResetCurrentItem()
    cb('ok')
end)

RegisterNUICallback('getdata', function(_, cb)
    local fullName = GetPlayerName(PlayerId())
    local jobLabel, gradeLabel = "", ""

    if ESX and ESX.PlayerData then
        if ESX.PlayerData.firstName then
            fullName = ESX.PlayerData.firstName .. " " .. (ESX.PlayerData.lastName or "")
        end
        if ESX.PlayerData.job then
            jobLabel   = ESX.PlayerData.job.label       or ""
            gradeLabel = ESX.PlayerData.job.grade_label or ""
        end
    end

    cb({
        name = fullName,
        job  = { label = jobLabel, grade_label = gradeLabel },
    })
end)

RegisterNUICallback('saveModel', function(data, cb)
    TriggerServerEvent('Documents:saveModel', currentItemId, currentItemName, data.infos_document)
    SetNuiFocus(false, false)
    ResetCurrentItem()
    cb('ok')
end)

RegisterNUICallback('saveDocument', function(data, cb)
    TriggerServerEvent('Documents:saveDocument', currentItemId, currentItemName, currentModelId, data.infos_document)
    SetNuiFocus(false, false)
    ResetCurrentItem()
    cb('ok')
end)

-- ---------------------------------------------------------------------
-- Give a closed document to the nearest player
-- ---------------------------------------------------------------------
local function GiveDocument(docId)
    local player, distance = GetClosestPlayer()
    if player == -1 or distance > 3.0 then
        ESX.ShowNotification(translate.TR_NOONE)
        return
    end
    TriggerServerEvent('Documents:giveDocument', docId, GetPlayerServerId(player))
end

-- ---------------------------------------------------------------------
-- Open an existing model/document into the NUI (view or edit)
-- ---------------------------------------------------------------------
local function RequestOpen(docType, id, mode)
    ESX.TriggerServerCallback('Documents:openItem', function(res)
        if not res then
            ESX.ShowNotification(translate.TR_NOT_PERMISSION)
            return
        end

        currentItemId   = id
        currentItemType = docType
        currentItemName = res.name
        currentModelId  = res.model_id

        if mode == 'view' then
            OpenNUI('openViewDocument', res.infos_document)
        elseif docType == 'model' then
            OpenNUI('openEditModel', res.infos_document)
        else
            OpenNUI('openEditDocument', res.infos_document)
        end
    end, docType, id)
end

-- ---------------------------------------------------------------------
-- Create a brand new model, or a new document based on a chosen model
-- ---------------------------------------------------------------------
local OpenListMenu -- forward declaration (recursive/mutually referenced)

local function PromptCreate(docType)
    if docType == 'model' then
        local name = KeyboardInput(translate.TR_CREATE4)
        if not name or name == '' then return end

        ResetCurrentItem()
        currentItemType = 'model'
        currentItemName = name

        OpenNUI('openCreateModel', nil)
        return
    end

    -- creating a document: first pick which model it's based on
    OpenListMenu('model', nil, function(modelRow)
        ESX.TriggerServerCallback('Documents:openItem', function(res)
            if not res then
                ESX.ShowNotification(translate.TR_NOT_PERMISSION)
                return
            end

            local name = KeyboardInput(translate.TR_CREATE4, modelRow.name)
            if not name or name == '' then return end

            ResetCurrentItem()
            currentItemType = 'document'
            currentItemName = name
            currentModelId  = modelRow.id

            res.infos_document.name = nil -- strip the model's routing sentinel
            OpenNUI('openCreateDocument', res.infos_document)
        end, 'model', modelRow.id)
    end)
end

-- ---------------------------------------------------------------------
-- Per-item action menu (view / edit / close / copy / give / delete)
-- ---------------------------------------------------------------------
local function OpenItemActions(docType, row)
    local items = {}
    local isCopy = docType == 'document' and IsFlagTrue(row.is_copy)

    table.insert(items, {
        img = "document.png", text = translate.TR_OPEN, text2 = translate.TR_OPEN2 .. row.name,
        callBack = function() RequestOpen(docType, row.id, 'view') end,
    })

    if not isCopy then
        local canEdit = (docType == 'model' and HasJob(jobs_SaveTemplate))
            or (docType == 'document' and HasJob(jobs_CreateDocument))

        if canEdit and not IsFlagTrue(row.closed) then
            table.insert(items, {
                img = "edit.png",
                text = translate.TR_EDIT,
                text2 = (docType == 'model' and translate.TR_EDIT2 or translate.TR_EDIT3) .. row.name,
                callBack = function() RequestOpen(docType, row.id, 'edit') end,
            })
        end

        if docType == 'document' then
            if HasJob(jobs_CloseDocument) and not IsFlagTrue(row.closed) then
                table.insert(items, {
                    img = "close.png", text = translate.TR_CLOSE, text2 = translate.TR_CLOSE2 .. row.name,
                    callBack = function()
                        TriggerServerEvent('Documents:closeDocument', row.id)
                        OpenListMenu(docType)
                    end,
                })
            end

            if HasJob(jobs_CopyDocument) then
                table.insert(items, {
                    img = "copy.png", text = translate.TR_COPY, text2 = translate.TR_COPY2 .. row.name,
                    callBack = function()
                        TriggerServerEvent('Documents:copyDocument', row.id)
                        OpenListMenu(docType)
                    end,
                })
            end

            if HasJob(jobs_GiveDocument) then
                table.insert(items, {
                    img = "give.png", text = translate.TR_GIVE, text2 = translate.TR_GIVE2,
                    callBack = function() GiveDocument(row.id) end,
                })
            end
        end
    end

    if HasJob(jobs_DeleteDocument) then
        table.insert(items, {
            img = "delete.png",
            text = translate.TR_DELETE,
            text2 = (docType == 'model' and translate.TR_DELETE2 or translate.TR_DELETE3) .. row.name,
            callBack = function()
                TriggerServerEvent('Documents:deleteItem', docType, row.id)
                OpenListMenu(docType)
            end,
        })
    end

    table.insert(items, {
        img = "back.png", text = translate.TR_BACK, text2 = translate.TR_BACK3,
        isBack = true,
        callBack = function() OpenListMenu(docType) end,
    })

    IconMenu.OpenMenu(items)
end

-- ---------------------------------------------------------------------
-- List menu (also used in "pick a model" mode when creating a document)
-- ---------------------------------------------------------------------
OpenListMenu = function(docType, search, pickCallback)
    ESX.TriggerServerCallback('Documents:getLists', function(rows)
        local items = {}

        local canCreate = (docType == 'model' and HasJob(jobs_SaveTemplate))
            or (docType == 'document' and HasJob(jobs_CreateDocument))
        if canCreate then
            table.insert(items, {
                img = "create.png",
                text = (docType == 'model' and translate.TR_CREATE2 or translate.TR_CREATE3),
                text2 = "",
                callBack = function() PromptCreate(docType) end,
            })
        end

        table.insert(items, {
            img = "search.png", text = translate.TR_SEARCH, text2 = translate.TR_SEARCH2,
            callBack = function()
                local term = KeyboardInput(translate.TR_SEARCH_KEYBOARD, search or "")
                OpenListMenu(docType, term, pickCallback)
            end,
        })

        if #rows == 0 then
            table.insert(items, {
                img = "stop.png", text = translate.TR_NOT_DOCUMENTS, text2 = "",
                callBack = function() OpenListMenu(docType, search, pickCallback) end,
            })
        end

        for _, row in ipairs(rows) do
            local label = row.name
            if docType == 'document' and IsFlagTrue(row.closed) then
                label = label .. "  (" .. translate.TR_CLOSE .. ")"
            end
            table.insert(items, {
                img = "document.png", text = label, text2 = "",
                callBack = function()
                    if pickCallback then
                        pickCallback(row)
                    else
                        OpenItemActions(docType, row)
                    end
                end,
            })
        end

        table.insert(items, {
            img = "back.png", text = translate.TR_BACK, text2 = translate.TR_BACK2,
            isBack = true,
            callBack = function()
                if pickCallback then return end
                OpenRootMenu()
            end,
        })

        IconMenu.OpenMenu(items)
    end, docType, search)
end

-- ---------------------------------------------------------------------
-- Root menu
-- ---------------------------------------------------------------------
function OpenRootMenu()
    IconMenu.OpenMenu({
        {
            img = "folder.png", text = translate.TR_VIEW_MODELS, text2 = translate.TR_VIEW_MODELS2,
            callBack = function() OpenListMenu('model') end,
        },
        {
            img = "archive.png", text = translate.TR_VIEW_DOCUMENTS, text2 = translate.TR_VIEW_DOCUMENTS2,
            callBack = function() OpenListMenu('document') end,
        },
    })
end

-- Bound to F9 by default (rebindable by the player in FiveM's key-binding
-- settings, under this resource's name). No chat command needed.
-- Everyone can open and browse; the create/edit/close/copy/give/delete
-- options are still individually gated by job further down.
RegisterCommand('documents_openmenu', function()
    OpenRootMenu()
end, false)
RegisterKeyMapping('documents_openmenu', 'Open Official Documents Menu', 'keyboard', 'F9')

-- ---------------------------------------------------------------------
-- Citizens: view documents that were given to them (not job-gated)
-- ---------------------------------------------------------------------
RegisterCommand('mydocuments', function()
    ESX.TriggerServerCallback('Documents:getMyDocuments', function(rows)
        if #rows == 0 then
            ESX.ShowNotification(translate.TR_NOT_DOCUMENTS)
            return
        end

        local items = {}
        for _, row in ipairs(rows) do
            table.insert(items, {
                img = "document.png", text = row.name, text2 = translate.TR_OPEN2 .. row.name,
                callBack = function()
                    ESX.TriggerServerCallback('Documents:openMyDocument', function(res)
                        if not res then return end
                        currentItemId   = row.id
                        currentItemType = 'document'
                        OpenNUI('openViewDocument', res.infos_document)
                    end, row.id)
                end,
            })
        end
        IconMenu.OpenMenu(items)
    end)
end, false)

RegisterNetEvent('Documents:notifyReceived')
AddEventHandler('Documents:notifyReceived', function()
    ESX.ShowNotification(translate.TR_RECEIVE)
end)
