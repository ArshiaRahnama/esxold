RegisterServerEvent("ServerEmoteRequest")
AddEventHandler("ServerEmoteRequest", function(target, emotename, etype)
	--if exports['Eye-AC']:CheckPlayers(source, target, 8.0) ~= false then return end
	TriggerClientEvent("ClientEmoteRequestReceive", target, emotename, etype)
end)

RegisterServerEvent("ServerValidEmote") 
AddEventHandler("ServerValidEmote", function(target, requestedemote, otheremote)
	--if exports['Eye-AC']:CheckPlayers(source, target, 8.0) ~= false then return end
	TriggerClientEvent("SyncPlayEmote", source, otheremote, source)
	TriggerClientEvent("SyncPlayEmoteSource", target, requestedemote)
end)