CreateThread(function()
	Wait(1000)
	TriggerEvent('chat:addSuggestion', '/biz', 'Chat with your own business/holding team only', {
		{ name = 'message', help = 'Message to send' },
	})
end)
