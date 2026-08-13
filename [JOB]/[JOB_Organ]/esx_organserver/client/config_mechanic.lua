
-- Server Discord : https://discord.gg/3jzScCJZ5C

Config_mechanic                            = {}
Config_mechanic.DrawDistance               = 10.0
Config_mechanic.MaxInService               = -1
Config_mechanic.EnablePlayerManagement     = true
Config_mechanic.EnableSocietyOwnedVehicles = false
Config_mechanic.NPCSpawnDistance           = 500.0
Config_mechanic.NPCNextToDistance          = 25.0
Config_mechanic.NPCJobEarnings             = { min = 0, max = 0 }
Config_mechanic.Locale                     = 'en'

Config_mechanic.Blips = {
   {x = -357.879, y = -126.839, z = 38.697},
   -- { x = 1303.06, y = 2654.06, z = 39.61 },
   --{ x = 1179.48, y = 2652.99, z = 37.81 }
}

Config_mechanic.Zones = {
  MechanicActions = { --spawm mashin
    Pos   = { x = -363.874, y = -154.750, z = 38.232, num = 1},
    Size  = { x = 0.8, y = 0.8, z = 0.8 },
    Color = { r = 204, g = 204, b = 0 },
    Type  = 36,
  },
  
  MechanicCloark = { -- Lebas
    Pos   = { x = -341.479, y = -162.094, z = 44.587 },
    Size  = { x = 0.8, y = 0.8, z = 0.8 },
    Color = { r = 204, g = 204, b = 0 },
    Type  = 21,
  },
  
  MechanicStock = { --- Inventory
    Pos   = { x = -351.690, y = -165.668, z = 39.014 },
    Size  = { x = 0.8, y = 0.8, z = 0.8 },
    Color = { r = 204, g = 204, b = 0 },
    Type  = 40,
  },
 
  VehicleDeleter = {
    Pos   = { x = -367.215, y = -142.010, z = 38.685 },
    Size  = { x = 2.0, y = 2.0, z = 2.0 },
    Color = { r = 254, g = 0, b = 0 },
    Type  = 24,
    Heading = 90.0,
  },


  VehicleDeleter2 = {
    Pos   = { x = -341.882, y = -141.409, z = 60.608 },
    Size  = { x = 2.0, y = 2.0, z = 2.0 },
    Color = { r = 254, g = 0, b = 0 },
    Type  = 24,
    Heading = 90.0,
  },

  Helicopters = {
    Pos   = { x = -333.712, y = -126.344, z = 60.475, num = 1},
    Size  = { x = 0.8, y = 0.8, z = 0.8 },
    Color = { r = 204, g = 204, b = 0 },
    Type  = 34,
  },

  -- GasCan = {
  --   Pos   = { x = -322.57 , y = -145.33, z = 39.02},
  --   Size  = { x = 0.8, y = 0.8, z = 0.8 },
  --   Color = { r = 204, g = 204, b = 0 },
  --   Type  = 21,
  -- },
  
  BossActions = {
    Pos   = { x = -339.041, y = -157.458, z = 44.587 },
    Size  = { x = 0.8, y = 0.8, z = 0.8 },
    Color = { r = 204, g = 204, b = 0 },
    Type  = 29,
  },
  
   --Biroon Shahr
  -- MechanicActions2 = {
    -- Pos   = { x =1282.69, y = 2661.72, z = 39.64, num = 2 },
    -- Size  = { x = 0.8, y = 0.8, z = 0.8 },
    -- Color = { r = 204, g = 204, b = 0 },
    -- Type  = 21,
  -- },
  -- MechanicCloark2 = {
    -- Pos   = { x = 1333.99 , y = 2637.67, z = 46.53 },
    -- Size  = { x = 0.8, y = 0.8, z = 0.8 },
    -- Color = { r = 204, g = 204, b = 0 },
    -- Type  = 21,
  -- },
  -- GasCan2 = {
    -- Pos   = { x = 1339.54 , y = 2669.14, z = 39.61 },
    -- Size  = { x = 0.8, y = 0.8, z = 0.8 },
    -- Color = { r = 204, g = 204, b = 0 },
    -- Type  = 21,
  -- },
  -- VehicleDeleter2 = {
    -- Pos   = { x = 1289.61, y = 2667.71, z = 39.55 },
    -- Size  = { x = 2.0, y = 2.0, z = 2.0 },
    -- Color = { r = 254, g = 0, b = 0 },
    -- Type  = 24,
  -- },
  
   -- MechanicStock2 = {
    -- Pos   = { x = 1339.24, y = 2665.94, z = 39.61 },
    -- Size  = { x = 0.8, y = 0.8, z = 0.8 },
    -- Color = { r = 204, g = 204, b = 0 },
    -- Type  = 21,
  -- },
}




