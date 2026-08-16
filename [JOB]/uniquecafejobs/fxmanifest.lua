fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Arshia | arshiahub.ir'
description 'Unique Cafe Jobs - multi-cafe crafting job (UwU Café / Obsidian Brew / Voltage Coffee Co.) + the uwumarket player marketplace, bundled into one resource'
version '1.0.0'

-- shared/cafes.lua is the single source of truth for the 3 cafes (job name,
-- society, station coordinates). Add a 4th cafe by copying a block in there -
-- nothing else needs to change, every file below already loops over `Cafes`.

shared_scripts {
	'@essentialmode/locale.lua',
	'@ox_lib/init.lua',
	'locales/en.lua',
	'shared/cafes.lua',
	'shared/menu.lua',
	'shared/configcrafting.lua',
	'shared/market_products.lua',
	'shared/newbiz_items.lua',
	'shared/corp.lua',
}

client_scripts {
	'client/nui_router.lua',
	'client/main.lua',
	'client/items.lua',
	'client/newbiz_items.lua',
	'client/functions.lua',
	'client/crafting_cl.lua',
	'client/market_client.lua',
	'client/corp_client.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua',
	'server/items.lua',
	'server/newbiz_items.lua',
	'server/crafting_sv.lua',
	'server/market_config.lua',
	'server/market_server.lua',
	'server/corp_server.lua',
}

ui_page 'html/index.html'

files {
	'html/index.html',

	'html/cafe/form.html',
	'html/cafe/css.css',
	'html/cafe/script.js',
	'html/cafe/jquery-3.4.1.min.js',

	'html/market/index.html',
	'html/market/css/*.css',
	'html/market/js/*.js',
	'html/market/js/*.js.map',
	'html/market/img/*.png',
	'html/market/favicon.ico',

	'@esx_inventoryhud/html/img/items/*.png',
}

dependencies {
	'essentialmode',
	'esx_society',
	'mysql-async',
	'ox_lib',
	'esx_inventoryhud',
}
