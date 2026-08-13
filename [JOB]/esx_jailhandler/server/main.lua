ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Booking tools (prison jumpsuit / mugshot) available to Law Enforcement + all DOJ jobs ("doc" kept for legacy compat)
local function IsBookingJob(jobName)
	return jobName == "police" or jobName == "sheriff" or jobName == "mt"
		or jobName == "fbi" or jobName == "cid" or jobName == "cia" or jobName == "marshal" or jobName == "judge" or jobName == "doa"
		or jobName == "doc"
end


RegisterCommand('pj', function(source, args, users)

    local xPlayer = ESX.GetPlayerFromId(source)

        if IsBookingJob(xPlayer.job.name) then

            if args[1] then

                local target = tonumber(args[1])

                    if target then

                        if GetPlayerName(target) then

                            if args[2] then

                                if args[2] == "true" or args[2] == "false" then

                                    if args[2] == "true" then

                                        TriggerClientEvent('esx_jailhandler:statusHandler', target, true)

                                    elseif args[2] == "false" then

                                        TriggerClientEvent('esx_jailhandler:statusHandler', target, false)

                                    end

                                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma vaziat avaz kardan lebas ^2 " .. GetPlayerName(target) .. " ^0Ra be ^3" .. args[2] .. "^0 taghir dadid!")

                                else
                                    TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat status faghat mitavanid true/false vared konid!")
                                end

                            else
                                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat status chizi vared nakardid!")
                            end

                        else
                            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Player mored nazar online nist!")
                        end

                    else
                        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!")
                    end

            else
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID chizi vared nakardid!")
            end

        else

            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma police nistid!")

        end

end)

RegisterCommand('mug', function(source)

    local xPlayer = ESX.GetPlayerFromId(source)

    if IsBookingJob(xPlayer.job.name) then

        TriggerClientEvent('esx_jailhandler:domugshot', source)
    
    else

        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma police nistid!")

    end



end)