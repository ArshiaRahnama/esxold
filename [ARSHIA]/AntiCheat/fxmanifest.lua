fx_version 'cerulean'
game 'gta5'

author 'Arshia | arshiahub.ir | Unique RP'
description 'AntiCheat - Statistical anomaly-detection add-on for UNIQUE_AC (speed / noclip / godmode)'
version '1.0.0'

-- Standalone by design: does NOT touch UNIQUE_AC's own files, does NOT share globals
-- with it (every FiveM resource has its own isolated Lua environment), and only
-- needs ESX + oxmysql, both of which are already loaded earlier in server.cfg.
-- This means it can be dropped in or removed at any time without risking the
-- existing 150k-line UNIQUE_AC core.

client_script 'client.lua'

server_script 'server.lua'

shared_script 'config.lua'
