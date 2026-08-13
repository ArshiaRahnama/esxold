fx_version 'cerulean'
game 'gta5'

files {
    -- 'html/index.html',
    -- 'html/css/style.css',
    -- 'html/js/app.js',
    -- 'html/images/water.png',
    -- 'html/images/bread.png',
    "@esx_inventoryhud/html/img/items/*.png"
}

ui_page 'html/index.html'

client_scripts {
    'client.lua',
    'Config.lua',
}

server_scripts {
    'server.lua',
    'Config.lua',
}

-- تنظیمات و فایل‌های اضافی
shared_scripts {
    '@ox_lib/init.lua' -- در صورتی که از ox_lib استفاده می‌کنید
}

lua54 'yes'
