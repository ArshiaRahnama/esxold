ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_barbershop:pay')
AddEventHandler('esx_barbershop:pay', function()

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeMoney(Config.Price)

	TriggerClientEvent('esx:showNotification', source, "Shoma Mablagh ~g~" .. '$' .. Config.Price.. "~0~ Pardakhtid!")

end)

ESX.RegisterServerCallback('esx_barbershop:checkMoney', function(source, cb)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.get('money') >= Config.Price then
		cb(true)
	else
		cb(false)
	end

end)
