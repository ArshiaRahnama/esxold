
local skillcheck

function lib.skillCheck(difficulty, inputs)
    if skillcheck then return end
    skillcheck = promise:new()

    lib.setNuiFocus(false, true)
    SendNUIMessage({
        action = 'startSkillCheck',
        data = {
            difficulty = difficulty,
            inputs = inputs
        }
    })

    return Citizen.Await(skillcheck)
end

function lib.cancelSkillCheck()
    if not skillcheck then
        error('No skillCheck is active')
    end

    SendNUIMessage({action = 'skillCheckCancel'})
end

function lib.skillCheckActive()
    return skillcheck ~= nil
end

RegisterNUICallback('skillCheckOver', function(success, cb)
    cb(1)

    if skillcheck then
        lib.resetNuiFocus()

        skillcheck:resolve(success)
        skillcheck = nil
    end
end)
