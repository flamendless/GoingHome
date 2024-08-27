--project by Brandon Blanker Lim-it
--@flamendless
--@flam8studio

local VERSION = "v1.1.9"
local MOBILE_VERSION = "8"
local DESKTOP_VERSION = "8"
PRO_VERSION = true
DEBUGGING = false
local debug_overlay = true

OS = love.system.getOS()
ON_MOBILE = (OS == "Android") or (OS == "iOS")

JSON = require("libs.json.json")
LOADER = require("libs.love-loader")
Inspect = require("libs.inspect.inspect")
Lume = require("libs.lume")
Anim8 = require("libs.anim8")
Timer = require("libs.knife.timer")
Object = require("libs.classic")
HumpTimer = require("libs.hump.timer")
FC = require("libs.firstcrush.gui")

IMAGES = {}
SOUNDS = {}
SCENES = {}

require("globals")

love.graphics.setDefaultFilter("nearest", "nearest", 1)
local img_loading = love.graphics.newImage("assets/loading.png")
local lsw, lsh = img_loading:getDimensions()

cursorImage = love.graphics.newImage("assets/cursor.png")
love.mouse.setVisible(false)

local URLS = require("urls")
local Shaders = require("shaders")
local utf8 = require("utf8")

if ON_MOBILE then
	Android = require("gui")
	Android.debug_overlay = debug_overlay

	if not PRO_VERSION then
		LoveAdmob = require("love_admob")
		LoveAdmob.debugging = DEBUGGING
		AdMobKeys = require("admob_keys")
		AdMobKeys.test = DEBUGGING
	end

	if PRO_VERSION then
		VERSION = VERSION .. "-android-pro-v" .. MOBILE_VERSION
	else
		VERSION = VERSION .. "-android-v" .. MOBILE_VERSION
	end
end

FADE_OBJ = Fade(1, 6)
DEF_FONT = love.graphics.newFont("assets/Jamboree.ttf", 8)
DEF_FONT:setFilter("nearest", "nearest", 1)
DEF_FONT_HEIGHT = DEF_FONT:getHeight()
DEF_FONT_HALF = DEF_FONT_HEIGHT / 2

WIDTH, HEIGHT = 128, 64
WIDTH_HALF = WIDTH / 2
HEIGHT_HALF = HEIGHT / 2
SW, SH = love.window.getDesktopDimensions()
INTERACT = false
TX = 0
TY = 0
FINISHED_LOADING = false

love.keyboard.setTextInput(false)
MAIN_CANVAS = love.graphics.newCanvas(love.graphics.getDimensions())

local function toggle_fs()
	love.window.setFullscreen(not love.window.getFullscreen())
	local g_width, g_height = love.graphics.getDimensions()
	if ON_MOBILE then
		RATIO = math.min(g_width / WIDTH, g_height / HEIGHT)
	else
		RATIO_X, RATIO_Y = g_width / WIDTH, g_height / HEIGHT
		RATIO = math.min(RATIO_X, RATIO_Y)
	end
	MAIN_CANVAS = love.graphics.newCanvas(love.graphics.getDimensions())
end

-- pauseFlag = false
TEMP_MOVE = false

