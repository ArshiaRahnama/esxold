fx_version 'adamant'

game 'gta5'

version '1.0.1'

-- FIX: 'litesql' resource does not exist on this server. oxmysql (already ensured
-- in server.cfg) declares `provide 'mysql-async'` / `provide 'ghmattimysql'` but NOT
-- 'litesql', so this MUST reference oxmysql directly or the resource fails to start.
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
