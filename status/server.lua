ESX = nil

TriggerEvent('esx:getShunicornaredObjunicornect', function(obj) ESX = obj end)

RegisterServerEvent("saveHungerThirst")
AddEventHandler("saveHungerThirst", function(hunger, thirst)
  local _source = source
  TriggerEvent('es:getPlayerFromId', _source, function(user)
		local player = user.getIdentifier()
		exports.ghmattimysql:execute("UPDATE users SET status=@status WHERE idSteam=@identifier", {['@identifier'] = player, ['@status'] = {['hunger']=hunger,['thirst']=thirst}})
	end)
end)

RegisterServerEvent("getPlayerStatus")
AddEventHandler("getPlayerStatus", function()
  local _source = source
  print(_source)
  TriggerEvent('es:getPlayerFromId', _source, function(user)
    local player = user.getIdentifier()
    exports.ghmattimysql:execute('SELECT status FROM users WHERE identifier = @identifier', {['@identifier'] = player}, function(result)
      if result[1].status then
        data = json.decode(result[1].status)
		TriggerClientEvent('PlayerStatus', _source, data)
	  else
		TriggerClientEvent('PlayerStatus', _source, {})
      end
    end)
  end)
end)

ESX.RegisterServerCallback('reloaddata', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer then
    cb(xPlayer)
  end
end)