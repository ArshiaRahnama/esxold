Config         = {}
Locales        = {}
Config.Locale  = 'en'
Config.Zones   = {}
Config.TickTime         = 100
Config.UpdateClientTime = 5000
Config.ReceiveMsg = true
Config.DrawingTime = 15*1000 --10 seconds
Config.TextColor = {r=255, g=255,b=255} -- WHITE (Player Data)
Config.AlertTextColor = {r=255, g=0, b=0} -- RED (Player Left Game)
Config.LogSystem = true
Config.UseSteam = true -- If False then use R* License
Config.LogBotName = "ServerTest CL"
Config.AutoDisableDrawing = true
Config.AutoDisableDrawingTime = 15000
Config.TackleDistance				= 3.0
Config.MaxDistance = 1.5
Config.debug = false
Config.ServiceExtensionOnEscape		= 5
Config.ServiceLocation 				= {x =  1682.3, y = 2515.52, z = 44.9}
Config.ReleaseLocation				= {x = 1846.11, y = 2585.85, z = 45.67}
Config.Price = 100
Config.DrawDistance = 100.0
Config.MarkerSize   = {x = 1.5, y = 1.5, z = 1.0}
Config.MarkerColor  = {r = 102, g = 102, b = 204}
Config.MarkerType   = 1


Config.Shops = {
  {x = -814.308,  y = -183.823,  z = 36.568},
  {x = 136.826,   y = -1708.373, z = 28.291},
  {x = -1282.604, y = -1116.757, z = 5.990},
  {x = 1931.513,  y = 3729.671,  z = 31.844},
  {x = 1212.840,  y = -472.921,  z = 65.208},
  {x = -32.885,   y = -152.319,  z = 56.076},
  {x = -278.077,  y = 6228.463,  z = 30.695},
  --{x = -2678.02,  y = 1303.69,  z = 151.01},
}

for i=1, #Config.Shops, 1 do

	Config.Zones['Shop_' .. i] = {
	 	Pos   = Config.Shops[i],
	 	Size  = Config.MarkerSize,
	 	Color = Config.MarkerColor,
	 	Type  = Config.MarkerType
  }

end

Config.ServiceLocations = {
	{ type = "cleaning", coords = vector3(1682.3, 2515.52, 44.9) },
	{ type = "cleaning", coords = vector3(1669.86, 2494.0, 44.9) }, 
	{ type = "cleaning", coords = vector3(1657.47, 2529.99, 44.9) }, 
	{ type = "cleaning", coords = vector3(1689.26, 2523.39, 44.9) }, 
	{ type = "cleaning", coords = vector3(1679.83, 2494.03, 44.9) }, 
	{ type = "cleaning", coords = vector3(1666.23, 2506.68, 44.9) }, 
	{ type = "cleaning", coords = vector3(1687.47, 2508.32, 44.9) }, 
	{ type = "cleaning", coords = vector3(1700.86, 2519.08, 44.9) },
	{ type = "gardening", coords = vector3(1688.37, 2501.19, 44.9) },
	{ type = "gardening", coords = vector3(1661.83, 2504.66, 44.9) },
	{ type = "gardening", coords = vector3(1666.37, 2520.29, 44.9) },
	{ type = "gardening", coords = vector3(1681.5, 2534.03, 44.9) },
	{ type = "gardening", coords = vector3(1702.24, 2506.54, 44.9) }
}

Config.Uniforms = {
	prison_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1']  = 146, ['torso_2']  = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms']     = 119, ['pants_1']  = 3,
			['pants_2']  = 7,   ['shoes_1']  = 12,
			['shoes_2']  = 12,  ['chain_1']  = 0,
			['chain_2']  = 0
		},
		female = {
			['tshirt_1'] = 3,   ['tshirt_2'] = 0,
			['torso_1']  = 38,  ['torso_2']  = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms']     = 120,  ['pants_1'] = 3,
			['pants_2']  = 15,  ['shoes_1']  = 66,
			['shoes_2']  = 5,   ['chain_1']  = 0,
			['chain_2']  = 0
		}
	}
}

