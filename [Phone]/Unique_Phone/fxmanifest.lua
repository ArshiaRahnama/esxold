fx_version 'adamant'

game 'gta5'

lua54 'yes'

client_scripts {
    '@ox_lib/init.lua',
    'client/*.lua',
    'config.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua',
    'config.lua',
}

shared_script '@esx_inventoryhud/html/img/vehicle/*.png'

ui_page "html/index.html"

files {
    'html/*.html',
    'html/js/*.js',
    'html/img/*.png',
    'html/img/jobs/*.png',
    'html/css/*.css',
    'html/fonts/*.ttf',
    'html/fonts/*.otf',
    'html/fonts/*.woff',
    'html/img/backgrounds/*.png',
    'html/img/apps/*.png',
}


