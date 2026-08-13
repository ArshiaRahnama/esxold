ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('Admin_Menu:GetActivePlayers', function(source, cb)
    local cX = ESX.GetPlayers()
    local cJ = {}
    for i=1, #cX, 1 do
      local cSource = cX[i]
      local name = GetPlayerName(cSource)
      if name ~= '**Invalid**' then
        cJ[cSource] = name
      end
    end
    cb(cJ)
end)

ESX.RegisterServerCallback('esx_spectate:xPlayerServerSide', function(source, cb, ID)
  local xPlayer = ESX.GetPlayerFromId(tonumber(ID))
  if xPlayer then
      cb(xPlayer)
  else
      cb(nil)
  end
end)

ESX.RegisterServerCallback('Admin_Menu:GetTargetPosition', function(source, cb, id)
  local sPlayer = ESX.GetPlayerFromId(tonumber(id))
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer and sPlayer then
    cb(GetEntityCoords(GetPlayerPed(tonumber(id))))
  else
    cb(GetEntityCoords(GetPlayerPed(tonumber(source))))
  end
end)

ESX.RegisterServerCallback('esx_spectate:RequestPermission', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  cb(tonumber(xPlayer.permission_level))
end)

ESX.RegisterServerCallback('esx_spectate:RequestDutyStatus', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer.get('aduty') then
      cb(true)
  else
      cb(false)
  end
end)

RegisterCommand('slap', function(source, args)
  if not tonumber(args[1]) then return end
  local TargetId = tonumber(args[1])
  local xPlayer = ESX.GetPlayerFromId(source)
  local Target = ESX.GetPlayerFromId(TargetId)

  if xPlayer.permission_level >= 2 and Target then 
    TriggerClientEvent('AdminMenu:SlapPlayers', TargetId)
  end
end)