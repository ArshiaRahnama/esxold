fx_version 'adamant'
games {'gta5'}

client_scripts {
	'@essentialmode/locale.lua',
	'@ox_lib/init.lua', -- provides the global `lib` used by lib.notify
	'config.lua',
	'client/*.lua',
	'config.lua',
	'locales/*.lua',  
}

server_scripts {
	'@essentialmode/locale.lua',
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/*.lua',
	'config.lua',
	'locales/*.lua'
}
