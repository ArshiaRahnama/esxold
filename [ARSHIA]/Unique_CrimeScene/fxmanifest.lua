fx_version 'cerulean'
game 'gta5'

author 'Arshia | arshiahub.ir | Unique RP'
description 'DOJ Crime Scene Investigation System - runs alongside Unique_RobSystem, does not modify it'
version '1.0.0'

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
