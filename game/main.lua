--project by Brandon Blanker Lim-it
--@flamendless
--@flam8studio

local VERSION = "v1.0.22"
PRO_VERSION = false
DEBUGGING = true

love.graphics.setDefaultFilter("nearest", "nearest", 1)
local img_loading = love.graphics.newImage("assets/loading.png")
local lsw, lsh = img_loading:getDimensions()

local cursor = love.mouse.newCursor("assets/cursor.png")
love.mouse.setCursor(cursor)

local URLS = require("urls")
local Shaders = require("shaders")

JSON = require("libs.json.json")
LOADER = require("libs.love-loader")
Inspect = require("libs.inspect.inspect")
Lume = require("libs.lume")
-- pause = require("pause")
Anim8 = require("libs.anim8")
Timer = require("libs.knife.timer")
Object = require("libs.classic")
Player = require("player")
Fade = require("fade")
Enemy = require("enemy")
Chair = require("chair")

Items = require("items")
Interact = require("interact")
SaveData = require("save_data")

OS = love.system.getOS()
ON_MOBILE = (OS == "Android") or (OS == "iOS")
if ON_MOBILE then
	Android = require("gui")
	LoveAdmob = require("love_admob")
	LoveAdmob.debugging = DEBUGGING

	if PRO_VERSION then
		VERSION = VERSION .. "-android-pro"
	else
		VERSION = VERSION .. "-android"
	end

	AdMobKeys = require("admob_keys")
	AdMobKeys.test = DEBUGGING
end
--require("error")

Gallery = require("gallery")

require("gameStates")
Assets = require("assets")

DEF_FONT = love.graphics.newFont("assets/Jamboree.ttf", 8)
DEF_FONT:setFilter("nearest", "nearest", 1)
DEF_FONT_HEIGHT = DEF_FONT:getHeight()
DEF_FONT_HALF = DEF_FONT_HEIGHT / 2

Images = {}
Sounds = {}
FINISHED_LOADING = false
SCENE = {}

-- p_anim, animation = {}

require("rain_intro_scenes")
require("game_over")
require("animation")
require("secret_room")
require("attic_room")
require("particles")
require("rightroom")
require("leftroom")
require("storagePuzzle")
require("leave_event")
require("credits_scene")

HumpTimer = require("libs.hump.timer")
SPLASH_FINISHED = false

local utf8 = require("utf8")
USER_INPUT = ""
CORRECT = "mom fell his fault"

love.keyboard.setTextInput(false)
WIDTH, HEIGHT = 128, 64
HEIGHT_HALF = HEIGHT / 2
SW, SH = love.window.getDesktopDimensions()
INTERACT = false
TY = 0

-- local recording = false

FC = require("libs.firstcrush.gui")

MAIN_CANVAS = love.graphics.newCanvas(love.graphics.getDimensions())

local function toggle_fs()
	love.window.setFullscreen(not love.window.getFullscreen())
	local sWidth, sHeight = love.graphics.getDimensions()
	RATIO = math.min(sWidth / WIDTH, sHeight / HEIGHT)
	MAIN_CANVAS = love.graphics.newCanvas(love.graphics.getDimensions())
end

if DEBUGGING == false then
	if not ON_MOBILE then
		toggle_fs()
	end

	TY = 0
	-- ty = sh - (height * math.min(sw/width,sh/height))
	if OS == "iOS" then
		if PRO_VERSION then
			--ty = sh - (height * math.min(sw/width,sh/height))
			TY = HEIGHT_HALF
		end
	end
	if ON_MOBILE then
		if PRO_VERSION then
			TY = HEIGHT
		else
			TY = SH - (HEIGHT * math.min(SW / WIDTH, SH / HEIGHT))
		end
	end
end

if gameplay_record then
	love.mouse.setVisible(false)
end

-- pauseFlag = false
TEMP_MOVE = false

