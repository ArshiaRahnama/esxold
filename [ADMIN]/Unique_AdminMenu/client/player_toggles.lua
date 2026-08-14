-- Made global to match menu_ui.lua's checkbox display variables (see note
-- there) - both files now read/write the exact same state.
godmode = false
local infStamina = false
invisibility = false
invisibility2 = false
local noRagDoll = false

-- ============================================================================
-- SECURITY: these effects used to flip the moment the LOCAL client fired
-- "skadmin:toggleGodmode" etc. - meaning a modified client could call that
-- event on itself with zero server involvement and grant itself godmode.
-- Now every toggle is *requested* from the server (Unique_AdminMenu:RequestToggle),
-- the server checks permission_level + aduty, and only then tells this
-- client to actually apply the effect (Unique_AdminMenu:ApplyToggle).
-- GodMode is additionally backed by the server-side SetPlayerInvincible
-- native, which a client cannot fake at all.
-- ============================================================================

local function RequestToggle(feature)
  TriggerServerEvent('Unique_AdminMenu:RequestToggle', feature)
end

RegisterNetEvent('Unique_AdminMenu:ApplyToggle')
AddEventHandler('Unique_AdminMenu:ApplyToggle', function(feature, newValue)
  if feature == 'godmode' then
    godmode = newValue
    -- SetPlayerInvincible already makes this authoritative server-side;
    -- SetEntityInvincible here is just so the local ped doesn't show pain
    -- FX for damage that will be undone anyway.
    SetEntityInvincible(PlayerPedId(), godmode)
    drawNotification(godmode and "~b~God mode activated" or "~r~God mode deactivated")

  elseif feature == 'infstamina' then
    infStamina = newValue
    ActiveStamina()
    drawNotification(infStamina and "~b~Infinite Stamina activated" or "~r~Infinite Stamina deactivated")

  elseif feature == 'invisibility' then
    invisibility = newValue
    SetEntityVisible(PlayerPedId(), not invisibility, 0)
    SetForcePedFootstepsTracks(invisibility)
    if invisibility then
      drawNotification("~b~Invisibility activated")
      TriggerServerEvent("Admin_Menu:SpectStatus", true)
    else
      drawNotification("~r~Invisibility deactivated")
      TriggerServerEvent("Admin_Menu:SpectStatus", false)
    end

  elseif feature == 'invisibility2' then
    invisibility2 = newValue
    if invisibility2 then
      drawNotification("~b~Invisibility activated")
      TriggerServerEvent("Admin_Menu:SpectStatus", true)
      SetEntityAlpha(PlayerPedId(), 160, false)
      SetEntityVisible(PlayerPedId(), true, false)
      invisibility2th2()
    else
      ResetEntityAlpha(PlayerPedId())
      SetEntityVisible(PlayerPedId(), true, true)
      drawNotification("~r~Invisibility deactivated")
      TriggerServerEvent("Admin_Menu:SpectStatus", false)
    end

  elseif feature == 'noragdoll' then
    noRagDoll = newValue
    SetPedCanRagdoll(PlayerPedId(), not noRagDoll)
    drawNotification(noRagDoll and "~b~No Rag Doll activated" or "~r~No Rag Doll deactivated")

  elseif feature == 'noclip' then
    IsNoclipActive = newValue
    noclip = newValue
    if IsNoclipActive then
      NoClipThread()
    end

  elseif feature == 'superjump' then
    superjump = newValue
    if superjump then SuperJumpThread() end

  elseif feature == 'fastrun' then
    fastrun = newValue
    if fastrun then FastRunThread() end

  elseif feature == 'blip' then
    blipdool = newValue
    if blipdool then BlipThread() end
  end
end)

-- Public entry points kept with their old names so menu_ui.lua's checkbox
-- callbacks barely had to change - they now just request instead of firing
-- the effect directly.
function RequestGodmode() RequestToggle('godmode') end
function RequestInfStamina() RequestToggle('infstamina') end
function RequestInvisibility() RequestToggle('invisibility') end
function RequestInvisibility2() RequestToggle('invisibility2') end
function RequestNoRagDoll() RequestToggle('noragdoll') end
function RequestNoclip() RequestToggle('noclip') end
function RequestSuperjump() RequestToggle('superjump') end
function RequestFastrun() RequestToggle('fastrun') end
function RequestBlip() RequestToggle('blip') end

function ActiveStamina()
  Citizen.CreateThread(function()
    while infStamina and aduty do
      Citizen.Wait(0)
      RestorePlayerStamina(PlayerPedId(), 1.0)
    end
    infStamina = not aduty and false or infStamina
  end)
end
