ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--[[
	Only /mp lives here.

	/f and /dep are ALREADY implemented in [SCRIPT]/ScriptPack/server/dispatch-sv.lua
	(with a proper organGroups table + off-duty handling) - registering them again
	here would just create a duplicate RegisterCommand conflict. Only /mp (own job
	only, e.g. CID -> CID) was missing anywhere in the codebase, so that's the only
	one added in this file.
]]

local function sendToSet(jobSet, tag, color, senderName, senderGradeLabel, message)
	local xPlayers = ESX.GetPlayers()
	for i = 1, #xPlayers do
		local xTarget = ESX.GetPlayerFromId(xPlayers[i])
		if xTarget and jobSet[xTarget.job.name] then
			TriggerClientEvent('chatMessage', xPlayers[i], '', color,
				('[%s | %s] %s: %s'):format(tag, senderGradeLabel, senderName, message))
		end
	end
end

RegisterCommand('mp', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end

	if not GetDepartmentForJob(xPlayer.job.name) then
		TriggerClientEvent('esx:showNotification', source, 'You are not on a department job.')
		return
	end

	local message = table.concat(args, ' ')
	if message == '' then return end

	sendToSet({ [xPlayer.job.name] = true }, 'MP', { 0, 200, 120 }, xPlayer.name, xPlayer.job.grade_label, message)
end, false)
