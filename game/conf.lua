function love.conf(t)
	t.releases = {
		title = "Going Home: Revisited",
		author = "Brandon Blanker Lim-it",
		email = "flamendless8@gmail.com",
		homepage = "http://flamendless.github.com/brbl",
		description = "A Pixelated Survival Horror Game",
		version = "2.0.0"
	}
	t.window.width = 1024
	t.window.height = 512
	t.window.resizable = false
	t.window.title = "Going Home: Revisited"
	t.externalstorage = true
	t.version = "11.4"
	t.window.icon = "assets/icon.png"
	t.identity = "GoingHomeRevisited"

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

	lovedebug = debug
	debug = false
	debugMode = false
	gameplay_record = false
	cheat = false
	pro_version = true
	apple_ver = false
	shaders_test = true
end
