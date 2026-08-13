fx_version 'cerulean'
game 'gta5'

author 'Arshia / arshiahub.ir'
version '1.0.0'
ui_page 'html/index.html'
lua54 'yes'
shared_script '@ox_lib/init.lua'

client_scripts {
    'Config.lua',
    'Client/*.lua'
}

server_scripts{
    'Config.lua',
    'Server/*.lua',
    "@mysql-async/lib/MySQL.lua"
}

files {
    'html/index.html',
    'html/css/*.css',
    'html/*.css',
    'html/js/*.js',
    'html/js/*.js.map',
    'html/img/*.png',
    'html/img/*.jpg',
    'html/img/*.gif',
    -- 'html/_sounds/*.mp3',
    "@esx_inventoryhud/html/img/items/*.png"
}