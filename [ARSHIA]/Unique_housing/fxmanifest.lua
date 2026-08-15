fx_version 'adamant'
game 'gta5'
description 'Sunset housing'
lua54 'yes'
dependency 'oxmysql'
server_scripts {
    'config_sv.lua',
    '@oxmysql/lib/MySQL.lua',
    'server/db.lua',
    'server/load.lua',
    'server/inventory.lua',
    'server/main.lua',
}

ui_page 'object/nui/furniture.html'
client_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'client/*.lua',
    'object/config.lua',
    'object/src/utils.lua',
    'object/src/client/disablecontrols.lua',
    'object/src/client/main.lua',
}

files {
    'object/nui/furniture.html',
    'object/nui/aim.png',
    'object/nui/back.png',
    'object/nui/cancel.png',
    'object/nui/dec.png',
    'object/nui/down.png',
    'object/nui/edit.png',
    'object/nui/exit.png',
    'object/nui/forward.png',
    'object/nui/icon1.png',
    'object/nui/inc.png',
    'object/nui/left.png',
    'object/nui/remove.png',
    'object/nui/right.png',
    'object/nui/slide.png',
    'object/nui/test.png',
    'object/nui/up.png',
    'object/nui/affirm-detuned.wav',
    'object/nui/affirm-melodic2.wav',
    'object/nui/affirm-melodic3.wav',
    'object/nui/alert-echo.wav',
    'object/nui/camera_click.wav',
    'object/nui/click-analogue-1.wav',
    'object/nui/click-round-pop-1.wav',
    'object/nui/click-round-pop-2.wav',
    'object/nui/click-round-pop-3.wav',
}

files {
	'stream/shellpropsv3.ytyp',
	'stream/shellpropsv4.ytyp',
	'stream/shellpropv2s.ytyp',
	'stream/shellpropsv5.ytyp',
	'stream/shellprops.ytyp',
	'stream/shellpropsv7.ytyp',
	'stream/shellpropsv8.ytyp',
	'stream/shellpropsv10.ytyp',
	'stream/shellpropsv9.ytyp'
}

data_file 'DLC_ITYP_REQUEST' 'shellprops.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv5.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv2.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv4.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv3.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv7.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv8.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv10.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv9.ytyp'


this_is_a_map 'yes'