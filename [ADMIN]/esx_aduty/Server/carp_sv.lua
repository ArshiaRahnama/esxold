ESX = nil
AdminPlayers = {}
tempOown = false

-- [SECURITY] The "Code" string and the "xC_BabatMordAdmin2:AdminBakhti"
-- event that sent it to clients for pcall(load(Code)) execution have been
-- removed - that was a remote-code-execution channel (server could push and
-- run arbitrary Lua on every client). Everything that string used to define
-- (SpawnVehicle, visibility, the keybind table) now lives as normal static
-- code in Client/carp_cl.lua, so nothing else changes.

local Table = {}

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterCommand(
    "carp",
    function(source, args)
        local playerperm = ESX.GetPlayerFromId(source).permission_level
        if playerperm >= 5 then
            if args[1] ~= nil then
                exports.oxmysql:scalar(
                    "SELECT vehicle FROM owned_vehicles WHERE plate = @plate",
                    {["plate"] = args[1]},
                    function(data)
                        if not data then
                            TriggerEvent("esx:showNotification", "~r~Mashini Ba In Plak Peyda Nashod!")
                            return
                        end
                        local vehicle = json.decode(data)
                        TriggerClientEvent("Mid_Admin:SpawnVehicle", source, vehicle, args[1])
                        print(vehicle)
                    end
                )
            end
        else
            TriggerEvent("esx:showNotification", "~h~~b~Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra Nadarid!")
        end
    end,
    false
)

