--[[
	Unique_Radio - config.lua
	Merged from "radio_list" (on-screen radio member list) + "rp-radio" (handheld radio item).
	Everything both scripts need lives in this ONE file now.
]]

-----------------------------------------------------------
-- 1) RADIO LIST (on-screen overlay of who is on your channel)
-----------------------------------------------------------
Config = {}

Config.UseRPName = true -- Use ESX / QB-Core / JLRP-Framework name if available

Config.LetPlayersChangeVisibilityOfRadioList = true
Config.RadioListVisibilityCommand = "radiolist" -- only if LetPlayersChangeVisibilityOfRadioList = true

Config.LetPlayersSetTheirOwnNameInRadio = true
Config.ResetPlayersCustomizedNameOnExit = true -- only if LetPlayersSetTheirOwnNameInRadio = true
Config.RadioListChangeNameCommand = "nameinradio" -- only if LetPlayersSetTheirOwnNameInRadio = true

-- Friendly display names for the overlay list.
-- FIXED: extended to cover every channel Unique_Radio actually uses (was missing 29/30/36/911/40/41,
-- which used to make the overlay show raw numbers instead of names for those channels).
Config.RadioChannelsWithName = {
	["0"]   = "Admin",
	["1"]   = "Police",
	["2"]   = "Sheriff",
	["3"]   = "Fbi",
	["4"]   = "Dadgostari",
	["5"]   = "Ambulance",
	["29"]  = "Mechanic",
	["30"]  = "Artesh",
	["36"]  = "Taxi",
	["911"] = "Shared",
	["40"]  = "World (Public)",
	["41"]  = "World (Streamer)",
}

-----------------------------------------------------------
-- 2) HANDHELD RADIO (item, controls, frequency dial)
-----------------------------------------------------------
radioConfig = {
	Controls = {
		Activator = { Name = "INPUT_CELLPHONE_CANCEL", Key = 177 }, -- BackSpace
		Secondary = { Name = "INPUT_SPRINT", Key = 21, Enabled = false },
		Toggle    = { Name = "INPUT_CONTEXT", Key = 51 }, -- E
		Increase  = { Name = "INPUT_CELLPHONE_RIGHT", Key = 175, Pressed = false },
		Decrease  = { Name = "INPUT_CELLPHONE_LEFT", Key = 174, Pressed = false },
		Input     = { Name = "INPUT_FRONTEND_ACCEPT", Key = 201, Pressed = false }, -- Enter
		Broadcast = { Name = "INPUT_INTERACTION_MENU", Key = 244 }, -- M
		ToggleClicks = { Name = "INPUT_SELECT_WEAPON", Key = 37 }, -- Tab
	},
	Frequency = {
		Private = { -- Manually-blocked frequencies (need explicit access to tune into these)
			[1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true,
			[8] = true, [9] = true, [10] = true, [11] = true, [12] = true, [13] = true, [14] = true,
			[15] = true, [16] = true, [17] = true, [18] = true, [19] = true, [20] = true,
		},
		Current = 1,      -- Don't touch
		CurrentIndex = 1, -- Don't touch
		Min = 1,
		Max = 1000,
		List = {},   -- Don't touch, generated at runtime
		Access = {}, -- Don't touch, generated at runtime
	},
	AllowRadioWhenClosed = true,
}

-----------------------------------------------------------
-- 3) JOB <-> FREQUENCY PRIVACY
-----------------------------------------------------------
-- FIXED (real access-control bug): the original rp-radio granted each job "private"
-- access to one set of frequencies (901-913 range) while the actual job keybind
-- (ALT+1 -> JoinRadioJob) put people on a DIFFERENT, completely unprotected channel
-- (1, 2, 3, 4, 5, 29, 30, 36). That meant anyone could manually dial into
-- frequency 29/30/36 (and even 1-5 was only "protected" by luck, since 1-20 happens
-- to be in the generic Private block above) and eavesdrop on Mechanic/Artesh/Taxi
-- radio chatter, and there was no shared 911 line consistency either.
-- Below, every job is granted access to the EXACT channel its keybind actually
-- joins, so the channel that's really used is the one that's actually protected.
SI = {
	PrivateFrequency = {
		["police"]     = { 1, 901, 900, 911 },
		["sheriff"]    = { 2, 902, 900, 911 },
		["fbi"]        = { 3, 904, 900, 911 },
		["dadgostari"] = { 4, 912, 900, 911 }, -- DOJ / judge
		["ambulance"]  = { 5, 905, 911 },
		["mechanic"]   = { 29, 906 },
		["taxi"]       = { 36, 907 },
		["artesh"]     = { 30, 911 },
		-- Kept for other jobs that may exist on the server but aren't wired to a
		-- keybind in this resource yet - harmless if unused.
		["mt"]     = { 903, 900 },
		["cid"]    = { 909, 900 },
		["cia"]    = { 910, 900 },
		["judge"]  = { 912, 900 },
		["doa"]    = { 913, 900 },
		["weazel"] = { 908 },
	}
}

for _, frequencies in pairs(SI.PrivateFrequency) do
	for _, frequency in pairs(frequencies) do
		radioConfig.Frequency.Private[frequency] = true
	end
end
