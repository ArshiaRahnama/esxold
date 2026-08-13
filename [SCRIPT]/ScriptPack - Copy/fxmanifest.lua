fx_version 'adamant'
games {'gta5'}


lua54 'yes'

client_scripts {
	'@essentialmode/locale.lua',
	'@ox_lib/init.lua', -- provides the global `lib` used by lib.notify
	'config.lua',
	'client/*.lua',
	'config.lua',
	'locales/*.lua',  
	'client/bastan-r-q-cl.lua',
	'autorules/client.lua',
	'autorules/config.lua',
}

server_scripts {
	'@essentialmode/locale.lua',
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/*.lua',
	'config.lua',
	'locales/*.lua',
	'autorules/config.lua',
}

server_exports {
	'GangLog',
	'HomeLog',
	'TrunkLog',
	'TransferLog',
	'TransActionLog',
	'RobLog',
	'RobLogF',
	'GetDiscord',
	'AddProp',
	'AddPed',
	'AddVehicle',
	'RewardAll'
}

exports {
	'GetVehicles',
	'Impoundsheriff',
	'ImpoundPolice',
	'getMaxSpeedInOffroad',
	'getVar',
}


