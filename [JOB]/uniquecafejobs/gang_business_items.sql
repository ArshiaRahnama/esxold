-- 6 new finished items for Suds & Cash (car wash)
REPLACE INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
	('premium_wax', 'Premium Wax', 10, 0, 1),
	('interior_cleaner', 'Interior Cleaner Kit', 10, 0, 1),
	('rim_polish', 'Rim Polish', 10, 0, 1),
	('air_freshener_pine', 'Air Freshener Pine', 10, 0, 1),
	('ceramic_coat', 'Ceramic Coat', 10, 0, 1),
	('tire_shine', 'Tire Shine', 10, 0, 1);

-- 2 new raw ingredients for Suds & Cash
REPLACE INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
	('soap_foam', 'Soap Foam', 30, 0, 1),
	('microfiber_cloth', 'Microfiber Cloth', 30, 0, 1);