if ON_MOBILE and not PRO_VERSION then
	function PreloadAds()
		LoveAdmob.createBanner(AdMobKeys.ids.banner, "bottom")
		LoveAdmob.requestInterstitial(AdMobKeys.ids.inter)
		LoveAdmob.requestRewardedAd(AdMobKeys.ids.reward)
	end

	function ShowBannerAds()
		if math.floor(LoveAdmob.ad_timers.banner) % 5 ~= 0 then return end
		if FC:validate() ~= "accept" then return end
		LoveAdmob.createBanner(AdMobKeys.ids.banner, "bottom")
		LoveAdmob.showBanner()
		LoveAdmob.ad_timers.banner = 0
	end

	function ShowInterstitialAds()
		if LoveAdmob.shown_count.interstitial >= 3 then
			return
		end

		if LoveAdmob.showing.interstitial then return end
		if math.floor(LoveAdmob.ad_timers.interstitial) % 5 ~= 0 then return end
		if FC:validate() ~= "accept" then return end
		if not LoveAdmob.isInterstitialLoaded() then
			LoveAdmob.requestInterstitial(AdMobKeys.ids.inter)
		end
		if LoveAdmob.isInterstitialLoaded() then
			LoveAdmob.showInterstitial()
			LoveAdmob.showing.interstitial = true
			LoveAdmob.ad_timers.interstitial = 0
			LoveAdmob.shown_count.interstitial = LoveAdmob.shown_count.interstitial + 1
		end
	end

	function ShowRewardedAds(force, cb_reward_success)
		if LoveAdmob.shown_count.rewarded >= 3 then
			cb_reward_success("skipped", 0)
			return
		end

		if cb_reward_success then
			LoveAdmob.rewardUserWithReward = cb_reward_success
		end

		if not force then
			if LoveAdmob.showing.rewarded then return end
			if math.floor(LoveAdmob.ad_timers.rewarded) % 5 ~= 0 then return end
		end
		if FC:validate() ~= "accept" then return end
		if not LoveAdmob.isRewardedAdLoaded() then
			LoveAdmob.requestRewardedAd(AdMobKeys.ids.reward)
		end

		if LoveAdmob.isRewardedAdLoaded() then
			LoveAdmob.showRewardedAd()
			LoveAdmob.showing.rewarded = true
			LoveAdmob.ad_timers.rewarded = 0
			LoveAdmob.shown_count.rewarded = LoveAdmob.shown_count.rewarded + 1
		else
			LoveAdmob.showing.rewarded = false
			LoveAdmob.ad_timers.rewarded = 0
			cb_reward_success("load_failed", 0)
		end
	end
end

function love.load()
	print("VERSION:", VERSION)
	if ON_MOBILE then
		print("MOBILE VERSION:", MOBILE_VERSION)
	else
		print("DESKTOP VERSION:", DESKTOP_VERSION)
	end
	SaveData.load()

	if PRO_VERSION then
		STATES = "splash"
	else
		STATES = "adshow"
	end

	CLOCK = 0 --game timer

	local g_width, g_height = love.graphics.getDimensions()

	if ON_MOBILE then
		RATIO = math.min(g_width / WIDTH, g_height / HEIGHT)
	else
		RATIO_X, RATIO_Y = g_width / WIDTH, g_height / HEIGHT
		RATIO = math.min(RATIO_X, RATIO_Y)
	end

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
end

function love.update(dt)
	if not ON_MOBILE then
		MOUSE_X, MOUSE_Y = love.mouse.getPosition()
	end

	CLOCK = CLOCK + dt

	local ww, wh = love.graphics.getDimensions()

	TX = (ww / 2 - (WIDTH * RATIO) / 2)
	TX = math.max(0, TX)

	local OFFY = (not ON_MOBILE) and 8 or 0
	TY = (wh / 2 - (HEIGHT * RATIO) / 2) - OFFY
	TY = math.max(0, TY)

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
					love.mouse.setVisible(false)
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
	love.graphics.scale(RATIO, RATIO)
	if FINISHED_LOADING then
		-- if shaders_test or enemy_exists then
		-- 	love.graphics.setShader(Shaders.palette_swap)
		-- end

		gamestates.draw()
		Pause.draw()

		love.graphics.setShader()

		if FC:getState() then FC:draw() end
	else
		local percent = 0
		if LOADER.resourceCount ~= 0 then
			percent = LOADER.loadedCount / LOADER.resourceCount
		end
		love.graphics.setColor(1, 1, 1, 0.58)
		love.graphics.setFont(DEF_FONT)
		local str_loading = ("Loading..%d%%"):format(percent * 100)
		love.graphics.print(str_loading, WIDTH_HALF - DEF_FONT:getWidth(str_loading) / 2, HEIGHT - DEF_FONT_HEIGHT)

		local scale = 0.4
		love.graphics.draw(img_loading, WIDTH_HALF, HEIGHT_HALF, 0, scale, scale, lsw / 2, lsh / 2)
	end
	love.graphics.pop()

	love.graphics.setCanvas()

	love.graphics.setColor(1, 1, 1, 1)
	if not ENDING_LEAVE and SaveData.data.use_grayscale then
		love.graphics.setShader(Shaders.grayscale)
	end
	love.graphics.draw(MAIN_CANVAS, TX, TY)
	love.graphics.setShader()

	if not ON_MOBILE then
		love.graphics.draw(cursorImage, MOUSE_X, MOUSE_Y)
	end

	if debug_overlay then
		if ON_MOBILE then
			love.graphics.setColor(1, 0, 0, 1)
			local touch_ids = love.touch.getTouches()
			for _, touch_id in ipairs(touch_ids) do
				local tx, ty = love.touch.getPosition(touch_id)
				tx = (tx - TX) / RATIO
				ty = (ty - TY) / RATIO
				love.graphics.circle("fill", tx, ty, 2)
			end
		end

		love.graphics.push()
		love.graphics.setColor(1, 0, 0, 1)
		local scale = BatteriesManager.get_light_scale()
		love.graphics.scale(3, 3)
		love.graphics.print(VERSION, 8, 0)
		love.graphics.print("Difficulty: " .. DifficultySelect.idx, 8, 8)
		love.graphics.print("Battery: " .. scale, 8, 16)
		love.graphics.print(string.format("TX, TY, R: %d, %d, %.2f", TX, TY, RATIO), 8, 24)
		if MOVE_CHAIR then
			love.graphics.print("Chair: " .. MOVE_CHAIR, 8, 32)
		end
		love.graphics.pop()
	end

	-- love.graphics.setColor(1, 0, 0, 1)
	-- local ry = love.graphics.getHeight()/2 - (HEIGHT*RATIO)/2
	-- love.graphics.rectangle("line", 0, ry, WIDTH*RATIO, HEIGHT*RATIO)
