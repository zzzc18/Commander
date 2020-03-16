MyColor = {}

function MyColor.Purple()
    return 0.5, 0.2, 1
end

function MyColor.Red()
    return 1, 0, 0
end

function MyColor.Blue()
    return 0, 0, 1
end

function MyColor.Orange()
    return 1, 0.6470588235294118, 0
end

function MyColor.Green()
    return 0, 1, 0
end

function MyColor.DarkGreen()
    return MyColor.convert255(0, 115, 0)
end

function MyColor.Cyan()
    return 0, 1, 1
end

function MyColor.White()
    return 1, 1, 1
end

function MyColor.WhiteWithA(k)
    local rgba = {}
    rgba[1], rgba[2], rgba[3] = MyColor.White()
    rgba[4] = k
    return rgba
end

function MyColor.Black()
    return 0, 0, 0
end

function MyColor.BlackWithA(k)
    local rgba = {}
    rgba[1], rgba[2], rgba[3] = MyColor.Black()
    rgba[4] = k
    return rgba
end

function MyColor.Gray()
    return MyColor.convert255(192, 192, 192)
end

function MyColor.Army(k)
    if k == 0 then
        return MyColor.Orange()
    end
    if k == 1 then
        return MyColor.DarkGreen()
    end
    if k == 2 then
        return MyColor.Cyan()
    end
end

function MyColor.ArmyWithA(armyID, k)
    local rgba = {}
    rgba[1], rgba[2], rgba[3] = MyColor.Army(armyID)
    rgba[4] = k
    return rgba
end

function MyColor.ArmyPath(k)
    local rgba = {}
    if k == 0 then
        rgba[1], rgba[2], rgba[3] = MyColor.Orange()
    end
    if k == 1 then
        rgba[1], rgba[2], rgba[3] = MyColor.DarkGreen()
    end
    if k == 2 then
        rgba[1], rgba[2], rgba[3] = MyColor.Cyan()
    end
    rgba[4] = 0.5
    return rgba
end

function MyColor.Yellow(k)
    if k == 1 then
        return 0.9607843137254902, 0.8705882352941177, 0.7019607843137254
    end
    if k == 2 then
        return 0.7803921568627451, 0.3803921568627451, 0.0784313725490196
    end
    if k == 3 then
        return 0.5450980392156862, 0.27058823529411763, 0.07450980392156863
    end
    if k >= 4 then
        return 0.6078431372549019, 0.1843137254901961, 0.07058823529411765
    end
end

function MyColor.Weapon(k)
    if k == 1 then
        return MyColor.Purple()
    end
    if k == 2 then
        return MyColor.Blue()
    end
end

function MyColor.BackGround()
    return MyColor.Yellow(1)
end

function MyColor.Error()
    local rgba = {}
    rgba[1], rgba[2], rgba[3] = MyColor.Red()
    rgba[4] = 0.5
    return rgba
end

function MyColor.SideBar()
    local rgba = {}
    rgba[1], rgba[2], rgba[3] = MyColor.White()
    rgba[4] = 0.7
    return rgba
end

function MyColor.Win(k)
    local rgba = {}
    rgba[1], rgba[2], rgba[3] = MyColor.Red()
    rgba[4] = k
    return rgba
end

function MyColor.Lose(k)
    local rgba = {}
    rgba[1], rgba[2], rgba[3] = MyColor.Black()
    rgba[4] = k
    return rgba
end

function MyColor.Default()
    local rgba = {}
    rgba[1], rgba[2], rgba[3] = MyColor.Purple()
    rgba[4] = 0.7
    return rgba
end

function MyColor.convert255(arg1, arg2, arg3)
    return arg1 / 255, arg2 / 255, arg3 / 255
end

MyColor.heightTable = {
    {L = 0, R = 49},
    {L = 50, R = 99},
    {L = 100, R = 149},
    {L = 150, R = 200}
}

return MyColor
