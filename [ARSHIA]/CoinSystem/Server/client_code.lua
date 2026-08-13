local AllCode = [[

ESX = nil
local PlayerData = {}
local Coin = { Num = 0 }

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent(Config.ESX, function(obj) ESX = obj end)
        Citizen.Wait(5)
        PlayerData = ESX.GetPlayerData()
		TriggerServerEvent("Coin-System:LoadCoin")
    end
end)

Client("esx:playerLoaded", function(xPlayer)
	Wait(1000)
	TriggerServerEvent("Coin-System:LoadCoin")
end)

Client("Coin-System:PlayerCoin", function(CoinNumber)
	Coin.Num = CoinNumber
end)

Client("Coin-System:AddCoin", function(CoinNumber)
	TriggerServerEvent("Coin-System:AddCoinCL", CoinNumber)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10*1000*15)
		local players = GetPlayerServerId(PlayerId())
		TriggerServerEvent("Coin-System:AddTimer", players, 5)
		TriggerServerEvent("Coin-System:ResetCoinTimer", players)
	end
end)

-- RegisterCommand('addcoin', function(source, args)
--     ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
--         if aperm >= 8 then
-- 			if not tonumber(args[1]) or not tonumber(args[2]) then
-- 				TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true, args = {"[SYSTEM]", "Lotfan Id va Meghdar Coin Ra Vared Konid!"}})
-- 			else
-- 				if GetPlayerName(GetPlayerFromServerId(tonumber(args[1]))) == "**Invalid**" then return TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true, args = {"[SYSTEM]", "In Id Vojood Nadarad!"}}) end
-- 				TriggerServerEvent("Coin-System:AddCoin", args[1], args[2])
-- 				TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true, args = {"[SYSTEM]", args[2].." Adad Coin Baraye "..GetPlayerName(GetPlayerFromServerId(tonumber(args[1]))).."("..args[1]..") Add Kardid!"}})
-- 			end
-- 		else
-- 			TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true, args = {"[SYSTEM]", "Shoma Admin Nistid!"}})
--         end
--     end)
-- end, false)

-- RegisterCommand('removecoin', function(source, args)
--     ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
--         if aperm >= 8 then
-- 			if not tonumber(args[1]) or not tonumber(args[2]) then
-- 				TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true, args = {"[SYSTEM]", "Lotfan Id va Meghdar Coin Ra Vared Konid!"}})
-- 			else
-- 				if GetPlayerName(GetPlayerFromServerId(tonumber(args[1]))) == "**Invalid**" then return TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true, args = {"[SYSTEM]", "In Id Vojood Nadarad!"}}) end
-- 				TriggerServerEvent("Coin-System:RemoveCoin", args[1], args[2])
-- 				TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true, args = {"[SYSTEM]", args[2].." Adad Coin Az "..GetPlayerName(GetPlayerFromServerId(tonumber(args[1]))).."("..args[1]..") Kam Kardid!"}})
-- 			end
-- 		else
-- 			TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true, args = {"[SYSTEM]", "Shoma Admin Nistid!"}})
--         end
--     end)
-- end, false)

RegisterCommand('setcoin', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
        if aperm >= 8 then
			if not tonumber(args[1]) or not tonumber(args[2]) then
				TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true, args = {"[SYSTEM]", "Lotfan Id va Meghdar Coin Ra Vared Konid!"}})
			else
				if GetPlayerName(GetPlayerFromServerId(tonumber(args[1]))) == "**Invalid**" then return TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true, args = {"[SYSTEM]", "In Id Vojood Nadarad!"}}) end
				TriggerServerEvent("Coin-System:SetCoin", args[1], args[2])
				TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true, args = {"[SYSTEM]", "Shoma Coin "..GetPlayerName(GetPlayerFromServerId(tonumber(args[1]))).."("..args[1]..") Ra Be"..args[2].." Taghir Dadid!"}})
			end
		else
			TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true, args = {"[SYSTEM]", "Shoma Admin Nistid!"}})
        end
    end)
end, false)

-- RegisterCommand('getcoin', function(source, args)
--     ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
-- 		if aperm >= 8 then
-- 		ESX.TriggerServerCallback('Coin-System:GetPlayerCoin', function(Coin)
-- 				if not tonumber(args[1]) or not args[1] then
-- 					TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true, args = {"[SYSTEM]", "Lotfan Id Player Ra Vared Konid!"}})
-- 				else
-- 					if GetPlayerName(GetPlayerFromServerId(tonumber(args[1]))) == "**Invalid**" then return TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true, args = {"[SYSTEM]", "In Id Vojood Nadarad!"}}) end
-- 					TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true, args = {"[SYSTEM]", GetPlayerName(GetPlayerFromServerId(tonumber(args[1]))).."("..args[1]..") Be Meghdar ^3"..Coin.."^0 Coin Darad!"}})
-- 				end
-- 			end, tonumber(args[1]))
-- 		else
-- 			TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true, args = {"[SYSTEM]", "Shoma Admin Nistid!"}})
-- 		end
--     end)
-- end, false)

]]

Server("Coin-System:initialize", function()
	TriggerClientEvent("Coin-System:initialize", -1, AllCode)
end)