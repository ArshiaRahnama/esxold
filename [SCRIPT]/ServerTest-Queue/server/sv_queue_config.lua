ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Config = {}

local loadFile = LoadResourceFile(GetCurrentResourceName(), "./people.json")
local people = json.decode(loadFile)

Config.Priority = {}

MySQL.ready(function()
    local admins = MySQL.Sync.fetchAll('SELECT * FROM users WHERE permission_level > 0')
    for i,v in ipairs(admins) do
        Config.Priority[v.identifier] = v.permission_level
    end

    for i,v in ipairs(people) do
        Config.Priority[v.identifier] = v.perm
    end
end)

RegisterCommand('aqueue', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.permission_level >= 10 then

        if not args[1] or not tonumber(args[1]) or not args[2] or not tonumber(args[2]) then
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Syntax vared shode eshtebah ast!")
            return
        end

        local target = tonumber(args[1])
        local perm = tonumber(args[2])

        local name = GetPlayerName(target)
        if name then
            local identifier = GetPlayerIdentifier(target)
            if not Config.Priority[identifier] then
                table.insert(people, {identifier = identifier, perm = perm})
                SaveResourceFile(GetCurrentResourceName(), "people.json", json.encode(people), -1)
                Config.Priority[identifier] = perm
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^2 " .. name .. "^0 ba priority ^1" .. perm .. "^0 ezafe shod!")
            else
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0In shakhs dar list hast!")
            end
        else
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0ID vared shode eshtebah ast!")
        end

    else
        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dastresi kafi baraye in dastor ra nadarid!")
    end

end, false)

Config.RequireSteam = true

Config.PriorityOnly = false

Config.DisableHardCap = true

Config.ConnectTimeOut = 600

Config.QueueTimeOut = 90

Config.EnableGrace = true

Config.GracePower = 5

Config.GraceTime = 480

Config.JoinDelay = 20000

Config.ShowTemp = true

Config.Language = {
    joining = "\xF0\x9F\x8E\x89Dar Hal Vorood...",
    connecting = "\xE2\x8F\xB3Dar Hal Etesal...",
    idrr = "\xE2\x9D\x97[ServerTest-Queue] Moshakhast Shoma Shensaye Nashod Dobare Talash Konid.",
    err = "\xE2\x9D\x97[ServerTest-Queue] ERROR",
    pos = "\xF0\x9F\x90\x8CMogheiat Shoma %d/%d Dar Saf \xF0\x9F\x95\x9C%s",
    connectingerr = "\xE2\x9D\x97[ServerTest-Queue] Error: Shoma Vared Saf Nashodid",
    timedout = "\xE2\x9D\x97[ServerTest-Queue] Error: Timed out.",
    wlonly = "\xE2\x9D\x97[ServerTest-Queue] Shoma Dar List Nistid Nemitavanid Join Shavid.",
    steam = "\xE2\x9D\x97 [ServerTest-Queue] Steam: Steam Khod Ta Baz Konid Sepas Connect Shavid."
}