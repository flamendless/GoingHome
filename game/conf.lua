function love.conf(t)
	t.window.width = 1024
	t.window.height = 512
	t.window.resizable = false
	t.window.title = "Going Home: Revisited"
	t.window.icon = "assets/icon.png"
	t.window.fullscreen = true

	t.version = "11.5"
	t.identity = "GoingHomeRevisited"
	t.externalstorage = true

	t.accelerometerjoystick = false
	t.modules.data = true
	t.modules.event = true
	t.modules.font = true
	t.modules.graphics = true
	t.modules.image = true
	t.modules.keyboard = true
	t.modules.math = true
	t.modules.mouse = true
	t.modules.system = true
	t.modules.timer = true
	t.modules.window = true
	t.modules.audio = true
	t.modules.joystick = false
	t.modules.sound = true
	t.modules.thread = true
	t.modules.touch = true
	t.modules.video = false
	t.modules.physics = false

	--console
	--io.stdout:setvbuf("no")
end
