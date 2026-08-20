

function lib.triggerClientEvent(eventName, targetIds, ...)
    local payload = msgpack.pack_args(...)
    local payloadLen = #payload

    if lib.array.isArray(targetIds) then
        for i = 1, #targetIds do
            TriggerClientEventInternal(eventName, targetIds[i] , payload, payloadLen)
        end

        return
    end

    TriggerClientEventInternal(eventName, targetIds , payload, payloadLen)
end

return lib.triggerClientEvent
