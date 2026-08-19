fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Unique RP'
description 'unique_weaponserial -- every weapon gets a unique serial, multiple copies of the same weapon can be carried as separate inventory items, dropping/picking up preserves the serial, and police can look a serial up.'
version '1.0.0'

-- Load order requirement: needs essentialmode (patches xPlayer.addWeapon /
-- xPlayer.removeWeapon per-player via esx:playerLoaded) and
-- esx_inventoryhud (reuses its EXISTING, already-working item drop/pickup
-- system for dropped weapons -- see server/main.lua for why). Both are
-- ensured earlier: essentialmode in the "Base" section of server.cfg,
-- esx_inventoryhud alongside this resource inside [ARSHIA].
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