Config_mechanic.AuthorizedVehicles = {
	Shared = {
    {
			model = 'b2chal',
			label = 'Mechanic Chal',
			Extra = {['1'] = 1, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['5'] = 1}

		},	
		{
			model = 'b219tahoe',
			label = 'Mechanic Tahoe',
			Extra = {['1'] = 1, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['5'] = 1, ['6'] = 1, ['7'] = 1}

		},
		{
			model = 'b218tau',
			label = 'Mechanic Tau',
			Extra = {['1'] = 1, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['6'] = 1, ['7'] = 1}
		},
		{
			model = 'b216explorer',
			label = 'MC Explorer',
			Extra = {['1'] = 1, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['5'] = 1, ['6'] = 1}
		},
		{
			model = 'b214charger',
			label = 'Mechanic Charger',
			Extra = {['1'] = 1, ['2'] = 1, ['3'] = 1, ['5'] = 1, ['6'] = 1, ['7'] = 1, ['8'] = 1 }
		},
		{
			model = 'b212caprice',
			label = 'Mechanic Caprice',
			Extra = {['1'] = 1, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['5'] = 1, ['6'] = 1}
		},
		{
			model = 'b211vic',
			label = 'Mechanic Vic',
			Extra = {['1'] = 1, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['5'] = 1, ['6'] = 1, ['10'] = 1}
		},
		{
			model = 'b218charger',
			label = 'Mechanic Charger18',
			Extra = {['1'] = 1, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['5'] = 1, ['6'] = 1}
		},
		{
			model = 'fibm5',
			label = 'Mechanic BMWM5',
			Extra = {['1'] = 0}
		},
    {
			model = 'swat_dirtbike',
			label = 'Mechanic Motor',
      Extra = {['1'] = 0}
		},
    {
			model = 'polnspeedo',
			label = 'Mechanic Van',
      Extra = {['11'] = 0}
		},
    {
			model = 'POLKCH',
			label = 'Mechanic Kamacho',
      Extra = {['1'] = 1, ['3'] = 1, ['4'] = 1 }
		},
		{
			model = 'flatbed',
			label = 'FlatBed'
		},
	},


  Sharedheli = {			
    -- Extra : 0 = true , 1 = false
    { model = 'polmav', label = 'Mechanic Polmav', Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 0, ['5'] = 0 } },
    { model = 'tx_heli', label = 'Mechanic Heli', Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 0, ['5'] = 0 } },

  },
}

Config_mechanic.VehicleSpawnPoint = {
  [1] = {
    Pos   = { x = -367.215, y = -142.010, z = 38.685 },
    Heading = 22.12,
  },

  [2] = {
    Pos   = { x = 1266.65, y = 2653.16, z = 37.60 },
    Heading = 20.51,
  }
}

Config_mechanic.Vehicles = {
  'adder',
  'asea',
  'asterope',
  'banshee',
  'buffalo'
}

Config_mechanic.AuthorizedItems = {
  { name = 'water', price = 60 , label = 'Ab'},
  -- { name = 'silencer', price = 5000, label = 'Silencer'},
  -- { name = 'grip', price = 5000, label = 'Grip' },
  -- { name = 'clip', price = 10, label = 'Kheshab' },
  { name = 'radio', price = 3000, label = 'Bisim' },
  { name = 'phone', price = 2000, label = 'Goshi' },
  { name = 'bread', price = 60, label = 'Noon' },
  
}

-- Server Discord : https://discord.gg/3jzScCJZ5C