end

function love.mousereleased(x, y, button, istouch)
	if not FINISHED_LOADING then return end
	if not PRESSED then return end
	local state = gamestates.getState()
	if (state == "intro") or (state == "rain_intro") then
		PRESSED = false
	end
end

function love.mousepressed(x, y, button, istouch)
	FC:mousepressed(x, y, button, istouch)
	if not FINISHED_LOADING then return end
	local state = gamestates.getState()
	local mx = (x - TX) / RATIO
	local my = (y - TY) / RATIO

	if state == "gallery" then
		Gallery.interactions(nil, x, y)

	elseif button == 1 and state == "difficulty_select" then
		local was_interacted = DifficultySelect.interact()
		if was_interacted then
			DifficultySelect.goto_next()
		end

	elseif state == "title" and button == 1 then
		if instruction == false and about == false and questions == false and not options then
			if check_gui(gui_pos.start_x, gui_pos.start_y, gui_pos.start_w, gui_pos.start_h) then
				gamestates.control()
			elseif check_gui(gui_pos.quit_x, gui_pos.quit_y, gui_pos.quit_w, gui_pos.quit_h) then
				if OS ~= "iOS" then
					love.event.quit()
				end
			elseif check_gui(gui_pos.webx, gui_pos.weby, gui_pos.webw, gui_pos.webh) then
				if ON_MOBILE and LoveAdmob then
					if LoveAdmob.isInterstitialLoaded() == true then
						LoveAdmob.showInterstitial()
					end
				else
					love.system.openURL(URLS.game_page)
				end
			elseif check_gui(gui_pos.g_x, gui_pos.g_y, gui_pos.g_w, gui_pos.g_h) then
				gamestates.nextState("gallery")
			elseif check_gui(gui_pos.options_x, gui_pos.options_y, gui_pos.options_w, gui_pos.options_h) then
				options = not options
			elseif check_gui(gui_pos.q_x, gui_pos.q_y, gui_pos.q_w, gui_pos.q_h) then
				questions = not questions
			elseif check_gui(gui_pos.a_x, gui_pos.a_y, gui_pos.a_w, gui_pos.a_h) then
				about = not about
			elseif check_gui(gui_pos.i_x, gui_pos.i_y, gui_pos.i_w, gui_pos.i_h) then
				instruction = not instruction
			end
		end

		if options then
			local base_y = 1 + DEF_FONT_HEIGHT
			local rw = 8
			for i, item in ipairs(SaveData.get_opts()) do
				local str = item.str
				local by = base_y + DEF_FONT_HEIGHT * (i - 1)
				local rx = WIDTH - 16 - rw / 2
				local ry = by + rw / 4

				if check_gui(16, by, DEF_FONT:getWidth(str), DEF_FONT_HEIGHT) or
					check_gui(rx, ry, rw, rw)
				then
					SaveData.toggle_opts(i)
				end
			end
		elseif questions then
			local url
			if check_gui(gui_pos.t_x, gui_pos.t_y, gui_pos.t_w, gui_pos.t_h) then
				url = URLS.twitter
			elseif check_gui(gui_pos.p_x, gui_pos.p_y, gui_pos.p_w, gui_pos.p_h) then
				if OS ~= "iOS" then
					url = URLS.paypal
				end
			elseif check_gui(gui_pos.e_x, gui_pos.e_y, gui_pos.e_w, gui_pos.e_h) then
				url = URLS.mailto
			end

			if url then
				love.system.openURL(url)
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

	elseif state == "rain_intro" then
		-- if ON_MOBILE then
		-- 	Android.touchpressed(nil, x, y)
		-- end
		-- if check_gui(
		-- 		gui_pos.skip_x,
		-- 		gui_pos.skip_y,
		-- 		gui_pos.skip_w,
		-- 		gui_pos.skip_h
		-- 	) then
		-- 	PRESSED = true
		-- 	FADE_OBJ.state = true
		-- 	gamestates.nextState("intro")
		-- end
	elseif state == "intro" then
		-- if ON_MOBILE or check_gui(
		-- 		gui_pos.skip_x,
		-- 		gui_pos.skip_y,
		-- 		gui_pos.skip_w,
		-- 		gui_pos.skip_h
		-- 	) then
		-- 	PRESSED = true
		-- 	FADE_OBJ.state = true
		-- 	STATES = "tutorial"
		-- 	gamestates.load()
		-- end
	elseif state == "tutorial" and ON_MOBILE then
		PRESSED = true
		FADE_OBJ.state = true
		gamestates.nextState("main")
	elseif state == "main" then
		Pause.mousepressed(mx, my, button)
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
	-- end
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
			PLAYER.isMoving = false
		end
	elseif state == "intro" or state == "rain_intro" then
		if key == "return" or key == "e" then
			PRESSED = false
		end
	elseif state == "difficulty_select" then
		DifficultySelect.keyreleased(key)

	elseif state == "title" then
		if (instruction == false and about == false and questions == false and options == false) and CURSOR_SELECT then
			--1 start
			--2 quit
			--3 options
			--4 gallery
			--5 questions
			--6 about
			--7 instructions
			--8 website
			if key == "w" or key == "up" then
				CURSOR_POS = 1
			elseif key == "s" or key == "down" then
				CURSOR_POS = 2
			elseif key == "d" or key == "right" then
				CURSOR_POS = CURSOR_POS + 1
			elseif key == "a" or key == "left" then
				CURSOR_POS = CURSOR_POS - 1
			elseif key == "return" or key == "e" then
				if CURSOR_POS == 1 then
					gamestates.control()
				elseif CURSOR_POS == 2 then
					love.event.quit()
				elseif CURSOR_POS == 3 then
					options = true
				elseif CURSOR_POS == 4 then
					gamestates.nextState("gallery")
				elseif CURSOR_POS == 5 then
					questions = true
				elseif CURSOR_POS == 6 then
					about = true
				elseif CURSOR_POS == 7 then
					instruction = true
				elseif CURSOR_POS == 8 then
					love.system.openURL(URLS.game_page)
				end
			end

			if CURSOR_POS > 8 then
				CURSOR_POS = 8
			elseif CURSOR_POS < 0 then
				CURSOR_POS = 0
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
		E_C = 1
	elseif key == "d" then
		E_C = 2
	elseif key == "e" then
		if ROUTE == 1 then
			if E_C == 1 then
				event_route = him_convo
			elseif E_C == 2 then
				event_route = wait_convo
			end
		elseif ROUTE == 2 then
			if E_C == 1 then
				event_route = leave_convo
			elseif E_C == 2 then
				event_route = wait_convo
			end
		end
		if event_route ~= nil then
			lr_event = 4
		end
	end
