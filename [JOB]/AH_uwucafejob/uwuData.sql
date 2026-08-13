--new item
INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
	('bastani', 'Bastani', 10, 0, 1),
	('boba_milk_tea_caramel', 'boba milk tea caramel', 10, 0, 1),
	('boba_milk_tea_matcha', 'Boba Milk Tea Matcha', 10, 0, 1),
	('bobal_tea_tamshak', 'Bobal Tea Tamshak', 10, 0, 1),
	('bobal_tea_matcha', 'Bobal Tea Matcha', 10, 0, 1),
	('cake_bastani_vanili', 'Cake Bastani Vanili', 10, 0, 1),
	('cake_limoii', 'Cake Limoii', 10, 0, 1),
	('cupcake_shokolati', 'Cupcake Shokolati', 10, 0, 1),
	('ice_coffee_matcha', 'Ice Coffee Matcha', 10, 0, 1),
	('milk_shake_shokolati', 'Milk Shake Shokolati', 10, 0, 1),
	('mufchocolate', 'Mufchocolate', 10, 0, 1),
	('muffin_tamshak', 'Muffin Tamshak', 10, 0, 1),
	('nodel', 'Nodel', 10, 0, 1),
	('pankik', 'Pankik', 10, 0, 1),
	('pankik_nutella', 'Pankik Nutella', 10, 0, 1),
	('pankik_oreo', 'Pankik Oreo', 10, 0, 1),
    ('tiramisuye_toot_farangi', 'Tiramisuye TotFarangi', 10, 0, 1),
    ('vafel_nutella', 'Vafel Nutella', 10, 0, 1),


	('vanil', 'Vanil', 30, 0, 1),
	('tamshak', 'Tamshak', 30, 0, 1),
	('powdr_matcha', 'Powdr Matcha', 30, 0, 1),
	('oreo', 'Oreo', 30, 0, 1),
	('nodel_kham', 'Nodel Kham', 30, 0, 1),
	('khame', 'Khame', 30, 0, 1),
	('kare', 'Kare', 30, 0, 1);






-- old item 

INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
	('abporteghal', 'Ab Porteghal', 10, 0, 1),
	('bubbletetotfarangi', 'Bubblete Totfarangi', 10, 0, 1),
	('cakebastani', 'Cake Bastani', 10, 0, 1),
	('cakebastanivanili', 'Cake Bastani Vanili', 10, 0, 1),
	('caketotfarangi', 'Cake Totfarangi', 10, 0, 1),
	('chaee', 'Chaee', 10, 0, 1),
	('cupcake', 'Cup Cake', 10, 0, 1),
	('ghahve50', 'Ghahve 50', 10, 0, 1),
	('ghahve80', 'Ghahve 80', 10, 0, 1),
	('ghahve100', 'Ghahve 100', 10, 0, 1),
	('hot_chocolate', 'Hot Chocolate', 10, 0, 1),
	('latte', 'Latte', 10, 0, 1),
	('milkshake', 'Milk Shake', 10, 0, 1),
	('noodles', 'Noodles', 10, 0, 1),
	('nutela', 'Nutela', 10, 0, 1),
	('shokolat', 'Shokolat', 10, 0, 1),
    ('suop', 'Suop', 10, 0, 1),


	('aard', 'Aard', 30, 0, 1),
	('bakingpowder', 'Baking Powder', 30, 0, 1),
	('daneghahve', 'Dane Ghahve', 30, 0, 1),
	('egg', 'Tokhm Morgh', 30, 0, 1),
	('fenjon', 'Fenjon', 30, 0, 1),
	('fenjonkasif', 'Fenjon Kasif', 30, 0, 1),
	('kare', 'Kare', 30, 0, 1),
	('kase', 'Kase', 30, 0, 1),
	('kasekasif', 'Kase Kasif', 30, 0, 1),
	('limo', 'Limo', 30, 0, 1),
	('podrcacao', 'Podr Cacao', 30, 0, 1),
	('shekar', 'Shekar', 30, 0, 1),
	('shir', 'Shir', 30, 0, 1),
	('totfarangi', 'Tot Farangi', 30, 0, 1),
	('yakh', 'Yakh', 30, 0, 1);
	



INSERT INTO `jobs` (`name`, `label`, `whitelisted`, `handyservice`, `hasapp`, `onlyboss`) VALUES
	('uwucafe', 'UwU Cafe', 1, '0', 0, 0);



INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`, `vehicles`, `helis`, `weapons`, `items`) VALUES
	
	('uwucafe', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('uwucafe', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('uwucafe', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('uwucafe', 4, 'boss', 'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL);



INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
	('society_uwucafe', 'uwucafe', 1);




INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
	('society_uwucafe', 'uwucafe', 1);



INSERT INTO `addon_account_data` (`account_name`, `money`, `owner`) VALUES
	('society_uwucafe', 0, NULL);
