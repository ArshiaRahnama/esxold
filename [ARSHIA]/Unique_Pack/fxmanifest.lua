fx_version 'cerulean'
game 'gta5'

author 'Unique RP'
description 'Unique_Flat_Bundle - HUNT, Megaphone, antipg, bzzz_addon_props_powerhouse, esx_fireworks, fightban, gang_mapings, joblist, notbad-rockstar-editor, pedshop, pmp_st_sweet, Unique_Scripts_Badge, Unique_Boxing, Unique_Scripts_NPC_Doctors, Unique_Scripts_Switchjob, maket_guns, Unique_Scripts_minimap_healdeleter, Unique_Scripts_vehicle_damage, Unique_Scripts_Washmoney, Unique_Scripts_item_mc, weapons-on-back'
version '1.0.0'
lua54 'yes'

-- وابستگی‌های لازم (باید جدا نصب/ensure بشن): oxmysql, pma-voice, ox_lib, ox_target
-- okokNotify حذف شد؛ نوتیفیکیشن‌ها به ox_lib (lib.notify) منتقل شدند
dependency 'pma-voice'
dependency 'ox_lib'
dependency 'ox_target'

shared_scripts {
    'config.lua',
}

client_scripts {
    '@ox_lib/init.lua', -- provides the global `lib` used by lib.notify
    'client.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua',
}

-- فایل‌های باینری (مدل/پراپ/انیمیشن) - همه تو یک پوشه‌ی stream واحد
files {
    'stream/molly@megaphone.ycd',
    'stream/molly@megaphone2.ycd',
    'stream/prop_fib_badge.ydr',
    'stream/prop_fib_badge+hidr.ytd',
    'stream/hud_reticle.gfx',
    'stream/minimap.gfx',
}
data_file 'DLC_ITYP_REQUEST' 'stream/*.ytyp'

file 'peds.meta'
data_file 'PED_METADATA_FILE' 'peds.meta'
