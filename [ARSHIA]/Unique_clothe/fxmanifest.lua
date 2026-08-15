fx_version 'bodacious'
game 'gta5'

-- clothe:saveOutfit/getOutfits/loadOutfit/deleteOutfit (ported from
-- esx_eden_clotheshop) use esx_datastore's 'property' store -- make
-- sure esx_datastore is ensured before this resource in server.cfg
-- (it already needs to be, for esx_property/esx_accessories/gangs)

server_scripts {
  'server/main.lua',
}

client_scripts {
  '@essentialmode/locale.lua',
  'client/main.lua',
}