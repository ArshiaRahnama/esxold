ESX = nil
local rank = 0
local PlayerData = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
    while PlayerData == nil do
        PlayerData = ESX.GetPlayerData()
        Citizen.Wait(5)
    end
    Citizen.Wait(4000)
    DecorRegister('typing', 2)
    DecorRegister('ShowTags', 2)
    DecorSetInt(PlayerPedId(), 'ShowTags', 1)
    DecorRegister('rank', 3)
    DecorSetInt(PlayerPedId(), 'typing', 0)
end)

local mpGamerTags = {}
local mpGamerTagSettings = {}
local ShowPlayersId = false
local playersInfo = {}
local Admins = {}
local gtComponent = {
    GAMER_NAME = 0,
    CREW_TAG = 1,
    healthArmour = 2,
    BIG_TEXT = 3,
    AUDIO_ICON = 4,
    MP_USING_MENU = 5,
    MP_PASSIVE_MODE = 6,
    WANTED_STARS = 7,
    MP_DRIVER = 8,
    MP_CO_DRIVER = 9,
    MP_TAGGED = 10,
    GAMER_NAME_NEARBY = 11,
    ARROW = 12,
    MP_PACKAGES = 13,
    INV_IF_PED_FOLLOWING = 14,
    RANK_TEXT = 15,
    MP_TYPING = 16
}

local function makeSettings()
    return {
        nameTag = nil,
        colors = {},
        toggle = false
    }
end



function updatePlayerNames()
    
    -- re-run this function the next frame
    SetTimeout(200, updatePlayerNames)

    -- get local coordinates to compare to
    local localCoords = GetEntityCoords(PlayerPedId())

    -- for each valid player index
    for _, i in ipairs(GetActivePlayers()) do
        -- get their ped
        local ped = GetPlayerPed(i)
        local serverId = GetPlayerServerId(i)
        local myserverId = GetPlayerServerId(PlayerId())
        local pedCoords = GetEntityCoords(ped)

        -- make a new settings list if needed
        if not mpGamerTagSettings[serverId] then
            mpGamerTagSettings[serverId] = makeSettings()
        end

        if not mpGamerTagSettings[serverId].nameTag then
           if i == PlayerId() or playersInfo[i] == nil then goto skip_this end
           if  playersInfo[i] == nil then goto skip_this end
        end

        -- check the ped, because changing player models may recreate the ped
        -- also check gamer tag activity in case the game deleted the gamer tag
        if not mpGamerTags[serverId] or mpGamerTags[serverId].ped ~= ped or not IsMpGamerTagActive(mpGamerTags[serverId].tag) then
            local nameTag = "["..serverId.."]"
            -- remove any existing tag
            if mpGamerTags[serverId] then
                RemoveMpGamerTag(mpGamerTags[serverId].tag)
            end

            -- store the new tag
            mpGamerTags[serverId] = {
                tag = CreateFakeMpGamerTag(GetPlayerPed(i), nameTag, false, false, '', 0),
                ped = ped
            }
        end

        local tag = mpGamerTags[serverId].tag

        local distance = playersInfo[i].info["distance"]

        if (distance < 20 or (mpGamerTagSettings[serverId].distance and distance <= mpGamerTagSettings[serverId].distance)) and playersInfo[i].info["cansee"] and HasEntityClearLosToEntity(PlayerPedId(), ped, 17) and not mpGamerTagSettings[serverId].toggle then
            SetMpGamerTagVisibility(tag, gtComponent.MP_TYPING, DecorGetInt(ped, 'typing') == 1)
            if ShowPlayersId or NetworkIsPlayerTalking(i) or mpGamerTagSettings[serverId].nameTag then
                local level = DecorGetInt(ped, "rank")
                if rank == 0 then
                    TriggerServerEvent("XP_System:setMyDecor", serverId)
                end
                SetMpGamerTagVisibility(tag, gtComponent.AUDIO_ICON, NetworkIsPlayerTalking(i))
                SetMpGamerTagAlpha(tag, gtComponent.AUDIO_ICON, 255)
                SetMpGamerTagVisibility(tag, gtComponent.GAMER_NAME, true)
                if mpGamerTagSettings[serverId] and mpGamerTagSettings[serverId].nameTag then
                    if mpGamerTagSettings[myserverId] and mpGamerTagSettings[myserverId].nameTag then
                        SetMpGamerTagName(tag, "["..serverId.."] " .. mpGamerTagSettings[serverId].nameTag)
                    else
                        SetMpGamerTagName(tag, "["..serverId.."] " .. mpGamerTagSettings[serverId].nameTag)
                    end
                else
                    if level == -1 then
                        SetMpGamerTagName(tag, "["..serverId.."]")
                    else
                        SetMpGamerTagName(tag, "["..serverId.."] ".. "| lvl : ".. level )
                    end
                end
                for k,v in pairs(mpGamerTagSettings[serverId].colors) do
                    SetMpGamerTagColour(tag, gtComponent[k], v)
                end
                if mpGamerTagSettings[serverId].nameTag then
                    SetMpGamerTagColour(tag, gtComponent.GAMER_NAME, 6)
                end
            else
                --SetMpGamerTagVisibility(tag, gtComponent.MP_TYPING, false)
                SetMpGamerTagVisibility(tag, gtComponent.GAMER_NAME, false)
                SetMpGamerTagVisibility(tag, gtComponent.AUDIO_ICON, false)
            end
        else
            SetMpGamerTagVisibility(tag, gtComponent.MP_TYPING, false)
            SetMpGamerTagVisibility(tag, gtComponent.GAMER_NAME, false)
            SetMpGamerTagVisibility(tag, gtComponent.AUDIO_ICON, false)
        end

        ::skip_this::
    end
