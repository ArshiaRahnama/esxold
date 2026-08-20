if not lib.checkDependency('ox_core', '0.21.3', true) then return end

local Ox = require '@ox_core.lib.init'
local utils = require 'client.utils'
local player = Ox.GetPlayer()

function utils.hasPlayerGotGroup(filter)
    return player.getGroup(filter)
end
