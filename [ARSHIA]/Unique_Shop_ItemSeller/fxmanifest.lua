fx_version 'cerulean'
game 'gta5'

author 'Unique RP'
description 'Unique_Shop_ItemSeller -- merged: Unique_Scripts_Shops + Unique_Scripts_ItemSeller (نوتیفیکیشن‌ها روی ox_lib / esx:showNotification هستن)'
version '1.0.0'

lua54 'yes'

shared_scripts {
	'@ox_lib/init.lua',
	'shared.lua',
}

client_scripts {

	'shop/config.lua',
	'shop/client.lua',


	'itemseller/config.lua',
	'itemseller/client.lua',
}

server_scripts {


	'shop/config.lua',
	'shop/server.lua',

	'itemseller/config.lua',
	'itemseller/server.lua',
}