if ON_MOBILE and not PRO_VERSION then
	function LoadAds()
		print("Loading ads...")
		if FC:validate() ~= "accept" then return end
		LoveAdmob.createBanner(AdMobKeys.ids.banner, "bottom")
		LoveAdmob.requestInterstitial(AdMobKeys.ids.inter)
		print("Loading success")
	end

	function ShowBannerAds()
		if math.floor(CLOCK) % 5 ~= 0 then return end
		LoveAdmob.showBanner()
	end

	function ShowInterstitialAds()
		if math.floor(CLOCK) % 3 ~= 0 then return end
		if FC:validate() ~= "accept" then return end
		if LoveAdmob.isInterstitialLoaded() then
			LoveAdmob.showInterstitial()
		end
	end
end

function love.load()
	print("VERSION:", VERSION)
	SaveData.load()

	if PRO_VERSION then
		STATES = "splash"
	else
		STATES = "adshow"
	end

	CLOCK = 0 --game timer

	local sWidth, sHeight = love.graphics.getDimensions()
	RATIO = math.min(sWidth / WIDTH, sHeight / HEIGHT)
	PRESSED = false
	love.keyboard.setKeyRepeat(true)

	gamestates.load()

	--canvas
	CANVAS_CUSTOM_MASK = love.graphics.newCanvas()
	love.graphics.setCanvas(CANVAS_CUSTOM_MASK)
	love.graphics.clear(0, 0, 0)
	love.graphics.setCanvas()

	--tv_flash
	CANVAS_TV_FLASH = love.graphics.newCanvas()
	love.graphics.setCanvas(CANVAS_TV_FLASH)
	love.graphics.clear(0, 0, 0)
	love.graphics.setCanvas()

	--candles
	CANVAS_CANDLES_FLASH = love.graphics.newCanvas()
	love.graphics.setCanvas(CANVAS_CANDLES_FLASH)
	love.graphics.clear(0, 0, 0)
	love.graphics.setCanvas()

	--right room
	CANVAS_RIGHT = love.graphics.newCanvas()
	love.graphics.setCanvas(CANVAS_RIGHT)
	love.graphics.clear(0, 0, 0)
	love.graphics.setCanvas()

	--left room
	CANVAS_LEFT = love.graphics.newCanvas()
	love.graphics.setCanvas(CANVAS_LEFT)
	love.graphics.clear(0, 0, 0)
	love.graphics.setCanvas()

	--dust
	-- dust = love.graphics.newCanvas()

	--set variables
	BLINK = false
	--windows animation var
	WIN_MOVE_L = true
	WIN_MOVE_R = true

	LIGHT_VALUE = 100 --starting light value
	LIGHT_BLINK = true
	LIGHT_ON = false
end

function love.update(dt)
	-- if recording then return end
	CLOCK = CLOCK + dt
	if not FINISHED_LOADING then
		LOADER.update()
	else
		-- if shaders_test or enemy_exists then
		-- 	Shaders.update(Shaders.palette_swap)
		-- end

		if ON_MOBILE and LoveAdmob then
			LoveAdmob.update(dt)
		end

		if FC:getState() then
			FC:update(dt)
		else
			local state = gamestates.getState()
			if state == "main" then
				if SaveData.data.hide_cursor then
					love.mouse.setVisible(false)
				else
					love.mouse.setVisible(true)
				end
			end

			gamestates.update(dt)
			if ON_MOBILE then
				Android.update(dt)
			end
		end
	end
end

