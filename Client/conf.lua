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
end
