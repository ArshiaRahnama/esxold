


Config	   		    = {}
Locales             = {}
Config.Locale       = 'en' --Change Language en = english - ir = persian | Taghir Zaban Script en = khareji - ir = irani
Config.ESX 			= 'esx:getSharedObject' -- Default esx:getSharedObject
Config.CoinItem     = false




















































-- ================================= --
-- ========= don't touch =========== --
-- ================================= --

function Command(Command, func)
	RegisterCommand(Command, func)
end

function Client(eventName, func)
	RegisterNetEvent(eventName)
	AddEventHandler(eventName, func)
end

function Server(eventName, func)
	RegisterServerEvent(eventName)
	AddEventHandler(eventName, func)
end

function _(str, ...)
    if Locales[Config.Locale] ~= nil then
        if Locales[Config.Locale][str] ~= nil then
            return string.format(Locales[Config.Locale][str], ...)
        else
            return "Moshkel Dar Rabete Ba Locale Pish Omade Be ScArY Elam Konid!"
        end
    else
        return "Moshkel Dar Rabete Ba Locale Pish Omade Be ScArY Elam Konid!"
    end
end

function _U(str, ...)
    return tostring(_(str, ...):gsub("^%l", string.upper))
end

-- ================================== --
-- ========= Dast Nazanid =========== --
-- ================================== --


