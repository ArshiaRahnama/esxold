ConfigSV = {}

-- Storage namespace used with esx_addoninventory / esx_datastore (Data_Storage)
-- Match this to whatever your server passes in client-side storage_data / uses.
ConfigSV.StorageNamespace = 'housing'

-- Should furniture placement be validated against money on the server too
-- (client already checks with CanBuy, this is a belt-and-suspenders check)
ConfigSV.RevalidateFurniturePrice = true

-- Max distance (world units) allowed between a player and a house/apartment
-- entercoords before server-side actions (buy, enter, edit...) are rejected.
-- Prevents obvious teleport/exploit abuse of server events.
ConfigSV.MaxActionDistance = 15.0

-- Discord webhook (optional) for house purchase / admin add / delete logs.
-- Leave empty to disable logging.
ConfigSV.LogWebhook = ''
