-- Run this once against your database. It only adds the 5 NEW businesses
-- (2 cafés + 3 restaurants) - 'uwucafe' already exists, untouched.
-- The item catalog (drinks/cakes/ingredients) is shared by all of them and
-- is already in your database from the original uwuData.sql, so it's not
-- repeated here.

INSERT INTO `jobs` (`name`, `label`, `whitelisted`, `handyservice`, `hasapp`, `onlyboss`) VALUES
	('obsidian', 'Obsidian Brew', 1, '0', 0, 0),
	('voltage', 'Voltage Coffee Co.', 1, '0', 0, 0),
	('ember', 'Ember & Ash', 1, '0', 0, 0),
	('anchor', 'The Rusty Anchor', 1, '0', 0, 0),
	('crimson', 'Crimson Fork', 1, '0', 0, 0);


INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`, `vehicles`, `helis`, `weapons`, `items`) VALUES
	('obsidian', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('obsidian', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('obsidian', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('obsidian', 4, 'boss',  'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),

	('voltage', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('voltage', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('voltage', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('voltage', 4, 'boss',  'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),

	('ember', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('ember', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('ember', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('ember', 4, 'boss',  'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),

	('anchor', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('anchor', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('anchor', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('anchor', 4, 'boss',  'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),

	('crimson', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('crimson', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('crimson', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('crimson', 4, 'boss',  'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL);


INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
	('society_obsidian', 'obsidian', 1),
	('society_voltage', 'voltage', 1),
	('society_ember', 'ember', 1),
	('society_anchor', 'anchor', 1),
	('society_crimson', 'crimson', 1);


INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
	('society_obsidian', 'obsidian', 1),
	('society_voltage', 'voltage', 1),
	('society_ember', 'ember', 1),
	('society_anchor', 'anchor', 1),
	('society_crimson', 'crimson', 1);


INSERT INTO `addon_account_data` (`account_name`, `money`, `owner`) VALUES
	('society_obsidian', 0, NULL),
	('society_voltage', 0, NULL),
	('society_ember', 0, NULL),
	('society_anchor', 0, NULL),
	('society_crimson', 0, NULL);

-- 10 new business jobs (2 each of bakery/bar/pizza/icecream/sushi)

INSERT INTO `jobs` (`name`, `label`, `whitelisted`, `handyservice`, `hasapp`, `onlyboss`) VALUES
	('flourish', 'Flourish Bakery', 1, '0', 0, 0),
	('goldcrust', 'Gold Crust Bakehouse', 1, '0', 0, 0),
	('static', 'Static Lounge', 1, '0', 0, 0),
	('nightjar', 'Nightjar Pub', 1, '0', 0, 0),
	('firebrick', 'Firebrick Pizza Co.', 1, '0', 0, 0),
	('slice', 'Slice Society', 1, '0', 0, 0),
	('frostbite', 'Frostbite Creamery', 1, '0', 0, 0),
	('sundae', 'Sundae Funday', 1, '0', 0, 0),
	('koi', 'Koi Sushi House', 1, '0', 0, 0),
	('wasabi', 'Wasabi & Co.', 1, '0', 0, 0);


INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`, `vehicles`, `helis`, `weapons`, `items`) VALUES
	('flourish', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('flourish', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('flourish', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('flourish', 4, 'boss',  'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('goldcrust', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('goldcrust', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('goldcrust', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('goldcrust', 4, 'boss',  'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('static', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('static', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('static', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('static', 4, 'boss',  'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('nightjar', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('nightjar', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('nightjar', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('nightjar', 4, 'boss',  'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('firebrick', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('firebrick', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('firebrick', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('firebrick', 4, 'boss',  'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('slice', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('slice', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('slice', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('slice', 4, 'boss',  'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('frostbite', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('frostbite', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('frostbite', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('frostbite', 4, 'boss',  'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('sundae', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('sundae', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('sundae', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('sundae', 4, 'boss',  'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('koi', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('koi', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('koi', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('koi', 4, 'boss',  'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('wasabi', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('wasabi', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('wasabi', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('wasabi', 4, 'boss',  'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL);


INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
	('society_flourish', 'flourish', 1),
	('society_goldcrust', 'goldcrust', 1),
	('society_static', 'static', 1),
	('society_nightjar', 'nightjar', 1),
	('society_firebrick', 'firebrick', 1),
	('society_slice', 'slice', 1),
	('society_frostbite', 'frostbite', 1),
	('society_sundae', 'sundae', 1),
	('society_koi', 'koi', 1),
	('society_wasabi', 'wasabi', 1);


INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
	('society_flourish', 'flourish', 1),
	('society_goldcrust', 'goldcrust', 1),
	('society_static', 'static', 1),
	('society_nightjar', 'nightjar', 1),
	('society_firebrick', 'firebrick', 1),
	('society_slice', 'slice', 1),
	('society_frostbite', 'frostbite', 1),
	('society_sundae', 'sundae', 1),
	('society_koi', 'koi', 1),
	('society_wasabi', 'wasabi', 1);


INSERT INTO `addon_account_data` (`account_name`, `money`, `owner`) VALUES
	('society_flourish', 0, NULL),
	('society_goldcrust', 0, NULL),
	('society_static', 0, NULL),
	('society_nightjar', 0, NULL),
	('society_firebrick', 0, NULL),
	('society_slice', 0, NULL),
	('society_frostbite', 0, NULL),
	('society_sundae', 0, NULL),
	('society_koi', 0, NULL),
	('society_wasabi', 0, NULL);

-- 1 new gang-front business (Suds & Cash car wash - money laundering front)

INSERT INTO `jobs` (`name`, `label`, `whitelisted`, `handyservice`, `hasapp`, `onlyboss`) VALUES
	('carwash', 'Suds & Cash', 1, '0', 0, 0);


INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`, `vehicles`, `helis`, `weapons`, `items`) VALUES
	('carwash', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('carwash', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('carwash', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('carwash', 4, 'boss',  'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL);


INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
	('society_carwash', 'carwash', 1);


INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
	('society_carwash', 'carwash', 1);


INSERT INTO `addon_account_data` (`account_name`, `money`, `owner`) VALUES
	('society_carwash', 0, NULL);
