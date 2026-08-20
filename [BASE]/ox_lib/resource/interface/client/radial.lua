

local isOpen = false

local menus = {}

local menuItems = {}

local menuHistory = {}

local currentRadial = nil

local function showRadial(id, option)
    local radial = id and menus[id]

    if id and not radial then
        return error('No radial menu with such id found.')
    end

    currentRadial = radial


    SendNUIMessage({
        action = 'openRadialMenu',
        data = false
    })

    Wait(100)


    if not isOpen then return end

    SendNUIMessage({
        action = 'openRadialMenu',
        data = {
            items = radial and radial.items or menuItems,
            sub = radial and true or nil,
            option = option
        }
    })
end

local function refreshRadial(menuId)
    if not isOpen then return end

    if currentRadial and menuId then
        if menuId == currentRadial.id then
            return showRadial(menuId)
        else
            for i = 1, #menuHistory do
                local subMenu = menuHistory[i]

                if subMenu.id == menuId then
                    local parent = menus[subMenu.id]

                    for j = 1, #parent.items do

                        if parent.items[j].menu == currentRadial.id then
                            return
                        end
                    end

                    currentRadial = parent

                    for j = #menuHistory, i, -1 do
                        menuHistory[j] = nil
                    end

                    return showRadial(currentRadial.id)
                end
            end
        end

        return
    end

    table.wipe(menuHistory)
    showRadial()
end

function lib.registerRadial(radial)
    menus[radial.id] = radial
    radial.resource = GetInvokingResource()

    if currentRadial then
        refreshRadial(radial.id)
    end
end

function lib.getCurrentRadialId()
    return currentRadial and currentRadial.id
end

function lib.hideRadial()
    if not isOpen then return end

    SendNUIMessage({
        action = 'openRadialMenu',
        data = false
    })

    lib.resetNuiFocus()
    table.wipe(menuHistory)

    isOpen = false
    currentRadial = nil
end

function lib.addRadialItem(items)
    local menuSize = #menuItems
    local invokingResource = GetInvokingResource()

    items = table.type(items) == 'array' and items or { items }

    for i = 1, #items do
        local item = items[i]
        item.resource = invokingResource

        if menuSize == 0 then
            menuSize += 1
            menuItems[menuSize] = item
        else
            for j = 1, menuSize do
                if menuItems[j].id == item.id then
                    menuItems[j] = item
                    break
                end

                if j == menuSize then
                    menuSize += 1
                    menuItems[menuSize] = item
                end
            end
        end
    end

    if isOpen and not currentRadial then
        refreshRadial()
    end
end

function lib.removeRadialItem(id)
    local menuItem

    for i = 1, #menuItems do
        menuItem = menuItems[i]

        if menuItem.id == id then
            table.remove(menuItems, i)
            break
        end
    end

    if not isOpen then return end

    refreshRadial(id)
end

function lib.clearRadialItems()
    table.wipe(menuItems)

    if isOpen then
        refreshRadial()
    end
end

RegisterNUICallback('radialClick', function(index, cb)
    cb(1)

    local itemIndex = index + 1
    local item, currentMenu

    if currentRadial then
        item = currentRadial.items[itemIndex]
        currentMenu = currentRadial.id
    else
        item = menuItems[itemIndex]
    end

    local menuResource = currentRadial and currentRadial.resource or item.resource

    if item.menu then
        menuHistory[#menuHistory + 1] = { id = currentRadial and currentRadial.id, option = item.menu }
        showRadial(item.menu)
    elseif not item.keepOpen then
        lib.hideRadial()
    end

    local onSelect = item.onSelect

    if onSelect then
        if type(onSelect) == 'string' then
            return exports[menuResource][onSelect](0, currentMenu, itemIndex)
        end

        onSelect(currentMenu, itemIndex)
    end
end)

RegisterNUICallback('radialBack', function(_, cb)
    cb(1)

    local numHistory = #menuHistory
    local lastMenu = numHistory > 0 and menuHistory[numHistory]

    if not lastMenu then return end

    menuHistory[numHistory] = nil

    if lastMenu.id then
        return showRadial(lastMenu.id, lastMenu.option)
    end

    currentRadial = nil


    SendNUIMessage({
        action = 'openRadialMenu',
        data = false
    })

    Wait(100)


    if not isOpen then return end

    SendNUIMessage({
        action = 'openRadialMenu',
        data = {
            items = menuItems,
            option = lastMenu.option
        }
    })
end)

RegisterNUICallback('radialClose', function(_, cb)
    cb(1)

    if not isOpen then return end

    lib.resetNuiFocus()

    isOpen = false
    currentRadial = nil
end)

RegisterNUICallback('radialTransition', function(_, cb)
    Wait(100)


    if not isOpen then return cb(false) end

    cb(true)
end)

local isDisabled = false

function lib.disableRadial(state)
    isDisabled = state

    if isOpen and state then
        return lib.hideRadial()
    end
end

lib.addKeybind({
    name = 'ox_lib-radial',
    description = locale('open_radial_menu'),
    defaultKey = 'z',
    onPressed = function()
        if isDisabled then return end

        if isOpen then
            return lib.hideRadial()
        end

        if #menuItems == 0 or IsNuiFocused() or IsPauseMenuActive() then return end

        isOpen = true

        SendNUIMessage({
            action = 'openRadialMenu',
            data = {
                items = menuItems
            }
        })

        lib.setNuiFocus(true)
        SetCursorLocation(0.5, 0.5)

        while isOpen do
            DisablePlayerFiring(cache.playerId, true)
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(2, 199, true)
            DisableControlAction(2, 200, true)
            Wait(0)
        end
    end,

})

AddEventHandler('onClientResourceStop', function(resource)
    for i = #menuItems, 1, -1 do
        local item = menuItems[i]

        if item.resource == resource then
            table.remove(menuItems, i)
        end
    end
end)
