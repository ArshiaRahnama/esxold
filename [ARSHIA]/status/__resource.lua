resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "ui/index.html"
files {
	"ui/index.html",
	"ui/imgs/test.png",
	"ui/fonts/fonts/Circular-Bold.ttf",
	"ui/fonts/fonts/Circular-Bold.ttf",
	"ui/fonts/fonts/Circular-Regular.ttf",
	"ui/js/script.js",
	"ui/css/style.css",
	"ui/css/index.css",
	"ui/js/debounce.min.js",
		-- Job Images
	'ui/assets/imgs/*.png',
	
}

client_scripts {
    'client.lua',
}

server_scripts {
    'server.lua',
}