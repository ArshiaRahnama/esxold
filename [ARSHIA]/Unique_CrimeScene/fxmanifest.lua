fx_version 'cerulean'
game 'gta5'
lua54 'yes' -- required by ox_lib

author 'Arshia | arshiahub.ir | Unique RP'
description 'DOJ Crime Scene Investigation System - runs alongside Unique_RobSystem, does not modify it'
version '1.0.0'

shared_script '@ox_lib/init.lua' -- required for lib.skillCheck / lib.notify — make sure ox_lib is started before this resource

shared_script 'config.lua'

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/style.css',
	'html/script.js'
}

client_script 'client/main.lua'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua'
}
