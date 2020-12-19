Timer = {}

Timer.begin = false
Timer.total = 0
Timer.MinStepLength = 0.5
 --每发送一步所需时间

function Timer.Begin()
    Timer.begin = true
end

function Timer.Update(dt)
    if not Timer.begin then
        return
    end
    Timer.total = Timer.total + dt

    if Timer.total >= Timer.MinStepLength then
        Timer.total = Timer.total - Timer.MinStepLength
        ServerSock.SendUpdate()
    end
end

return Timer
