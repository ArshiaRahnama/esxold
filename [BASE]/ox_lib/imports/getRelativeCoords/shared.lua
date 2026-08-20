local glm_sincos = require 'glm'.sincos
local glm_rad = require 'glm'.rad

function lib.getRelativeCoords(coords, heading, offset)
    offset = offset or heading
    local x, y, z, w = coords.x, coords.y, coords.z, type(heading) == 'number' and heading or coords.w
    local sin, cos = glm_sincos (glm_rad(w))
    local relativeX = offset.x * cos - offset.y * sin
    local relativeY = offset.x * sin + offset.y * cos

    return coords.w and vec4(
        x + relativeX,
        y + relativeY,
        z + offset.z,
        w
    ) or vec3(
        x + relativeX,
        y + relativeY,
        z + offset.z
    )
end

return lib.getRelativeCoords
