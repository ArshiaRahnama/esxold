-- Turf Wars Inc. - paintball turf-rental holding. Run once.

INSERT INTO `jobs` (`name`, `label`, `whitelisted`, `handyservice`, `hasapp`, `onlyboss`) VALUES
	('turfco', 'Turf Wars Inc.', 1, '0', 0, 0);


INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`, `vehicles`, `helis`, `weapons`, `items`) VALUES
	('turfco', 1, 'rank1', 'Referee',  1, '{}', '{}', '[]', '[]', NULL, NULL),
	('turfco', 2, 'rank2', 'Manager',  1, '{}', '{}', '[]', '[]', NULL, NULL),
	('turfco', 3, 'boss',  'Owner',    1, '{}', '{}', '[]', '[]', NULL, NULL);


INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
	('society_turfco', 'turfco', 1);


INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
	('society_turfco', 'turfco', 1);


INSERT INTO `addon_account_data` (`account_name`, `money`, `owner`) VALUES
	('society_turfco', 0, NULL);
