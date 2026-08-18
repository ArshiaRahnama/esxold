
fx_version 'cerulean'
game 'gta5' 

description 'Unique Jail System'
version '1.1.2'
author 'Unique Development'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts { 
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}






