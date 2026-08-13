fx_version 'bodacious'
games { 'gta5' }
lua54 'yes'

ui_page 'ui/index.html'
files {
    'ui/**',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua', -- ✅ اضافه شد: ماژول achievements به global MySQL نیاز داره
	'config.lua', -- ✅ کانفیگ مرکزی - باید قبل از همه‌ی ماژول‌ها لود بشه
	'modules/**/config.lu*',
	'modules/**/config_server.lu*',
	'modules/**/common/**/*.lua',
	'modules/**/server/**/*.lua',
}

client_scripts {
	'@ox_lib/init.lua',
    'config.lua', -- ✅ کانفیگ مرکزی - باید قبل از همه‌ی ماژول‌ها لود بشه
    'main.lua',
	'modules/*/config.lu*',
	'modules/**/client/**/config.lua',
	'modules/**/common/**/*.lua',
	'modules/**/client/**/*.lua',
}

dependency 'oxmysql' -- ✅ اضافه شد: مطمئن میشه oxmysql قبل از Unique_Ui استارت میشه