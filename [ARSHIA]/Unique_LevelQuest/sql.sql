-- ================================================================= --
-- Unique_LevelQuest — required SQL
-- ================================================================= --
-- Neither of these existed anywhere in the original fix_level_quest
-- folders, even though the whole XP/level/quest system depends on them.
-- Run this once against your `essentialmode` database before starting
-- the resource.
-- ================================================================= --

ALTER TABLE `users`
    ADD COLUMN `xp`   INT(11) NOT NULL DEFAULT 0,
    ADD COLUMN `rank` INT(11) NOT NULL DEFAULT 1;

CREATE TABLE IF NOT EXISTS `quest` (
    `identifier` VARCHAR(60)  NOT NULL,
    `date`       VARCHAR(20)  NOT NULL DEFAULT '',
    `quests`     LONGTEXT     NOT NULL,
    PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Safety net: if `quest` already existed on your DB from an earlier run
-- (without the `date` column), CREATE TABLE IF NOT EXISTS above is a
-- no-op and this ALTER TABLE adds it. If the column already exists this
-- one line will error and you can just ignore/skip it.
ALTER TABLE `quest` ADD COLUMN `date` VARCHAR(20) NOT NULL DEFAULT '';
