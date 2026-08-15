


-- NOTE: the `Jobs` field on each category below is not currently read anywhere
-- in crafting_cl.lua / crafting_sv.lua (it was dead in the original file too).
-- Real access control comes from which cafe's crafting-station zone the player
-- can even walk up to (see shared/cafes.lua + client/main.lua). Left populated
-- here in case you want to wire it into a menu filter later.
local ANY_CAFE_JOB = {'uwucafe', 'obsidian', 'voltage'}

ConfigCrafting = {
	Locale = 'en',
	BlipSprite = 556,
	BlipColor = 47,
	BlipText = 'Crafting Table',

	UseLimitSystem = true, -- Enable if your esx uses limit system
	
	CraftingStopWithDistance = true, -- Crafting will stop when not near workbench
	
	ExperiancePerCraft = 0, -- The amount of experiance added per craft (100 Experiance is 1 level)
	
	HideWhenCantCraft = false, -- Instead of lowering the opacity it hides the item that is not craftable due to low level or wrong job

	OpenCategoryHamzan = 'UwUHamzan',
	OpenCategoryGhahvesaz = 'UwUGhahve',
	OpenCategoryZarfShoe = 'UwUZarfShoe',
	OpenCategoryGaz = 'UwU',

	
	
	Categories = {
	
	['UwUHamzan'] = {
		Label = 'Item UwU',
		Image = 'cupcake',
		Jobs = ANY_CAFE_JOB,
	
	},
	
	['UwUGhahve'] = {
		Label = 'Item UwU',
		Image = 'cupcake',
		Jobs = ANY_CAFE_JOB,
	
	},
	
	['UwUZarfShoe'] = {
		Label = 'Item UwU',
		Image = 'cupcake',
		Jobs = ANY_CAFE_JOB,
	
	},
	
	['UwU'] = {
		Label = 'Item UwU',
		Image = 'cupcake',
		Jobs = ANY_CAFE_JOB,
	
	},

	
	},
	
	PermanentItems = { -- Items that dont get removed when crafting
		['wrench'] = true
	},
	
	Recipes = { 

	 ['shokolat'] = {
	 	Level = 1, 
		Category = 'UwUHamzan', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 8, 
	 	Ingredients = { 
		 ['shekar'] = 1, 
		 ['nutela'] = 1, 
		 ['shir'] = 2, 
			
	 	}
	 },

	 ['cakebastani'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 8, 
	 	Ingredients = { 
		 ['podrcacao'] = 1, 
		 ['shekar'] = 2, 
		 ['kare'] = 1, 
		 ['bakingpowder'] = 1, 
		 ['aard'] = 2, 
		 ['shir'] = 2, 
		 ['egg'] = 1, 
			
	 	}
	 },

	 ['caketotfarangi'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 8, 
	 	Ingredients = { 
		 ['totfarangi'] = 1, 
		 ['shekar'] = 2, 
		 ['kare'] = 1, 
		 ['bakingpowder'] = 1, 
		 ['aard'] = 2, 
		 ['shir'] = 2, 
		 ['egg'] = 1, 
			
	 	}
	 },

	 ['milkshake'] = {
	 	Level = 1, 
		Category = 'UwUHamzan', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 3, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 10, 
	 	Ingredients = { 
		 ['totfarangi'] = 1, 
		 ['shekar'] = 2, 
		 ['shir'] = 2, 
			
	 	}
	 },

	 ['latte'] = {
	 	Level = 1, 
		Category = 'UwUGhahve', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 10, 
	 	Ingredients = { 
		 ['shekar'] = 1, 
		 ['fenjon'] = 2, 
		 ['shir'] = 2, 
		 ['daneghahve'] = 1, 
			
	 	}
	 },

	 ['hot_chocolate'] = {
	 	Level = 1, 
		Category = 'UwUGhahve', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 10, 
	 	Ingredients = { 
		 ['podrcacao'] = 1, 
		 ['shekar'] = 1, 
		 ['water'] = 2, 
	 	}
	 },

	 ['ghahve50'] = {
	 	Level = 1, 
		Category = 'UwUGhahve', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 8, 
	 	Ingredients = { 
		 ['fenjon'] = 2, 
		 ['water'] = 1, 
		 ['daneghahve'] = 1, 
	 	}
	 },

	 ['ghahve80'] = {
	 	Level = 1, 
		Category = 'UwUGhahve', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 8, 
	 	Ingredients = { 
		 ['shekar'] = 1, 
		 ['fenjon'] = 2, 
		 ['water'] = 1, 
		 ['daneghahve'] = 2, 
	 	}
	 },

	 ['ghahve100'] = {
	 	Level = 1, 
		Category = 'UwUGhahve', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 8, 
	 	Ingredients = { 
		 ['fenjon'] = 2, 
		 ['water'] = 2, 
		 ['daneghahve'] = 4, 
	 	}
	 },

	 ['fenjon'] = {
	 	Level = 1, 
		Category = 'UwUZarfShoe', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 5, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 15, 
	 	Ingredients = { 
		 ['fenjonkasif'] = 5, 
		 ['water'] = 1, 
	 	}
	 },

	 ['bubbletetotfarangi'] = {
	 	Level = 1, 
		Category = 'UwUHamzan', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 3, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 12, 
	 	Ingredients = { 
		 ['totfarangi'] = 1, 
		 ['shir'] = 2, 
		 ['shekar'] = 1, 
		 
	 	}
	 },

	 ['cupcake'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 3, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 17, 
	 	Ingredients = { 
		 ['podrcacao'] = 1, 
		 ['shekar'] = 1, 
		 ['kare'] = 1, 
		 ['bakingpowder'] = 1, 
		 ['aard'] = 1, 
		 ['shir'] = 1, 
		 ['egg'] = 1, 
	 	}
	 },

	--  New Item

	--  ['bastani'] = {
	--  	Level = 1, 
	-- 	Category = 'UwU', 
	-- 	isGun = false, 
	-- 	Jobs = ANY_CAFE_JOB, 
	-- 	JobGrades = {}, 
	-- 	Amount = 3, 
	-- 	SuccessRate = 100, 
	-- 	requireBlueprint = false, 
	-- 	Time = 17, 
	--  	Ingredients = { 
	-- 	 ['podrcacao'] = 1, 
	-- 	 ['shekar'] = 1, 
	-- 	 ['kare'] = 1, 
	-- 	 ['bakingpowder'] = 1, 
	-- 	 ['aard'] = 1, 
	-- 	 ['shir'] = 1, 
	-- 	 ['egg'] = 1, 
	--  	}
	--  },

	 ['boba_milk_tea_caramel'] = {
	 	Level = 1, 
		Category = 'UwUHamzan', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 3, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 17, 
	 	Ingredients = { 
		 ['shir'] = 1, 
		 ['shekar'] = 1,
		 ['daneghahve'] = 2,
	 	}
	 },

	 ['boba_milk_tea_matcha'] = {
	 	Level = 1, 
		Category = 'UwUHamzan', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 3, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 10, 
	 	Ingredients = { 
		 ['shir'] = 1, 
		 ['shekar'] = 1,
		 ['powdr_matcha'] = 2,

	 	}
	 },

	 ['bobal_tea_matcha'] = {
	 	Level = 1, 
		Category = 'UwUHamzan', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 8, 
	 	Ingredients = { 
		 ['powdr_matcha'] = 1, 
		 ['shir'] = 1, 
		 ['shekar'] = 1, 
	 	}
	 },

	 ['bobal_tea_tamshak'] = {
	 	Level = 1, 
		Category = 'UwUHamzan', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 10, 
	 	Ingredients = { 
		 ['shir'] = 1, 
		 ['shekar'] = 1, 
		 ['tamshak'] = 1, 
	 	}
	 },

	 ['cake_bastani_vanili'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 3, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 17, 
	 	Ingredients = { 
		 ['aard'] = 1, 
		 ['bakingpowder'] = 1, 
		 ['egg'] = 1, 
		 ['vanil'] = 1, 
		 ['shir'] = 1, 
		 ['kare'] = 1, 
		 ['shekar'] = 1, 
	 	}
	 },

	 ['cake_limoii'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 10, 
	 	Ingredients = { 
		 ['limo'] = 1, 
		 ['aard'] = 1, 
		 ['bakingpowder'] = 1, 
		 ['shekar'] = 1, 
		 ['shir'] = 1, 
	 	}
	 },

	 ['cupcake_shokolati'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 3, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 11, 
	 	Ingredients = { 
		 ['shokolat'] = 1, 
		 ['aard'] = 1, 
		 ['shir'] = 1,
		 ['egg'] = 1,
		 ['kare'] = 1, 
		 ['bakingpowder'] = 1, 
	 	}
	 },

	 ['ice_coffee_matcha'] = {
	 	Level = 1, 
		Category = 'UwUHamzan', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 3, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 17, 
	 	Ingredients = { 

		 ['shir'] = 1, 
		 ['shekar'] = 1, 
		 ['khame'] = 1, 
		 ['powdr_matcha'] = 1, 

		
	 	}
	 },

	 ['milk_shake_shokolati'] = {
	 	Level = 1, 
		Category = 'UwUHamzan', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 17, 
	 	Ingredients = { 
			['shir'] = 1, 
			['shekar'] = 2,
		 	['podrcacao'] = 1, 
	 	}
	 },

	 ['mufchocolate'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 3, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 10, 
	 	Ingredients = { 
		 ['shokolat'] = 1, 
		 ['podrcacao'] = 1, 
		 ['aard'] = 1, 
		 ['egg'] = 1,
		 ['kare'] = 1, 
		 ['shekar'] = 1, 
		 ['shir'] = 1,
		 ['bakingpowder'] = 1,  
	 	}
	 },

	 ['muffin_tamshak'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 12, 
	 	Ingredients = { 
		 ['tamshak'] = 1, 
		 ['aard'] = 1, 
		 ['egg'] = 1, 
		 ['shir'] = 1, 
		 ['shekar'] = 1, 
		 ['bakingpowder'] = 1, 
	 	}
	 },

	 ['nodel'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 1, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 8, 
	 	Ingredients = { 
		 ['water'] = 2, 
		 ['nodel_kham'] = 1, 
		 ['kase'] = 1, 

	 	}
	 },

	 ['kase'] = {
	 	Level = 1, 
		Category = 'UwUZarfShoe', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 5, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 15, 
	 	Ingredients = { 
		 ['water'] = 1, 
		 ['kasekasif'] = 5, 
	 	}
	 },

	 ['pankik'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 5, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 17, 
	 	Ingredients = { 
		 ['shir'] = 1, 
		 ['egg'] = 1, 
		 ['aard'] = 1, 
		 ['shekar'] = 1, 
		 ['bakingpowder'] = 1, 
	 	}
	 },

	 ['pankik_nutella'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 3, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 12, 
	 	Ingredients = { 
			['aard'] = 1, 
			['shir'] = 1, 
			['egg'] = 1, 
			['kare'] = 1, 
			['bakingpowder'] = 1, 
		 	['nutela'] = 1, 
	 	}
	 },

	 ['pankik_oreo'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 8, 
	 	Ingredients = { 
		 ['oreo'] = 1, 
		 ['shir'] = 1, 
		 ['shekar'] = 1, 
		 ['egg'] = 1, 
		 ['bakingpowder'] = 1, 
		 ['kare'] = 1,
		 ['aard'] = 1, 
	 	}
	 },

	 ['tiramisuye_toot_farangi'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 17, 
	 	Ingredients = { 
		 ['aard'] = 2, 
		 ['totfarangi'] = 1, 
		 ['shekar'] = 1, 
		 ['egg'] = 1, 
		 ['khame'] = 1, 
		 ['shir'] = 1, 
		 ['kare'] = 1, 
		 ['bakingpowder'] = 1, 
	 	}
	 },


	 ['vafel_nutella'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 3, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 15, 
	 	Ingredients = { 
		 ['nutela'] = 1, 
		 ['aard'] = 1, 
		 ['egg'] = 1, 
		 ['shir'] = 1, 
		 ['aard'] = 1, 
		 ['kare'] = 1, 
		 ['shekar'] = 1, 
	 	}
	 },

	},

	
	Workbenches = { -- Every workbench location, leave {} for jobs if you want everybody to access
		{coords = vector3(-591.012, -1056.49, 22.2), jobs = {}, blip = false, recipes = {}, radius = 1.5 },
		{coords = vector3(-587.6, -1062.60, 22.556), jobs = {}, blip = false, recipes = {}, radius = 1.5 },
		{coords = vector3(-586.874, -1061.84, 22.344), jobs = {}, blip = false, recipes = {}, radius = 1.5 },
		{coords = vector3(-591.0, -1064.16, 22.544), jobs = {}, blip = false, recipes = {}, radius = 1.5 },
		

	},
	
}
	
	

function SendTextMessage(msg)

		-- SetNotificationTextEntry('STRING')
		-- AddTextComponentString(msg)
		-- DrawNotification(0,1)

		--EXAMPLE USED IN VIDEO
		--exports['mythic_notify']:SendAlert('inform', msg)
		
	ESX.ShowNotification(msg, "Craft Table", "info", 5000)

end
