--================================================================================================
--==                                VARIABLES - DO NOT EDIT                                     ==
--================================================================================================
ESX = nil
local robbed = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('bank:depositx')
AddEventHandler('bank:depositx', function(amount)
	local _source = source
	
	local xPlayer = ESX.GetPlayerFromId(_source)
	if amount == nil or amount <= 0 or amount > xPlayer.money then
		-- advanced notification with bank icon
		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Pardakhte Vajh', 'Meqdare Vorodi Eshtebah ast', 'CHAR_BANK_MAZE', 9)
	else
		xPlayer.removeMoney(amount)
		xPlayer.addBank(tonumber(amount))
		exports.ScriptPack:TransActionLog({source = xPlayer.source, type = "Variz", amount = amount})
                -- advanced notification with bank icon
		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Pardakhte Vajh', 'Shoma ~g~$' .. amount .. '~s~ Dakhele Bank Khod Gozashtid', 'CHAR_BANK_MAZE', 9)
	end
end)

RegisterServerEvent('new_banking:disableforhour')
AddEventHandler('new_banking:disableforhour', function(pos)
	table.insert(robbed, {
		pos = pos,
		timer = GetGameTimer()
	})
	TriggerClientEvent('new_banking:disableforhour',-1, pos, 60 * 60 * 1000)
end)

RegisterServerEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source)
	for _,v in pairs(robbed) do
		local timer = GetGameTimer() - v.timer
		if timer < 3600000 then
			TriggerClientEvent('new_banking:disableforhour', source, v.pos, timer)
		else
			table.remove(robbed, _)
		end
	end
end)

RegisterServerEvent('bank:withdrawx')
AddEventHandler('bank:withdrawx', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local base = 0
	amount = tonumber(amount)
	base = xPlayer.bank
	if amount == nil or amount <= 0 or amount > base then
                 -- advanced notification with bank icon
		
		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Bardashte Vajh', 'Meqdar Eshtebah ast', 'CHAR_BANK_MAZE', 9)
	else
		xPlayer.removeBank(amount)
		xPlayer.addMoney(amount)
				-- advanced notification with bank icon
		exports.ScriptPack:TransActionLog({source = xPlayer.source, type = "Bardasht", amount = amount})
		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Bardashte Vajh', 'Shoma ~r~$' .. amount .. '~s~ Az Hesabe Khod Bardashtid', 'CHAR_BANK_MAZE', 9)
	end
end)

RegisterServerEvent('bank:balance')
AddEventHandler('bank:balance', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	balance = xPlayer.bank
	TriggerClientEvent('currentbalance1', _source, balance)
	
end)

RegisterServerEvent('bank:transferx')
AddEventHandler('bank:transferx', function(to, amountt)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local zPlayer = ESX.GetPlayerFromId(to)
	local balance = 0
	amountt = tonumber(amountt)
	if not amountt then
		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Enteqale Vajh', 'Lotfan Faqat Adad Vared Konid', 'CHAR_BANK_MAZE', 9)
	end
	balance = xPlayer.bank
	zbalance = zPlayer.bank
	if tonumber(_source) == tonumber(to) then
		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Enteqale Vajh', 'Shenase Shakhs Morede Nazar Yaft nashod', 'CHAR_BANK_MAZE', 9)
	else
		if balance <= 0 or balance < tonumber(amountt) or tonumber(amountt) <= 0 then
			TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Enteqale Vajh', 'Mojodi Shoma Kafi nist', 'CHAR_BANK_MAZE', 9)
		else
			xPlayer.removeBank(amountt)
			zPlayer.addBank(amountt)
			exports.ScriptPack:TransferLog({source = xPlayer.source, target = zPlayer.source, type = "transfer", amount = amountt})
			TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Enteqale Vajh', 'Shoma ~r~$' .. amountt .. '~s~ Be ~r~' .. string.gsub(zPlayer.name, "_", " ") .. ' ~s~Enteqal Dadid.', 'CHAR_BANK_MAZE', 9)
			TriggerClientEvent('esx:showAdvancedNotification', to, 'Bank', 'Enteqale Vajh', '~r~$' .. amountt .. '~s~ Az tarafe ~r~' .. string.gsub(xPlayer.name, "_", " ") .. ' ~s~Be hesabe Shoma Variz Shod.', 'CHAR_BANK_MAZE', 9)
		end
	end
end)


RegisterServerEvent('bank:balance')
AddEventHandler('bank:balance', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    balance = xPlayer.bank
    
    -- دریافت IBAN از دیتابیس با استفاده از oxmysql
    local identifier = xPlayer.identifier
    exports.oxmysql:scalar('SELECT iban FROM users WHERE identifier = ?', {identifier}, function(iban)
        if iban == nil then
            -- اگر IBAN وجود نداشت، یک IBAN تصادفی ایجاد کنید
            iban = 'IR' .. math.random(1000000000000000000, 9999999999999999999)
            exports.oxmysql:update('UPDATE users SET iban = ? WHERE identifier = ?', {iban, identifier}, function(affectedRows)
                if affectedRows > 0 then
                    print(('IBAN generated for player %s: %s'):format(xPlayer.name, iban))
                end
            end)
        end
        
        TriggerClientEvent('currentbalance1', _source, balance, iban)
    end)
end)