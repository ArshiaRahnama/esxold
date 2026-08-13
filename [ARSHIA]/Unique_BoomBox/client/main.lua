ESX = nil
local isBoomboxActive = false
local boomboxObject = nil
local currentSound = nil
local currentVolume = Config.DefaultVolume
local currentDistance = Config.MaxDistance * (Config.DefaultVolume / Config.MaxVolume)
local playerId = nil

-- active playlist playback state (nil when nothing is playing from a playlist)
local activePlaylist = nil -- { name = ..., songs = { ... }, index = 1 }

local ANIM_DICT = 'missfinale_c2mcs_1'
local ANIM_NAME = 'fin_c2_mcs_1_camman'
local BONE_ID = 24818
local ATTACH_OFFSET = { x = 0.48, y = 0.14, z = -0.14 }
local ATTACH_ROT = { x = 90.0, y = 0.0, z = 90.0 }

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    playerId = GetPlayerServerId(PlayerId())
end)

-- ==========================================================
-- Helpers
-- ==========================================================

local function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end
end

local function loadModel(model)
    local hash = GetHashKey(model)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(0)
    end
    return hash
end

-- attaches (or re-attaches) the boombox prop + holding anim to the ped
local function applyBoomboxHold(playerPed)
    if not IsEntityPlayingAnim(playerPed, ANIM_DICT, ANIM_NAME, 3) then
        loadAnimDict(ANIM_DICT)
        TaskPlayAnim(playerPed, ANIM_DICT, ANIM_NAME, 8.0, -8.0, -1, 49, 0, false, false, false)
    end

    if boomboxObject and DoesEntityExist(boomboxObject) and not IsEntityAttachedToEntity(boomboxObject, playerPed) then
        AttachEntityToEntity(
            boomboxObject, playerPed, GetPedBoneIndex(playerPed, BONE_ID),
            ATTACH_OFFSET.x, ATTACH_OFFSET.y, ATTACH_OFFSET.z,
            ATTACH_ROT.x, ATTACH_ROT.y, ATTACH_ROT.z,
            true, true, false, true, 1, true
        )
    end
end

local function shortLink(link, maxLen)
    maxLen = maxLen or 42
    if #link <= maxLen then return link end
    return link:sub(1, maxLen - 3) .. '...'
end

-- fully stops the boombox and restores the player's normal state
function StopBoombox()
    if not isBoomboxActive then return end

    local playerPed = PlayerPedId()

    lib.hideContext()

    loadAnimDict('anim@heists@money_grab@briefcase')
    TaskPlayAnim(playerPed, 'anim@heists@money_grab@briefcase', 'put_down_case', 8.0, -8.0, -1, 49, 0, false, false, false)
    Citizen.Wait(700)
    ClearPedTasks(playerPed)

    if boomboxObject and DoesEntityExist(boomboxObject) then
        DeleteObject(boomboxObject)
    end
    boomboxObject = nil

    TriggerEvent('canemote', true)
    TriggerEvent('cansoot', true)
    TriggerEvent('handappstate', true)
    SetCanPedEquipAllWeapons(playerPed, true)

    isBoomboxActive = false
    activePlaylist = nil
    TriggerServerEvent('Im0ArSaBoom:stopMusic')
end

