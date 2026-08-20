fx_version 'adamant'

game 'gta5'

version '1.0.1'

shared_scripts {
	'config.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua',
}

client_scripts {
	'client/*.lua'
}

files {
	'background.png'
}
