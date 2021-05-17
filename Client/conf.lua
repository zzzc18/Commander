function love.conf(this)
    this.window.width = 1080
    this.window.height = 720
    -- this.window.setMode({ resizable = true })
    this.window.minwidth = 720
    this.window.minheight = 480
    this.window.resizable = true
    this.modules.joystick = false
    this.modules.physics = false
    this.window.title = "Client"
    this.window.icon = "data/Picture/Logo.png"
    Visable = true -- 设置图形化窗口的可见性，当为True启动将显示图形化窗口并进入Welcome;当为false时启动不显示图形化窗口且直接进入PlayGame.
    if Visable then
        this.modules.window = true
    else
        this.modules.window = false
    end
end