Config.Cooldowns = {
	["police"] = {
		light = 700,
		heavy = 1200
	},
	["civilian"] = {
		light = 1300,
		heavy = 1350
	}
}

Config.Weapons = {
	[GetHashKey("WEAPON_PISTOL")] = "light",
	[GetHashKey("WEAPON_COMBATPISTOL")] = "light",
	[GetHashKey("WEAPON_PISTOL50")] = "light",
	[GetHashKey("WEAPON_SNSPISTOL")] = "light",
	[GetHashKey("WEAPON_HEAVYPISTOL")] = "light",
	[GetHashKey("WEAPON_STUNGUN")] = "light",
	[GetHashKey("WEAPON_REVOLVER")] = "light",
	[GetHashKey("WEAPON_COMBATPDW")] = "heavy",
	[GetHashKey("WEAPON_PUMPSHOTGUN")] = "heavy",
	[GetHashKey("WEAPON_ASSAULTRIFLE")] = "heavy",
	[GetHashKey("WEAPON_ADVANCEDRIFLE")] = "heavy",
	[GetHashKey("WEAPON_SMG")] = "heavy",
	[GetHashKey("WEAPON_CARBINERIFLE")] = "heavy",
	[GetHashKey("WEAPON_BULLPUPRIFLE")] = "heavy",
	[GetHashKey("WEAPON_MICROSMG")] = "light",
}

-- Config.Interactables = {
-- 	"prop_bench_01a",
-- 	"prop_bench_01b",
-- 	"prop_bench_01c",
-- 	"prop_bench_02",
-- 	"prop_bench_03",
-- 	"prop_bench_04",
-- 	"prop_bench_05",
-- 	"prop_bench_06",
-- 	"prop_bench_05",
-- 	"prop_bench_08",
-- 	"prop_bench_09",
-- 	"prop_bench_10",
-- 	"prop_bench_11",
-- 	"prop_fib_3b_bench",
-- 	"prop_ld_bench01",
-- 	"prop_wait_bench_01",
-- 	"hei_prop_heist_off_chair",
-- 	"hei_prop_hei_skid_chair",
-- 	"prop_chair_01a",
-- 	"prop_chair_01b",
-- 	"prop_chair_02",
-- 	"prop_chair_03",
-- 	"prop_chair_04a",
-- 	"prop_chair_04b",
-- 	"prop_chair_05",
-- 	"prop_chair_06",
-- 	"prop_chair_05",
-- 	"prop_chair_08",
-- 	"prop_chair_09",
-- 	"prop_chair_10",
-- 	"prop_chateau_chair_01",
-- 	"prop_clown_chair",
-- 	"prop_cs_office_chair",
-- 	"prop_direct_chair_01",
-- 	"prop_direct_chair_02",
-- 	"prop_gc_chair02",
-- 	"prop_off_chair_01",
-- 	"prop_off_chair_03",
-- 	"prop_off_chair_04",
-- 	"prop_off_chair_04b",
-- 	"prop_off_chair_04_s",
-- 	"prop_off_chair_05",
-- 	"prop_old_deck_chair",
-- 	"prop_old_wood_chair",
-- 	"prop_rock_chair_01",
-- 	"prop_skid_chair_01",
-- 	"prop_skid_chair_02",
-- 	"prop_skid_chair_03",
-- 	"prop_sol_chair",
-- 	"prop_wheelchair_01",
-- 	"prop_wheelchair_01_s",
-- 	"p_armchair_01_s",
-- 	"p_clb_officechair_s",
-- 	"p_dinechair_01_s",
-- 	"p_ilev_p_easychair_s",
-- 	"p_soloffchair_s",
-- 	"p_yacht_chair_01_s",
-- 	"v_club_officechair",
-- 	"v_corp_bk_chair3",
-- 	"v_corp_cd_chair",
-- 	"v_corp_offchair",
-- 	"v_ilev_chair02_ped",
-- 	"v_ilev_hd_chair",
-- 	"v_ilev_p_easychair",
-- 	"v_ret_gc_chair03",
-- 	"prop_ld_farm_chair01",
-- 	"prop_table_04_chr",
-- 	"prop_table_05_chr",
-- 	"prop_table_06_chr",
-- 	"v_ilev_leath_chr",
-- 	"prop_table_01_chr_a",
-- 	"prop_table_01_chr_b",
-- 	"prop_table_02_chr",
-- 	"prop_table_03b_chr",
-- 	"prop_table_03_chr",
-- 	"prop_torture_ch_01",
-- 	"v_ilev_fh_dineeamesa",
-- 	"v_ilev_fh_kitchenstool",
-- 	"v_ilev_tort_stool",
-- 	"v_ilev_fh_kitchenstool",
-- 	"v_ilev_fh_kitchenstool",
-- 	"v_ilev_fh_kitchenstool",
-- 	"v_ilev_fh_kitchenstool",
-- 	"hei_prop_yah_seat_01",
-- 	"hei_prop_yah_seat_02",
-- 	"hei_prop_yah_seat_03",
-- 	"prop_waiting_seat_01",
-- 	"prop_yacht_seat_01",
-- 	"prop_yacht_seat_02",
-- 	"prop_yacht_seat_03",
-- 	"prop_hobo_seat_01",
-- 	"prop_rub_couch01",
-- 	"miss_rub_couch_01",
-- 	"prop_ld_farm_couch01",
-- 	"prop_ld_farm_couch02",
-- 	"prop_rub_couch02",
-- 	"prop_rub_couch03",
-- 	"prop_rub_couch04",
-- 	"p_lev_sofa_s",
-- 	"p_res_sofa_l_s",
-- 	"p_v_med_p_sofa_s",
-- 	"p_yacht_sofa_01_s",
-- 	"v_ilev_m_sofa",
-- 	"v_res_tre_sofa_s",
-- 	"v_tre_sofa_mess_a_s",
-- 	"v_tre_sofa_mess_b_s",
-- 	"v_tre_sofa_mess_c_s",
-- 	"prop_roller_car_01",
-- 	"prop_roller_car_02",
-- 	"v_ilev_chair02_ped",
-- 	"prop_chateau_table_01",
-- 	"v_club_stagechair",
-- 	"v_club_barchair",
-- 	"hei_heist_din_chair_06",
-- 	"bkr_prop_weed_chair_01a",
-- }


