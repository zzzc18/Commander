--此模块用于将程序运行过程中的日志信息写入.log文件
Debug = {}

function Debug.Init()
    CVerify.InitDebugLog()
    Debug.Log("info", "init Debug")
end

--添加一条日志，同时在控制台输出日志内容
--priority:日志类型，可以是info,warning或error
--text:日志信息
function Debug.Log(priority, text)
    print("[" .. priority .. "] " .. text)
    CVerify.Log(priority, text)
end
