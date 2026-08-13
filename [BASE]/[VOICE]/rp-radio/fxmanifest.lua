fx_version "adamant"
game "gta5"

name "rp-radio"
description "An in-game radio which makes use of the pma-voice radio API for FiveM"
author "Arshia Mtz"
version "2.2.1"

ui_page "index.html"

dependencies {
	"pma-voice",
	"ox_lib",
}

files {
	"index.html",
	"call.png",
	"on.ogg",
	"off.ogg",
}

client_scripts {
	"@ox_lib/init.lua", -- provides the global `lib` used by lib.notify
	"config.lua",
	"client.lua",
}

server_scripts {
	"server.lua",
}
