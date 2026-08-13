-- ============================================================
-- MIGRATIONS — سیستم مدیریت تغییرات دیتابیس
-- ============================================================
-- ✅ قبلاً هر ستون جدیدی که لازم می‌شد (مثل account_num)، مستقیم با
-- ensureColumn تو خودِ فایل ماژول نوشته می‌شد. مشکلش اینه که هیچ ثبتی از
-- "چی کِی اجرا شده" نداشتیم. الان یه جدول کوچیک (`unique_ui_migrations`)
-- نگه می‌داریم که هر migration فقط دقیقاً یه‌بار اجرا بشه، برای همیشه.
--
-- برای اضافه‌کردن یه تغییر دیتابیس جدید تو آپدیت‌های بعدی: فقط یه آیتم جدید
-- به لیست MIGRATIONS پایین اضافه کنید؛ خودش موقع استارت بعدی اجرا میشه.

while MySQL == nil do Wait(0) end

local MIGRATIONS = {
    {
        name = 'users_add_token_coin',
        run = function()
            local function ensureColumn(tableName, columnName, columnDef)
                local exists = MySQL.single.await([[
                    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
                    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = ? LIMIT 1
                ]], { tableName, columnName })
                if not exists then
                    MySQL.query.await(('ALTER TABLE `%s` ADD COLUMN `%s` %s'):format(tableName, columnName, columnDef))
                end
            end
            ensureColumn('users', 'token', 'INT NOT NULL DEFAULT 0')
            ensureColumn('users', 'coin', 'INT NOT NULL DEFAULT 0')
        end,
    },
    {
        name = 'users_add_account_num',
        run = function()
            local exists = MySQL.single.await([[
                SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
                WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'users' AND COLUMN_NAME = 'account_num'
                LIMIT 1
            ]])
            if not exists then
                MySQL.query.await('ALTER TABLE `users` ADD COLUMN `account_num` INT NOT NULL AUTO_INCREMENT UNIQUE')
            end
        end,
    },
    -- 👇 برای هر migration جدید بعدی، فقط یه آیتم مثل این‌ها اضافه کنید:
    -- {
    --     name = 'یه_اسم_یکتا_و_توصیفی',
    --     run = function()
    --         MySQL.query.await('ALTER TABLE ...')
    --     end,
    -- },
}

local function ensureMigrationsTable()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `unique_ui_migrations` (
            `name` VARCHAR(191) NOT NULL PRIMARY KEY,
            `applied_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        )
    ]])
end

local function runMigrations()
    local ok, err = pcall(ensureMigrationsTable)
    if not ok then
        print('^1[migrations]^7 نتونستم جدول unique_ui_migrations رو بسازم: ' .. tostring(err))
        return
    end

    for _, m in ipairs(MIGRATIONS) do
        local exists = MySQL.single.await('SELECT 1 FROM unique_ui_migrations WHERE name = ?', { m.name })
        if not exists then
            local runOk, runErr = pcall(m.run)
            if runOk then
                MySQL.insert.await('INSERT INTO unique_ui_migrations (name) VALUES (?)', { m.name })
                print(('^2[migrations]^7 اجرا و ثبت شد: %s'):format(m.name))
            else
                print(('^1[migrations]^7 خطا تو "%s": %s'):format(m.name, tostring(runErr)))
            end
        end
    end
end

CreateThread(function()
    runMigrations()
end)
