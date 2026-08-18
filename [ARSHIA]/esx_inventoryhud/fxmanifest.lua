fx_version 'bodacious'
game 'gta5'

server_scripts {
    '@litesql/lib/MySQL.lua',
    'server/**.lua',
    'modules/**/server/**.lua'
}
client_scripts {
    'shared/config.lua',
    'client/**.lua',
    'modules/**/client/**.lua'
}

shared_script {
    'modules/**/common/**.lua'
}

ui_page 'ui/index.html'


files {
    'ui/**',
}