RegisterNetEvent('Im0ArSaBoom:use')
AddEventHandler('Im0ArSaBoom:use', function()
    if isBoomboxActive then return end

    TriggerEvent('canemote', false)
    TriggerEvent('cansoot', false)
    TriggerEvent('handappstate', false)
    local playerPed = PlayerPedId()
    SetCanPedEquipAllWeapons(playerPed, false)
    local coords = GetEntityCoords(playerPed)

    loadAnimDict('anim@heists@money_grab@briefcase')
    TaskPlayAnim(playerPed, 'anim@heists@money_grab@briefcase', 'put_down_case', 8.0, -8.0, -1, 49, 0, false, false, false)
    Citizen.Wait(1000)
    ClearPedTasks(playerPed)

    local hash = loadModel('prop_boombox_01')
    boomboxObject = CreateObject(hash, coords.x, coords.y, coords.z, true, true, true)

    loadAnimDict(ANIM_DICT)
    TaskPlayAnim(playerPed, ANIM_DICT, ANIM_NAME, 8.0, -8.0, -1, 49, 0, false, false, false)
    AttachEntityToEntity(
        boomboxObject, playerPed, GetPedBoneIndex(playerPed, BONE_ID),
        ATTACH_OFFSET.x, ATTACH_OFFSET.y, ATTACH_OFFSET.z,
        ATTACH_ROT.x, ATTACH_ROT.y, ATTACH_ROT.z,
        true, true, false, true, 1, true
    )
    isBoomboxActive = true
    showhelp()
end)

function showhelp()
    Citizen.CreateThread(function()
        Citizen.Wait(500)
        while isBoomboxActive do
            Citizen.Wait(1)
            ESX.ShowHelpNotification('Baraye Baz Kardane ~g~Menu BoomBox ~w~Dokme ~r~G~w~ Ro Feshar Bedid ~n~(~r~' .. Config.StopKey:upper() .. '~w~ Baraye Khamoosh Kardane Foori)')
        end
    end)
end

-- ==========================================================
-- Bug fix watchdog: re-applies the hold anim / prop attachment
-- after a screen-fade transition (entering an interior / a
-- minigame behind a door, etc.) so the boombox never gets
-- stuck mid-animation. It never fights an unrelated anim that
-- doesn't involve a fade (e.g. short interaction minigames),
-- so it won't interfere with other scripts.
-- ==========================================================
Citizen.CreateThread(function()
    local wasFadedOut = false
    while true do
        Citizen.Wait(250)
        if isBoomboxActive then
            local fadedOut = IsScreenFadedOut() or IsScreenFadingOut()

            if fadedOut then
                wasFadedOut = true
            elseif wasFadedOut and not fadedOut then
                wasFadedOut = false
                Citizen.Wait(400)
                local playerPed = PlayerPedId()
                if isBoomboxActive
                    and not IsPedRagdoll(playerPed)
                    and not IsPedInAnyVehicle(playerPed, false)
                    and not IsEntityDead(playerPed)
                    and not IsPedCuffed(playerPed) then
                    applyBoomboxHold(playerPed)
                end
            end
        end
    end
end)

-- auto-stop in situations where carrying the boombox no longer makes sense
-- (also prevents the "stuck" object/anim state in those cases)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if isBoomboxActive then
            local playerPed = PlayerPedId()
            if IsEntityDead(playerPed) or IsPedInAnyVehicle(playerPed, false) then
                StopBoombox()
            end
        end
    end
end)

-- cleans everything up if the resource gets stopped/restarted while
-- a player has the boombox active, so they never get left with
-- "canemote/cansoot" permanently disabled or an orphaned prop
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    if isBoomboxActive then
        StopBoombox()
    end
end)

-- ==========================================================
-- Playback
-- ==========================================================

local function playLink(link)
    if not link or link == '' then
        ESX.ShowNotification('Link Eshtebas !')
        return false
    end
    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('Im0ArSaBoom:playMusic', link, coords, currentVolume, currentDistance)
    ESX.ShowNotification('Music Ba Movafaghiat Play Shod')
    return true
end

local function playPlaylistFrom(name, songs, startIndex)
    if not songs or #songs == 0 then return end
    if startIndex < 1 or startIndex > #songs then startIndex = 1 end
    activePlaylist = { name = name, songs = songs, index = startIndex }
    playLink(activePlaylist.songs[activePlaylist.index])
end

local function playlistStep(delta)
    if not activePlaylist then return end
    activePlaylist.index = activePlaylist.index + delta
    if activePlaylist.index > #activePlaylist.songs then
        activePlaylist.index = 1
    elseif activePlaylist.index < 1 then
        activePlaylist.index = #activePlaylist.songs
    end
    playLink(activePlaylist.songs[activePlaylist.index])
