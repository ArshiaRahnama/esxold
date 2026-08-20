<?php
declare(strict_types=1);

// ============================================================================
//  Unique_Login — password reset (web)
//
//  Standalone from UNIQUE_AC/central-hub on purpose: central-hub uses its
//  own local SQLite file for a completely different job (multi-server
//  monitoring). This talks directly to the SAME MySQL `login_users` table
//  the FiveM resource uses, so a password changed here works immediately
//  in-game — no server restart needed.
//
//  Deployment notes are in README.md next to this file. Short version:
//  put this behind HTTPS, create a DB user that can only SELECT/UPDATE
//  `login_users` and SELECT/INSERT/UPDATE `login_reset_throttle` (see
//  README), and fill in web/local-config.php with real credentials.
// ============================================================================

session_start();

require __DIR__ . '/config.php';

function db(): PDO {
    static $pdo = null;
    if ($pdo === null) {
        $pdo = new PDO(
            'mysql:host=' . RESET_DB_HOST . ';dbname=' . RESET_DB_NAME . ';charset=utf8mb4',
            RESET_DB_USER,
            RESET_DB_PASS,
            [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
        );
    }
    return $pdo;
}

function clientIp(): string {
    return $_SERVER['REMOTE_ADDR'] ?? '0.0.0.0';
}

// Same rolling-window rate limiting as Config.SmsRateLimit in the FiveM
// resource, just backed by a tiny MySQL table instead of an in-memory Lua
// table (a PHP process has no long-lived memory between requests).
function rateLimitCheck(string $bucketKey, int $maxCount, int $windowSeconds): bool {
    $pdo = db();
    $now = time();

    $stmt = $pdo->prepare('SELECT window_start, count FROM login_reset_throttle WHERE bucket_key = ?');
    $stmt->execute([$bucketKey]);
    $row = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$row || ($now - (int)$row['window_start']) >= $windowSeconds) {
        $stmt = $pdo->prepare(
            'INSERT INTO login_reset_throttle (bucket_key, window_start, count) VALUES (?, ?, 1)
             ON DUPLICATE KEY UPDATE window_start = VALUES(window_start), count = 1'
        );
        $stmt->execute([$bucketKey, $now]);
        return true;
    }

    if ((int)$row['count'] >= $maxCount) {
        return false;
    }

    $stmt = $pdo->prepare('UPDATE login_reset_throttle SET count = count + 1 WHERE bucket_key = ?');
    $stmt->execute([$bucketKey]);
    return true;
}

function sendSmsCode(string $phone, string $code): bool {
    $payload = json_encode([
        'mobile'     => $phone,
        'templateId' => RESET_SMS_TEMPLATE_ID,
        'parameters' => [['name' => 'OTP', 'value' => $code]],
    ]);

    $ch = curl_init(RESET_SMS_API_URL);
    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_POST           => true,
        CURLOPT_POSTFIELDS     => $payload,
        CURLOPT_HTTPHEADER     => [
            'Content-Type: application/json',
            'X-API-KEY: ' . RESET_SMS_API_KEY,
        ],
        CURLOPT_TIMEOUT => 10,
    ]);
    curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    return $httpCode >= 200 && $httpCode < 300;
}

