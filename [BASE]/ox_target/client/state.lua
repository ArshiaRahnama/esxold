local state = {}

local isActive = false

function state.isActive()
    return isActive
end

function state.setActive(value)
    isActive = value

    if value then
        SendNuiMessage('{"event": "visible", "state": true}')
    end
end

local nuiFocus = false

function state.isNuiFocused()
    return nuiFocus
end

function state.setNuiFocus(value, cursor)
    if value then SetCursorLocation(0.5, 0.5) end

    nuiFocus = value
    SetNuiFocus(value, cursor or false)
    SetNuiFocusKeepInput(value)
end

local isDisabled = false

function state.isDisabled()
    return isDisabled
end

function state.setDisabled(value)
    isDisabled = value
end

return state