end

-- ==========================================================
-- ox_lib menu
-- ==========================================================

local function openVolumeDialog()
    local input = lib.inputDialog('Set Volume', {
        { type = 'slider', label = 'Volume (%)', min = 0, max = 100, default = math.floor(currentVolume * 100) }
    })
    if input and input[1] then
        currentVolume = input[1] / 100
        TriggerServerEvent('Im0ArSaBoom:setVolume', currentVolume, currentDistance)
    end
    OpenBoomMenu()
end

local function openDistanceDialog()
    local input = lib.inputDialog('Set Distance', {
        { type = 'slider', label = 'Distance (m)', min = 0, max = Config.MaxDistance, default = math.floor(currentDistance) }
    })
    if input and input[1] then
        currentDistance = input[1]
        TriggerServerEvent('Im0ArSaBoom:setDistance', currentDistance)
    end
    OpenBoomMenu()
end

local function openPlayDialog()
    local input = lib.inputDialog('Play Music', {
        { type = 'input', label = 'Music Link', required = true, placeholder = 'https://...' }
    })
    if input and input[1] and input[1] ~= '' then
        activePlaylist = nil
        playLink(input[1])
    end
    OpenBoomMenu()
end

local function buildHistoryMenu(history)
    local options = {}
    if history and #history > 0 then
        for _, entry in ipairs(history) do
            table.insert(options, {
                title = shortLink(entry.link),
                icon = 'clock-rotate-left',
                onSelect = function()
                    activePlaylist = nil
                    playLink(entry.link)
                end
            })
        end
    else
        table.insert(options, { title = 'Chizi Peida Nashod', disabled = true })
    end

    lib.registerContext({
        id = 'boombox_history',
        title = 'Recently Played',
        menu = 'boombox_main',
        options = options
    })
end

local function openPlaylistDetail(pl)
    local options = {
        {
            title = '▶ Play All',
            icon = 'play',
            disabled = #pl.songs == 0,
            onSelect = function()
                playPlaylistFrom(pl.name, pl.songs, 1)
            end
        },
        {
            title = '＋ Add Song',
            icon = 'plus',
            onSelect = function()
                local input = lib.inputDialog('Add Song', {
                    { type = 'input', label = 'Music Link', required = true, placeholder = 'https://...' }
                })
                if input and input[1] and input[1] ~= '' then
                    ESX.TriggerServerCallback('Im0ArSaBoom:addToPlaylist', function(ok, result)
                        if not ok then ESX.ShowNotification(result) end
                        OpenBoomMenu()
                    end, pl.name, input[1])
                    return
                end
                OpenBoomMenu()
            end
        }
    }

    for idx, songLink in ipairs(pl.songs) do
        table.insert(options, {
            title = idx .. '. ' .. shortLink(songLink, 34),
            icon = 'music',
            description = 'Play from here',
            onSelect = function()
                playPlaylistFrom(pl.name, pl.songs, idx)
            end
        })
    end

    if #pl.songs > 0 then
        table.insert(options, {
            title = '🗑 Remove A Song',
            icon = 'trash',
            iconColor = '#ff4d5e',
            onSelect = function()
                local selectOptions = {}
                for idx, songLink in ipairs(pl.songs) do
                    table.insert(selectOptions, { label = idx .. '. ' .. shortLink(songLink, 30), value = idx })
                end
                local input = lib.inputDialog('Remove Song', {
                    { type = 'select', label = 'Which Song ?', options = selectOptions, required = true }
                })
                if input and input[1] then
                    ESX.TriggerServerCallback('Im0ArSaBoom:removeFromPlaylist', function(ok, result)
                        if not ok then ESX.ShowNotification(result) end
                        OpenBoomMenu()
                    end, pl.name, input[1])
                    return
                end
                OpenBoomMenu()
            end
        })
    end

    table.insert(options, {
        title = '🗑 Delete This Playlist',
        icon = 'trash',
        iconColor = '#ff4d5e',
        onSelect = function()
            local confirm = lib.alertDialog({
                header = 'Delete "' .. pl.name .. '" ?',
                content = 'In Amal Ghabele Bargasht Nist.',
                centered = true,
                cancel = true
            })
            if confirm == 'confirm' then
                ESX.TriggerServerCallback('Im0ArSaBoom:deletePlaylist', function(ok, result)
                    if ok then
                        if activePlaylist and activePlaylist.name == pl.name then
                            activePlaylist = nil
                        end
                    else
                        ESX.ShowNotification(result)
                    end
                    OpenBoomMenu()
                end, pl.name)
                return
            end
            OpenBoomMenu()
        end
    })

    lib.registerContext({
        id = 'boombox_playlist_detail',
        title = pl.name,
        menu = 'boombox_playlists',
        options = options
    })
    lib.showContext('boombox_playlist_detail')
