fx_version 'bodacious'
game 'gta5'

description 'Unique Punishment (Jail + Community Service)'
author 'Arshia'

-- litesql/mysql-async روی این سرور نیستن؛ oxmysql (که ensure شده) با
-- lib/MySQL.lua خودش همون MySQL.Async/MySQL.Sync/MySQL.ready رو میده
shared_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua'
}

client_scripts {
	'client/utils.lua',
	'client/jail.lua',
	'client/cs.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/jail.lua',
	'server/cs.lua'
}
