local ESX = nil
local PlayerCoin = 0

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(5)
    end
    TriggerServerEvent("Coin-System:LoadCoin")
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function()
    Wait(1000)
    TriggerServerEvent("Coin-System:LoadCoin")
end)

RegisterNetEvent("Coin-System:PlayerCoin")
AddEventHandler("Coin-System:PlayerCoin", function(coinAmount)
    PlayerCoin = coinAmount
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10 * 1000 * 15)
        local myServerId = GetPlayerServerId(PlayerId())
        TriggerServerEvent("Coin-System:AddTimer", myServerId, 5)
        TriggerServerEvent("Coin-System:ResetCoinTimer", myServerId)
    end
end)

RegisterCommand('setcoin', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
        if aperm >= Config.CoinAdminPermission then
            if not tonumber(args[1]) or not tonumber(args[2]) then
                TriggerEvent('chat:addMessage', { color = { 255, 0, 0 }, multiline = true, args = { "[SYSTEM]", "Lotfan Id va Meghdar Coin Ra Vared Konid!" } })
            else
                if GetPlayerName(GetPlayerFromServerId(tonumber(args[1]))) == "**Invalid**" then
                    return TriggerEvent('chat:addMessage', { color = { 255, 0, 0 }, multiline = true, args = { "[SYSTEM]", "In Id Vojood Nadarad!" } })
                end
                TriggerServerEvent("Coin-System:SetCoin", args[1], args[2])
                TriggerEvent('chat:addMessage', { color = { 255, 0, 0 }, multiline = true, args = { "[SYSTEM]", "Shoma Coin " .. GetPlayerName(GetPlayerFromServerId(tonumber(args[1]))) .. "(" .. args[1] .. ") Ra Be" .. args[2] .. " Taghir Dadid!" } })
            end
        else
            TriggerEvent('chat:addMessage', { color = { 255, 0, 0 }, multiline = true, args = { "[SYSTEM]", "Shoma Admin Nistid!" } })
        end
    end)
end, false)