end

local function buildPlaylistsMenu(playlists)
    local options = {
        {
            title = '＋ New Playlist',
            icon = 'plus',
            onSelect = function()
                local input = lib.inputDialog('New Playlist', {
                    { type = 'input', label = 'Playlist Name', required = true, max = Config.MaxPlaylistNameLength }
                })
                if input and input[1] and input[1] ~= '' then
                    ESX.TriggerServerCallback('Im0ArSaBoom:createPlaylist', function(ok, result)
                        if not ok then ESX.ShowNotification(result) end
                        OpenBoomMenu()
                    end, input[1])
                    return
                end
                OpenBoomMenu()
            end
        }
    }

    if playlists and #playlists > 0 then
        for _, pl in ipairs(playlists) do
            table.insert(options, {
                title = pl.name,
                description = #pl.songs .. ' song(s)',
                icon = 'list',
                arrow = true,
                onSelect = function()
                    openPlaylistDetail(pl)
                end
            })
        end
    end

    lib.registerContext({
        id = 'boombox_playlists',
        title = 'Playlists',
        menu = 'boombox_main',
        options = options
    })
end

local function buildMainMenu(data)
    local options = {}

    if activePlaylist then
        table.insert(options, {
            title = 'Now Playing: ' .. activePlaylist.name,
            description = 'Track ' .. activePlaylist.index .. ' / ' .. #activePlaylist.songs,
            icon = 'music',
            disabled = true
        })
        table.insert(options, {
            title = '⏮ Previous Track',
            icon = 'backward-step',
            onSelect = function()
                playlistStep(-1)
                OpenBoomMenu()
            end
        })
        table.insert(options, {
            title = '⏭ Next Track',
            icon = 'forward-step',
            onSelect = function()
                playlistStep(1)
                OpenBoomMenu()
            end
        })
    end

    table.insert(options, {
        title = 'Play Music',
        icon = 'play',
        onSelect = openPlayDialog
    })
    table.insert(options, {
        title = ('Volume: %d%%'):format(math.floor(currentVolume * 100)),
        icon = 'volume-high',
        onSelect = openVolumeDialog
    })
    table.insert(options, {
        title = ('Distance: %dm'):format(math.floor(currentDistance)),
        icon = 'ruler-horizontal',
        onSelect = openDistanceDialog
    })
    table.insert(options, {
        title = 'Recently Played',
        icon = 'clock-rotate-left',
        arrow = true,
        menu = 'boombox_history'
    })
    table.insert(options, {
        title = 'Playlists',
        icon = 'list-music',
        arrow = true,
        menu = 'boombox_playlists'
    })
    table.insert(options, {
        title = 'Stop Boombox',
        icon = 'stop',
        iconColor = '#ff4d5e',
        onSelect = function()
            StopBoombox()
        end
    })

    buildHistoryMenu(data.history)
    buildPlaylistsMenu(data.playlists)

    lib.registerContext({
        id = 'boombox_main',
        title = 'Boombox Menu',
        options = options
    })
end

