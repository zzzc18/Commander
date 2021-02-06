Switcher = {}
local canchange={}
local target={['1']=1,['2']=2}
local now=1

function Switcher.Init()
    for i = 1, SceneNum do
        canchange[i]={}
        for j = 1, SceneNum do
            canchange[i][j]=0
        end
    end
    canchange[1][2]=1
    canchange[2][1]=1
end

function Switcher.keypressed(key)
    print(now)
    print(target[key])
    print(canchange[now][target[key]])
    if target[key]~=nil and canchange[now][target[key]]~=0 then
        print("what")
        now=target[key]
        Switcher.To(Scene[target[key]])
    end
end

function Switcher.To(newState)
    print("switch")
    Running.DeInit()
    Running = newState
    Running.Init()
end

return Switcher
