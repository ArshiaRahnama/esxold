

fx_version 'cerulean'
game 'gta5'
lua54 'yes'
description "arshiahub.ir"
author "Arshia"
version "1"

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

ui_page "web/index.html"

files {
    'web/index.html',
    'web/style.css',
    'web/script.js',
    'web/img/*.png',
    'web/img/*.jpg',
    'web/img/*.gif',
    'web/img/*.webp',
    'web/*.ttf',
    'web/*.otf'
}

dependencies {
	'mysql-async',
	'/onesync',
	'essentialmode',
	'CoinSystem', -- provides the 'Coin-System:GetCoin' callback used for the coin display
}



