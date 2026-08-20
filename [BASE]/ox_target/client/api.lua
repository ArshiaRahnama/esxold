

local utils = require 'client.utils'

local api = setmetatable({}, {
    __newindex = function(self, index, value)
        rawset(self, index, value)
        exports(index, value)
    end
})

local function typeError(variable, expected, received)
    error(("expected %s to have type '%s' (received %s)"):format(variable, expected, received))
end

local function checkOptions(options)
    local optionsType = type(options)

    if optionsType ~= 'table' then
        typeError('options', 'table', optionsType)
    end

    local tableType = table.type(options)

    if tableType == 'hash' and options.label then
        options = { options }
    elseif tableType ~= 'array' then
        typeError('options', 'array', ('%s table'):format(tableType))
    end

    return options
end

function api.addPolyZone(data)
    if data.debug then utils.warn('Creating new PolyZone with debug enabled.') end

    data.resource = GetInvokingResource()
    data.options = checkOptions(data.options)
    return lib.zones.poly(data).id
end

function api.addBoxZone(data)
    if data.debug then utils.warn('Creating new BoxZone with debug enabled.') end

    data.resource = GetInvokingResource()
    data.options = checkOptions(data.options)
    return lib.zones.box(data).id
end

function api.addSphereZone(data)
    if data.debug then utils.warn('Creating new SphereZone with debug enabled.') end

    data.resource = GetInvokingResource()
    data.options = checkOptions(data.options)
    return lib.zones.sphere(data).id
end

function api.removeZone(id, suppressWarning)
    if Zones then
        if type(id) == 'string' then
            local foundZone

            for _, v in pairs(Zones) do
                if v.name == id then
                    foundZone = true
                    v:remove()
                end
            end

            if foundZone then return end
        elseif Zones[id] then
            return Zones[id]:remove()
        end
    end

    if suppressWarning then return end

    warn(('attempted to remove a zone that does not exist (id: %s)'):format(id))
end

local function removeTarget(target, remove, resource, showWarning)
    if type(remove) ~= 'table' then remove = { remove } end

    for i = #target, 1, -1 do
        local option = target[i]

        if option.resource == resource then
            for j = #remove, 1, -1 do
                if option.name == remove[j] then
                    table.remove(target, i)

                    if showWarning then
                        utils.warn(("Replacing existing target option '%s'."):format(option.name))
                    end
                end
            end
        end
    end
end

