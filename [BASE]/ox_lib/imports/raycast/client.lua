lib.raycast = {}

local StartShapeTestLosProbe = StartShapeTestLosProbe
local GetShapeTestResultIncludingMaterial = GetShapeTestResultIncludingMaterial
local glm_sincos = require 'glm'.sincos
local glm_rad = require 'glm'.rad
local math_abs = math.abs
local GetFinalRenderedCamCoord = GetFinalRenderedCamCoord
local GetFinalRenderedCamRot = GetFinalRenderedCamRot

function lib.raycast.fromCoords(coords, destination, flags, ignore)
    local handle = StartShapeTestLosProbe(coords.x, coords.y, coords.z, destination.x, destination.y,
        destination.z, flags or 511, cache.ped, ignore or 4)

    while true do
        Wait(0)
        local retval, hit, endCoords, surfaceNormal, material, entityHit = GetShapeTestResultIncludingMaterial(handle)

        if retval ~= 1 then
            return hit, entityHit, endCoords, surfaceNormal, material
        end
    end
end

local function getForwardVector()
    local sin, cos = glm_sincos(glm_rad(GetFinalRenderedCamRot(2)))
    return vec3(-sin.z * math_abs(cos.x), cos.z * math_abs(cos.x), sin.x)
end

function lib.raycast.fromCamera(flags, ignore, distance)
    local coords = GetFinalRenderedCamCoord()
    local destination = coords + getForwardVector() * (distance or 10)

    return lib.raycast.fromCoords(GetFinalRenderedCamCoord(), destination, flags, ignore)
end

lib.raycast.cam = lib.raycast.fromCamera

return lib.raycast