function OpenBoomMenu()
    if not isBoomboxActive then return end
    ESX.TriggerServerCallback('Im0ArSaBoom:getData', function(data)
        buildMainMenu(data)
        lib.showContext('boombox_main')
    end)
end

RegisterCommand('boombox_openmenu', function()
    if isBoomboxActive then
        OpenBoomMenu()
    end
end, false)
RegisterKeyMapping('boombox_openmenu', 'Baz Kardan Menu Boombox', 'keyboard', Config.OpenMenuKey)

RegisterCommand('boombox_stop', function()
    if isBoomboxActive then
        StopBoombox()
    end
end, false)
RegisterKeyMapping('boombox_stop', 'Khamoosh Kardane Foori Boombox', 'keyboard', Config.StopKey)

-- ==========================================================
-- xsound wiring
-- ==========================================================

RegisterNetEvent('Im0ArSaBoom:playMusic')
AddEventHandler('Im0ArSaBoom:playMusic', function(soundId, link, coords, volume, distance)
    if exports['xsound']:soundExists(soundId) then
        exports['xsound']:Destroy(soundId)
        Citizen.Wait(100)
    end
    exports['xsound']:PlayUrlPos(soundId, link, volume, coords)
    exports['xsound']:Distance(soundId, distance)
    exports['xsound']:setSoundDynamic(soundId, true)
    if GetPlayerServerId(PlayerId()) == playerId then
        currentSound = soundId
    end
    Citizen.Wait(500)
    if not exports['xsound']:soundExists(soundId) then
        ESX.ShowNotification('Link Dorost Nist !')
    end
end)

RegisterNetEvent('Im0ArSaBoom:setVolume')
AddEventHandler('Im0ArSaBoom:setVolume', function(soundId, volume, distance)
    if exports['xsound']:soundExists(soundId) then
        exports['xsound']:setVolume(soundId, volume)
        exports['xsound']:Distance(soundId, distance)
        if GetPlayerServerId(PlayerId()) == playerId then
            currentVolume = volume
            currentDistance = distance
        end
    end
end)

RegisterNetEvent('Im0ArSaBoom:setDistance')
AddEventHandler('Im0ArSaBoom:setDistance', function(soundId, distance)
    if exports['xsound']:soundExists(soundId) then
        exports['xsound']:Distance(soundId, distance)
        if GetPlayerServerId(PlayerId()) == playerId then
            currentDistance = distance
        end
    end
end)

RegisterNetEvent('Im0ArSaBoom:stopMusic')
AddEventHandler('Im0ArSaBoom:stopMusic', function(soundId)
    if exports['xsound']:soundExists(soundId) then
        exports['xsound']:Destroy(soundId)
        if GetPlayerServerId(PlayerId()) == playerId then
            currentSound = nil
        end
    end
end)

RegisterNetEvent('Im0ArSaBoom:updatePosition')
AddEventHandler('Im0ArSaBoom:updatePosition', function(soundId, coords)
    if exports['xsound']:soundExists(soundId) then
        exports['xsound']:Position(soundId, coords)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        if isBoomboxActive and currentSound and exports['xsound']:soundExists(currentSound) then
            local coords = GetEntityCoords(PlayerPedId())
            TriggerServerEvent('Im0ArSaBoom:updatePosition', coords)
        end
    end
end)

-- best-effort playlist auto-advance: when the current track is close to
-- ending, move on to the next song in the active playlist. Wrapped in
-- pcall since the exact xsound export/shape can vary between versions --
-- if it's unavailable, manual Next/Prev in the menu still always works.
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if isBoomboxActive and activePlaylist and currentSound then
            local ok, stamp = pcall(function()
                return exports['xsound']:getTimeStamp(currentSound)
            end)
            if ok and stamp and stamp.duration and stamp.duration > 0
                and stamp.currentTime and (stamp.duration - stamp.currentTime) <= 1.2 then
                playlistStep(1)
                Citizen.Wait(3000) -- avoid double-advancing while the new track loads
            end
        end
    end
end)
