-- Core 和 Operation 不同，虽然也是具体的操作，比如移动
-- Operation 采集鼠标信息，转化为指令，发送给服务端
-- Core 则将指令具体执行
Core = {}

function Core.PushMove(data)
    -- local str = string.format("%d, (%d, %d) -> (%d, %d)\n", data.armyID, data.srcX, data.srcY, data.dstX, data.dstY)
    -- print(str)
    CLib.GameMapPushMove(
        data.armyID,
        data.srcX,
        data.srcY,
        data.dstX,
        data.dstY
    )
end

return Core