function love.draw()
	love.graphics.setCanvas(MAIN_CANVAS)
	love.graphics.clear()
	love.graphics.push()
	-- if ON_MOBILE then
	-- 	love.graphics.translate(0, TY)
	-- end

	love.graphics.scale(RATIO, RATIO)
	if FINISHED_LOADING then
		-- if shaders_test or enemy_exists then
		-- 	love.graphics.setShader(Shaders.palette_swap)
		-- end

		-- if pauseFlag == false then
		gamestates.draw()
		-- elseif pauseFlag == true then
		-- 	pause.draw()
		-- end

		love.graphics.setShader()

		if FC:getState() then FC:draw() end
	else
		local percent = 0
		if LOADER.resourceCount ~= 0 then
			percent = LOADER.loadedCount / LOADER.resourceCount
		end
		love.graphics.setColor(1, 1, 1, 150 / 255)
		love.graphics.setFont(DEF_FONT)
		local str_loading = ("Loading..%d%%"):format(percent * 100)
		love.graphics.print(str_loading, WIDTH / 2 - DEF_FONT:getWidth(str_loading) / 2, HEIGHT - DEF_FONT_HEIGHT)

		local scale = 0.4
		love.graphics.draw(img_loading, WIDTH / 2, HEIGHT_HALF, 0, scale, scale, lsw / 2, lsh / 2)
	end
	love.graphics.pop()

	if DEBUGGING then
		love.graphics.push()
			love.graphics.scale(RATIO / 2, RATIO / 2)
			love.graphics.setColor(1, 0, 0, 1)
			love.graphics.setFont(DEF_FONT)
			love.graphics.print(VERSION, 8, 8)
			love.graphics.print(gamestates.getState(), 8, 16)
			love.graphics.print(tostring(CLOCK), 8, 24)
		love.graphics.pop()
	end

	love.graphics.setCanvas()

	love.graphics.setColor(1, 1, 1, 1)
	if not ending_leave and SaveData.data.use_grayscale then
		love.graphics.setShader(Shaders.grayscale)
	end
	love.graphics.draw(MAIN_CANVAS)
	love.graphics.setShader()
end

function love.mousereleased(x, y, button, istouch)
	if not FINISHED_LOADING then return end
	local state = gamestates.getState()
	local mx = (x) / RATIO
	local my = (y - TY) / RATIO
	if state == "intro" or state == "rain_intro" then
		if PRESSED == true then
			PRESSED = false
		end
	end
end

