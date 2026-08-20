
local alert = nil
local alertId = 0

function lib.alertDialog(data, timeout)
    if alert then return end

    local id = alertId + 1
    alertId = id
    alert = promise.new()

    lib.setNuiFocus(false)
    SendNUIMessage({
        action = 'sendAlert',
        data = data
    })

    if timeout then
        SetTimeout(timeout, function()
            if id == alertId then lib.closeAlertDialog('timeout') end
        end)
    end

    return Citizen.Await(alert)
end

function lib.closeAlertDialog(reason)
    if not alert then return end

    lib.resetNuiFocus()
    SendNUIMessage({
        action = 'closeAlertDialog'
    })

    local p = alert
    alert = nil

    if reason then p:reject(reason) else p:resolve() end
end

RegisterNUICallback('closeAlert', function(data, cb)
    cb(1)
    lib.resetNuiFocus()

    local promise = alert
    alert = nil

    promise:resolve(data)
end)

RegisterNetEvent('ox_lib:alertDialog', lib.alertDialog)
