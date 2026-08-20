

function SendCafeNUI(msg)
	SendNUIMessage({ __routeTo = 'cafe', payload = msg })
end

function SendMarketNUI(msg)
	SendNUIMessage({ __routeTo = 'market', payload = msg })
end
