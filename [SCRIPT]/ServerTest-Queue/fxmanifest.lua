fx_version 'bodacious'
game 'gta5'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/sv_queue_config.lua',
	'connectqueue.lua',
	'@ServerTest-Queue/connectqueue.lua',
	'shared/sh_queue.lua'
}

exports{
	'GetQueueExports'
}

server_exports {
	'GetQueueSize'
}

client_script 'shared/sh_queue.lua'

