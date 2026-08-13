fx_version 'cerulean'
game 'gta5'



lua54 'yes'

shared_scripts {
  '@ox_lib/init.lua'  -- Initialize ox_lib
}

client_scripts {
    'client.lua',
  --  'Config.lua',
}

server_scripts {
    'server.lua',
   -- 'Config.lua',
}

dependencies {
  'ox_lib'  -- Explicit dependency
}