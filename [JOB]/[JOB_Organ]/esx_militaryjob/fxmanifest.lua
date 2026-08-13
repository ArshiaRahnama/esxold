fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Arshia | arshiahub.ir | Unique RP'
description 'ESX Military Job - Department of Justice + Law Enforcement (Marshal, Judge, DOA, CID, CIA, FBI, Police, Sheriff, MT) - merged single resource'
version '1.0.0'

-- NOTE: every job module below has its own namespaced Config_<job> global,
-- its own namespaced functions/events/commands (suffixed _<job>), so bundling
-- all 9 jobs here in one resource does not overwrite or collide with one
-- another. Sheriff and MT still call into Police's own OutVehicle/drag/
-- putInVehicle/requestrelease handlers on purpose (shared cuff/drag system).

shared_scripts {
	'@essentialmode/locale.lua',
	'locales/*.lua',
}

client_scripts {
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
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	-- Marshal
	'client/config_marshal.lua',
	'server/marshal_main.lua',
	-- Judge
	'client/config_judge.lua',
	'server/judge_main.lua',
	-- DOA
	'client/config_doa.lua',
	'server/doa_main.lua',
	-- CID
	'client/config_cid.lua',
	'server/cid_main.lua',
	-- CIA
	'client/config_cia.lua',
	'server/cia_main.lua',
	'server/cia_speact_sv.lua',
	-- FBI
	'client/config_fbi.lua',
	'server/fbi_main.lua',
	'server/fbi_speact_sv.lua',
	-- Police
	'client/config_police.lua',
	'server/police_main.lua',
	-- Sheriff
	'client/config_sheriff.lua',
	'server/sheriff_main.lua',
	-- MT
	'client/config_mt.lua',
	'server/mt_main.lua',
}

dependencies {
	'essentialmode',
	'esx_society',
	'mysql-async',
}