function love.mousepressed(x, y, button, istouch)
	FC:mousepressed(x, y, button, istouch)
	if not FINISHED_LOADING then return end
	local state = gamestates.getState()
	local mx = (x) / RATIO
	local my = (y - TY) / RATIO
	--android.mouse_gui(x,y,button,istouch)
	if state == "gallery" then
		if Gallery.mouse(mx, my, gExit) then
			love.keypressed("escape")
		end
	elseif state == "title" then
		if button == 1 then
			if instruction == false and about == false and questions == false then
				if check_gui(gui_pos.start_x, gui_pos.start_y, gui_pos.start_w, gui_pos.start_h) then
					--start
					gamestates.control()
				elseif check_gui(gui_pos.quit_x, gui_pos.quit_y, gui_pos.quit_w, gui_pos.quit_h) then
					--exit
					if OS ~= "iOS" then
						love.event.quit()
					end
				elseif check_gui(gui_pos.webx, gui_pos.weby, gui_pos.webw, gui_pos.webh) then
					if ON_MOBILE then
						if LoveAdmob.isInterstitialLoaded() == true then
							LoveAdmob.showInterstitial()
						end
					else
						love.system.openURL(URLS.game_page)
					end
				end
			end

			if instruction or about or questions or options then
				if check_gui(gui_pos.b_x, gui_pos.b_y, gui_pos.b_w, gui_pos.b_h) then
					if options then
						SaveData.save()
					end

					instruction = false
					about = false
					questions = false
					options = false
				end
			end

			if check_gui(gui_pos.g_x, gui_pos.g_y, gui_pos.g_w, gui_pos.g_h) then
				gamestates.nextState("gallery")
			end

			if check_gui(gui_pos.options_x, gui_pos.options_y, gui_pos.options_w, gui_pos.options_h) then
				options = not options
			end

			if options and button == 1 then
				local base_y = 1 + DEF_FONT_HEIGHT
				local rw = 8
				for i, item in ipairs(SaveData.get_opts()) do
					local str, value = item.str, item.value
					local y = base_y + DEF_FONT_HEIGHT * (i - 1)
					local rx = WIDTH - 16 - rw / 2
					local ry = y + rw / 4

					if check_gui(16, y, DEF_FONT:getWidth(str), DEF_FONT_HEIGHT) or
						check_gui(rx, ry, rw, rw)
					then
						SaveData.toggle_opts(i)
					end
				end
			end

			if check_gui(gui_pos.q_x, gui_pos.q_y, gui_pos.q_w, gui_pos.q_h) then
				questions = not questions
			end

			if questions then
				if check_gui(gui_pos.t_x, gui_pos.t_y, gui_pos.t_w, gui_pos.t_h) then
					love.system.openURL(URLS.twitter)
				elseif check_gui(gui_pos.p_x, gui_pos.p_y, gui_pos.p_w, gui_pos.p_h) then
					if OS ~= "iOS" then
						love.system.openURL(URLS.paypal)
					end
				elseif check_gui(gui_pos.e_x, gui_pos.e_y, gui_pos.e_w, gui_pos.e_h) then
					love.system.openURL(URLS.mailto)
				end
			end

			if check_gui(gui_pos.a_x, gui_pos.a_y, gui_pos.a_w, gui_pos.a_h) then
				about = not about
			end

			if check_gui(gui_pos.i_x, gui_pos.i_y, gui_pos.i_w, gui_pos.i_h) then
				instruction = not instruction
			end
		end
	elseif state == "rain_intro" then
		if check_gui(gui_pos.skip_x, gui_pos.skip_y, gui_pos.skip_w, gui_pos.skip_h) then
			PRESSED = true
			fade.state = true
			STATES = "intro"
			gamestates.load()
		end
	elseif state == "intro" then
		if check_gui(gui_pos.skip_x, gui_pos.skip_y, gui_pos.skip_w, gui_pos.skip_h) then
			PRESSED = true
			fade.state = true
			STATES = "tutorial"
			gamestates.load()
		end
		-- elseif state == "main" and pauseFlag == true then
		-- 	if check_gui(gSound.x,gSound.y,gSound.w,gSound.h) then
		-- 		if gSound.img == images.gui_sound then
		-- 			pause.sound("off")
		-- 		else
		-- 			pause.sound("on")
		-- 		end
		-- 	elseif check_gui(gSettingsBack.x,gSettingsBack.y,gSettingsBack.w,gSettingsBack.h) then
		-- 		pause.exit()
		-- 	elseif check_gui(gQuit.x,gQuit.y,gQuit.w,gQuit.h) then
		-- 		love.event.quit()
		-- 	end
	end
end

