

local Keys_cad = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

ESX = nil
local PlayerData_cad = {}
local MdtDisplay_cad = false

Citizen.CreateThread(function()
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData_cad = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData_cad.job = job
end)

local function CheckPerm_cad()
    if PlayerData_cad.job == nil then return true end

    if (PlayerData_cad.job.name ~= DuckMdt.PoliceJob and PlayerData_cad.job.name ~= 'sheriff' and PlayerData_cad.job.name ~= 'fbi' and PlayerData_cad.job.name ~= 'mt' and PlayerData_cad.job.name ~= 'cid' and PlayerData_cad.job.name ~= 'cia' and PlayerData_cad.job.name ~= 'marshal' and PlayerData_cad.job.name ~= 'judge' and PlayerData_cad.job.name ~= 'doa') and DuckMdt.BlockNuiDevTool then
        if DuckMdt.LogUsingNuiDevTool then
            TriggerServerEvent('DuckMdt:PrintLog')
        end
        if DuckMdt.AnnouneAdminUsingNuiDevTool then
            TriggerServerEvent('DuckMdt:Announce')
        end
        return true
    else
        return false
    end
end

RegisterCommand(DuckMdt.Command, function()
    if PlayerData_cad.job == nil then return end

    if PlayerData_cad.job.name == DuckMdt.PoliceJob or PlayerData_cad.job.name == 'sheriff' or PlayerData_cad.job.name == 'fbi' or PlayerData_cad.job.name == 'mt' or PlayerData_cad.job.name == 'cid' or PlayerData_cad.job.name == 'cia' or PlayerData_cad.job.name == 'marshal' or PlayerData_cad.job.name == 'judge' or PlayerData_cad.job.name == 'doa' then
        if MdtDisplay_cad then
            ClearPedTasks(PlayerPedId())
            SendNuiMessage(json.encode({
                type = 'MDT',
                info = 'Close'
            }))
        else
            ExecuteCommand('e tablet2')
            SendNuiMessage(json.encode({
                type = 'MDT',
                info = 'Open',
            }))
        end
        MdtDisplay_cad = not MdtDisplay_cad
        SetNuiFocus(MdtDisplay_cad, MdtDisplay_cad)
    end
end, false)

RegisterNUICallback('Login', function()
    if CheckPerm_cad() then return end
    local xPlayer = ESX.GetPlayerData()
    ESX.TriggerServerCallback('DuckMdt:GetAllWanteds', function(obj)
        SendNuiMessage(json.encode({
            type = 'LoginUpdate',
            name = string.gsub(xPlayer.name, "_", " "),
            rank = PlayerData_cad.job.grade_label,
            PeopleWanteds = obj.peoples,
            WantedCars = obj.cars
        }))
    end)
end)

RegisterNUICallback('SearchCitizen', function(data, cb)
    if CheckPerm_cad() then return end
    ESX.TriggerServerCallback('DuckMdt:SearchCitizen', function(obj)
        SendNuiMessage(json.encode({
            type = 'SearchResult',
            Stype = 'Citizen',
            object = obj.Citizens
        }))
    end, data.Text)
end)

RegisterNUICallback('SearchCars', function(data, cb)
    if CheckPerm_cad() then return end
    ESX.TriggerServerCallback('DuckMdt:SearchCars', function(obj)
        SendNuiMessage(json.encode({
            type = 'SearchResult',
            Stype = 'Car',
            object = obj.Cars
        }))
    end, data.Text)
end)

RegisterNUICallback('CitizenProfile', function(data, cb)
    if CheckPerm_cad() then return end
    ESX.TriggerServerCallback('DuckMdt:CitizenProfile', function(obj)
        SendNuiMessage(json.encode({
            type = 'LoadCitizenProfile',
            object = obj.CitizenProfile,
            cars = obj.CitizenCars
        }))

        SendNuiMessage(json.encode({
            type = 'LoadDataList',
            object = obj.Data
        }))
    end, data.Steam)
end)

RegisterNUICallback('CarProfile', function(data, cb)
    if CheckPerm_cad() then return end
    ESX.TriggerServerCallback('DuckMdt:CarProfile', function(obj)
        SendNuiMessage(json.encode({
            type = 'LoadCarProfile',
            object = obj.CarInfo,
            owner = obj.OwnerInfo
        }))
    end, data.Plate)
end)

RegisterNUICallback('SaveNewData', function(data, cb)
    if CheckPerm_cad() then return end
    local xPlayer = ESX.GetPlayerData()
    ESX.TriggerServerCallback('DuckMdt:SaveNewData', function(obj)
        SendNuiMessage(json.encode({
            type = 'LoadDataList',
            object = obj.result,
        }))
    end, data.Reason, xPlayer.name, data.steam)
end)

RegisterNUICallback('DeleteData', function(data)
    if CheckPerm_cad() then return end

    ESX.TriggerServerCallback('DuckMdt:DeleteData', function(obj)
        SendNuiMessage(json.encode({
            type = 'LoadDataList',
            object = obj.result,
        }))
    end, data.id, data.steam)
end)

RegisterNUICallback('UpdateCharacterStatus', function(data)
    if CheckPerm_cad() then return end
    TriggerServerEvent('DuckMdt:UpdateCharacterStatus', data.NewStatus, data.steam)
end)

RegisterNUICallback('UpdateCarStatus', function(data)
    if CheckPerm_cad() then return end
    TriggerServerEvent('DuckMdt:UpdateCarStatus', data.NewStatus, data.plate)
end)

RegisterNUICallback('UpdateProfilePicCharacter', function(data)
    if CheckPerm_cad() then return end
    TriggerServerEvent('DuckMdt:UpdateProfilePicCharacter', data.url, data.steam)
end)

RegisterNUICallback('UpdateProfilePicCar', function(data)
    if CheckPerm_cad() then return end
    TriggerServerEvent('DuckMdt:UpdateProfilePicCar', data.url, data.plate)
end)

RegisterNUICallback('Exit', function(data)
    SendNuiMessage(json.encode({
        type = 'MDT',
        info = 'Close'
    }))
    MdtDisplay_cad = not MdtDisplay_cad
    SetNuiFocus(MdtDisplay_cad, MdtDisplay_cad)
    ClearPedTasks(PlayerPedId())
end)

RegisterNUICallback('LoadTenCodes', function()
    SendNuiMessage(json.encode({
        type = 'LoadTenCodes',
        Codes = DuckMdt.TenCodes
    }))
end)
