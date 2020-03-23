Timer = {}

Timer.begin = false
Timer.total = 0
Timer.second = 0
Timer.second25 = 0

function Timer.Begin()
    Timer.begin = true
end

function Timer.Update(dt)
    if not Timer.begin then
        return
    end
    Timer.total = Timer.total + dt
    Timer.second = Timer.second + dt
    Timer.second25 = Timer.second25 + dt
end

return Timer
