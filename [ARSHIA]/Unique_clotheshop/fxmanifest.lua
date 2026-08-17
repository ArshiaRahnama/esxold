fx_version 'cerulean'
game 'gta5'

author 'Unique RP'
description 'Unique_ClotheShop -- merged clothing shop (replaces the old Unique_clothe + Unique_clotheshop). Sells clothing zones/blips and gives out items in the exact clothe_<type>_<drawable>_<texture> format that esx_inventoryhud already knows how to wear, weigh and persist, so there is no separate wear/inventory system to keep in sync.'
version '2.0.0'

-- Load order requirement: this resource only needs ESX (essentialmode),
-- ox_target (for the shop interaction zones) and esx_inventoryhud (which
-- already owns clothing wear + DB persistence, tables player_worn_clothes
-- / player_clothe_packs). Make sure all three are ensured BEFORE this
-- resource in server.cfg -- inside [ARSHIA] that is already true because
-- esx_inventoryhud is ensured as part of [ARSHIA] together with this one,
-- and essentialmode / ox_target are both ensured in the "Base" section,
-- which loads earlier in server.cfg.
dependency 'ox_target'
dependency 'esx_inventoryhud'

ui_page 'html/index.html'

shared_scripts {
    'config.lua',
}

client_scripts {
    '@essentialmode/locale.lua',
    'locales/en.lua',
    'client/main.lua',
}

server_scripts {
    'server/main.lua',
}

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'html/Roboto-Regular.ttf',
}
