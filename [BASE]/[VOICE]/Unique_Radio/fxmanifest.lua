fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'Unique_Radio'
author 'ArshiaRahnama (merged & fixed)'
description 'Unique_Radio - Handheld radio (frequencies/items) + on-screen radio member list, merged into a single resource for pma-voice/ESX'
version '1.0.0'

-- pma-voice handles proximity/radio voice, ox_lib is used for notifications.
-- oxmysql is OPTIONAL: only used as a fallback if Config.RadioList.UseRPName = true
-- and no framework (ESX/QB/JLRP) is detected on the server.
dependencies {
	'pma-voice',
	'ox_lib',
}

ui_page 'ui/index.html'

files {
	'ui/index.html',
	'ui/call.png',
	'ui/on.ogg',
	'ui/off.ogg',
}

shared_scripts {
	'config.lua',
}

client_scripts {
	'@ox_lib/init.lua', -- provides the global `lib` used by lib.notify
	'client.lua',
}

server_scripts {
	'server.lua',
}