local function addTarget(target, options, resource)
    options = checkOptions(options)

    local checkNames = {}

    resource = resource or 'ox_target'

    for i = 1, #options do
        local option = options[i]
        option.resource = resource

        if option.name then
            checkNames[#checkNames + 1] = option.name
        end
    end

    if checkNames[1] then
        removeTarget(target, checkNames, resource, true)
    end

    local num = #target

    for i = 1, #options do
        local option = options[i]

        if resource == 'ox_target' then
            if option.canInteract then
                option.canInteract = msgpack.unpack(msgpack.pack(option.canInteract))
            end

            if option.onSelect then
                option.onSelect = msgpack.unpack(msgpack.pack(option.onSelect))
            end
        end

        num += 1
        target[num] = options[i]
    end
end

local peds = {}

function api.addGlobalPed(options)
    addTarget(peds, options, GetInvokingResource())
end

function api.removeGlobalPed(options)
    removeTarget(peds, options, GetInvokingResource())
end

local vehicles = {}

function api.addGlobalVehicle(options)
    addTarget(vehicles, options, GetInvokingResource())
end

function api.removeGlobalVehicle(options)
    removeTarget(vehicles, options, GetInvokingResource())
end

local objects = {}

function api.addGlobalObject(options)
    addTarget(objects, options, GetInvokingResource())
end

function api.removeGlobalObject(options)
    removeTarget(objects, options, GetInvokingResource())
end

local players = {}

function api.addGlobalPlayer(options)
    addTarget(players, options, GetInvokingResource())
end

function api.removeGlobalPlayer(options)
    removeTarget(players, options, GetInvokingResource())
end

local models = {}

function api.addModel(arr, options)
    if type(arr) ~= 'table' then arr = { arr } end
    local resource = GetInvokingResource()

    for i = 1, #arr do
        local model = arr[i]
        model = tonumber(model) or joaat(model)

        if not models[model] then
            models[model] = {}
        end

        addTarget(models[model], options, resource)
    end
end

function api.removeModel(arr, options)
    if type(arr) ~= 'table' then arr = { arr } end
    local resource = GetInvokingResource()

    for i = 1, #arr do
        local model = arr[i]
        model = tonumber(model) or joaat(model)

        if models[model] then
            if options then
                removeTarget(models[model], options, resource)
            end

            if not options or #models[model] == 0 then
                models[model] = nil
            end
        end
    end
end

local entities = {}

function api.addEntity(arr, options)
    if type(arr) ~= 'table' then arr = { arr } end
    local resource = GetInvokingResource()

    for i = 1, #arr do
        local netId = arr[i]

        if NetworkDoesNetworkIdExist(netId) then
            if not entities[netId] then
                entities[netId] = {}

                if not Entity(NetworkGetEntityFromNetworkId(netId)).state.hasTargetOptions then
                    TriggerServerEvent('ox_target:setEntityHasOptions', netId)
                end
            end

            addTarget(entities[netId], options, resource)
        end
    end
end

function api.removeEntity(arr, options)
    if type(arr) ~= 'table' then arr = { arr } end
    local resource = GetInvokingResource()

    for i = 1, #arr do
        local netId = arr[i]

        if entities[netId] then
            if options then
                removeTarget(entities[netId], options, resource)
            end

            if not options or #entities[netId] == 0 then
                entities[netId] = nil
            end
        end
    end
end

RegisterNetEvent('ox_target:removeEntity', api.removeEntity)

local localEntities = {}

function api.addLocalEntity(arr, options)
    if type(arr) ~= 'table' then arr = { arr } end
    local resource = GetInvokingResource()

    for i = 1, #arr do
        local entityId = arr[i]

        if DoesEntityExist(entityId) then
            if not localEntities[entityId] then
                localEntities[entityId] = {}
            end

            addTarget(localEntities[entityId], options, resource)
        else
            print(("No entity with id '%s' exists."):format(entityId))
        end
    end
end

function api.removeLocalEntity(arr, options)
    if type(arr) ~= 'table' then arr = { arr } end
    local resource = GetInvokingResource()

    for i = 1, #arr do
        local entity = arr[i]

        if localEntities[entity] then
            if options then
                removeTarget(localEntities[entity], options, resource)
            end

            if not options or #localEntities[entity] == 0 then
                localEntities[entity] = nil
            end
        end
    end
end

CreateThread(function()
    while true do
        Wait(60000)

        for entityId in pairs(localEntities) do
            if not DoesEntityExist(entityId) then
                localEntities[entityId] = nil
            end
        end
    end
end)

local function removeResourceGlobals(resource, target)
    for i = 1, #target do
        local options = target[i]

        for j = #options, 1, -1 do
            if options[j].resource == resource then
                table.remove(options, j)
            end
        end
    end
end

local function removeResourceTargets(resource, target)
    for i = 1, #target do
        local tbl = target[i]

        for key, options in pairs(tbl) do
            for j = #options, 1, -1 do
                if options[j].resource == resource then
                    table.remove(options, j)
                end
            end

            if #options == 0 then
                tbl[key] = nil
            end
        end
    end
end

AddEventHandler('onClientResourceStop', function(resource)
    removeResourceGlobals(resource, { peds, vehicles, objects, players })
    removeResourceTargets(resource, { models, entities, localEntities })

    if Zones then
        for _, v in pairs(Zones) do
            if v.resource == resource then
                v:remove()
            end
        end
    end
end)

local NetworkGetEntityIsNetworked = NetworkGetEntityIsNetworked
local NetworkGetNetworkIdFromEntity = NetworkGetNetworkIdFromEntity

local options_mt = {}
options_mt.__index = options_mt
options_mt.size = 1

function options_mt:wipe()
    options_mt.size = 1
    self.globalTarget = nil
    self.model = nil
    self.entity = nil
    self.localEntity = nil

    if self.__global[1]?.name == 'builtin:goback' then
        table.remove(self.__global, 1)
    end
end

function options_mt:set(entity, _type, model)
    if not entity then return end

    if _type == 1 and IsPedAPlayer(entity) then
        self:wipe()
        self.globalTarget = players
        options_mt.size += 1

        return
    end

    local netId = NetworkGetEntityIsNetworked(entity) and NetworkGetNetworkIdFromEntity(entity)

    self.globalTarget = _type == 1 and peds or _type == 2 and vehicles or objects
    self.model = models[model]
    self.entity = netId and entities[netId] or nil
    self.localEntity = localEntities[entity]
    options_mt.size += 1

    if self.model then options_mt.size += 1 end
    if self.entity then options_mt.size += 1 end
    if self.localEntity then options_mt.size += 1 end
end

local global = {}

function api.addGlobalOption(options)
    addTarget(global, options, GetInvokingResource())
end

function api.removeGlobalOption(options)
    removeTarget(global, options, GetInvokingResource())
end

local options = setmetatable({
    __global = global
}, options_mt)

function api.getTargetOptions(entity, _type, model)
    if not entity then return options end

    if IsPedAPlayer(entity) then
        return {
            global = players,
        }
    end

    local netId = NetworkGetEntityIsNetworked(entity) and NetworkGetNetworkIdFromEntity(entity)

    return {
        global = _type == 1 and peds or _type == 2 and vehicles or objects,
        model = models[model],
        entity = netId and entities[netId] or nil,
        localEntity = localEntities[entity],
    }
end

local state = require 'client.state'

function api.disableTargeting(value)
    if value then
        state.setActive(false)
    end

    state.setDisabled(value)
end

function api.isActive()
    return state.isActive()
end

return api
