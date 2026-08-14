ESX = nil
local connectedPlayers = {}
--jobs
local Admins = 0
local Police = 0
local MT = 0
local Sheriff = 0
local Fbi = 0
local Mechanic = 0
local Taxi = 0
local Medic = 0
local weazel = 0
local Cid = 0
local Cia = 0
local Marshal = 0
local Judge = 0
local Doa = 0
--Robs
local Bank = 0
local Feleca = 0
local Minibank = 0
local SheriffBank=0
local Javahery = 0
local Bime = 0
local Cargo = 0
local JewelerySheriff = 0
local mythic = 0
local shop = 0


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_scoreboard:getConnectedPlayers', function(source, cb)
	cb(connectedPlayers)
end)

AddEventHandler('esx:setJob', function(playerId, job, lastJob)
	connectedPlayers[playerId].job = job.name

	TriggerClientEvent('esx_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end)

ESX.RegisterServerCallback("scoreboard:getPlayersJob", function(source, cb)
	Citizen.Wait(400)
    Police = 0
	MT = 0
    Sheriff = 0
    Fbi = 0
	Mechanic = 0
	Taxi = 0
	Medic = 0
	Admins = 0
	weazel = 0
    Medic = 0
	weazel = 0
	Cid = 0
	Cia = 0
	Marshal = 0
	Judge = 0
	Doa = 0
    for k, v in pairs(GetPlayers()) do
		local xPlayer = ESX.GetPlayerFromId(v)
		if xPlayer then 
			if ESX.GetPlayerFromId(v).job.name == "fbi" then
				Fbi = Fbi + 1
			end
			if ESX.GetPlayerFromId(v).job.name == "sheriff" then
				Sheriff  = Sheriff  + 1
			end
			if ESX.GetPlayerFromId(v).job.name == "police" then
				Police = Police + 1
			end
			if ESX.GetPlayerFromId(v).job.name == "mt" then
				MT = MT + 1
			end
			if ESX.GetPlayerFromId(v).job.name == "mechanic" then
				Mechanic = Mechanic + 1
			end
			if ESX.GetPlayerFromId(v).job.name == "taxi" then
				Taxi = Taxi + 1
			end
			if ESX.GetPlayerFromId(v).job.name == "ambulance" then
				Medic = Medic + 1
			end
			if ESX.GetPlayerFromId(v).job.name == "weazel" then
				weazel = weazel + 1
			end
			if ESX.GetPlayerFromId(v).job.name == "cid" then
				Cid = Cid + 1
			end
			if ESX.GetPlayerFromId(v).job.name == "cia" then
				Cia = Cia + 1
			end
			if ESX.GetPlayerFromId(v).job.name == "marshal" then
				Marshal = Marshal + 1
			end
			if ESX.GetPlayerFromId(v).job.name == "judge" then
				Judge = Judge + 1
			end
			if ESX.GetPlayerFromId(v).job.name == "doa" then
				Doa = Doa + 1
			end
			if ESX.GetPlayerFromId(v).permission_level > 0 and ESX.GetPlayerFromId(v).get('aduty') then
				Admins = Admins + 1
			end
		end
    end

    cb({
        police = Police,
        mt = MT,
        sheriff = Sheriff,
        fbi = Fbi,
		mechanic = Mechanic,
		taxi = Taxi,
		ambulance = Medic,
		weazel = weazel,
		cid = Cid,
		cia = Cia,
		marshal = Marshal,
		judge = Judge,
		doa = Doa,
		admins=Admins
    })
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	AddPlayerToScoreboard(xPlayer, true)
end)

AddEventHandler('esx:playerDropped', function(playerId)
	connectedPlayers[playerId] = nil

	TriggerClientEvent('esx_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end)


AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.CreateThread(function()
			Citizen.Wait(1000)
			AddPlayersToScoreboard()
		end)
	end
end)

function AddPlayerToScoreboard(xPlayer, update)
	local playerId = xPlayer.source

	connectedPlayers[playerId] = {}

	if update then
		TriggerClientEvent('esx_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
	end

end

ESX.RegisterServerCallback('GetAllPlayersRV', function(source, cb)
	local allpl = 0
	local tedadplayer = 0
	local players = ESX.GetPlayers()

	for i=1, #players, 1 do
		allpl = allpl +1
		
	end
	tedadplayer = allpl
	cb(tedadplayer)
end)

function AddPlayersToScoreboard()
	local players = ESX.GetPlayers()

	for i=1, #players, 1 do
		local xPlayer = ESX.GetPlayerFromId(players[i])
		AddPlayerToScoreboard(xPlayer, false)
		
	end

	TriggerClientEvent('esx_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end

ESX.RegisterServerCallback("scoreboard:getRobsCd", function(source, cb)

	cb({
		cargo=os.time() - Cargo - 14400,		--!Time To Second
		jewelery=os.time() - Javahery - 1800,
		Bimeh=os.time() - Bime - 5400,
		Bank=os.time() - Bank - 7200,
		SheriffBank=os.time() - SheriffBank - 7200,
		Minibank=os.time() - Minibank - 420,
		Feleca=os.time() - Feleca - 7200,
		JewelerySheriff=os.time() - JewelerySheriff - 1800,
		mythic=os.time() - mythic - 5400,
		shop=os.time() - shop - 240,
	})
end)


AddEventHandler("SetRobberyCoolDown", function(Rob)
	if Rob == "jewelery" then 
		Javahery = os.time()
	elseif Rob == "Cargo" then 
		Cargo = os.time()
	elseif Rob == "Bimeh" then 
		Bime = os.time()
	elseif Rob == "Bank" then 
		Bank = os.time()
	elseif Rob == "SheriffBank" then 
		SheriffBank = os.time()
	elseif Rob == "Feleca" then 
		Feleca = os.time()
	elseif Rob == "shop" then 
		shop = os.time()
	elseif Rob == "Minibank" then 
		Minibank = os.time()
	elseif Rob == "JewelerySheriff" then 
		JewelerySheriff = os.time()
	elseif Rob == "mythic" then 
		mythic = os.time()
	end
end)


ESX.RegisterServerCallback('playertimeplayerr', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    exports.oxmysql:execute("SELECT timePlay FROM users WHERE identifier = @identifier", {["@identifier"] = xPlayer.identifier}, function(resualt)
        local hours, minutes = convertSecondsToTime(resualt[1].timePlay)

		local timeplarr = string.format("%02d:%02d", hours, minutes)
		

        cb(tostring(timeplarr))

    end)

end)

function convertSecondsToTime(seconds)

    local hours = math.floor(seconds / 3600)
    seconds = seconds % 3600


    local minutes = math.floor(seconds / 60)
    seconds = seconds % 60


    local remainingSeconds = seconds

    return hours, minutes, remainingSeconds
end