-- ============================================================
-- esx_inventoryhud / server / job.lua
--
-- Backs modules/job/client/main.lua exactly as written (not
-- modified). Permission checks (who can access which items) are
-- handled entirely by that module via the pre-existing external
-- 'esx_society:getInventoryPermission' callback -- this file only
-- persists the stash contents, keyed by job name.
-- ============================================================

if ESX == nil then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    while ESX == nil do
        Citizen.Wait(0)
    end
end

CreateThread(function()
    exports.oxmysql:execute([[
        CREATE TABLE IF NOT EXISTS `job_inventories` (
            `job_name` VARCHAR(64) NOT NULL PRIMARY KEY,
            `items` LONGTEXT NOT NULL DEFAULT ('[]'),
            `weapons` LONGTEXT NOT NULL DEFAULT ('[]'),
            `slots` INT NOT NULL DEFAULT 50
        )
    ]], {})
end)

local function loadJob(jobName, cb)
    exports.oxmysql:fetch('SELECT items, weapons, slots FROM job_inventories WHERE job_name = @job', {
        ['@job'] = jobName
    }, function(result)
        if result and result[1] then
            local ok1, items = pcall(json.decode, result[1].items or '[]')
            local ok2, weapons = pcall(json.decode, result[1].weapons or '[]')
            cb(ok1 and items or {}, ok2 and weapons or {}, result[1].slots or 50)
        else
            exports.oxmysql:execute('INSERT INTO job_inventories (job_name, items, weapons, slots) VALUES (@job, @items, @weapons, @slots)', {
                ['@job'] = jobName,
                ['@items'] = '[]',
                ['@weapons'] = '[]',
                ['@slots'] = 50
            })
            cb({}, {}, 50)
        end
    end)
end

local function saveJob(jobName, items, weapons)
    exports.oxmysql:execute('UPDATE job_inventories SET items = @items, weapons = @weapons WHERE job_name = @job', {
        ['@job'] = jobName,
        ['@items'] = json.encode(items),
        ['@weapons'] = json.encode(weapons)
    })
end

ESX.RegisterServerCallback('inventory-job:getInventory', function(source, cb, jobName)
    loadJob(jobName, function(items, weapons, slots)
        cb({ items = items, weapons = weapons, slots = slots })
    end)
end)

RegisterServerEvent('inventory-job:updateSlot')
AddEventHandler('inventory-job:updateSlot', function(jobName, data)
    if not data or not data.name then return end
    loadJob(jobName, function(items, weapons)
        local list = data.ammo ~= nil and weapons or items
        for _, entry in ipairs(list) do
            if entry.name == data.name then
                entry.slot = data.droppedTo or data.slot
            end
        end
        saveJob(jobName, items, weapons)
    end)
end)

RegisterServerEvent('inventory-job:put')
AddEventHandler('inventory-job:put', function(jobName, data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or not data or not data.name then return end

    loadJob(jobName, function(items, weapons)
        if data.ammo ~= nil then
            local weapon = xPlayer.getWeapon(data.name)
            if not weapon then return end
            xPlayer.removeWeapon(data.name)
            table.insert(weapons, { name = data.name, ammo = weapon.ammo or 0, slot = data.droppedTo })
        else
            local item = xPlayer.getInventoryItem(data.name)
            local count = math.min(data.count or 1, item and item.count or 0)
            if count < 1 then return end
            xPlayer.removeInventoryItem(data.name, count)

            local found = false
            for _, entry in ipairs(items) do
                if entry.name == data.name then
                    entry.count = entry.count + count
                    found = true
                    break
                end
            end
            if not found then
                table.insert(items, { name = data.name, count = count, slot = data.droppedTo })
            end
        end
        saveJob(jobName, items, weapons)
    end)
end)

RegisterServerEvent('inventory-job:get')
AddEventHandler('inventory-job:get', function(jobName, data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or not data or not data.name then return end

    loadJob(jobName, function(items, weapons)
        if data.ammo ~= nil then
            for i, entry in ipairs(weapons) do
                if entry.name == data.name then
                    table.remove(weapons, i)
                    saveJob(jobName, items, weapons)
                    xPlayer.addWeapon(entry.name, entry.ammo or 0)
                    return
                end
            end
        else
            for i, entry in ipairs(items) do
                if entry.name == data.name then
                    local count = math.min(data.count or entry.count, entry.count)
                    if count < 1 then return end
                    if not xPlayer.canCarryItem(data.name, count) then
                        TriggerClientEvent('esx:showNotification', src, 'Vazn Zaiad Ast !')
                        return
                    end
                    entry.count = entry.count - count
                    if entry.count <= 0 then
                        table.remove(items, i)
                    end
                    saveJob(jobName, items, weapons)
                    xPlayer.addInventoryItem(data.name, count)
                    return
                end
            end
        end
    end)
end)
