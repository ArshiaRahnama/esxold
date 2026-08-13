
--[[ 
 █████╗ ███╗   ███╗██╗██████╗     ██╗  ██╗██╗██████╗ ██████╗ ███████╗███╗   ██╗
██╔══██╗████╗ ████║██║██╔══██╗    ██║  ██║██║██╔══██╗██╔══██╗██╔════╝████╗  ██║
███████║██╔████╔██║██║██████╔╝    ███████║██║██║  ██║██║  ██║█████╗  ██╔██╗ ██║
██╔══██║██║╚██╔╝██║██║██╔══██╗    ██╔══██║██║██║  ██║██║  ██║██╔══╝  ██║╚██╗██║
██║  ██║██║ ╚═╝ ██║██║██║  ██║    ██║  ██║██║██████╔╝██████╔╝███████╗██║ ╚████║
╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═╝    ╚═╝  ╚═╝╚═╝╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝                                                                           
]]

fx_version('cerulean')
games({ 'gta5' })

description 'AH Uwucafe Job'
version '1.0.0'

lua54 'yes'

server_scripts{
    '@mysql-async/lib/MySQL.lua',
	'@essentialmode/locale.lua',
    '@ox_lib/init.lua',
	'locales/en.lua',
    'Shared/*.lua',
    'server/main.lua',
    'server/items.lua',
    'server/crafting_sv.lua',
}

client_scripts{
    '@essentialmode/locale.lua',
	'locales/en.lua',
    'Shared/*.lua',
    '@ox_lib/init.lua',
    'Client/main.lua',
    'Client/items.lua',
    'Client/functions.lua',
    'Client/crafting_cl.lua',
}

ui_page 'html/form.html'

files {
	'html/form.html',
	'html/css.css',
	'html/script.js',
	'html/jquery-3.4.1.min.js',
	'@esx_inventoryhud/html/img/items/*.png',
}

shared_script '@esx_inventoryhud/html/img/items/*.png'




