fx_version 'bodacious'
games {'gta5'}

description 'Daily Quest System By arshiahub.ir'
version 'v1.0.0'

server_scripts{
	'@mysql-async/lib/MySQL.lua',
	'files/Server.lua',
}

client_scripts {
	'files/Client.lua'
}

shared_scripts {
	'Config.lua'
}