-- 3 corp jobs sitting on top of the 17 businesses (Meridian Holdings,
-- Blacktide Logistics, Crate & Carry Distribution). Run once.

INSERT INTO `jobs` (`name`, `label`, `whitelisted`, `handyservice`, `hasapp`, `onlyboss`) VALUES
	('meridian', 'Meridian Holdings', 1, '0', 0, 0),
	('blacktide', 'Blacktide Logistics', 1, '0', 0, 0),
	('cratecarry', 'Crate & Carry Distribution', 1, '0', 0, 0);


INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`, `vehicles`, `helis`, `weapons`, `items`) VALUES
	('meridian', 1, 'rank1', 'Analyst', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('meridian', 2, 'rank2', 'Director', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('meridian', 3, 'boss',  'CEO',      1, '{}', '{}', '[]', '[]', NULL, NULL),

	('blacktide', 1, 'rank1', 'Runner',   1, '{}', '{}', '[]', '[]', NULL, NULL),
	('blacktide', 2, 'rank2', 'Enforcer', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('blacktide', 3, 'boss',  'Boss',     1, '{}', '{}', '[]', '[]', NULL, NULL),

	('cratecarry', 1, 'rank1', 'Driver',   1, '{}', '{}', '[]', '[]', NULL, NULL),
	('cratecarry', 2, 'rank2', 'Manager',  1, '{}', '{}', '[]', '[]', NULL, NULL),
	('cratecarry', 3, 'boss',  'Owner',    1, '{}', '{}', '[]', '[]', NULL, NULL);


INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
	('society_meridian', 'meridian', 1),
	('society_blacktide', 'blacktide', 1),
	('society_cratecarry', 'cratecarry', 1);


INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
	('society_meridian', 'meridian', 1),
	('society_blacktide', 'blacktide', 1),
	('society_cratecarry', 'cratecarry', 1);


INSERT INTO `addon_account_data` (`account_name`, `money`, `owner`) VALUES
	('society_meridian', 0, NULL),
	('society_blacktide', 0, NULL),
	('society_cratecarry', 0, NULL);
