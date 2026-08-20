

function lib.setVehicleProperties(vehicle, props)
    Entity(vehicle).state:set('ox_lib:setVehicleProperties', props, true)
end
