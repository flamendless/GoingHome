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

	--console
	--io.stdout:setvbuf("no")

	lovedebug = debug
	debug = false
	debugMode = false
	gameplay_record = false
	cheat = false
	pro_version = true
	apple_ver = false
end