function love.keyreleased(key)
	if key == "f6" then
		toggle_fs()
	end

	if not FINISHED_LOADING then return end

	local state = gamestates.getState()
	if ON_MOBILE then
		Android.setKey(key)
	end

	if state == "main" then
		if key == "a" or key == "d" then
			player.isMoving = false
		end
	elseif state == "intro" or state == "rain_intro" then
		if key == "return" or key == "e" then
			PRESSED = false
		end
	elseif state == "title" then
		if (instruction == false and about == false and questions == false and options == false) and cursor_select then
			--1 start
			--2 quit
			--3 options
			--4 gallery
			--5 questions
			--6 about
			--7 instructions
			--8 website
			if key == "w" or key == "up" then
				cursor_pos = 1
			elseif key == "s" or key == "down" then
				cursor_pos = 2
			elseif key == "d" or key == "right" then
				cursor_pos = cursor_pos + 1
			elseif key == "a" or key == "left" then
				cursor_pos = cursor_pos - 1
			elseif key == "return" or key == "e" then
				if cursor_pos == 1 then
					gamestates.control()
				elseif cursor_pos == 2 then
					love.event.quit()
				elseif cursor_pos == 3 then
					options = true
				elseif cursor_pos == 4 then
					gamestates.nextState("gallery")
				elseif cursor_pos == 5 then
					questions = true
				elseif cursor_pos == 6 then
					about = true
				elseif cursor_pos == 7 then
					instruction = true
				elseif cursor_pos == 8 then
					love.system.openURL(URLS.game_page)
				end
			end

			if cursor_pos > 8 then
				cursor_pos = 8
			elseif cursor_pos < 0 then
				cursor_pos = 0
			end
		end
		if key == "escape" then
			if instruction == true then
				instruction = false
			end
			if about == true then
				about = false
			end
			if questions == true then
				questions = false
			end
		end
	end

	if lr_event ~= 3 then return end

	if key == "a" then
		e_c = 1
	elseif key == "d" then
		e_c = 2
	elseif key == "e" then
		if route == 1 then
			if e_c == 1 then
				event_route = him_convo
			elseif e_c == 2 then
				event_route = wait_convo
			end
		elseif route == 2 then
			if e_c == 1 then
				event_route = leave_convo
			elseif e_c == 2 then
				event_route = wait_convo
			end
		end
		if event_route ~= nil then
			lr_event = 4
		end
	end
end

