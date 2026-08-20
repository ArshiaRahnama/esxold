

Corp = {
	Meridian = {
		Job     = 'meridian',
		Society = 'meridian',
		Label   = 'Holding 1',

		HQ = { x = -75.3, y = -818.3, z = 243.8 },
		Blip = { Sprite = 476, Color = 2, Scale = 1.0 },

		BossAction = { Pos = { x = -75.3, y = -818.3, z = 243.8 }, Name = 'Portfolio Dashboard', Icon = 'fa-solid fa-chart-line' },
		CloackRoom = { Pos = { x = -71.3, y = -818.3, z = 243.8 }, Name = 'Cloack Room', Icon = 'fa-solid fa-shirt' },

		SpawnVehicle = 'baller6',
		SpawnMarker  = { x = -60.0, y = -818.3, z = 243.8 },
		SpawnPoint   = { x = -50.0, y = -812.0, z = 242.9, w = 90.0 },
		DeleteMarker = { x = -55.0, y = -813.0, z = 243.8 },

		FranchiseFeePercent  = 5,
		CollectCooldownMins  = 30,




		PortfolioJobs = { 'flourish', 'goldcrust', 'static', 'nightjar', 'firebrick', 'slice', 'frostbite', 'sundae', 'koi', 'wasabi' },
		AcquireCost = 20000,


		Ranks = {
			{ id = 'bronze', label = 'Bronze', feePercent = 5,  upgradeCost = 0 },
			{ id = 'silver', label = 'Silver', feePercent = 8,  upgradeCost = 15000 },
			{ id = 'gold',   label = 'Gold',   feePercent = 12, upgradeCost = 30000 },
		},





		VIPJobs = { 'uwucafe', 'obsidian', 'voltage', 'ember', 'anchor', 'crimson', 'carwash' },
		VIPPartnershipCost = 50000,
		VIPFeePercent = 15,
	},

	Blacktide = {
		Job     = 'blacktide',
		Society = 'blacktide',
		Label   = 'Blacktide Logistics',

		HQ = { x = 1207.0, y = -3129.0, z = 5.9 },
		Blip = { Sprite = 478, Color = 1, Scale = 1.0 },

		BossAction = { Pos = { x = 1207.0, y = -3129.0, z = 5.9 }, Name = 'Boss Action', Icon = 'fa-solid fa-gear' },
		CloackRoom = { Pos = { x = 1211.0, y = -3129.0, z = 5.9 }, Name = 'Cloack Room', Icon = 'fa-solid fa-shirt' },

		SpawnVehicle = 'burrito3',
		SpawnMarker  = { x = 1220.0, y = -3129.0, z = 5.9 },
		SpawnPoint   = { x = 1230.0, y = -3123.0, z = 5.0,  w = 90.0 },
		DeleteMarker = { x = 1225.0, y = -3124.0, z = 5.9 },

		LaunderCutPercent  = 65,
		BusinessCutPercent = 10,

		MaxPerWash      = 10000,
		CooldownSeconds = 600,
	},

	CrateCarry = {
		Job     = 'cratecarry',
		Society = 'cratecarry',
		Label   = 'Crate & Carry Distribution',

		HQ = { x = 1210.0, y = -3050.0, z = 5.0 },
		Blip = { Sprite = 473, Color = 5, Scale = 1.0 },

		Freezer    = { Pos = { x = 1210.0, y = -3050.0, z = 5.0 }, Name = 'Warehouse Stock', Icon = 'fa-regular fa-box' },
		ResaleShop = { Pos = { x = 1214.0, y = -3050.0, z = 5.0 }, Name = 'Resale Counter',  Icon = 'fa-solid fa-cash-register' },
		BossAction = { Pos = { x = 1206.0, y = -3050.0, z = 5.0 }, Name = 'Boss Action', Icon = 'fa-solid fa-gear' },
		CloackRoom = { Pos = { x = 1218.0, y = -3050.0, z = 5.0 }, Name = 'Cloack Room', Icon = 'fa-solid fa-shirt' },

		SpawnVehicle = 'mule',
		SpawnMarker  = { x = 1195.0, y = -3050.0, z = 5.0 },
		SpawnPoint   = { x = 1185.0, y = -3044.0, z = 4.1,  w = 90.0 },
		DeleteMarker = { x = 1190.0, y = -3045.0, z = 5.0 },

		WholesaleUnitPrice = 5,
		WholesaleBuyLimit  = 20,
		Markup             = 1.8,
	},
}

CorpJobSet = { meridian = true, blacktide = true, cratecarry = true }

function IsCorpJob(jobName)
	return CorpJobSet[jobName] == true
end
