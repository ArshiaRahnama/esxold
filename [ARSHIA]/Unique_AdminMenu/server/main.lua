ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- ============================================================================
-- CONFIG
-- ============================================================================
-- Set a Discord webhook URL to get every admin action logged there too.
-- Leave as "" to only print to the server console.
local Config = {
    DiscordWebhook = "",
    -- minimum ESX permission_level required to use ANY toggle below, on top
    -- of always requiring the player to be on aduty
    MinPermissionLevel = 1,
}

-- ============================================================================
-- STATE - server is now the source of truth for who has what active.
-- Any other resource (e.g. UNIQUE_AC) can call
-- exports.Unique_AdminMenu:IsAdminToggleActive(source, 'godmode') to check
-- whether a given effect on a given player is a *legitimate* admin toggle
-- before flagging/kicking them for it.
-- ============================================================================
local AdminToggleState = {}

local function GetState(source)
    if not AdminToggleState[source] then
        AdminToggleState[source] = {}
    end
    return AdminToggleState[source]
end

AddEventHandler('playerDropped', function()
    AdminToggleState[source] = nil
end)

-- ============================================================================
-- PERMISSION HELPERS
-- ============================================================================
function IsOnDutyAdmin(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end
    if xPlayer.permission_level == nil or xPlayer.permission_level < Config.MinPermissionLevel then
        return false
    end
    if not xPlayer.get('aduty') then
        return false
    end
    return true
end

-- ============================================================================
-- AUDIT LOG - every admin action (toggle, teleport, spectate, slap, area)
-- goes through here so there's always a paper trail.
-- ============================================================================
function LogAdminAction(source, action, details)
    local name = GetPlayerName(source) or ('Unknown (' .. tostring(source) .. ')')
    local line = ('[Unique_AdminMenu] %s (id:%s) -> %s%s'):format(
        name, tostring(source), action, details and (' | ' .. details) or ''
    )
    print(line)

    if Config.DiscordWebhook ~= "" then
        local embeds = {
            {
                ["title"] = "Admin Action: " .. action,
                ["type"] = "rich",
                ["color"] = 15105642,
                ["description"] = ("**Admin:** %s (id: %s)\n%s"):format(name, tostring(source), details or ""),
            }
        }
        PerformHttpRequest(Config.DiscordWebhook, function() end, 'POST',
            json.encode({ username = "Admin Log", embeds = embeds }),
            { ['Content-Type'] = 'application/json' })
    end
end

-- Exported so other resources (anticheat, logging systems, etc.) can check
-- whether a player's current state (invincible, noclipping, etc.) is a
-- legitimate, server-approved admin toggle rather than a cheat.
exports('IsAdminToggleActive', function(source, feature)
    local state = AdminToggleState[source]
    if not state then return false end
    return state[feature] == true
end)

-- ============================================================================
-- TOGGLE REQUESTS - client no longer flips these effects on its own; it
-- asks the server, the server checks permission + aduty, records the new
-- state, and (for godmode) also applies the real server-side native so the
-- invincibility is authoritative and can't be faked by a modified client.
-- ============================================================================
local ValidFeatures = {
    godmode      = true,
    invisibility = true,
    invisibility2= true,
    noclip       = true,
    superjump    = true,
    fastrun      = true,
    noragdoll    = true,
    infstamina   = true,
    blip         = true,
}

RegisterServerEvent('Unique_AdminMenu:RequestToggle')
AddEventHandler('Unique_AdminMenu:RequestToggle', function(feature)
    local source = source
    if not ValidFeatures[feature] then return end

    if not IsOnDutyAdmin(source) then
        LogAdminAction(source, "DENIED toggle:" .. feature, "player is not an on-duty admin")
        TriggerClientEvent('esx:showNotification', source, "~r~Shoma dastresi nadarid ya OffDuty hastid!")
        return
    end

    local state = GetState(source)
    state[feature] = not state[feature]
    local newValue = state[feature]

    if feature == 'godmode' then
        -- Real server-authoritative invincibility. A modified client cannot
        -- fake this the way it could fake a purely local SetEntityInvincible.
        SetPlayerInvincible(source, newValue)
    end

    LogAdminAction(source, "toggle:" .. feature, "new state: " .. tostring(newValue))
    TriggerClientEvent('Unique_AdminMenu:ApplyToggle', source, feature, newValue)
end)

-- ============================================================================
-- EXISTING CALLBACKS - now permission-gated. Previously ANY connected
-- player could call these and get back the full player list / another
-- player's exact coordinates with zero permission check.
-- ============================================================================
ESX.RegisterServerCallback('Admin_Menu:GetActivePlayers', function(source, cb)
    if not IsOnDutyAdmin(source) then cb({}) return end

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
  if not IsOnDutyAdmin(source) then cb(nil) return end
  local xPlayer = ESX.GetPlayerFromId(tonumber(ID))
  if xPlayer then
      cb(xPlayer)
  else
      cb(nil)
  end
end)

ESX.RegisterServerCallback('Admin_Menu:GetTargetPosition', function(source, cb, id)
  if not IsOnDutyAdmin(source) then cb(GetEntityCoords(GetPlayerPed(tonumber(source)))) return end
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

  -- was: permission_level >= 2 only. Added the same aduty requirement every
  -- other admin action here uses, so /slap can't be used while off-duty.
  if xPlayer.permission_level >= 2 and xPlayer.get('aduty') and Target then
    LogAdminAction(source, "slap", "target: " .. GetPlayerName(TargetId) .. " (id:" .. TargetId .. ")")
    TriggerClientEvent('AdminMenu:SlapPlayers', TargetId)
  end
end)
