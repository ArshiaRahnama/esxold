

CreateThread(function()
    local executed = false
    Wait(1000)
    Client('Coin-System:initialize', function(data)
        if not executed then
            executed = true
			load(data)()
        end
    end)
    TriggerServerEvent('Coin-System:initialize')
end)


