fx_version 'cerulean'
game 'gta5'

author 'Unique RP'
description 'Unique_Shop_ItemSeller -- merged: Unique_Scripts_Shops + Unique_Scripts_ItemSeller (نوتیفیکیشن‌ها روی ox_lib / esx:showNotification هستن)'
version '1.0.0'

lua54 'yes'

-- ox_lib لازمه چون نوتیفیکیشن‌های کلاینت هر دو زیرسیستم از lib.notify استفاده می‌کنن
shared_scripts {
	'@ox_lib/init.lua',
	'shared.lua', -- متغیر مشترک url (قبلاً تو هر دو ریسورس تکرار شده بود)
}

client_scripts {
	-- Shop (فروشگاه‌ها: Shops/MC/Narekshop/Gunshop)
	'shop/config.lua',
	'shop/client.lua',

	-- ItemSeller (فروش آیتم: Tailor/Lumberjack/Slaughterer/Fueler/Laster/Miner/Separated/Drugdealer2)
	'itemseller/config.lua',
	'itemseller/client.lua',
}

server_scripts {
	-- @oxmysql رو هر دو زیرسیستم به‌طور غیرمستقیم از essentialmode/framework می‌گیرن؛
	-- اگه server.lua خودشون مستقیم mysql صدا می‌زنن این خط رو نگه دار.
	'shop/config.lua',
	'shop/server.lua',

	'itemseller/config.lua',
	'itemseller/server.lua',
}

-- توجه: fxmanifest اصلیِ هر دو ریسورس یه ui_page/files برای html/index.html داشتن
-- که هیچ‌جای کد (SendNUIMessage / SetNuiFocus / RegisterNUICallback) صداش نمی‌زد --
-- یعنی کاملاً بلااستفاده بود. عمداً از این فایل حذف شده تا این ریسورس merge شده
-- تمیز بمونه. خودِ فایل‌های html/ (images/water.png و index.rar) دست‌نخورده
-- توی shop/html و itemseller/html نگه داشته شدن، چیزی حذف نشده.
