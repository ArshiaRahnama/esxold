ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
-- BUGFIX: server-side, essentialmode answers 'esx:getSharedObject' synchronously
-- (unlike the client, which has to wait a tick for the network round-trip).
-- The previous version of this file wrapped this in a Citizen.CreateThread
-- wait-loop (copying the client-side idiom), which meant ESX.RegisterServerCallback
-- below ran on the SAME tick, before the thread ever got a chance to run once -
-- so it crashed with "attempt to index a nil value (global 'ESX')" on resource
-- start, the callback never got registered, and every /handling attempt just
-- hung forever waiting for a server response that would never come.

-- SECURITY FIX: the original resource only checked ESX.GetPlayerData().perm
-- CLIENT-SIDE, which is trivially spoofable by any mod menu / cheat client -
-- the server never verified anything, it just trusted whatever the client said.
-- Kept as a local (not global Config) so it can never clash with ScriptPack's
-- own global Config table or with anything else merged into this resource.
local BABICZ_REQUIRED_PERM = 5

local function HasHandlingPermission(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return false end
	return (xPlayer.permission_level or 0) >= BABICZ_REQUIRED_PERM
end

-- The client now asks the server before it's allowed to open the UI at all,
-- instead of only trusting its own local copy of the permission level.
ESX.RegisterServerCallback('babiczhandling:checkPermission', function(source, cb)
	cb(HasHandlingPermission(source))
end)

-- Audit trail: every open + every saved/named handling change is logged to
-- the server console (who, when, which plate). If a modified client skips
-- the client-side gate and fires these events directly anyway, the server
-- re-checks permission itself and simply refuses to log it as legitimate -
-- the attempt (and the player's server id) still shows up so admins can act.
RegisterServerEvent('babiczhandling:logOpen')
AddEventHandler('babiczhandling:logOpen', function(plate)
	local src = source
	local name = GetPlayerName(src) or ('id ' .. tostring(src))
	if not HasHandlingPermission(src) then
		print(('^1[BabiczHandlingEditor] BLOCKED^0 unauthorized open attempt by %s (server id %s) - insufficient permission_level'):format(name, src))
		return
	end
	print(('^3[BabiczHandlingEditor]^0 %s (id %s) opened the handling editor - plate: %s'):format(name, src, tostring(plate)))
end)

RegisterServerEvent('babiczhandling:logSave')
AddEventHandler('babiczhandling:logSave', function(handlingName, plate)
	local src = source
	local name = GetPlayerName(src) or ('id ' .. tostring(src))
	if not HasHandlingPermission(src) then
		print(('^1[BabiczHandlingEditor] BLOCKED^0 unauthorized save attempt by %s (server id %s)'):format(name, src))
		return
	end
	print(('^3[BabiczHandlingEditor]^0 %s (id %s) saved handling "%s" - plate: %s'):format(name, src, tostring(handlingName), tostring(plate)))
end)
