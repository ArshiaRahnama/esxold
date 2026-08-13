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
Config.ServiceExtensionOnEscape		= 0
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

Config.Interactables = {
	"prop_bench_01a",
	"prop_bench_01b",
	"prop_bench_01c",
	"prop_bench_02",
	"prop_bench_03",
	"prop_bench_04",
	"prop_bench_05",
	"prop_bench_06",
	"prop_bench_05",
	"prop_bench_08",
	"prop_bench_09",
	"prop_bench_10",
	"prop_bench_11",
	"prop_fib_3b_bench",
	"prop_ld_bench01",
	"prop_wait_bench_01",
	"hei_prop_heist_off_chair",
	"hei_prop_hei_skid_chair",
	"prop_chair_01a",
	"prop_chair_01b",
	"prop_chair_02",
	"prop_chair_03",
	"prop_chair_04a",
	"prop_chair_04b",
	"prop_chair_05",
	"prop_chair_06",
	"prop_chair_05",
	"prop_chair_08",
	"prop_chair_09",
	"prop_chair_10",
	"prop_chateau_chair_01",
	"prop_clown_chair",
	"prop_cs_office_chair",
	"prop_direct_chair_01",
	"prop_direct_chair_02",
	"prop_gc_chair02",
	"prop_off_chair_01",
	"prop_off_chair_03",
	"prop_off_chair_04",
	"prop_off_chair_04b",
	"prop_off_chair_04_s",
	"prop_off_chair_05",
	"prop_old_deck_chair",
	"prop_old_wood_chair",
	"prop_rock_chair_01",
	"prop_skid_chair_01",
	"prop_skid_chair_02",
	"prop_skid_chair_03",
	"prop_sol_chair",
	"prop_wheelchair_01",
	"prop_wheelchair_01_s",
	"p_armchair_01_s",
	"p_clb_officechair_s",
	"p_dinechair_01_s",
	"p_ilev_p_easychair_s",
	"p_soloffchair_s",
	"p_yacht_chair_01_s",
	"v_club_officechair",
	"v_corp_bk_chair3",
	"v_corp_cd_chair",
	"v_corp_offchair",
	"v_ilev_chair02_ped",
	"v_ilev_hd_chair",
	"v_ilev_p_easychair",
	"v_ret_gc_chair03",
	"prop_ld_farm_chair01",
	"prop_table_04_chr",
	"prop_table_05_chr",
	"prop_table_06_chr",
	"v_ilev_leath_chr",
	"prop_table_01_chr_a",
	"prop_table_01_chr_b",
	"prop_table_02_chr",
	"prop_table_03b_chr",
	"prop_table_03_chr",
	"prop_torture_ch_01",
	"v_ilev_fh_dineeamesa",
	"v_ilev_fh_kitchenstool",
	"v_ilev_tort_stool",
	"v_ilev_fh_kitchenstool",
	"v_ilev_fh_kitchenstool",
	"v_ilev_fh_kitchenstool",
	"v_ilev_fh_kitchenstool",
	"hei_prop_yah_seat_01",
	"hei_prop_yah_seat_02",
	"hei_prop_yah_seat_03",
	"prop_waiting_seat_01",
	"prop_yacht_seat_01",
	"prop_yacht_seat_02",
	"prop_yacht_seat_03",
	"prop_hobo_seat_01",
	"prop_rub_couch01",
	"miss_rub_couch_01",
	"prop_ld_farm_couch01",
	"prop_ld_farm_couch02",
	"prop_rub_couch02",
	"prop_rub_couch03",
	"prop_rub_couch04",
	"p_lev_sofa_s",
	"p_res_sofa_l_s",
	"p_v_med_p_sofa_s",
	"p_yacht_sofa_01_s",
	"v_ilev_m_sofa",
	"v_res_tre_sofa_s",
	"v_tre_sofa_mess_a_s",
	"v_tre_sofa_mess_b_s",
	"v_tre_sofa_mess_c_s",
	"prop_roller_car_01",
	"prop_roller_car_02",
	"v_ilev_chair02_ped",
	"prop_chateau_table_01",
	"v_club_stagechair",
	"v_club_barchair",
	"hei_heist_din_chair_06",
	"bkr_prop_weed_chair_01a",
}


