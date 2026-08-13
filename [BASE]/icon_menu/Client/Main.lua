local List = {}
local openned = false
local backIndex = nil -- index (1-based) of the "back" item, if any

-- Mouse left-click to select, arrow keys to move, ESC to close.
-- Backspace goes back one level — and if there's no "back" item on the
-- current screen (i.e. you're at the root menu), it closes the whole
-- menu instead, same as Esc. Right-click does NOT close the menu.
--   176 INPUT_CELLPHONE_SELECT -> ENTER *or* LEFT MOUSE BUTTON
--   172 INPUT_CELLPHONE_UP     -> ARROW UP
--   173 INPUT_CELLPHONE_DOWN   -> ARROW DOWN
--   200 INPUT_FRONTEND_PAUSE   -> suppress the game's own pause menu
--                                  while our menu is open
-- ESC and Backspace are read as raw keys (27 / 8) so they're independent
-- from the right-mouse-button that INPUT_CELLPHONE_CANCEL (177) would
-- otherwise also trigger on.
local CONTROL_SELECT   = 176
local CONTROL_UP       = 172
local CONTROL_DOWN     = 173
local CONTROL_PAUSE    = 200
local RAWKEY_ESCAPE    = 27
local RAWKEY_BACKSPACE = 8

local function GoBackOrClose()
    if backIndex and List[backIndex] and List[backIndex].callBack then
        List[backIndex].callBack()
    else
        ForceCloseMenu() -- nowhere to go back to (root menu) -> just close
    end
end

function OpenMenu(list, configs)
    local elements = {}
    backIndex = nil

    for i,k in pairs(list) do
        local image = ""
        if not string.find(k.img, "http") and not string.find(k.img,'nui://') then
            image = "./img/"
        end

        if k.isBack then
            backIndex = i
        end

        table.insert(elements, {img = image .. k.img, text = k.text, text2 = k.text2})
    end

    List = list

    SendNUIMessage({
        elements = elements,
        configs = configs or config_default
    })

    openned = true
    -- No SetNuiFocus on purpose: no visible cursor, no game controls
    -- taken away. Navigation is driven entirely by the polling loop
    -- below (left click / arrow keys / Esc).
end

function ForceCloseMenu()
    SendNUIMessage({
        goBack = true
    })
    openned = false
end

CreateThread(function()
    Wait(5000)
    SendNUIMessage({
        config_default = config_default
    })
end)

CreateThread(function()
    while true do
        Wait(0)

        if openned then
            DisableControlAction(0, CONTROL_SELECT, true)
            DisableControlAction(0, CONTROL_UP, true)
            DisableControlAction(0, CONTROL_DOWN, true)
            DisableControlAction(0, CONTROL_PAUSE, true)

            if IsDisabledControlJustPressed(0, CONTROL_UP) then
                SendNUIMessage({ upSelected = true })
                Wait(150)
            elseif IsDisabledControlJustPressed(0, CONTROL_DOWN) then
                SendNUIMessage({ downSelected = true })
                Wait(150)
            elseif IsDisabledControlJustPressed(0, CONTROL_SELECT) then
                SendNUIMessage({ enterSelected = true })
                Wait(150)
            elseif IsRawKeyPressed(RAWKEY_BACKSPACE) then
                GoBackOrClose()
                Wait(150)
            elseif IsRawKeyPressed(RAWKEY_ESCAPE) then
                ForceCloseMenu()
                Wait(150)
            end
        end
    end
end)

RegisterNUICallback('enterSelected', function(data, cb)
    local selected = tonumber(data.selected)
    if List[selected + 1] and List[selected + 1].callBack then
        List[selected + 1].callBack()
    end
    cb('ok')
end)

exports("OpenMenu", OpenMenu)
exports("ForceCloseMenu", ForceCloseMenu)

exports("IsOpen", function()
    return openned
end)
