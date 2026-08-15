

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Unique Gangs (merged: gangs + gangprop + gangaccount)'

version '1.0.0'

-- این دو خط تضمین می‌کنه که essentialmode و mysql-async همیشه قبل از این
-- ریسورس لود بشن، حتی اگه تو server.cfg ترتیبشون درست چیده نشده باشه.
-- (این باعث میشه تابع _U/Locales که این ریسورس بهش وابسته‌ست همیشه آماده باشه)
dependency 'mysql-async'
dependency 'essentialmode'

-- =====================================================================
-- این ریسورس حاصل ادغام سه ریسورس مجزا در یک ریسورس واحده:
--   gangs        -> config.lua        + server/main.lua        + server/mainxp.lua
--                                      + client/main.lua        + client/mainxp.lua
--   gangprop     -> prop_config.lua   + server/prop_main.lua
--                                      + client/prop_main.lua
--   gangaccount  -> server/classes/addonaccount.lua + server/account_main.lua
--
-- برای جلوگیری از تداخل، جدول سراسری Config مربوط به gangprop به PropConfig
-- تغییر نام پیدا کرد (چون هر دو ریسورس قبلی یک متغیر سراسری به اسم Config
-- می‌ساختن که با ادغام، دومی اولی رو کامل پاک می‌کرد).
-- فایل‌های ترجمه (locales) زبان‌های en و fr هم چون در هر دو پکیج تعریف
-- شده بودن با هم merge شدن تا هیچ‌کدوم از رشته‌های ترجمه از بین نره.
-- =====================================================================

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'locales/br.lua',
	'locales/es.lua',
	'config.lua',
	'prop_config.lua',
	'server/main.lua',
	'server/mainxp.lua',
	'server/prop_main.lua',
	'server/classes/addonaccount.lua',
	'server/account_main.lua'
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'locales/br.lua',
	'locales/es.lua',
	'config.lua',
	'prop_config.lua',
	'client/main.lua',
	'client/mainxp.lua',
	'client/prop_main.lua'
}