-- Config.Sitable = {
-- 	--Only verticalOffset works right now!	
-- 	--all scenarios: pastebin.com/6mrYTdQv
	
-- 	-- BENCH
-- 	prop_bench_01a 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_bench_01b 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_bench_01c 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_bench_02 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_bench_03 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_bench_04 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_bench_05 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_bench_06 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_bench_05 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_bench_08 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_bench_09 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_bench_10 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_bench_11 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_fib_3b_bench 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_ld_bench01 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_wait_bench_01 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},

-- 	-- CHAIR
-- 	hei_prop_heist_off_chair 	= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	hei_prop_hei_skid_chair 	= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_chair_01a 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_chair_01b 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_chair_02 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_chair_03 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_chair_04a 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_chair_04b 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_chair_05 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_chair_06 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_chair_05 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_chair_08 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_chair_09 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_chair_10 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_chateau_chair_01 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_clown_chair 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_cs_office_chair 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_direct_chair_01 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_direct_chair_02 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_gc_chair02 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_off_chair_01 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_off_chair_03 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_off_chair_04 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_off_chair_04b 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_off_chair_04_s 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_off_chair_05 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_old_deck_chair 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_old_wood_chair 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_rock_chair_01 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_skid_chair_01 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_skid_chair_02 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_skid_chair_03 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_sol_chair 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_wheelchair_01 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_wheelchair_01_s 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	p_armchair_01_s 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	p_clb_officechair_s 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	p_dinechair_01_s 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	p_ilev_p_easychair_s 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	p_soloffchair_s 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	p_yacht_chair_01_s 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	v_club_officechair 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	v_corp_bk_chair3 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	v_corp_cd_chair 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	v_corp_offchair 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	v_ilev_chair02_ped 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	v_ilev_hd_chair 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	v_ilev_p_easychair 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	v_ret_gc_chair03 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_ld_farm_chair01 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_table_04_chr 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_table_05_chr 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_table_06_chr 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	v_ilev_leath_chr 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_table_01_chr_a 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_table_01_chr_b 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_table_02_chr 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_table_03b_chr 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_table_03_chr 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_torture_ch_01 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	v_ilev_fh_dineeamesa 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},


