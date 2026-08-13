fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Arshia | arshiahub.ir | Unique RP'
description 'ESX Organ Services (Mechanic, Taxi, Weazel, Ambulance) - merged single resource'
version '1.0.0'

-- NOTE: every job module below has its own namespaced Config_<job> global and its
-- own namespaced internal functions (suffixed _<job>), so bundling them here in one
-- resource does not overwrite or collide with one another. Player-facing commands
-- that never actually collided (911, ad, ads, news, newstime, tabligh, getclass)
-- were kept with their ORIGINAL names on purpose - don't rename them again.

shared_scripts {
	'@essentialmode/locale.lua',
	'@ox_lib/init.lua',
	'locales/*.lua',
}

client_scripts {
	-- Mechanic
	'client/config_mechanic.lua',
	'client/mechanic_main.lua',
	-- Taxi
	'client/config_taxi.lua',
	'client/taxi_main.lua',
	-- Weazel
	'client/config_weazel.lua',
	'client/weazel_main.lua',
	'client/weazel_cam_client.lua',
	-- Teleporters (Ambulance / Mechanic / Taxi)
	'client/teleport_ambulance.lua',
	'client/teleport_mechanic.lua',
	'client/teleport_taxi.lua',
	-- Ambulance
	'client/config_ambulance.lua',
	'client/ambulance_main.lua',
	'client/ambulance_job.lua',
	-- Ambulance body-damage UI (drop your bodydamage/ assets in, see bodydamage/README_fa.txt)
	'bodydamage/client/*.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	-- Mechanic
	'client/config_mechanic.lua',
	'server/mechanic_main.lua',
	-- Taxi
	'client/config_taxi.lua',
	'server/taxi_main.lua',
	-- Weazel
	'client/config_weazel.lua',
	'server/weazel_main.lua',
	'server/weazel_cam_server.lua',
	-- Ambulance
	'client/config_ambulance.lua',
	'server/ambulance_main.lua',
}

ui_page 'bodydamage/html/index.html'

files {
	'bodydamage/html/index.html',
	'bodydamage/html/css/*.css',
	'bodydamage/html/js/*.js',

	'bodydamage/html/img/*.png',

	'bodydamage/html/img/f/*.png',
	'bodydamage/html/img/f/bruises/*.png',
	'bodydamage/html/img/f/cuts/*.png',
	'bodydamage/html/img/f/punchs/*.png',
	'bodydamage/html/img/f/shots/*.png',

	'bodydamage/html/img/m/*.png',
	'bodydamage/html/img/m/bruises/*.png',
	'bodydamage/html/img/m/cuts/*.png',
	'bodydamage/html/img/m/punchs/*.png',
	'bodydamage/html/img/m/shots/*.png',
}

dependencies {
	'essentialmode',
	'esx_society',
	'mysql-async',
	'ox_lib',
}
