Color = {}

function Color.Purple()
    return 0.5, 0.2, 1
end

function Color.Red()
    return 1, 0, 0
end

function Color.Blue()
    return 0, 0, 1
end

function Color.Orange()
    return 1, 0.6470588235294118, 0
end

function Color.Green()
    return 0, 1, 0
end

function Color.DarkGreen()
    return Color.convert255(0, 115, 0)
end

function Color.Cyan()
    return 0, 1, 1
end

function Color.White()
    return 1, 1, 1
end

function Color.WhiteWithA(k)
    local rgba = {}
    rgba[1], rgba[2], rgba[3] = Color.White()
    rgba[4] = k
    return rgba[1], rgba[2], rgba[3], rgba[4]
end

function Color.Black()
    return 0, 0, 0
end

function Color.BlackWithA(k)
    local rgba = {}
    rgba[1], rgba[2], rgba[3] = Color.Black()
    rgba[4] = k
    return rgba[1], rgba[2], rgba[3], rgba[4]
end

function Color.Gray()
    return Color.convert255(192, 192, 192)
end

function Color.Army(k)
    local colorName
    if k == 0 then
        colorName = "White"
    end
    if k == 1 then
        colorName = "DarkGreen"
    end
    if k == 2 then
        colorName = "Cyan"
    end
    if k == 4 then
        colorName = "Purple"
    end
    if k == 5 then
        colorName = "Orange"
    end
    return Color.GetColor(colorName, 0.5)
end

function Color.GetColor(colorName, alpha)
    if alpha == nil then
        alpha = 1
    end
    local r, g, b = Color[colorName]()
    return r, g, b, alpha
end

function Color.convert255(arg1, arg2, arg3)
    return arg1 / 255, arg2 / 255, arg3 / 255
end

return Color