-- 	v_ilev_fh_kitchenstool 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	v_ilev_tort_stool 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	v_ilev_fh_kitchenstool 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	v_ilev_fh_kitchenstool 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	v_ilev_fh_kitchenstool 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	v_ilev_fh_kitchenstool 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},

-- 	-- SEAT
-- 	hei_prop_yah_seat_01 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	hei_prop_yah_seat_02 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	hei_prop_yah_seat_03 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_waiting_seat_01 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_yacht_seat_01 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_yacht_seat_02 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_yacht_seat_03 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_hobo_seat_01 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.65, forwardOffset = 0.0, leftOffset = 0.0},

-- 	-- COUCH
-- 	prop_rub_couch01 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	miss_rub_couch_01 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_ld_farm_couch01 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_ld_farm_couch02 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_rub_couch02 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_rub_couch03 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_rub_couch04 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},

-- 	-- SOFA
-- 	p_lev_sofa_s 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	p_res_sofa_l_s 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	p_v_med_p_sofa_s 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	p_yacht_sofa_01_s 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	v_ilev_m_sofa 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	v_res_tre_sofa_s 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	v_tre_sofa_mess_a_s 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	v_tre_sofa_mess_b_s 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	v_tre_sofa_mess_c_s 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},

-- 	-- MISC
-- 	prop_roller_car_01 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	prop_roller_car_02 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	v_ilev_chair02_ped 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.0, forwardOffset = 0.0, leftOffset = 0.0},
-- 	v_club_stagechair   		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	v_club_barchair     		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	hei_heist_din_chair_06      = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- 	bkr_prop_weed_chair_01a      = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
-- }

function _(str, ...)
    if Locales[Config.Locale] ~= nil then
        if Locales[Config.Locale][str] ~= nil then
            return string.format(Locales[Config.Locale][str], ...)
        else
            return "Moshkel Dar Rabete Ba Locale Pish Omade Be ScArY Elam Konid!"
        end
    else
        return "Moshkel Dar Rabete Ba Locale Pish Omade Be ScArY Elam Konid!"
    end
end

function _U(str, ...)
    return tostring(_(str, ...):gsub("^%l", string.upper))
end