function love.keypressed(key)
	-- if key == "f9" then recording = not recording end
	if not FINISHED_LOADING then return end
	local dt = love.timer.getDelta()
	local state = gamestates.getState()
	if ON_MOBILE then
		Android.setKey(key)
	end

	-- if state == "title" then
	--  if pro_version then
	-- 	if key == "g" then
	-- 		gamestates.nextState("gallery")
	-- 	end
	--  end
	-- end

	if state == "gallery" then
		if PRO_VERSION then
			Gallery.keypressed(key)
			if key == "escape" then
				Gallery.exit()
				gamestates.nextState("title")
			end
		end
	end

	if key == "e" or key == "space" or key == "return" then
		if state == "splash" then
			gamestates.nextState("splash2")
		elseif state == "splash2" then
			gamestates.nextState("title")
		end
	end

	-- local to_skip = (
	-- 	(key == "e") or
	-- 	(key == "return") or
	-- 	(key == "escape") or
	-- 	(key == "space")
	-- )
	local to_skip = key ~= nil

	if to_skip and state == "rain_intro" then
		PRESSED = true
		fade.state = true
		STATES = "intro"
		gamestates.load()
	elseif to_skip and state == "intro" then
		PRESSED = true
		fade.state = true
		STATES = "tutorial"
		gamestates.load()
	elseif to_skip and state == "tutorial" then
		PRESSED = true
		fade.state = true
		STATES = "main"
		gamestates.load()
	elseif state == "main" then
		if key == "f" then
			if currentRoom ~= Images["rightRoom"] and
				currentRoom ~= Images["leftRoom"] and
				ending_leave ~= true and
				word_puzzle == false
			then
				LIGHT_ON = not LIGHT_ON

				if ghost_event == "limp" or
					ghost_event == "flashback" or
					currentRoom == Images["leftRoom"] or
					currentRoom == Images["rightRoom"] or
					ending_leave == true then
					Sounds.fl_toggle:stop()
				else
					Sounds.fl_toggle:play()
				end
			end
		end

		-- if OS ~= "Android" or OS ~= "iOS" then
		-- 	if key == "p" then
		-- 		if pauseFlag == true then
		-- 			pause.exit()
		-- 		else
		-- 			pause.load()
		-- 		end
		-- 	end
		-- end

		if move == true then
			love.keyboard.setKeyRepeat(true)
			if pushing_anim == false then
				if key == "a" then
					if player.moveLeft == true then
						player.isMoving = true
					end
					if player.dir == 1 then
						player.dir = -1
						child:flipH()
						player_push:flipH()
						idle:flipH()
						-- walk:flipH()
					end

					if ghost_event == "no escape" then
						if ghost_chase == false then
							ghost_chase = true
						end
					end
				elseif key == "d" then
					if player.moveRight == true then
						player.isMoving = true
					end
					if player.dir == -1 then
						player.dir = 1
						child:flipH()
						player_push:flipH()
						idle:flipH()
						-- walk:flipH()
					end
					if ghost_event == "no escape" then
						if ghost_chase == false then
							ghost_chase = true
						end
					end
				elseif key == "e" and move then
					--try fix for overlapping texts
					for _, obj in ipairs(dialogue) do
						if obj.simpleMessage or obj.specialTxt then
							return
						end
					end

					if currentRoom == Images["leftRoom"] or currentRoom == Images["rightRoom"] then
						if LIGHT_ON == false then
							player:checkItems()
							player:checkDoors()
						end
					end
					if move_chair == false then
						if (event_find == false) and (LIGHT_ON == true) then
							player:checkItems()
							player:checkDoors()
						else
							player:checkItems()
							player:checkDoors()
						end
					end
				end
			end
		elseif move == false then
			love.keyboard.setKeyRepeat(false)
			for _, v in ipairs(dialogue) do
				for _, k in ipairs(obj) do
					if v.tag == k.tag then
						if v.state == true then
							if key == "e" then
								if v.n <= #v.txt then
									v.n = v.n + 1
								end
							end

							if v.option == true then
								if key == "left" or key == "a" then
									v.cursor = 1
								elseif key == "right" or key == "d" then
									v.cursor = 2
								elseif key == "space" or key == "return" or key == "e" then
									v:returnChoices(v.cursor)
								end
							end
						end
					end
				end
			end

			if lr_event == 3 then
				if key == "a" then
					e_c = 1
				elseif key == "d" then
					e_c = 2
				elseif key == "e" then
					if route == 1 then
						if e_c == 1 then
							event_route = him_convo
						elseif e_c == 2 then
							event_route = wait_convo
						end
					elseif route == 2 then
						if e_c == 1 then
							event_route = leave_convo
						elseif e_c == 2 then
							event_route = wait_convo
						end
					end
					if event_route ~= nil then
						lr_event = 4
					end
				end
			end
		end
	end

	if word_puzzle == true then
		move = false
		if ON_MOBILE then
			Android.lightChange(true)
		end
		if key == "escape" then
			word_puzzle = false
			move = true
			storage_puzzle = false
			if ON_MOBILE then
				Android.lightChange(false)
			end
		else
			love.keyboard.setTextInput(true)
			if key == "backspace" then
				Sounds.backspace_key:play()
				Sounds.backspace_key:setLooping(false)
				local byteoffset = utf8.offset(USER_INPUT, -1)
				if byteoffset then
					USER_INPUT = string.sub(USER_INPUT, 1, byteoffset - 1)
				end
			end
		end
	end

	if doodle_flag == true then
		move = false
		if ON_MOBILE then
			Android.lightChange(true)
		end
		if key == "escape" then
			doodle_flag = false
			move = true
			storage_puzzle = false
			if ON_MOBILE then
				Android.lightChange(false)
			end
		elseif key == "a" then
			if pic_number > 1 then
				pic_number = pic_number - 1
				random_page()
			else
				pic_number = 1
			end
		elseif key == "d" then
			if pic_number < #puzzle_pics then
				pic_number = pic_number + 1
				random_page()
			else
				pic_number = #puzzle_pics
			end
		end
	end

	if clock_puzzle == true then
		if ON_MOBILE then
			Android.lightChange(true)
		end
		if key == "escape" then
			clock_puzzle = false
			move = true
			if ON_MOBILE then
				Android.lightChange(false)
			end
		elseif key == "w" then
			if selected == "hour" then
				if hour < 12 then
					hour = hour + 1
				else
					hour = 1
				end
			elseif selected == "minute" then
				if minute < 60 then
					minute = minute + 1
				else
					minute = 1
				end
			elseif selected == "second" then
				if second < 60 then
					second = second + 1
				else
					second = 1
				end
			elseif selected == "ampm" then
				if ampm == "am" then
					ampm = "pm"
				else
					ampm = "am"
				end
			end
		elseif key == "s" then
			if selected == "hour" then
				if hour > 1 then
					hour = hour - 1
				else
					hour = 12
				end
			elseif selected == "minute" then
				if minute > 1 then
					minute = minute - 1
				else
					minute = 60
				end
			elseif selected == "second" then
				if second > 1 then
					second = second - 1
				else
					second = 60
				end
			elseif selected == "ampm" then
				if ampm == "am" then
					ampm = "pm"
				else
					ampm = "am"
				end
			end
		elseif key == "a" then
			if selected == "minute" then
				selected = "hour"
			elseif selected == "second" then
				selected = "minute"
			elseif selected == "ampm" then
				selected = "second"
			end
		elseif key == "d" then
			if selected == "hour" then
				selected = "minute"
			elseif selected == "minute" then
				selected = "second"
			elseif selected == "second" then
				selected = "ampm"
			end
		elseif key == "return" then
			clock_puzzle = false
			move = true
			if ON_MOBILE or DEBUGGING == true then
				Android.lightChange(false)
			end
			if hour == 10 and minute == 2 and second == 8 and ampm == "pm" then
				clock_puzzle = false
				Sounds.item_got:play()
				solved = true
				Sounds.main_theme:stop()
				Sounds.intro_soft:stop()
				Sounds.finding_home:stop()
				Sounds.ts_theme:stop()
			end
		end
	end
