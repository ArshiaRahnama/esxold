-- ============================================================
-- unique_weaponserial / client / main.lua
--
-- Only job here: let the player drop the weapon currently in their
-- hand. Server-side holsters it into a carried 'wpn_<serial>' item,
-- then this reuses esx_inventoryhud's OWN existing, working ground
-- drop system for that exact item -- so pickup/expiry/weight all
-- keep working exactly like every other dropped item, and the serial
-- survives automatically because it's baked into the item name.
-- ============================================================

local ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
end)

local hashToWeaponName = {}
CreateThread(function()
    while ESX == nil do Wait(0) end
    for _, weapon in ipairs(ESX.GetWeaponList() or {}) do
        hashToWeaponName[GetHashKey(weapon.name)] = weapon.name
    end
end)

RegisterNetEvent('unique_weaponserial:doThrow')
AddEventHandler('unique_weaponserial:doThrow', function(itemName)
    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('inventory:core:throwItem', itemName, 1, coords)
end)

RegisterCommand('dropweapon', function()
    local ped = PlayerPedId()
    local weaponHash = GetSelectedPedWeapon(ped)
    local weaponName = hashToWeaponName[weaponHash]

    if not weaponName or weaponHash == GetHashKey('WEAPON_UNARMED') then
        ESX.ShowNotification('~r~Chizi baraye endakhtan dar dast nadari')
        return
    end

    TriggerServerEvent('unique_weaponserial:holsterForDrop', weaponName)
end, false)

RegisterKeyMapping('dropweapon', 'Endakhtan Aslahe Dar Dast', 'keyboard', 'X')
