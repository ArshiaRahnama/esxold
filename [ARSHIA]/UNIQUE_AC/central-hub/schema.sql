-- UNIQUE_AC Central Hub — SQLite schema
-- Run once: sqlite3 hub.db < schema.sql

CREATE TABLE IF NOT EXISTS license_keys (
    key_value    TEXT PRIMARY KEY,
    owner_name   TEXT NOT NULL,
    note         TEXT DEFAULT '',
    max_servers  INTEGER NOT NULL DEFAULT 1,
    expires_at   INTEGER,              -- unix timestamp, NULL = never expires
    active       INTEGER NOT NULL DEFAULT 1,
    created_at   INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS servers (
    id                 INTEGER PRIMARY KEY AUTOINCREMENT,
    license_key        TEXT NOT NULL,
    server_name        TEXT NOT NULL DEFAULT 'Unnamed Server',
    version            TEXT DEFAULT '',
    player_count       INTEGER DEFAULT 0,
    max_players        INTEGER DEFAULT 0,
    quarantine_count   INTEGER DEFAULT 0,
    appeal_count       INTEGER DEFAULT 0,
    ban_count_total    INTEGER DEFAULT 0,
    last_heartbeat_at  INTEGER DEFAULT 0,
    last_status        TEXT NOT NULL DEFAULT 'online',
    created_at         INTEGER NOT NULL,
    UNIQUE(license_key, server_name)
);

CREATE TABLE IF NOT EXISTS urgent_events (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    license_key  TEXT NOT NULL,
    server_name  TEXT NOT NULL DEFAULT 'Unnamed Server',
    kind         TEXT NOT NULL,        -- e.g. 'quarantine', 'offline_recovered'
    message      TEXT NOT NULL,
    created_at   INTEGER NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_servers_license ON servers(license_key);
CREATE INDEX IF NOT EXISTS idx_urgent_created ON urgent_events(created_at);
