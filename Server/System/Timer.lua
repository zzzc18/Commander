Timer = {}

Timer.begin = false
Timer.total = 0
Timer.stepLength = 1.5
Timer.stepHalf = 0
Timer.step = 0
Timer.step25 = 0

function Timer.Begin()
    Timer.begin = true
end

function Timer.Update(dt)
    if not Timer.begin then
        return
    end
    Timer.total = Timer.total + dt
    Timer.stepHalf = Timer.stepHalf + dt
    Timer.step = Timer.step + dt
    Timer.step25 = Timer.step25 + dt

    if Timer.stepHalf >= Timer.stepLength / 2 then
        Timer.stepHalf = Timer.stepHalf - Timer.stepLength / 2
        ServerSock.SendGameMapMoveUpdate()
    end
    if Timer.step >= Timer.stepLength then
        Timer.step = Timer.step - Timer.stepLength
        ServerSock.SendGameMapUpdate()
    end
    if Timer.step25 >= Timer.stepLength * 25 then
        Timer.step25 = Timer.step25 - Timer.stepLength * 25
        ServerSock.SendGameMapBigUpdate()
    end
end

return Timer
