local input

function lib.inputDialog(heading, rows, options)
    if input then return end
    input = promise.new()


    for i = 1, #rows do
        if type(rows[i]) == 'string' then
            rows[i] = { type = 'input', label = rows[i]  }
        end
    end

    lib.setNuiFocus(false)
    SendNUIMessage({
        action = 'openDialog',
        data = {
            heading = heading,
            rows = rows,
            options = options
        }
    })

    return Citizen.Await(input)
end

function lib.closeInputDialog()
    if not input then return end

    lib.resetNuiFocus()
    SendNUIMessage({
        action = 'closeInputDialog'
    })

    input:resolve(nil)
    input = nil
end

RegisterNUICallback('inputData', function(data, cb)
    cb(1)
    lib.resetNuiFocus()

    local promise = input
    input = nil

    promise:resolve(data)
end)
