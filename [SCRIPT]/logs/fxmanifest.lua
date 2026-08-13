fx_version 'bodacious'
game 'gta5'

description 'Discord Bot' 			-- Resource Description

server_script {						-- Server Scripts
	'shared/*.lua',
	'SERVER/Server.lua',
}

client_script {						-- Client Scripts
	'shared/*.lua',
	'CLIENT/*.lua',
}