cfg = {
	deformationMultiplier = -1,					-- How much should the vehicle visually deform from a collision. Range 0.0 to 10.0 Where 0.0 is no deformation and 10.0 is 10x deformation. -1 = Don't touch. Visual damage does not sync well to other players.
	deformationExponent = 0.4,					-- How much should the handling file deformation setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
	collisionDamageExponent = 0.6,				-- How much should the handling file deformation setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.

	damageFactorEngine = 3.0,					-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
	damageFactorBody = 4.0,					-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
	damageFactorPetrolTank = 40.0,				-- Sane values are 1 to 200. Higher values means more damage to vehicle. A good starting point is 64
	engineDamageExponent = 0.6,					-- How much should the handling file engine damage setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
	weaponsDamageMultiplier = 0.01,				-- How much damage should the vehicle get from weapons fire. Range 0.0 to 10.0, where 0.0 is no damage and 10.0 is 10x damage. -1 = don't touch
	degradingHealthSpeedFactor = 10,			-- Speed of slowly degrading health, but not failure. Value of 10 means that it will take about 0.25 second per health point, so degradation from 800 to 305 will take about 2 minutes of clean driving. Higher values means faster degradation
	cascadingFailureSpeedFactor = 8.0,			-- Sane values are 1 to 100. When vehicle health drops below a certain point, cascading failure sets in, and the health drops rapidly until the vehicle dies. Higher values means faster failure. A good starting point is 8
	degradingFailureThreshold = 800.0,			-- Below this value, slow health degradation will set in
	cascadingFailureThreshold = 360.0,			-- Below this value, health cascading failure will set in
	engineSafeGuard = 100.0,					-- Final failure value. Set it too high, and the vehicle won't smoke when disabled. Set too low, and the car will catch fire from a single bullet to the engine. At health 100 a typical car can take 3-4 bullets to the engine before catching fire.
	torqueMultiplierEnabled = true,				-- Decrease engine torque as engine gets more and more damaged
	limpMode = false,							-- If true, the engine never fails completely, so you will always be able to get to a mechanic unless you flip your vehicle and preventVehicleFlip is set to true
	limpModeMultiplier = 0.15,					-- The torque multiplier to use when vehicle is limping. Sane values are 0.05 to 0.25
	preventVehicleFlip = true,					-- If true, you can't turn over an upside down vehicle
	sundayDriver = false,						-- If true, the accelerator response is scaled to enable easy slow driving. Will not prevent full throttle. Does not work with binary accelerators like a keyboard. Set to false to disable. The included stop-without-reversing and brake-light-hold feature does also work for keyboards.
	sundayDriverAcceleratorCurve = 7.5,			-- The response curve to apply to the accelerator. Range 0.0 to 10.0. Higher values enables easier slow driving, meaning more pressure on the throttle is required to accelerate forward. Does nothing for keyboard drivers
	sundayDriverBrakeCurve = 5.0,				-- The response curve to apply to the Brake. Range 0.0 to 10.0. Higher values enables easier braking, meaning more pressure on the throttle is required to brake hard. Does nothing for keyboard drivers
	displayBlips = false,						-- Show blips for mechanics locations
	compatibilityMode = false,					-- prevents other scripts from modifying the fuel tank health to avoid random engine failure with BVA 2.01 (Downside is it disabled explosion prevention)
	randomTireBurstInterval = 0,				-- Number of minutes (statistically, not precisely) to drive above 22 mph before you get a tire puncture. 0=feature is disabled


	classDamageMultiplier = {
		[0] = 	0.3,		--	0: Compacts
				0.3,		--	1: Sedans
				0.3,		--	2: SUVs
				0.3,		--	3: Coupes
				0.3,		--	4: Muscle
				0.3,		--	5: Sports Classics
				0.3,		--	6: Sports
				0.3,		--	7: Super
				0.05,		--	8: Motorcycles
				0.7,		--	9: Off-road
				0.25,		--	10: Industrial
				0.3,		--	11: Utility
				0.3,		--	12: Vans
				0.3,		--	13: Cycles
				0.3,		--	14: Boats
				0.3,		--	15: Helicopters
				0.3,		--	16: Planes
				0.3,		--	17: Service
				0.25,		--	18: Emergency
				0.25,		--	19: Military
				0.25,		--	20: Commercial
				0.3			--	21: Trains
	}
}


repairCfg = {
	mechanics = {

	},

	fixMessages = {
		"Mashin Shoma Kami Tamir Shod",
	},
	fixMessageCount = 1,

	noFixMessages = {
		"Motor Mashin Shoma Salem Ast",
		"Mashin Shoma Salem Ast"
	},
	noFixMessageCount = 2
}

RepairEveryoneWhitelisted = true
RepairWhitelist =
{
	"steam:110000146d830cd",
	"steam:000000000000000",
	"ip:192.168.0.1"			-- not sure if ip whitelist works?
}
-- ====================================================================
-- [Unique_Pack] merged config (از پک قبلی Unique_Pack)
-- ====================================================================
-- ====================================================================
-- Config_HUNT (از HUNT/Config.lua)
-- ====================================================================
Config_HUNT = {}

Config_HUNT.ItemsLashe = {
    'lasheoghab',
    'lasheaho', 
    'lashekhargush', 
    'lasherottweiler', 
    'lashehusky', 
    'lashecougar', 
    'lashepig', 
    'lashecoyote', 
    'lashemorgh'
}

