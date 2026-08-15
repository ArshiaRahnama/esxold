-- Run this once against your database. It only adds the 2 NEW cafe jobs
-- (Obsidian Brew / Voltage Coffee Co.) - 'uwucafe' already exists, untouched.
-- The item catalog (drinks/cakes/ingredients) is shared by all cafes and is
-- already in your database from the original uwuData.sql, so it's not
-- repeated here.

INSERT INTO `jobs` (`name`, `label`, `whitelisted`, `handyservice`, `hasapp`, `onlyboss`) VALUES
	('obsidian', 'Obsidian Brew', 1, '0', 0, 0),
	('voltage', 'Voltage Coffee Co.', 1, '0', 0, 0);


INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`, `vehicles`, `helis`, `weapons`, `items`) VALUES
	('obsidian', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('obsidian', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('obsidian', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('obsidian', 4, 'boss',  'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),

	('voltage', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('voltage', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('voltage', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('voltage', 4, 'boss',  'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL);


INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
	('society_obsidian', 'obsidian', 1),
	('society_voltage', 'voltage', 1);


INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
	('society_obsidian', 'obsidian', 1),
	('society_voltage', 'voltage', 1);


INSERT INTO `addon_account_data` (`account_name`, `money`, `owner`) VALUES
	('society_obsidian', 0, NULL),
	('society_voltage', 0, NULL);
