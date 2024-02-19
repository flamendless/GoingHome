Player = require("player")
Fade = require("fade")
Enemy = require("enemy")
Chair = require("chair")

Pause = require("pause")
Items = require("items")
Interact = require("interact")
SaveData = require("save_data")
ClockPuzzle = require("clock_puzzle")

Gallery = require("gallery")

require("gameStates")
Assets = require("assets")


require("rain_intro_scenes")
GameOver = require("game_over")
require("animation")
require("secret_room")
require("attic_room")
require("particles")
require("rightroom")
require("leftroom")
require("storagePuzzle")
require("leave_event")
require("credits_scene")

SPLASH_FINISHED = false

USER_INPUT = ""

function Set(list)
	local set = {}
	for _, l in ipairs(list) do set[l] = true end
	return set
end

OBTAINABLES = Set({
	"cabinet", --where to get the toy hammer
	"toy", --where to get the air pumper
	"ball", --interacts with the hoop
	"hole", -- switch inside the holes
	"head_key",
	"kitchen key",
	"crowbar",
	"rope",
	"chest",
	"clock",
	"chair",
	"crowbar2",
	--gun parts
	"gun1",
	"gun2",
	"gun3",
	"match",
	"revolver",
	"gotBall"
})

LOCKED = Set {
	"mainRoom_right",
	"livingRoom_mid",
	"masterRoom_mid"
}

MOVE = false
LIGHT_VALUE = 100
LIGHT_BLINK = true
LIGHT_ON = false
BLINK = false
WIN_MOVE_L = true
WIN_MOVE_R = true
ENEMY_EXISTS = false
SEEN = false
GAMEOVER = false

PLAYER = Player(0, 0, 8, 16)
GHOST = Enemy(42, 30, 12, 14)
MRCHAIR = Chair()
