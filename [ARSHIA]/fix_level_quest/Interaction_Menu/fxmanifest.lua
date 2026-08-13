fx_version 'cerulean'
games { 'gta5' }

author 'arshiahub.ir'
description 'Interaction Menu'
version '1.0.0'


server_scripts {
    '@mysql-async/lib/MySQL.lua',
	'server.lua',
}
client_scripts {
    '@QuestSystem/Config.lua',
    '@XP_Level_System/config.lua',
	'client.lua'
}

ui_page {
    'html/index.html'
}

files {
    'html/index.html',
    'html/scripts/*.js',
    'html/styles/*.css',
    'html/fonts/*.*',
 -- 'html/img/*.png'
}