end

function love.keypressed(key)
	-- if key == "g" then
	-- 	gamestates.nextState("title")
	-- 	RESET_STATES()
	-- end

	if not FINISHED_LOADING then return end
	local state = gamestates.getState()
	if ON_MOBILE then
		Android.setKey(key)
	end

	if state == "gallery" then
		Gallery.keypressed(key)
		if PRO_VERSION then
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
		FADE_OBJ.state = true
		gamestates.nextState("intro")
	elseif to_skip and state == "intro" then
		PRESSED = true
		FADE_OBJ.state = true
		gamestates.nextState("tutorial")
	elseif to_skip and state == "tutorial" then
		PRESSED = true
		FADE_OBJ.state = true
		gamestates.nextState("main")
	elseif state == "main" then
		if key == "f" then
			if currentRoom ~= IMAGES["rightRoom"] and
				currentRoom ~= IMAGES["leftRoom"] and
				ENDING_LEAVE ~= true and
				word_puzzle == false
			then
				LIGHT_ON = not LIGHT_ON

				if GHOST_EVENT == "limp" or
					GHOST_EVENT == "flashback" or
					currentRoom == IMAGES["leftRoom"] or
					currentRoom == IMAGES["rightRoom"] or
					ENDING_LEAVE == true then
					SOUNDS.fl_toggle:stop()
				else
					SOUNDS.fl_toggle:play()
				end
			end
		end

		if not ON_MOBILE and key == "p" then
			Pause.toggle()
		end

		if MOVE == true then
			love.keyboard.setKeyRepeat(true)
			if PUSHING_ANIM == false then
				if key == "a" then
					if PLAYER.moveLeft == true then
						PLAYER.isMoving = true
					end
					if PLAYER.dir == 1 then
						PLAYER.dir = -1
						child:flipH()
						player_push:flipH()
						idle:flipH()
						-- walk:flipH()
					end

					if GHOST_EVENT == "no escape" and not GHOST_CHASE then
						GHOST_CHASE = true
					end
				elseif key == "d" then
					if PLAYER.moveRight == true then
						PLAYER.isMoving = true
					end
					if PLAYER.dir == -1 then
						PLAYER.dir = 1
						child:flipH()
						player_push:flipH()
						idle:flipH()
						-- walk:flipH()
					end

					if GHOST_EVENT == "no escape" and not GHOST_CHASE then
						GHOST_CHASE = true
					end
				elseif key == "e" and MOVE then
					--try fix for overlapping texts
					for _, obj in ipairs(DIALOGUES) do
						if obj.simpleMessage or obj.specialTxt then
							return
						end
					end

					if DifficultySelect.idx == 2 then
						local has_interact = BatteriesManager.check_interact()
						if has_interact then
							return
						end
					end

					if not LIGHT_ON then
						if currentRoom == IMAGES.leftRoom or currentRoom == IMAGES.rightRoom then
							PLAYER:checkItems()
							PLAYER:checkDoors()
						end
					end

					if MOVE_CHAIR == false then
						if (event_find == false) and (LIGHT_ON == true) then
							PLAYER:checkItems()
							PLAYER:checkDoors()
						else
							PLAYER:checkItems()
							PLAYER:checkDoors()
						end
					end
				end
			end
		elseif MOVE == false then
			love.keyboard.setKeyRepeat(false)
			for _, v in ipairs(DIALOGUES) do
				for _, k in ipairs(ITEMS_LIST) do
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
					E_C = 1
				elseif key == "d" then
					E_C = 2
				elseif key == "e" then
					if ROUTE == 1 then
						if E_C == 1 then
							event_route = him_convo
						elseif E_C == 2 then
							event_route = wait_convo
						end
					elseif ROUTE == 2 then
						if E_C == 1 then
							event_route = leave_convo
						elseif E_C == 2 then
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
		MOVE = false
		if ON_MOBILE then
			Android.lightChange(true)
		end
		if key == "escape" then
			word_puzzle = false
			MOVE = true
			storage_puzzle = false
			if ON_MOBILE then
				Android.lightChange(false)
			end
		else
			love.keyboard.setTextInput(true)
			if key == "backspace" then
				SOUNDS.backspace_key:play()
				SOUNDS.backspace_key:setLooping(false)
				local byteoffset = utf8.offset(USER_INPUT, -1)
				if byteoffset then
					USER_INPUT = string.sub(USER_INPUT, 1, byteoffset - 1)
				end
			end
		end
	end

	process_doodle_puzzle(key)

	if ClockPuzzle.state == true then
		if ON_MOBILE then
			Android.lightChange(true)
		end
		if key == "escape" then
			ClockPuzzle.state = false
			MOVE = true
			if ON_MOBILE then
				Android.lightChange(false)
			end
		elseif key == "w" then
			ClockPuzzle.ev_up()
		elseif key == "s" then
			ClockPuzzle.ev_down()
		elseif key == "a" then
			ClockPuzzle.ev_left()
		elseif key == "d" then
			ClockPuzzle.ev_right()
		elseif key == "return" then
			MOVE = true
			if (ON_MOBILE or DEBUGGING) and Android then
				Android.lightChange(false)
			end
			ClockPuzzle.ev_enter()
		end
	end