end

Citizen.CreateThread(function()
    while true do
        for _, player in ipairs(GetActivePlayers()) do

            local coords = GetEntityCoords(GetPlayerPed(-1))
            local coords2 = GetEntityCoords(GetPlayerPed(player))
            local distance = math.floor(Vdist2(coords.x, coords.y, coords.z, coords2.x, coords2.y, coords2.z))
            playersInfo[player] = {}
            playersInfo[player]["info"] = {}
            playersInfo[player].info["distance"] = distance
            playersInfo[player].info["cansee"] = IsEntityVisible(GetPlayerPed(player))
        end
        Citizen.Wait(2000)
    end
end)

AddEventHandler('onKeyUP', function(key)
    if key == "numpad7" then
        if not ShowPlayersId then
            ShowPlayersId = true
            TriggerServerEvent("3dme:shareDisplay",
                'Player [' .. GetPlayerServerId(PlayerId()) .. "] Be ID Ha Negah Kard", true)
            SetTimeout(5000, function()
                ShowPlayersId = false
            end)
        end
    end
end)

RegisterNetEvent("ShowID")
AddEventHandler("ShowID", function(state)
    if state == true then
        ShowPlayersId = true
    else
        ShowPlayersId = false
    end
end)


RegisterNetEvent("UpdateAdminTags")
AddEventHandler("UpdateAdminTags", function(Tags)
    Admins = {}
    Admins = Tags
end)

function GetColor(RankName)
 -- 18 SH 
    local RankColors = {
        ['Helper'] = {code = 172, rgb = {r = 92, g = 113, b = 120}},
        ['Senior Helper'] = {code = 18, rgb = {r = 3, g = 255, b = 0}},
        ['Head Helper'] = {code = 129, rgb = {r = 0, g = 212, b = 131}},
        ['Admin'] = {code = 9, rgb = {r = 14, g = 188, b = 30}},
        ['Senior Admin'] = {code = 21, rgb = {r = 0, g = 129, b = 161}},
        ['Head Admin'] = {code = 212, rgb = {r = 67, g = 61, b = 250}},
        ['Moderator'] = {code = 215, rgb = {r = 19, g = 11, b = 241}},
        ['Head Moderator'] = {code = 147, rgb = {r = 255, g = 0, b = 0}},
        ['Supervisor'] = {code = 168, rgb = {r = 246, g = 255, b = 0}},
        ['Manager'] = {code = 142, rgb = {r = 255, g = 255, b = 255}},
        ['Owner'] = {code = 0, rgb = {r = 255, g = 255, b = 255}}, -- 0
        ['Developer'] = {code = 206, rgb = {r = 255, g = 255, b = 255}},

    }
    if RankColors[RankName] then
        return tonumber(RankColors[RankName].code)
    else
        return 2
    end

end
function UpdateAdminTags()
    SetTimeout(250, UpdateAdminTags)
    for k, v in pairs(GetActivePlayers()) do
        for j, c in pairs(Admins) do
            if c.ID == GetPlayerServerId(v) and c.Tag then
                CreateMpGamerTagForNetPlayer(v, "[" .. c.Tag .. "] " .. GetPlayerName(v), false, false, '', 0, 0, 0, 0)
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(GetPlayerPed(v))) < 15.0 and
                    DoesEntityExist(GetPlayerPed(v)) and c.Toggle then
                    if DecorGetInt(GetPlayerPed(v), 'typing') == 1 or NetworkIsPlayerTalking(v) then
                        SetMpGamerTagVisibility(v, 0, false)
                    else
                        SetMpGamerTagVisibility(v, 0, true)
                    end
                    SetMpGamerTagColour(v, 0, tonumber(GetColor(c.Tag)))
                    SetMpGamerTagAlpha(v, 0, 255)
                else
                    SetMpGamerTagVisibility(v, 0, false)
                end
            end
        end
    end
end

AddEventHandler('onResourceStop', function(name)
    if name == GetCurrentResourceName() then
        for _, v in pairs(mpGamerTags) do
            RemoveMpGamerTag(v.tag)
        end
    end
end)


updatePlayerNames()
SetTimeout(250, UpdateAdminTags)