Config.Sitable = {
	--Only verticalOffset works right now!	
	--all scenarios: pastebin.com/6mrYTdQv
	
	-- BENCH
	prop_bench_01a 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_bench_01b 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_bench_01c 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_bench_02 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_bench_03 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_bench_04 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_bench_05 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_bench_06 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_bench_05 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_bench_08 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_bench_09 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_bench_10 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_bench_11 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_fib_3b_bench 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_ld_bench01 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_wait_bench_01 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},

	-- CHAIR
	hei_prop_heist_off_chair 	= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	hei_prop_hei_skid_chair 	= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_chair_01a 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_chair_01b 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_chair_02 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_chair_03 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_chair_04a 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_chair_04b 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_chair_05 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_chair_06 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_chair_05 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_chair_08 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_chair_09 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_chair_10 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_chateau_chair_01 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_clown_chair 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_cs_office_chair 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_direct_chair_01 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_direct_chair_02 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_gc_chair02 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_off_chair_01 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_off_chair_03 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_off_chair_04 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_off_chair_04b 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_off_chair_04_s 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_off_chair_05 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_old_deck_chair 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_old_wood_chair 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_rock_chair_01 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_skid_chair_01 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_skid_chair_02 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_skid_chair_03 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_sol_chair 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_wheelchair_01 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_wheelchair_01_s 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	p_armchair_01_s 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	p_clb_officechair_s 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	p_dinechair_01_s 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	p_ilev_p_easychair_s 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	p_soloffchair_s 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	p_yacht_chair_01_s 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	v_club_officechair 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	v_corp_bk_chair3 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	v_corp_cd_chair 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	v_corp_offchair 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	v_ilev_chair02_ped 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	v_ilev_hd_chair 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	v_ilev_p_easychair 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	v_ret_gc_chair03 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_ld_farm_chair01 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_table_04_chr 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_table_05_chr 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_table_06_chr 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	v_ilev_leath_chr 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_table_01_chr_a 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_table_01_chr_b 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_table_02_chr 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_table_03b_chr 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_table_03_chr 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_torture_ch_01 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	v_ilev_fh_dineeamesa 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},


	v_ilev_fh_kitchenstool 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	v_ilev_tort_stool 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	v_ilev_fh_kitchenstool 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	v_ilev_fh_kitchenstool 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	v_ilev_fh_kitchenstool 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	v_ilev_fh_kitchenstool 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},

	-- SEAT
	hei_prop_yah_seat_01 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	hei_prop_yah_seat_02 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	hei_prop_yah_seat_03 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_waiting_seat_01 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_yacht_seat_01 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_yacht_seat_02 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_yacht_seat_03 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_hobo_seat_01 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.65, forwardOffset = 0.0, leftOffset = 0.0},

	-- COUCH
	prop_rub_couch01 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	miss_rub_couch_01 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_ld_farm_couch01 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_ld_farm_couch02 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_rub_couch02 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_rub_couch03 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_rub_couch04 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},

	-- SOFA
	p_lev_sofa_s 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	p_res_sofa_l_s 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	p_v_med_p_sofa_s 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	p_yacht_sofa_01_s 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	v_ilev_m_sofa 				= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	v_res_tre_sofa_s 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	v_tre_sofa_mess_a_s 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	v_tre_sofa_mess_b_s 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	v_tre_sofa_mess_c_s 		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},

	-- MISC
	prop_roller_car_01 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	prop_roller_car_02 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	v_ilev_chair02_ped 			= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.0, forwardOffset = 0.0, leftOffset = 0.0},
	v_club_stagechair   		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	v_club_barchair     		= { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	hei_heist_din_chair_06      = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	bkr_prop_weed_chair_01a      = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
}

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