end

function love.textinput(t)
	if string.len(USER_INPUT) < string.len(CORRECT) then
		Sounds.type:play()
		Sounds.type:setLooping(false)
		USER_INPUT = USER_INPUT .. t
	end
end

function math.clamp(x, min, max)
	return x < min and min or (x > max and max or x)
end

function Set(list)
	local set = {}
	for _, l in ipairs(list) do set[l] = true end
	return set
end

function round(num, idp)
	local mult = 10 ^ (idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function check_gun()
	if obtainables["gun1"] == false and
		obtainables["gun2"] == false and
		obtainables["gun3"] == false then
		doorTxt("I have all the parts", "I need a table to rebuild it")
		local ammo_dial = Interact(false, { "It's an ammo box", "There's only one ammo here", "Load it?" }, { "Yes", "No" },
			"", "ammo")
		table.insert(dialogue, ammo_dial)
		local ammo_item = Items(Images.ammo, Images["leftRoom"], 41, 34, "ammo")
		table.insert(obj, ammo_item)
		ammo_available = true
	else
		move = true
	end
end

function turnLight()
	if currentRoom ~= Images["rightRoom"] and currentRoom ~= Images["leftRoom"] and ending_leave ~= true then
		if word_puzzle == false then
			if LIGHT_ON == true then
				LIGHT_ON = false
			elseif LIGHT_ON == false then
				LIGHT_ON = true
			end
			if ghost_event == "limp" or
				ghost_event == "flashback" or
				currentRoom == Images["leftRoom"] or
				currentRoom == Images["rightRoom"] or
				ending_leave == true then
				Sounds.fl_toggle:stop()
			else
				Sounds.fl_toggle:play()
			end
		end
	end
end

function love.touchpressed(id, x, y)
	if not FINISHED_LOADING then return end
	Android.touchpressed(id, x, y)
end

function love.touchreleased(id, x, y)
	if not FINISHED_LOADING then return end
	Android.touchreleased(id, x, y)
end

function love.touchmoved(id, x, y)
	if not ON_MOBILE then return end
	--local state = gamestates.getState()
	--if state == "gallery" then
	--if pro_version then
	--Gallery.touchmoved(id,x,y)
	--end
	--end
end
