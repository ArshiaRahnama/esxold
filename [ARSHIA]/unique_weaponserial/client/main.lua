

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