Config_HUNT.ItemsTabdil = {
    lasheoghab = {name = 'lasheoghab', head = 'headeoghab', gosht = 'goshteoghab', post = ''},
    lasheaho = {name = 'lasheaho', head = 'headeaho', gosht = 'goshteaho', post = 'posteaho'}, 
    lashekhargush = {name = 'lashekhargush', head = 'headekhargush', gosht = 'goshtekhargush', post = 'postekhargush'}, 
    lasherottweiler = {name = 'lasherottweiler', head = 'headerottweiler', gosht = 'goshterottweiler', post = 'posterottweiler'}, 
    lashehusky = {name = 'lashehusky', head = 'headehusky', gosht = 'goshtehusky', post = 'postehusky'}, 
    lashecougar = {name = 'lashecougar', head = 'headecougar', gosht = 'goshtecougar', post = 'postecougar'}, 
    lashepig = {name = 'lashepig', head = 'headepig', gosht = 'goshtepig', post = 'postepig'},
    lashecoyote = {name = 'lashecoyote', head = 'headecoyote', gosht = 'goshtecoyote', post = 'postecoyote'}, 
    lashemorgh = {name = 'lashemorgh', head = 'heademorgh', gosht = 'slaughtered_chicken', post = ''}
}
-- ====================================================================
-- Config_Megaphone (از Megaphone/config.lua)
-- ====================================================================
Config_Megaphone = {}

Config_Megaphone.Framework = 'esx' -- esx, qb-core, 
-- ====================================================================
-- Config_Antipg (از antipg/config.lua)
-- ====================================================================
Config_Antipg = {
    Debug = false,

    -- Chop Shop feature disabled: replaced by the dedicated [ARSHIA]/chopshop
    -- resource (3 locations, engine1-6 tiered items). Engine repair/install
    -- below is untouched — it's a separate feature.
    ChopShopEnabled = false,

    InstallLocation = vector3(-352.312, -90.3062, 40.0),  ----- Nasb va Tamir
    
    Marker = {  ------- Chop Shop 
        Position = vector3(602.6905, -438.514, 24.756),
        Color = {r = 255, g = 0, b = 0, a = 100}
    },

    Items = {
        Engine = {
            Name = 'engine',
            Label = 'Engine',
            Prop = 'prop_car_engine_01'
        }
    }
}

-- ====================================================================
-- Config_PedShop (از pedshop/config.lua)
-- ====================================================================
Config_PedShop = {}


Config_PedShop.Locations = {
    PedShop = vector3(-416.513, 1116.741, 325.87),
    PedChange = vector3(-410.834, 1115.171, 325.87) 
}


Config_PedShop.AvailablePedsMale = {
    {label = "Beach Guy", model = "a_m_m_beach_01", expire = 7, price = 100000},   
    {label = "Farmer", model = "a_m_m_farmer_01", expire = 14, price = 500000}, 
}


Config_PedShop.AvailablePedsFemale = {
    {label = "Beach Girl", model = "a_f_y_beach_01", expire = 7, price = 100000},
    {label = "Fitness Girl", model = "a_f_y_fitness_01", expire = 14, price = 500000},
    {label = "Sweet", model = "pmp_st_sweet", expire = 30, price = 20000}, 
    {label = "Yoga", model = "a_f_y_yoga_01", expire = 30, price = 20000}, 
}

-- ====================================================================
-- config (gang_mapings - lowercase, بدون تداخل)
-- ====================================================================
config = {}

-- config.coords = {
--     {x = -1561.27, y = -49.3924, z = 56.501},
--     {x = -1465.53, y = -28.9578, z = 60.655},
--     {x = -1467.11, y = 39.88935, z = 58.928},
-- }



-- blips1 = {
--     -- {title="Gang House", colour=32, id=378, config.coords.x, config.coords.y, config.coords.x.z},
--     {title="Gang House", colour=32, id=378, x = -1561.27, y = -49.3924, z = 56.501},
--     {title="Gang House", colour=32, id=378, x = -1465.53, y = -28.9578, z = 60.655},
--     {title="Gang House", colour=32, id=378, x = -1467.11, y = 39.88935, z = 58.928},
-- }


-- ====================================================================
-- Config_Switchjob (از Unique_Scripts_Switchjob/config.lua)
-- ====================================================================
Config_Switchjob = {}


