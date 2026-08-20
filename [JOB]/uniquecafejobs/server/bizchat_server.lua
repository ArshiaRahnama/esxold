

local function isUniqueCafeJob(job)
	return IsCafeJob(job) or IsCorpJob(job) or job == TurfCo.Job
end

RegisterCommand('biz', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end

	if not isUniqueCafeJob(xPlayer.job.name) then
		TriggerClientEvent('esx:showNotification', source, 'You are not on a business/holding job.')
		return
	end

	local message = table.concat(args, ' ')
	if message == '' then return end

	local displayLabel = xPlayer.job.name
	local cafe = GetCafeForJob(xPlayer.job.name)
	if cafe then
		displayLabel = GetDisplayLabel(cafe.Job, cafe.Label)
	elseif xPlayer.job.name == Corp.Meridian.Job then
		displayLabel = GetDisplayLabel(Corp.Meridian.Job, Corp.Meridian.Label)
	elseif xPlayer.job.name == Corp.Blacktide.Job then
		displayLabel = GetDisplayLabel(Corp.Blacktide.Job, Corp.Blacktide.Label)
	elseif xPlayer.job.name == Corp.CrateCarry.Job then
		displayLabel = GetDisplayLabel(Corp.CrateCarry.Job, Corp.CrateCarry.Label)
	elseif xPlayer.job.name == TurfCo.Job then
		displayLabel = GetDisplayLabel(TurfCo.Job, TurfCo.Label)
	end

	local xPlayers = ESX.GetPlayers()
	for i = 1, #xPlayers do
		local xTarget = ESX.GetPlayerFromId(xPlayers[i])
		if xTarget and xTarget.job.name == xPlayer.job.name then
			TriggerClientEvent('chatMessage', xPlayers[i], '', { 0, 200, 120 },
				('[BIZ | %s] %s: %s'):format(displayLabel, xPlayer.name, message))
		end
	end
end, false)
