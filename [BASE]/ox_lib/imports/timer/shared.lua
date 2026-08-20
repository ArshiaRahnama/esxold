

local timer = lib.class('OxTimer')

function timer:constructor(time, onEnd, async)
    assert(type(time) == "number" and time > 0, "Time must be a positive number")
    assert(onEnd == nil or type(onEnd) == "function", "onEnd must be a function or nil")
    assert(type(async) == "boolean" or async == nil, "async must be a boolean or nil")

    self.onEnd = onEnd
    self.private.initialTime = time
    self.private.currentTimeLeft = time
    self.private.startTime = 0
    self.private.paused = false
    self.private.triggerOnEnd = true

    self:start(async)
end

function timer:run()
    while self:isPaused() or self:getTimeLeft('ms') > 0 do
        Wait(0)
    end

    if self.private.triggerOnEnd then
        self:onEnd()
    end

    self.private.triggerOnEnd = true
end

function timer:start(async)
    if self.private.startTime > 0 then error('Cannot start a timer that is already running') end

    self.private.startTime = GetGameTimer()

    if not async then return self:run() end

    Citizen.CreateThreadNow(function()
        self:run()
    end)
end

function timer:forceEnd(triggerOnEnd)
    if self:getTimeLeft('ms') <= 0 then return end

    self.private.paused = false
    self.private.currentTimeLeft = 0
    self.private.triggerOnEnd = triggerOnEnd

    Wait(0)
end

function timer:pause()
    if self.private.paused then return end

    self.private.currentTimeLeft = self:getTimeLeft('ms')
    self.private.paused = true
end

function timer:play()
    if not self.private.paused then return end
    self.private.startTime = GetGameTimer()
    self.private.paused = false
end

function timer:isPaused()
    return self.private.paused
end

function timer:restart(async)
    self:forceEnd(false)
    Wait(0)
    self.private.currentTimeLeft = self.private.initialTime
    self.private.startTime = 0
    self:start(async)
end

function timer:getTimeLeft(format)
    local ms = self.private.currentTimeLeft - (GetGameTimer() - self.private.startTime)

    local roundedfloat = function(value)
        return tonumber(string.format('%.2f', value))
    end

    if format == 'ms' then
        return roundedfloat(ms)
    end

    local s = ms / 1000

    if format == 's' then
        return roundedfloat(s)
    end

    local m = s / 60

    if format == 'm' then
        return roundedfloat(m)
    end

    local h = m / 60

    if format == 'h' then
        return roundedfloat(h)
    end

    return {
        ms = roundedfloat(ms),
        s = roundedfloat(s),
        m = roundedfloat(m),
        h = roundedfloat(h)
    }
end

function lib.timer(time, onEnd, async)
    return timer:new(time, onEnd, async)
end

return lib.timer
