# Unique_Login — پنل وب بازیابی رمز عبور

یه صفحه‌ی وب مستقل (بدون نیاز به وصل بودن به سرور بازی) که مستقیم به همون
دیتابیس MySQL می‌زنه که ریسورس FiveM ازش استفاده می‌کنه. تغییر رمز اینجا
فوراً توی بازی هم اعمال میشه، بدون ری‌استارت سرور.

**چرا جدا از `UNIQUE_AC/central-hub`؟** چون central-hub یه دیتابیس SQLite
جدا و مستقل برای کار خودش (مانیتورینگ چند سروری) داره؛ این پنل باید
مستقیم به MySQL خودِ سرور بازی وصل بشه، پس عمداً جداش کردم.

## نصب

1. جدول `login_reset_throttle` رو با اجرای `sql/install.sql` (آپدیت‌شده)
   بساز — اگه قبلاً اجراش کردی، کافیه فقط همون قسمت جدید (CREATE TABLE
   `login_reset_throttle`) رو دوباره اجرا کنی.

2. **یه یوزر MySQL محدود بساز** — هرگز از `root` یا یوزر اصلی گیم استفاده
   نکن، چون این کد روی یه وب‌هاست عمومی اجرا میشه:
   ```sql
   CREATE USER 'unique_login_web'@'%' IDENTIFIED BY 'یه-پسورد-قوی';
   GRANT SELECT, UPDATE ON essentialmode.login_users TO 'unique_login_web'@'%';
   GRANT SELECT, INSERT, UPDATE ON essentialmode.login_reset_throttle TO 'unique_login_web'@'%';
   FLUSH PRIVILEGES;
   ```

3. کنار `config.php`، یه فایل به اسم `local-config.php` بساز (این فایل رو
   هیچ‌وقت commit/آپلود پابلیک نکن) با محتوای:
   ```php
   <?php
   define('RESET_DB_HOST', '127.0.0.1');
   define('RESET_DB_NAME', 'essentialmode');
   define('RESET_DB_USER', 'unique_login_web');
   define('RESET_DB_PASS', 'همون-پسورد-قوی');
   define('RESET_SMS_API_KEY', 'کلید-واقعی-sms.ir');
   ```

4. کل پوشه‌ی `web/` رو روی هاست/سرور PHP خودت (php-fpm + nginx یا apache)
   آپلود کن. **حتماً پشت HTTPS باشه** (رمز/کد OTP رد میشه، بدون SSL قابل
   شنودن).

5. آدرس نهایی چیزی مثل `https://arshiahub.ir/reset-password.php` میشه —
   می‌تونی لینکش رو توی Discord سرور یا صفحه‌ی اتصال بازی بذاری.

## نکات امنیتی

- `local-config.php` باید بیرون از webroot باشه یا با `.htaccess`/`nginx
  location` محافظت بشه (مشابه محافظتی که central-hub برای `hub.db` داره).
- Rate limit همینجا (فایل `config.php`) با همون اعداد `Config.SmsRateLimit`
  توی `config.lua` بازی هماهنگه — اگه یکیشون رو عوض کردی، اون یکی رو هم
  دستی هماهنگ کن (دو تا اپلیکیشن جدا از هم هستن).
- کد OTP فقط ۲ دقیقه (`RESET_CODE_TTL_SECONDS`) توی session معتبره.
- پسورد جدید دقیقاً با همون الگوریتم SQL‌سایدِ ریسورس بازی (`SHA2(pass,
  256)`) هش میشه — نه bcrypt/password_hash — چون باید عین همون مقداری
  باشه که `CheckLogin()` توی `server.lua` باهاش مقایسه می‌کنه.
