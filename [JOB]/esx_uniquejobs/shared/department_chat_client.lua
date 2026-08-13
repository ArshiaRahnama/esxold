-- Adds nicer autocomplete hints for the department chat commands.
-- (The base chat resource already auto-lists every RegisterCommand, this just
-- adds the /f, /dep, /mp entries with proper argument hints & descriptions.)
CreateThread(function()
	Wait(1000)
	TriggerEvent('chat:addSuggestion', '/mp', 'Chat with your own job only (e.g. CID -> CID)', {
		{ name = 'message', help = 'Message to send' },
	})
	TriggerEvent('chat:addSuggestion', '/f', 'Chat with your whole department (DOJ / Law Enforcement / Organ Services)', {
		{ name = 'message', help = 'Message to send' },
	})
	TriggerEvent('chat:addSuggestion', '/dep', 'Chat with every department job (DOJ + Law Enforcement + Organ Services)', {
		{ name = 'message', help = 'Message to send' },
	})
end)
