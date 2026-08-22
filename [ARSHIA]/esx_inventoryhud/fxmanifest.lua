fx_version 'bodacious'
game 'gta5'

dependency 'oxmysql'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/**.lua',
    'modules/**/server/**.lua'
}
client_scripts {
    'client/**.lua',
    'modules/**/client/**.lua'
}

shared_scripts {
    'shared/**.lua'
}

shared_script {
    'modules/**/common/**.lua'
}

ui_page 'html/index.html'


files {
    'html/**',
}
