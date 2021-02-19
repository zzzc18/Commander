-- Core 和 Operation 不同，虽然也是具体的操作，比如移动
-- Operation 采集鼠标信息，转化为指令，发送给服务端
-- Core 则将指令具体执行
local Core = {}

--此函数在ClientSock中被调用以添加移动命令，流程图中将忽略了这一中转过程
function Core.PushMove(data)
    -- local str = string.format("%d, (%d, %d) -> (%d, %d)\n", data.armyID, data.srcX, data.srcY, data.dstX, data.dstY)
    -- print(str)
    CGameMap.PushMove(data.armyID, data.srcX, data.srcY, data.dstX, data.dstY)
end

return Core
