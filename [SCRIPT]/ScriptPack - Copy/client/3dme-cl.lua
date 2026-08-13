-- Settings
ESX = nil
local color = { r = 255, g = 255, b = 255, alpha = 255 } -- Color of the text 
local font = 0 -- Font of the text
local time = 10000 -- Duration of the display of the text : 1000ms = 1sec
local background = {
    enable = false,
    color = { r = 153, g = 0, b = 153, alpha = 255 },
}
local dropShadow = false

Citizen.CreateThread(function ()
	while ESX == nil do
	  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	  Citizen.Wait(1)
	   PlayerData = ESX.GetPlayerData()
	end
end)
  
  RegisterNetEvent('esx:playerLoaded')
  AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
  end)
  
  RegisterNetEvent('esx:setJob')
  AddEventHandler('esx:setJob', function(job)
	  PlayerData.job = job
  end)

-- Don't touch
local nbrDisplaying = 1

RegisterCommand('me', function(source, args)
        local text = '' -- edit here if you want to change the language : EN: the person / FR: la personne
            for i = 1,#args do
                text = text .. ' ' .. args[i]
            end
            text = text
            TriggerServerEvent('3dme:shareDisplay', text, true)

end)

RegisterNetEvent('3dme:triggerDisplay')
AddEventHandler('3dme:triggerDisplay', function(text, source, sendMessage)
    --if not ESX.Game.PlayerExist(source) then return end
    local offset = 1 + (nbrDisplaying*0.1)
    Displays(GetPlayerFromServerId(source), text, offset, sendMessage,source)
end)
RegisterNetEvent('3dme:triggerDisplayDo')
AddEventHandler('3dme:triggerDisplayDo', function(text, source)
    --if not ESX.Game.PlayerExist(source) then return end
    local offset = 1 + (nbrDisplaying*0.1)
    DisplayDo(GetPlayerFromServerId(source), text, offset,source)
end)

function Displays(mePlayer, text, offset, chatMessage,src)
    local displaying = true

    -- Chat message
    if chatMessage then
        local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
        local coords = GetEntityCoords(PlayerPedId(), false)
        local dist = Vdist2(coordsMe, coords)
		
        if dist < 50 then
          TriggerEvent('chat:addMessage', {
                color = { 104, 50, 168 },
                multiline = true,
                args = { '(' .. src .. ') : ' ..text}
            })

        end
    end

    Citizen.CreateThread(function()
        Wait(time)
        displaying = false
    end)
    Citizen.CreateThread(function()
        nbrDisplaying = nbrDisplaying + 1
        while displaying do
            Wait(1)
            local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
            local coords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist2(coordsMe, coords)
            if dist < 50 then
                Draw3DText(coordsMe['x'], coordsMe['y'], coordsMe['z']+offset, text)
            end
        end
        nbrDisplaying = nbrDisplaying - 1
    end)
end



function Draw3DText(x,y,z, text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    local dist = #(vector3(px,py,pz) - vector3(x,y,z))
 
    local scale = ((1/dist)*2)*(1/GetGameplayCamFov())*100

    if onScreen then

        -- Formalize the text
        SetTextColour(color.r, color.g, color.b, color.alpha)
        SetTextScale(0.0*scale, 0.7*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextCentre(true)
        if dropShadow then
            SetTextDropshadow(10, 100, 100, 100, 255)
        end

        -- Calculate width and height
        BeginTextCommandWidth("STRING")
        AddTextComponentString(text)
        local height = GetTextScaleHeight(0.55*scale, font)
        local width = EndTextCommandGetWidth(font)

        -- Diplay the text
        SetTextEntry("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)

        if background.enable then
            DrawRect(_x, _y+scale/45, width, height, background.color.r, background.color.g, background.color.b , background.color.alpha)
        end
    end
end