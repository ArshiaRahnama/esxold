fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Dev : Arshia - UniqueScript Shop'
description 'BoomBox System'
version '1.5.0'

dependency 'ox_lib'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}
