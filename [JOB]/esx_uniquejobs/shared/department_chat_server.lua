ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--[[
	Three tiers of internal chat for the 13 department jobs, closest scope first:

	/mp  <msg>  -> reaches only players with your EXACT job        (e.g. CID -> CID)
	/f   <msg>  -> reaches your whole DEPARTMENT                    (e.g. any DOJ job -> all DOJ jobs)
	/dep <msg>  -> reaches EVERY department job, DOJ + LE + Organ   (cross-department, all 13 jobs)

	Anyone not currently on one of the 13 department jobs gets a notification
	and nothing is sent. This file only needs `Departments` / GetDepartmentForJob
	from shared/departments.lua (loaded earlier as a shared_script).
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

RegisterCommand('f', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end

	local dept = GetDepartmentForJob(xPlayer.job.name)
	if not dept then
		TriggerClientEvent('esx:showNotification', source, 'You are not on a department job.')
		return
	end

	local message = table.concat(args, ' ')
	if message == '' then return end

	sendToSet(GetDepartmentJobSet(xPlayer.job.name), 'F | ' .. dept.label, { 0, 140, 255 }, xPlayer.name, xPlayer.job.grade_label, message)
end, false)

RegisterCommand('dep', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end

	if not GetDepartmentForJob(xPlayer.job.name) then
		TriggerClientEvent('esx:showNotification', source, 'You are not on a department job.')
		return
	end

	local message = table.concat(args, ' ')
	if message == '' then return end

	local allJobs = {}
	for _, dept in ipairs(Departments) do
		for _, j in ipairs(dept.jobs) do allJobs[j] = true end
	end

	sendToSet(allJobs, 'DEP', { 255, 170, 0 }, xPlayer.name, xPlayer.job.grade_label, message)
end, false)
