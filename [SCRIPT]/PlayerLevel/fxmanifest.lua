
fx_version('cerulean')
games({ 'gta5' })

version '1.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'config.lua',
	'Server/mainxp_sv.lua'
}

client_scripts { 
	'@essentialmode/locale.lua',
	'config.lua',
	'Client/mainxp_cl.lua'
}









