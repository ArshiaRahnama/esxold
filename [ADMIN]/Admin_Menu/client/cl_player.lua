local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local godmode = false
local infStamina = false
invisibility = false
invisibility2 = false
local noRagDoll = false

-- GODMODE
RegisterNetEvent("skadmin:toggleGodmode")
AddEventHandler("skadmin:toggleGodmode", function()
  godmode = not godmode
  SetEntityInvincible(PlayerPedId(), godmode)
  if godmode then
    drawNotification("~b~God mode activated")
  else
    drawNotification("~r~God mode deactivated")
  end
end)

-- INFINITE STAMINA
RegisterNetEvent("skadmin:toggleInfStamina")
AddEventHandler("skadmin:toggleInfStamina", function()
  infStamina = not infStamina
  ActiveStamina()
  if infStamina then
    drawNotification("~b~Infinite Stamina activated")
  else
    drawNotification("~r~Infinite Stamina deactivated")
  end
end)

-- INVISIBILITY
RegisterNetEvent("skadmin:toggleInvisibility")
AddEventHandler("skadmin:toggleInvisibility", function()
  invisibility = not invisibility
  SetEntityVisible(PlayerPedId(), not invisibility, 0)
  SetForcePedFootstepsTracks(invisibility) -- TODO: all players ?!
  if invisibility then
    drawNotification("~b~Invisibility activated")
    TriggerServerEvent("Admin_Menu:SpectStatus", true)
  else
    drawNotification("~r~Invisibility deactivated")
    TriggerServerEvent("Admin_Menu:SpectStatus", false)
  end
end)


RegisterNetEvent("skadmin:toggleInvisibility2")
AddEventHandler("skadmin:toggleInvisibility2", function()

  invisibility2 = not invisibility2

  if invisibility2 then
    drawNotification("~b~Invisibility activated")
    TriggerServerEvent("Admin_Menu:SpectStatus", true)
    SetEntityAlpha(PlayerPedId(), 160, false)
    SetEntityVisible(PlayerPedId(), true, false)
  else
    ResetEntityAlpha(PlayerPedId())
    SetEntityVisible(PlayerPedId(), true, true)
    drawNotification("~r~Invisibility deactivated")
    TriggerServerEvent("Admin_Menu:SpectStatus", false)
  end



end)

-- NO RAG DOLL
RegisterNetEvent("skadmin:toggleNoRagDoll")
AddEventHandler("skadmin:toggleNoRagDoll", function()
  noRagDoll = not noRagDoll
  SetPedCanRagdoll( PlayerPedId(), not noRagDoll )
  if noRagDoll then
    drawNotification("~b~No Rag Doll activated")
  else
    drawNotification("~r~No Rag Doll deactivated")
  end
end)


function ActiveStamina()
  Citizen.CreateThread(function()
    while infStamina and aduty do
      Citizen.Wait(0)
      RestorePlayerStamina(PlayerPedId(), 1.0)
    end
    infStamina = not aduty and false or infStamina
  end)
end