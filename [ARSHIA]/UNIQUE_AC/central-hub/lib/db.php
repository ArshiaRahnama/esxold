<?php
declare(strict_types=1);

require_once __DIR__ . '/../config.php';

function hub_db(): PDO {
    static $pdo = null;
    if ($pdo === null) {
        $isNew = !file_exists(HUB_DB_PATH);
        $pdo = new PDO('sqlite:' . HUB_DB_PATH);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
        $pdo->exec('PRAGMA foreign_keys = ON');
        if ($isNew) {
            $pdo->exec(file_get_contents(__DIR__ . '/../schema.sql'));
        }
    }
    return $pdo;
}

function hub_now(): int {
    return time();
}

function hub_require_admin(string $loginPathRelativeToCaller = 'login.php'): void {
    session_start();
    if (empty($_SESSION['hub_admin']) || $_SESSION['hub_admin'] !== true) {
        header('Location: ' . $loginPathRelativeToCaller);
        exit;
    }
}

function hub_json(array $data, int $status = 200): void {
    http_response_code($status);
    header('Content-Type: application/json');
    echo json_encode($data);
    exit;
}

function hub_valid_license(string $key): ?array {
    $stmt = hub_db()->prepare('SELECT * FROM license_keys WHERE key_value = :k LIMIT 1');
    $stmt->execute([':k' => $key]);
    $row = $stmt->fetch();
    if (!$row) return null;
    if ((int)$row['active'] !== 1) return null;
    if ($row['expires_at'] !== null && (int)$row['expires_at'] < hub_now()) return null;
    return $row;
}

function hub_notify_discord(string $message): void {
    if (HUB_DISCORD_WEBHOOK === '' || !preg_match('#^https?://#', HUB_DISCORD_WEBHOOK)) return;
    $payload = json_encode([
        'username' => HUB_BRAND_NAME . ' Hub',
        'embeds' => [[
            'description' => $message,
            'color' => 16753920,
        ]],
    ]);
    $ch = curl_init(HUB_DISCORD_WEBHOOK);
    curl_setopt_array($ch, [
        CURLOPT_POST => true,
        CURLOPT_POSTFIELDS => $payload,
        CURLOPT_HTTPHEADER => ['Content-Type: application/json'],
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT => 5,
    ]);
    curl_exec($ch);
    curl_close($ch);
}
