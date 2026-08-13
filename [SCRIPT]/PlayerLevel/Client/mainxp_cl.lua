ESX = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

local PlayerData = {}
local Data = {}
Config.PlayerLevels[0] = 0

local Arrived = false

RegisterNetEvent('PlayerLevel:Arrived')
AddEventHandler('PlayerLevel:Arrived', function()
  Arrived = true
end)


RegisterNetEvent('PlayerLevel:AddXPtoPlayer')
AddEventHandler('PlayerLevel:AddXPtoPlayer', function(AddedXP, Data)
  if Data.XP + AddedXP >= Config.PlayerLevels[Data.Level + 1] then
    repeat
      CreateRankBar(0, Config.PlayerLevels[Data.Level + 1], Data.XP, Config.PlayerLevels[Data.Level + 1], Data.Level)
      Data.Level = Data.Level + 1
      AddedXP = Data.XP + AddedXP - Config.PlayerLevels[Data.Level]
      Data.XP = 0
      TriggerEvent("PlayerLevel:RankUpMessage", "Shoma Level Up Shodid", 5000)
    until Data.XP + AddedXP < Config.PlayerLevels[Data.Level + 1]
      if AddedXP > 0 then
      Data.XP = Data.XP + AddedXP
      end
      CreateRankBar(0, Config.PlayerLevels[Data.Level + 1], 0, Data.XP, Data.Level)
  else
    CreateRankBar(0, Config.PlayerLevels[Data.Level + 1], Data.XP, Data.XP + AddedXP, Data.Level)
    Data.XP = Data.XP + AddedXP
  end
end)
RegisterNetEvent('PlayerLevel:RemoveXPtoPlayer')
AddEventHandler('PlayerLevel:RemoveXPtoPlayer', function(RemoveXP, Data)
  if Data.XP - RemoveXP <= Config.PlayerLevels[Data.Level - 1] then
    repeat
      CreateRankBar(0, Config.PlayerLevels[Data.Level - 1], Data.XP, Config.PlayerLevels[Data.Level - 1], Data.Level)
      Data.Level = Data.Level - 1
      RemoveXP = Data.XP - RemoveXP - Config.PlayerLevels[Data.Level]
      Data.XP = 0
      TriggerEvent("PlayerLevel:RankUpMessage", "Level Down Shodid", 5000)
    until Data.XP + RemoveXP < Config.PlayerLevels[Data.Level - 1]
      if RemoveXP > 0 then
      Data.XP = Data.XP - RemoveXP
      end
      CreateRankBar(0, Config.PlayerLevels[Data.Level - 1], 0, Data.XP, Data.Level)
  else
    CreateRankBar(0, Config.PlayerLevels[Data.Level - 1], Data.XP, Data.XP - RemoveXP, Data.Level)
    Data.XP = Data.XP - RemoveXP
  end
end)

-- Citizen.CreateThread(function()
--   AddEventHandler("onKeyDown", function(key)
--       if key == "i" then
--           local player = GetPlayerServerId(PlayerId())
--           TriggerServerEvent("PlayerLevel:GetLevels_SV", player)
--       end
--   end)
-- end)

RegisterNetEvent('PlayerLevel:GetLevels_CL')
AddEventHandler('PlayerLevel:GetLevels_CL', function(Data)
  CreateRankBar(0, Config.PlayerLevels[Data.Level + 1], Data.XP, Data.XP, Data.Level)
end)

function CreateRankBar(XP_StartLimit_RankBar, XP_EndLimit_RankBar, playersPreviousXP, playersCurrentXP, CurrentPlayerLevel, TakingAwayXP)
    RankBarColor = TakingAwayXP and 6 or 116
    if not HasHudScaleformLoaded(19) then
          RequestHudScaleform(19)
      while not HasHudScaleformLoaded(19) do
        Wait(1)
      end
    end
      BeginScaleformMovieMethodHudComponent(19, "SET_COLOUR")
      PushScaleformMovieFunctionParameterInt(RankBarColor)
      EndScaleformMovieMethodReturn()
      BeginScaleformMovieMethodHudComponent(19, "SET_RANK_SCORES")
      PushScaleformMovieFunctionParameterInt(XP_StartLimit_RankBar)
      PushScaleformMovieFunctionParameterInt(XP_EndLimit_RankBar)
      PushScaleformMovieFunctionParameterInt(playersPreviousXP)
      PushScaleformMovieFunctionParameterInt(playersCurrentXP)
      PushScaleformMovieFunctionParameterInt(CurrentPlayerLevel)
      PushScaleformMovieFunctionParameterInt(100)
      EndScaleformMovieMethodReturn()
end

RegisterNetEvent('PlayerLevel:RankUpMessage')
AddEventHandler('PlayerLevel:RankUpMessage', function(MsgText, setCounter)
  PlaySoundFrontend(-1, "LOSER", "HUD_AWARDS")
end)