end

function love.textinput(t)
	storage_puzzle_text_input(t)
end

function round(num, idp)
	local mult = 10 ^ (idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function check_gun()
	if OBTAINABLES["gun1"] == false and
		OBTAINABLES["gun2"] == false and
		OBTAINABLES["gun3"] == false then
		doorTxt("I have all the parts", "I need a table to rebuild it")
		local dialogue_ammo = Interact(
			false,
			{ "It's an ammo box", "There's only one ammo here", "Load it?" },
			{ "Yes", "No" },
			"",
			"ammo"
		)
		table.insert(DIALOGUES, dialogue_ammo)
		local item_ammo = Items(IMAGES.ammo, IMAGES["leftRoom"], 41, 34, "ammo")
		table.insert(ITEMS_LIST, item_ammo)
		AMMO_AVAILABLE = true
	else
		MOVE = true
	end
end

function turnLight()
	if currentRoom ~= IMAGES["rightRoom"] and currentRoom ~= IMAGES["leftRoom"] and ENDING_LEAVE ~= true then
		if word_puzzle == false then
			if LIGHT_ON == true then
				LIGHT_ON = false
			elseif LIGHT_ON == false then
				LIGHT_ON = true
			end
			if GHOST_EVENT == "limp" or
				GHOST_EVENT == "flashback" or
				currentRoom == IMAGES["leftRoom"] or
				currentRoom == IMAGES["rightRoom"] or
				ENDING_LEAVE == true then
				SOUNDS.fl_toggle:stop()
			else
				SOUNDS.fl_toggle:play()
			end
		end
	end
end

function love.touchpressed(id, x, y)
	if not FINISHED_LOADING then return end
	local tx = (x - TX) / RATIO
	local ty = (y - TY) / RATIO
	Android.touchpressed(id, tx, ty)
end

function love.touchreleased(id, x, y)
	if not FINISHED_LOADING then return end
	local tx = (x - TX) / RATIO
	local ty = (y - TY) / RATIO
	Android.touchreleased(id, tx, ty)
end

-- function love.touchmoved(id, x, y)
-- 	if not ON_MOBILE then return end
-- 	--local state = gamestates.getState()
-- 	--if state == "gallery" then
-- 	--if pro_version then
-- 	--Gallery.touchmoved(id,x,y)
-- 	--end
-- 	--end
-- end

function unrequire(m)
	package.loaded[m] = nil
	_G[m] = nil
	-- require(m)
end

function RESET_STATES()
	local ext = ".lua"
	local ignore = {
		admob_keys = 1,
		conf = 1,
		error = 1,
		gallery = 1,
		gui = 1,
		love_admob = 1,
		main = 1,
		pause = 1,
		-- player = 1,
		saved_data = 1,
		shaders = 1,
		urls = 1,
	}
	local files = love.filesystem.getDirectoryItems("")
	for _, file in ipairs(files) do
		if file:sub(- #ext) == ext then
			local f = file:sub(0, -(#ext + 1))
			if not ignore[f] then
				print("resetting:", f)
				unrequire(f)
				require(f)
			end
		end
	end

	ON_LOAD_ASSETS()
	SaveData.load()
end

function ON_LOAD_ASSETS()
	local state = gamestates.getState()
	print("loaded", state)
	TEX_LIGHT = IMAGES.light

	Gallery.load()
	animation_set()

	if state == "main" then
		particle_set()
		Assets.set()
	end

	Assets.init_gui_pos()
	gamestates.init()
	FINISHED_LOADING = true
end

function math.clamp(v, lo, hi)
	return math.max(lo, math.min(v, hi))
end

function math.wrap(v, lo, hi)
	return (v - lo) % (hi - lo) + lo
end

function CLAMP_LIGHT(lx, ly)
	lx = lx or LIGHTX
	ly = ly or LIGHTY
	if DifficultySelect.idx == 2 then
		LIGHTX = math.clamp(lx, PLAYER.x - 40, PLAYER.x + 35)
		LIGHTY = math.clamp(ly, PLAYER.y - 15, PLAYER.y + 10)
	else
		LIGHTX = math.clamp(lx, PLAYER.x - 120, PLAYER.x + 100)
		LIGHTY = math.clamp(ly, PLAYER.y - 20, PLAYER.y + 0)
	end
end
