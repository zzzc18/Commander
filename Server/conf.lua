function love.conf(this)
    -- this.window.width = 1920
    -- this.window.height = 1012
    -- this.window.setMode({ resizable = true })
    this.window.resizable = true
    this.modules.joystick = false
    this.modules.physics = false
    this.window.title = "Server"
    this.window.icon = "data/Picture/Logo.png"
end
