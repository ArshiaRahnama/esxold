fx_version 'cerulean'
game 'gta5'

author 'arshiahub.ir'
description 'XP-Level System'
version '1.0.0'

client_script 'client.lua'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}

shared_script 'config.lua'
