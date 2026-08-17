fx_version 'adamant'
game 'gta5'

-- needs essentialmode's ESX object, ox_target for the shop zones, and
-- Unique_clothe (its getClothe2 export is the real item catalog this
-- shop sells from) -- make sure Unique_clothe is ensured BEFORE this
-- resource in server.cfg
dependency 'ox_target'
dependency 'Unique_clothe'

ui_page 'html/index.html'

client_scripts {
	'@essentialmode/locale.lua',
	'locales/de.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/es.lua',
	'locales/pl.lua',
	'locales/sv.lua',
	'locales/cs.lua',
	'config.lua',
	'client/main.lua'
}

server_scripts {
	'config.lua',
	'server/main.lua'
}

files {
	'html/index.html',
	'html/style.css',
	'html/app.js',
	'html/logo.png',
	'html/img/*.png',
	'html/Roboto-Regular.ttf'
}