function csrfToken(): string {
    if (empty($_SESSION['csrf'])) {
        $_SESSION['csrf'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['csrf'];
}

function csrfValid(): bool {
    return isset($_POST['csrf'], $_SESSION['csrf']) && hash_equals($_SESSION['csrf'], $_POST['csrf']);
}

$error = null;
$success = null;
// step: 'phone' (ask for phone) -> 'verify' (code + new password) -> 'done'
$step = $_SESSION['reset_step'] ?? 'phone';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrfValid()) {
        $error = 'درخواست نامعتبر است، صفحه را رفرش کنید.';
    } elseif (($_POST['action'] ?? '') === 'send_code') {
        $phone = preg_replace('/\D/', '', $_POST['phone'] ?? '');

        if (strlen($phone) !== 10) {
            $error = 'شماره تلفن باید ۱۰ رقم باشد (بدون صفر اول).';
        } elseif (!rateLimitCheck('phone:' . $phone, RESET_MAX_PER_PHONE_PER_HOUR, 3600)) {
            $error = 'تعداد درخواست‌های شما برای این شماره بیش از حد مجاز است. کمی بعد دوباره تلاش کنید.';
        } elseif (!rateLimitCheck('ip:' . clientIp(), RESET_MAX_PER_IP_PER_HOUR, 3600)) {
            $error = 'تعداد درخواست‌های شما بیش از حد مجاز است. کمی بعد دوباره تلاش کنید.';
        } else {
            $stmt = db()->prepare('SELECT id, username FROM login_users WHERE phone = ? LIMIT 1');
            $stmt->execute([$phone]);
            $user = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$user) {
                $error = 'این شماره تلفن در سیستم ثبت نشده است.';
            } else {
                $code = (string)random_int(100000, 999999);
                if (sendSmsCode($phone, $code)) {
                    $_SESSION['reset_phone']    = $phone;
                    $_SESSION['reset_username'] = $user['username'];
                    $_SESSION['reset_code']     = $code;
                    $_SESSION['reset_expires']  = time() + RESET_CODE_TTL_SECONDS;
                    $_SESSION['reset_step']     = 'verify';
                    $step = 'verify';
                } else {
                    $error = 'خطا در ارسال پیامک. لطفاً دوباره تلاش کنید.';
                }
            }
        }
    } elseif (($_POST['action'] ?? '') === 'reset_password') {
        $code        = preg_replace('/\D/', '', $_POST['code'] ?? '');
        $newPassword = $_POST['new_password'] ?? '';
        $confirm     = $_POST['confirm_password'] ?? '';

        if (empty($_SESSION['reset_phone']) || empty($_SESSION['reset_code'])) {
            $error = 'نشست شما منقضی شده، دوباره شماره را وارد کنید.';
            $_SESSION['reset_step'] = 'phone';
            $step = 'phone';
        } elseif (time() > ($_SESSION['reset_expires'] ?? 0)) {
            $error = 'کد تأیید منقضی شده است. دوباره درخواست کد کنید.';
            $_SESSION['reset_step'] = 'phone';
            $step = 'phone';
        } elseif (!hash_equals((string)$_SESSION['reset_code'], $code)) {
            $error = 'کد تأیید اشتباه است.';
            $step = 'verify';
        } elseif (strlen($newPassword) < 6) {
            $error = 'رمز عبور باید حداقل ۶ کاراکتر باشد.';
            $step = 'verify';
        } elseif ($newPassword !== $confirm) {
            $error = 'رمز عبور و تکرار آن یکسان نیست.';
            $step = 'verify';
        } else {
            // Same hashing scheme as the in-game resource: SHA2-256 done
            // inside the query, matching what CheckLogin() in server.lua
            // compares against — password_hash()/bcrypt would NOT match.
            $stmt = db()->prepare('UPDATE login_users SET password = SHA2(?, 256) WHERE phone = ?');
            $stmt->execute([$newPassword, $_SESSION['reset_phone']]);

            $success = 'رمز عبور با موفقیت تغییر کرد. اکنون می‌توانید با نام کاربری و رمز جدید وارد سرور شوید.';
            $step = 'done';
            unset($_SESSION['reset_phone'], $_SESSION['reset_username'], $_SESSION['reset_code'], $_SESSION['reset_expires'], $_SESSION['reset_step']);
        }
    }
}
?>
<!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>بازیابی رمز عبور | Unique RP</title>
<style>
    :root {
        --dark: #020c1b; --mid: #0a192f; --light: #112240;
        --aqua: #00f5d4; --white: #e6f1ff; --gray: #8892b0; --red: #ff6b6b;
    }
    * { box-sizing: border-box; }
    body {
        background: var(--dark); color: var(--white);
        font-family: Tahoma, sans-serif; display: flex; justify-content: center;
        align-items: center; min-height: 100vh; margin: 0; padding: 20px;
    }
    .card {
        background: var(--mid); border-radius: 15px; padding: 30px;
        max-width: 420px; width: 100%; border: 1px solid var(--light);
    }
    h1 { color: var(--aqua); font-size: 1.4rem; text-align: center; margin-top: 0; }
    label { display: block; margin: 14px 0 6px; font-size: 0.9rem; color: var(--gray); }
    input {
        width: 100%; padding: 10px; border-radius: 8px; border: 1px solid var(--light);
        background: var(--dark); color: var(--white); font-size: 1rem;
    }
    button {
        width: 100%; margin-top: 20px; padding: 12px; border: none; border-radius: 8px;
        background: var(--aqua); color: var(--dark); font-weight: bold; font-size: 1rem;
        cursor: pointer;
    }
    .msg { border-radius: 8px; padding: 12px; margin-bottom: 14px; font-size: 0.9rem; text-align: center; }
    .msg.error { background: #1a0a0a; border: 1px solid var(--red); color: var(--red); }
    .msg.success { background: #0a1a0a; border: 1px solid #64ffda; color: #64ffda; }
    .hint { font-size: 0.8rem; color: var(--gray); margin-top: 4px; }
</style>
</head>
<body>
<div class="card">
    <h1>🔑 بازیابی رمز عبور</h1>

    <?php if ($error): ?>
        <div class="msg error">❌ <?= htmlspecialchars($error) ?></div>
    <?php endif; ?>
    <?php if ($success): ?>
        <div class="msg success">✅ <?= htmlspecialchars($success) ?></div>
    <?php endif; ?>

    <?php if ($step === 'phone'): ?>
        <form method="post">
            <input type="hidden" name="csrf" value="<?= htmlspecialchars(csrfToken()) ?>">
            <input type="hidden" name="action" value="send_code">
            <label>شماره تلفن ثبت‌شده (بدون 0 اول)</label>
            <input type="text" name="phone" placeholder="9123456789" maxlength="10" required>
            <button type="submit">ارسال کد تأیید</button>
        </form>

    <?php elseif ($step === 'verify'): ?>
        <p class="hint">کد ۶ رقمی به شماره <?= htmlspecialchars($_SESSION['reset_phone'] ?? '') ?> ارسال شد
        (حساب: <?= htmlspecialchars($_SESSION['reset_username'] ?? '') ?>). کد تا ۲ دقیقه معتبر است.</p>
        <form method="post">
            <input type="hidden" name="csrf" value="<?= htmlspecialchars(csrfToken()) ?>">
            <input type="hidden" name="action" value="reset_password">
            <label>کد تأیید</label>
            <input type="text" name="code" maxlength="6" required>
            <label>رمز عبور جدید</label>
            <input type="password" name="new_password" minlength="6" required>
            <label>تکرار رمز عبور جدید</label>
            <input type="password" name="confirm_password" minlength="6" required>
            <button type="submit">تغییر رمز عبور</button>
        </form>

    <?php else: ?>
        <p class="hint" style="text-align:center">می‌توانید این صفحه را ببندید و از داخل بازی وارد شوید.</p>
    <?php endif; ?>
</div>
</body>
</html>