-- SECURITY FIX: this used to hardcode a specific steam hex ID with automatic
-- Police rank 20 / FBI rank 8 access via /fbichange, completely bypassing
-- your admin/permission system. Removed. Add entries back here yourself,
-- deliberately, if you want specific players to have this menu.
Config_Switchjob.AllowedJobs = {}

Config_Switchjob.MenuCommand = "fbichange"
-- ====================================================================
-- Config_WeaponsOnBack (از weapons-on-back/Config.lua)
-- ====================================================================
Config_WeaponsOnBack = {}

Config_WeaponsOnBack.mahdod = true -- estefade az in job ha va gang ha(nazdik base gang) mitonan estefade kon

Config_WeaponsOnBack.WeaponComponents = {
    -- CARBINE RIFLE
    [GetHashKey("WEAPON_CARBINERIFLE")] = {
        ['clip_default'] = 0x9FBE33EC,
        ['clip_extended'] = 0x91109691,
        ['clip_box'] = 0x91109691,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0xA0D89C42,
        ['suppressor'] = 0x837445AA,
        ['grip'] = 0xC164F53,
        ['luxary_finish'] = 0xD89B9658
    },
    
    -- CARBINE RIFLE MK2
    [GetHashKey("WEAPON_CARBINERIFLE_MK2")] = {
        ['clip_default'] = 0x4C7A391E,
        ['clip_extended'] = 0x5DD5DBD5,
        ['clip_tracer'] = 0x1757F566,
        ['clip_incendiary'] = 0x3D25C2A7,
        ['clip_armor_piercing'] = 0x255D5D57,
        ['clip_fmj'] = 0x44032F11,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope_holo'] = 0x49B2945,
        ['scope_medium'] = 0xC66B6542,
        ['suppressor'] = 0x837445AA,
        ['grip'] = 0x9D65907A,
        ['barrel'] = 0x833637FF
    },
    
    -- ASSAULT RIFLE
    [GetHashKey("WEAPON_ASSAULTRIFLE")] = {
        ['clip_default'] = 0xBE5EEA16,
        ['clip_extended'] = 0xB1214F9B,
        ['clip_drum'] = 0xDBF0A53D,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0x9D2FBF29,
        ['suppressor'] = 0x837445AA,
        ['grip'] = 0xC164F53,
        ['luxary_finish'] = 0x4EAD7533
    },
    
    -- SPECIAL CARBINE
    [GetHashKey("WEAPON_SPECIALCARBINE")] = {
        ['clip_default'] = 0x7C8BD10E,
        ['clip_extended'] = 0x6B59AEAA,
        ['clip_drum'] = 0xD9C1E5B1,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0xA0D89C42,
        ['suppressor'] = 0x837445AA,
        ['grip'] = 0x9D65907A,
        ['luxary_finish'] = 0x730154F2
    },
    
    -- BULLPUP RIFLE
    [GetHashKey("WEAPON_BULLPUPRIFLE")] = {
        ['clip_default'] = 0xC5A12F80,
        ['clip_extended'] = 0xB3688B0F,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0xAA2C45B4,
        ['suppressor'] = 0x837445AA,
        ['grip'] = 0xC164F53,
        ['luxary_finish'] = 0xA857BC78
    },
    
    -- ADVANCED RIFLE
    [GetHashKey("WEAPON_ADVANCEDRIFLE")] = {
        ['clip_default'] = 0xFA8FA10F,
        ['clip_extended'] = 0x8EC1C979,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0xAA2C45B4,
        ['suppressor'] = 0x837445AA,
        ['luxary_finish'] = 0x377CD377
    },
    
    -- SMG
    [GetHashKey("WEAPON_SMG")] = {
        ['clip_default'] = 0x26574997,
        ['clip_extended'] = 0x350966FB,
        ['clip_drum'] = 0x79C77076,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0x3CC6BA57,
        ['suppressor'] = 0xC304849A,
        ['luxary_finish'] = 0x27872C90
    },
    
    -- SMG MK2
    [GetHashKey("WEAPON_SMGMK2")] = {
        ['clip_default'] = 0x4C24806E,
        ['clip_extended'] = 0xB9835B2E,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope_holo'] = 0x3F3C8181,
        ['scope_small'] = 0x3DECC7DA,
        ['suppressor'] = 0xC304849A,
        ['muzzle_flat'] = 0xB99402D4,
        ['muzzle_tactical'] = 0xC867A07B,
        ['barrel'] = 0xD9103EE1
    },
    
    -- MICRO SMG
    [GetHashKey("WEAPON_MICROSMG")] = {
        ['clip_default'] = 0xCB48AEF0,
        ['clip_extended'] = 0x10E6BA2B,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0x9D2FBF29,
        ['suppressor'] = 0xAC42DF71,
        ['luxary_finish'] = 0x487AAE09
    },
    
    -- ASSAULT SMG
    [GetHashKey("WEAPON_ASSAULTSMG")] = {
        ['clip_default'] = 0x8D1307B0,
        ['clip_extended'] = 0xBB46E417,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0x9D2FBF29,
        ['suppressor'] = 0xA73D4664,
        ['luxary_finish'] = 0x278C78AF
    },
    
    -- GUSENBERG
    [GetHashKey("WEAPON_GUSENBERG")] = {
        ['clip_default'] = 0x1CE5A6A5,
        ['clip_extended'] = 0xEAC8C270
    },
    
    -- PISTOL
    [GetHashKey("WEAPON_PISTOL")] = {
        ['clip_default'] = 0xFED0FD71,
        ['clip_extended'] = 0xED265A1C,
        ['flashlight'] = 0x43FD595B,
        ['suppressor'] = 0x65EA7EBB,
        ['luxary_finish'] = 0xD7391086
    },
    
    -- PISTOL .50
    [GetHashKey("WEAPON_PISTOL50")] = {
        ['clip_default'] = 0x2297BE19,
        ['clip_extended'] = 0xD9D3AC92,
        ['flashlight'] = 0x359B7AAE,
        ['suppressor'] = 0xA73D4664,
        ['luxary_finish'] = 0x77B8AB2F
    },
    
    -- SNIPER RIFLE
    [GetHashKey("WEAPON_SNIPERRIFLE")] = {
        ['suppressor'] = 0x9BC64089,
        ['scope_large'] = 0xD2443DDC,
        ['scope_advanced'] = 0xBC54DA77
    },
    
    -- HEAVY SHOTGUN
    [GetHashKey("WEAPON_HEAVYSHOTGUN")] = {
        ['clip_default'] = 0x324F2D5F,
        ['clip_extended'] = 0x971CF6FD,
        ['clip_drum'] = 0x88C7DA53,
        ['flashlight'] = 0x7BC4CDDC,
        ['suppressor'] = 0xA73D4664,
        ['grip'] = 0xC164F53
    },
    
    -- PUMPSHOTGUN
    [GetHashKey("WEAPON_PUMPSHOTGUN")] = {
        ['flashlight'] = 0x7BC4CDDC,
        ['suppressor'] = 0xE608B35E,
        ['luxary_finish'] = 0xA2D79DDB
    },
    
    -- ASSAULT SHOTGUN
    [GetHashKey("WEAPON_ASSAULTSHOTGUN")] = {
        ['clip_default'] = 0x94E81BC7,
        ['clip_extended'] = 0x86BD7F72,
        ['flashlight'] = 0x7BC4CDDC,
        ['suppressor'] = 0x837445AA,
        ['grip'] = 0xC164F53
    },
    
    -- BULLPUP SHOTGUN
    [GetHashKey("WEAPON_BULLPUPSHOTGUN")] = {
        ['flashlight'] = 0x7BC4CDDC,
        ['suppressor'] = 0xA73D4664,
        ['grip'] = 0xC164F53
    },
    

    [GetHashKey("WEAPON_M4")] = {
        ['clip_default'] = 0xBE5EEA16,
        ['clip_extended'] = 0xB1214F9B,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0x9D2FBF29,
        ['suppressor'] = 0x837445AA,
        ['grip'] = 0xC164F53
    }
}