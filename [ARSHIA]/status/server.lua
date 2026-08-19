ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(100)
    end
end)

-- =========================================================
-- Save Hunger / Thirst
-- =========================================================

RegisterServerEvent("saveHungerThirst")
AddEventHandler("saveHungerThirst", function(hunger, thirst)
    local source = source

    if not ESX then
        print("^1[STATUS] ESX is not loaded.^0")
        return
    end

    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        return
    end

    local identifier = xPlayer.getIdentifier()

    local status = json.encode({
        hunger = tonumber(hunger) or 100,
        thirst = tonumber(thirst) or 100
    })

    exports.ghmattimysql:execute(
        "UPDATE users SET status = @status WHERE identifier = @identifier",
        {
            ['@identifier'] = identifier,
            ['@status'] = status
        }
    )
end)

-- =========================================================
-- Get Player Status
-- =========================================================

RegisterServerEvent("getPlayerStatus")
AddEventHandler("getPlayerStatus", function()
    local source = source

    if not ESX then
        print("^1[STATUS] ESX is not loaded.^0")
        return
    end

    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        TriggerClientEvent('PlayerStatus', source, {})
        return
    end

    local identifier = xPlayer.getIdentifier()

    exports.ghmattimysql:execute(
        "SELECT status FROM users WHERE identifier = @identifier LIMIT 1",
        {
            ['@identifier'] = identifier
        },
        function(result)

            if result and result[1] and result[1].status then

                local statusData = {}

                local success, decoded = pcall(json.decode, result[1].status)

                if success and decoded then
                    statusData = decoded
                end

                TriggerClientEvent('PlayerStatus', source, statusData)

            else
                TriggerClientEvent('PlayerStatus', source, {})
            end

        end
    )
end)

-- =========================================================
-- Reload Player Data
-- =========================================================

ESX.RegisterServerCallback('reloaddata', function(source, cb)

    if not ESX then
        cb(nil)
        return
    end

    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        cb(xPlayer)
    else
        cb(nil)
    end

end)