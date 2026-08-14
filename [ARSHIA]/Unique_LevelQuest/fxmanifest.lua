fx_version 'cerulean'
games { 'gta5' }

author 'arshiahub.ir'
description 'Unique Level/XP + Daily Quest + HUD Menu (merged: XP_Level_System + QuestSystem + Interaction_Menu)'
version '2.0.0'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server/core.lua',
    'server/xp.lua',
    'server/quest.lua',
    'server/bridges.lua',
    'server/menu.lua',
}

client_scripts {
    'config.lua',
    'client/xp.lua',
    'client/quest.lua',
    'client/bridges.lua',
    'client/menu.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/scripts/*.js',
    'html/styles/*.css',
    'html/fonts/*.*',
}
