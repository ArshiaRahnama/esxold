fx_version 'adamant'
games {'gta5'}


lua54 'yes'

-- وابستگی‌های لازم (باید جدا ensure بشن - تو سرورت هر سه از قبل هستن)
dependency 'pma-voice'
dependency 'ox_lib'
dependency 'ox_target'

client_scripts {
	'@essentialmode/locale.lua',
	'@ox_lib/init.lua', -- provides the global `lib` used by lib.notify
	'config.lua',
	'client/*.lua',
	'config.lua',
	'locales/*.lua',  
	'client/bastan-r-q-cl.lua',
	'autorules/client.lua',
	'autorules/config.lua',
}

server_scripts {
	'@essentialmode/locale.lua',
	'@async/async.lua',
	'@oxmysql/lib/MySQL.lua', -- FIX: was '@mysql-async/lib/MySQL.lua' - no resource by that name exists on this server (only oxmysql, which provides a mysql-async-compatible MySQL.Async.* API), so this was silently broken before
	'config.lua',
	'server/*.lua',
	'config.lua',
	'locales/*.lua',
	'autorules/config.lua',
}

-- فایل‌های باینری اومده از Unique_Pack که نیاز به اعلام صریح دارن
-- (مدل‌ها/دیکشنری‌های stream/*.ydr /*.ytd /*.ycd /*.ytyp خودکار استریم می‌شن،
-- این‌ها استثنائاتی هستن که خودِ Unique_Pack هم صریح تعریفشون کرده بود)
files {
	'stream/molly@megaphone.ycd',
	'stream/molly@megaphone2.ycd',
	'stream/prop_fib_badge.ydr',
	'stream/prop_fib_badge+hidr.ytd',
	'stream/minimap.gfx',
}
data_file 'DLC_ITYP_REQUEST' 'stream/*.ytyp'

file 'peds.meta'
data_file 'PED_METADATA_FILE' 'peds.meta'

server_exports {
	'GangLog',
	'HomeLog',
	'TrunkLog',
	'TransferLog',
	'TransActionLog',
	'RobLog',
	'RobLogF',
	'GetDiscord',
	'AddProp',
	'AddPed',
	'AddVehicle',
	'RewardAll'
}

exports {
	'GetVehicles',
	'Impoundsheriff',
	'ImpoundPolice',
	'getMaxSpeedInOffroad',
	'getVar',
}


