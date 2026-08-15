fx_version 'cerulean'
game 'gta5'

author 'Arshia'
description 'Unique_AdminMenu - merged from esx_AdminAre + Admin_Menu, expanded'
version '2.0.0'

-- Load order matters: warmenu (UI lib) and general_utils (shared helpers like
-- drawNotification, GetUserInput) must load before the files that call them.
client_scripts {
	'@ox_lib/init.lua', -- needed for lib.notify (used by admin_area.lua)
	'client/warmenu.lua',
	'client/general_utils.lua',
	'client/admin_area.lua',
	'client/spectate_teleport_noclip.lua',
	'client/menu_ui.lua',
	'client/player_toggles.lua',
	'client/admin_tools_menu.lua',
	'client/nui_panel.lua',
}

server_scripts {
	"@mysql-async/lib/MySQL.lua",
	'server/admin_area.lua',
	'server/main.lua',
	'server/admin_tools.lua',
}

ui_page('html/index.html')
files {
	'html/index.html',
	'html/style.css',
	'html/app.js',
}

-- Still depends on esx_aduty for permission_level / aduty (on-duty) status
-- and the GodMode toggle event (esx_aduty:GodModeMenu). esx_aduty stays
-- installed as its own resource; do not remove it. Also needs the small
-- exports('GetReports', ...) addition made to esx_aduty/Server/ReportMenu_sv.lua
-- for the Report Queue panel to work.
dependency 'esx_aduty'
