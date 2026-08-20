fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Unique RP'
description 'unique_weaponserial -- every weapon gets a unique serial, multiple copies of the same weapon can be carried as separate inventory items, dropping/picking up preserves the serial, and police can look a serial up.'
version '1.0.0'

dependency 'esx_inventoryhud'

shared_script '@essentialmode/locale.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/serials.lua',
    'server/main.lua',
}

client_scripts {
    'client/main.lua',
}
