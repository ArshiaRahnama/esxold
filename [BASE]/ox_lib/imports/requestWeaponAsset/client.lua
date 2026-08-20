

function lib.requestWeaponAsset(weaponType, timeout, weaponResourceFlags, extraWeaponComponentFlags)
    if HasWeaponAssetLoaded(weaponType) then return weaponType end

    local weaponTypeType = type(weaponType)

    if weaponTypeType ~= 'string' and weaponTypeType ~= 'number' then
        error(("expected weaponType to have type 'string' or 'number' (received %s)"):format(weaponTypeType))
    end

    if weaponResourceFlags and type(weaponResourceFlags) ~= 'number' then
        error(("expected weaponResourceFlags to have type 'number' (received %s)"):format(type(weaponResourceFlags)))
    end

    if extraWeaponComponentFlags and type(extraWeaponComponentFlags) ~= 'number' then
        error(("expected extraWeaponComponentFlags to have type 'number' (received %s)"):format(type(extraWeaponComponentFlags)))
    end

    return lib.streamingRequest(RequestWeaponAsset, HasWeaponAssetLoaded, 'weaponHash', weaponType, timeout, weaponResourceFlags or 31, extraWeaponComponentFlags or 0)
end

return lib.requestWeaponAsset
