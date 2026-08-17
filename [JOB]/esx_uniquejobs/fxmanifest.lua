fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Arshia | arshiahub.ir | Unique RP'
description 'ESX Unique Jobs - Department Of Justice + Law Enforcement + Organ Services, all 13 jobs, one resource'
version '1.0.0'

-- NOTE: every job module below has its own namespaced Config_<job> global and its
-- own namespaced internal functions/events (suffixed _<job>), so bundling all 13
-- jobs here does not overwrite or collide with one another. Boss-menu branch
-- switching ("Change to CID" / "Change to FBI" / ...) lives in esx_society
-- (Config.JobGroups) and is shared across the whole resource - see boss actions
-- in shared/department_chat.lua for the /f /dep /mp radio-style chat commands.
--
-- NOTE: the standalone Unique_Cad resource (police MDT/dispatch tablet, /mdt)
-- was merged in under cad/. A FiveM resource can only have ONE ui_page, and
-- this resource already used its ui_page for the bodydamage HUD, so ui.html
-- is a small router page that iframes both bodydamage/html/index.html and
-- cad/html/index.html and relays SendNuiMessage to both - neither app's own
-- HTML/JS/CSS had to be touched. cad/client/main.lua uses its own locals
-- (Keys_cad, PlayerData_cad, ...) instead of the DuckMdt-era globals so it
-- can't collide with the other job modules in this file.

shared_scripts {
	'@essentialmode/locale.lua',
	'@ox_lib/init.lua',
	'locales/*.lua',
	'shared/departments.lua',
	'cad/config_cad.lua',
}

client_scripts {
	-- ── Department Of Justice ──
	-- Marshal
	'client/config_marshal.lua',
	'client/marshal_main.lua',
	-- Judge
	'client/config_judge.lua',
	'client/judge_main.lua',
	-- DOA
	'client/config_doa.lua',
	'client/doa_main.lua',
	-- CID
	'client/config_cid.lua',
	'client/cid_main.lua',
	-- CIA
	'client/config_cia.lua',
	'client/cia_main.lua',
	'client/cia_speact_cl.lua',
	-- FBI
	'client/config_fbi.lua',
	'client/fbi_main.lua',
	'client/fbi_speact_cl.lua',

	-- ── Law Enforcement ──
	-- Police
	'client/config_police.lua',
	'client/police_main.lua',
	-- Sheriff
	'client/config_sheriff.lua',
	'client/sheriff_main.lua',
	-- MT
	'client/config_mt.lua',
	'client/mt_main.lua',
	-- Teleporter (Police / Sheriff / MT / FBI)
	'client/teleport_police.lua',

	-- ── Organ Services ──
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
	'client/teleport_weazel.lua',
	-- Ambulance
	'client/config_ambulance.lua',
	'client/ambulance_main.lua',
	'client/ambulance_job.lua',
	-- Ambulance body-damage UI
	'bodydamage/client/*.lua',

	-- ── Shared: department boss-menu switcher + /f /dep /mp chat ──
	'shared/department_chat_client.lua',

	-- ── CAD / MDT tablet (/mdt) - Police, Sheriff, FBI, MT, CID, CIA, Marshal, Judge, DOA ──
	'cad/client/main.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',

	-- ── Department Of Justice ──
	'client/config_marshal.lua',
	'server/marshal_main.lua',
	'client/config_judge.lua',
	'server/judge_main.lua',
	'client/config_doa.lua',
	'server/doa_main.lua',
	'client/config_cid.lua',
	'server/cid_main.lua',
	'client/config_cia.lua',
	'server/cia_main.lua',
	'server/cia_speact_sv.lua',
	'client/config_fbi.lua',
	'server/fbi_main.lua',
	'server/fbi_speact_sv.lua',

	-- ── Law Enforcement ──
	'client/config_police.lua',
	'server/police_main.lua',
	'client/config_sheriff.lua',
	'server/sheriff_main.lua',
	'client/config_mt.lua',
	'server/mt_main.lua',

	-- ── Organ Services ──
	'client/config_mechanic.lua',
	'server/mechanic_main.lua',
	'client/config_taxi.lua',
	'server/taxi_main.lua',
	'client/config_weazel.lua',
	'server/weazel_main.lua',
	'server/weazel_cam_server.lua',
	'client/config_ambulance.lua',
	'server/ambulance_main.lua',

	-- ── Shared: /f /dep /mp chat ──
	'shared/department_chat_server.lua',

	-- ── CAD / MDT tablet ──
	'cad/server/main.lua',
}

ui_page 'ui.html'

files {
	'ui.html',

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

	'cad/html/index.html',
	'cad/html/app.js',
	'cad/html/style.css',
	'cad/html/img/*',
	'cad/html/fonts/*',
	'cad/html/sounds/*',
}

dependencies {
	'essentialmode',
	'esx_society',
	'mysql-async',
	'ox_lib',
}
