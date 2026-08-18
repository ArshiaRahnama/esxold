fx_version 'bodacious'
game 'gta5'

author 'Unique LOGIN - arshiahub.ir'
description 'Unique_Login - Steam-optional connect login (username/password + SMS OTP) via deferrals'
version '1.0.0'

server_scripts {
    -- FIX: the original file pointed at '@mysql-async/lib/MySQL.lua', but
    -- this server only ever ensures 'oxmysql' (see server.cfg) — the
    -- mysql-async resource isn't installed at all, so the resource would
    -- have failed to start outright. oxmysql ships the same MySQL.Async /
    -- MySQL.Sync compatibility API, so this one-line swap is all that's
    -- needed — no query in server.lua had to change.
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server.lua',
}
