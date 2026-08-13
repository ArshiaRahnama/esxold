USE essentialmode;
ALTER TABLE `users` ADD COLUMN
(
	`coin` int(11) NOT NULL DEFAULT '0',
	`timercoin` int(11) NOT NULL DEFAULT '0'
) 