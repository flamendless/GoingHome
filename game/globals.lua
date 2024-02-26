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
	"toy",  --where to get the air pumper
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
GHOST_EVENT = ""
GHOST_CHASE = false
TEMP_CLOCK_GUN = -1
ENDING_LEAVE = false
PUSHING_ANIM = false
ENDING_ANIMATE = false


ITEMS_LIST = {}
DIALOGUES = {}
RL = {}
LL = {}
PUZZLE_PICS = {}
ITEMS_PROPERTIES = {
	dynamic = {
		"portraits",
		"head",
		"stand",
		"ball",
		"cabinet",
		"toy",
		"refrigerator",
		"hoop",
		"hole",
		"master bed",
		"sink",
		"safe vault",
		"tv",
		"open_vault",
		"rope",
		"chest",
		"clock",
		"chair_final",
		"chest2",
		--gun parts
		"shelf",
		"candles left",
		"candles right",
		"trash bin",
		"secret drawer",
		"storage puzzle",
		"crib",
		"kitchen table",
		"battery",
		"ammo",
		"revolver2",
		"note"
	},
	static = {
		"shoerack",
		"shelf",
		"portraits",
		"displays",
		"landscape",
		"head",
		"stand",
		"bench",
		"ball",
		"candles left",
		"candles right",
		"abstract",
		"surreal",
		"cabinet",
		"crib",
		"toy",
		"kitchen table",
		"refrigerator",
		"trash bin",
		"sink",
		"hole",
		"storage",
		"toolbox",
		"store_bench",
		"hoop",
		"hoop_ball",
		"master bed",
		"tv",
		"safe vault",
		"rope",
		"open_vault",
		"open_vault2",
		"ladder",
		"corpse",
		"attic_ladder",
		"chest",
		"clock",
		"chair",
		"chest2",
		"secret drawer",
		"storage puzzle",
		"battery",
		"ammo",
	}
}
if ON_MOBILE then
	for n, m in pairs(ITEMS_PROPERTIES.dynamic) do
		if m == "battery" then
			table.remove(ITEMS_PROPERTIES.dynamic, n)
		end
	end
end
