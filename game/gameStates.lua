gamestates = {}

about = false
options = false
questions = false
DOOR_LOCKED = true

if DEBUGGING then
	DOOR_LOCKED = false
end

--
lStrike = false
local _alarm = 3
local tt_txt = "Where are they?"
local tt_txt2 = "I have to look for them"
local t = 1
_timer = 5
_flag = false
txt1 = ""
txt1_x = 0
txt1_y = 0
tv_trigger = 0
bed_trigger = 0
tv_light_flag = false
rope_trigger = 0
attic_trigger = false
chest_open = false
crowbar_broken = false

event = ""

ClockPuzzle.state = false

move_chair = false

pushing_anim = false
chair_final = false
final_flashback = false
random_breathe_flag = true
event_trigger_light = 0

candles_light = false
candles_light_flag = false

basement_unlocked = false
right_light_flag = true
left_light_flag = false
rightroom_unlocked = false
storage_puzzle = false
doodle_flag = false
final_puzzle_solved = false
word_puzzle = false
gun_complete = 0
gun_rebuild = false
lr_event = 0
light_refilled = false
ammo_available = false
ammo_picked = false
ending = false
ending_animate = false
shoot_pose_animate = false
reload_animate = false
bullet_fired = false
leave_animate = false
basement_lock = true
ending_leave = false
ending_leave_event = 0
player_color = false

thunder_play = true
lightning_flash = true

mouse_select = false
cursor_select = false
cursor_pos = 0
ending_final = 0
player_ending_shot = false
ending_shot = 0
broken_revolver = false
final_clock = 0
credits_flag = false
gun_click_flag = false
ending_shoot = false
ending_shoot_event = 0
f_shot_anim2_flag = false
f_shot_anim_flag = false
rr_event = 0
fade_to_black = false
ending_wait = false
flash_text_finished = false
gun_obtained = false
route = 0
l, r = 0, 0
adTimer = 5
local adTxts = {
	"Please Allow Ads to support",
	"The Developer. Ads will be",
	"unintrusive and shown",
	"minimally, or buy",
	"the adless version",
}
local adTxt = table.concat(adTxts, "\n")
lightningVol = 0.3

local tutorial_timer = 5

local intro_txt = {
	"",
	"...",
	"Claire..",
	"Alex..",
	"I'm here..",
	"Where are you two?",
	"Why is it so dark in here?",
	"The storm must have",
	"caused the blackout",
	"Good thing I've brought",
	"my flashlight.",
	""
}

local instruction_texts_title = {
	"A, D to move, E to interact",
	"F to toggle flashlight",
	"ENTER/ESC on puzzle",
	"Your actions affect the story",
}
local instruction_texts = {
	"A, D to move, E to interact",
	"F to toggle flashlight",
	"ENTER/ESC on puzzle",
	"F6 to toggle fullscreen",
	"Your actions affect the story",
}
local instruction_texts_mobile = {
	"Navigate using a small light",
	"Avoid the fear that haunts",
	"It must not be exposed to light",
	"Your actions affect the story",
}

local str_about = {
	"About:",
	"Game By: @flamendless",
	"Programmer: Brandon Lim-it",
	"Artist: Conrad Reyes",
	"QA: Ian Plaus",
}

local function draw_instructions()
	love.graphics.setColor(0, 0, 0, 0)
	love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
	love.graphics.setFont(DEF_FONT)
	love.graphics.setColor(1, 1, 1)

	local state = gamestates.getState()

	local by = 0
	if state == "tutorial" then
		by = 0
	else
		by = 4
	end

	local texts, last_str
	if ON_MOBILE then
		texts = instruction_texts_mobile
		last_str = "tap to continue"
	else
		if state == "title" then
			texts = instruction_texts_title
		else
			texts = instruction_texts
		end
		last_str = "press E to continue"
	end

	local y
	for i, str in ipairs(texts) do
		y = by + DEF_FONT_HEIGHT * (i - 1)
		love.graphics.print(str, WIDTH_HALF - DEF_FONT:getWidth(str) / 2, y)
	end

	if state == "tutorial" then
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.print(last_str, WIDTH_HALF - DEF_FONT:getWidth(last_str) / 2, y + DEF_FONT_HEIGHT)
		love.graphics.setColor(1, 1, 1, 1)
	end
end

function gamestates.load()
	tutorial_timer = 5
	go_flag = 0
	mid_dial = 0

	RANDOM_BREATHE = true

	txt = "press I for instruction"
	fade = Fade(1, 6)
	instruction = false
	doors_locked = true
	action_flag = 0
	tt_update = false

	intro_count = 1
	intro_timer = 2.5
	intro_finished = false

	Assets.load()
end

function gamestates.init()
	SaveData.load()

	local state = gamestates.getState()
	if state == "gallery" then
		Sounds.ts_theme:stop()
	elseif state == "adshow" then
		-- assets.load()
		FC:init()
		FC:GDPR_init()
	elseif state == "splash" then
		-- if pro_version then
		-- 	assets.load()
		-- end
		splash_timer = HumpTimer:new()
		splash_timer:after(3, function()
			--states = "splash2"
			gamestates.nextState("splash2")
		end)
		logoTimer = HumpTimer:new()
		logoTimer:after(3, function()
			--states = "title"
			gamestates.nextState("title")
		end)
	elseif state == "title" then
		--set music
		Sounds.ts_theme:setLooping(true)
		Sounds.ts_theme:play()
		Sounds.ts_theme:setVolume(0.5)
		if ON_MOBILE and not PRO_VERSION then
			PreloadAds()
		end
		if SaveData.data.music_sounds then
			love.audio.setVolume(1)
		else
			love.audio.setVolume(0)
		end
	elseif state == "rain_intro" then
		Sounds.ts_theme:stop()
		intro_load()
	elseif state == "intro" then
		Sounds.knock:play()
		Sounds.enemy_scream:setLooping(false)
		Sounds.intro_soft:stop()
	elseif state == "main" then
		Pause.init()
		Sounds.fl_toggle:setLooping(false)
		Sounds.fl_toggle:setVolume(1)

		Sounds.rain:setLooping(true)
		Sounds.rain:setVolume(0.8)
		Sounds.rain:play()
		Sounds.ts_theme:stop()

		fade.state = true
		move = true
		LIGHT_VALUE = 1

		--create dynamic objects
		player = Player(WIDTH_HALF, HEIGHT_HALF, 8, 16)
		ghost = Enemy(42, 30, 12, 14)

		mrChair = Chair()

		ENEMY_EXISTS = false
		seen = false
		GAMEOVER = false

		currentRoom = Images["mainRoom"]
		--locked doors
		locked = Set {
			"mainRoom_right",
			"livingRoom_mid",
			"masterRoom_mid"
		}

		if not DOOR_LOCKED then
			locked["mainRoom_right"] = false
		end

		obtainables = Set({
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
	end
end

function gamestates.getState() return STATES end

function gamestates.update(dt)
	local mx, my = love.mouse.getPosition()
	mx = mx / RATIO
	my = (my + TY) / RATIO

	if currentRoom == Images["leftRoom"] or
		currentRoom == Images["rightRoom"] or
		currentRoom == Images["basementRoom"] or
		ending_leave == true then
		ENEMY_EXISTS = false
	end

	local state = gamestates.getState()
	fade:update(dt)

	if state == "gallery" then
		Gallery.update(dt)
	elseif state == "adshow" then
		if ON_MOBILE then
			if adTimer > 0 then
				adTimer = adTimer - 1 * dt
				if adTimer <= 0 then
					STATES = "splash"
					gamestates.load()
				end
			end
		else
			STATES = "splash"
			gamestates.load()
		end
	elseif state == "splash" then
		splash_anim:update(dt)
		if SPLASH_FINISHED then
			splash_timer:update(dt)
		end
	elseif state == "splash2" then
		logoTimer:update(dt)
	elseif state == "tutorial" then
		tutorial_timer = tutorial_timer - dt
		if tutorial_timer < 0 then
			fade.state = true
			gamestates.nextState("main")
		end
	elseif state == "title" then
		if ON_MOBILE and (not PRO_VERSION) then
			ShowBannerAds()
		end

		if instruction == false and about == false and questions == false and options == false then
			if check_gui(gui_pos.start_x, gui_pos.start_y, gui_pos.start_w, gui_pos.start_h) or
				check_gui(gui_pos.quit_x, gui_pos.quit_y, gui_pos.quit_w, gui_pos.quit_h) or
				check_gui(gui_pos.i_x, gui_pos.i_y, gui_pos.i_w, gui_pos.i_h) or
				check_gui(gui_pos.a_x, gui_pos.a_y, gui_pos.a_w, gui_pos.a_h) or
				check_gui(gui_pos.q_x, gui_pos.q_y, gui_pos.q_w, gui_pos.q_h) or
				check_gui(gui_pos.webx, gui_pos.weby, gui_pos.webw, gui_pos.webh) or
				check_gui(gui_pos.g_x, gui_pos.g_y, gui_pos.g_w, gui_pos.g_h) or
				check_gui(gui_pos.options_x, gui_pos.options_y, gui_pos.options_w, gui_pos.options_h)
			then
				mouse_select = true
			else
				mouse_select = false
			end
		end

		if mouse_select == true then
			cursor_pos = 0
			cursor_select = false
		else
			cursor_select = true
		end
	elseif state == "rain_intro" then
		intro_update(dt)
	elseif state == "intro" then
		intro_timer = intro_timer - 1 * dt

		if intro_timer <= 0 then
			intro_timer = 2
			if intro_count < #intro_txt then
				intro_count = intro_count + 1
			end
		end

		if intro_count == #intro_txt then
			--play door sound
			--start main
			intro_finished = true
		end

		if intro_finished == true then
			if Sounds.unlock:isPlaying() == false then
				Sounds.unlock:play()
			end
			gamestates.nextState("tutorial")
		end

		--sounds
		--loop rain and thunder
		--knock
		--unlock
		if thunder_play == true then
			local c = intro_count % 2
			if c ~= 1 then
				Sounds.thunder:play()
			end
		end

		if Sounds.knock:isPlaying() == false then
			if Sounds.rain:isPlaying() == false then
				Sounds.rain:play()
			end
		end

		skip_button:update(dt)

		-----MAIN-------
	elseif state == "main" then
		--windows
		win_left_anim:update(dt)
		win_right_anim:update(dt)
		Timer.update(dt)

		if WIN_MOVE_L == false then
			Timer.after(10, function()
				WIN_MOVE_L = true
				win_left_anim:resume()
			end)
		end
		if WIN_MOVE_R == false then
			Timer.after(9, function()
				WIN_MOVE_R = true
				win_right_anim:resume()
			end)
		end

		if ghost_event == "flashback" and Sounds.tv_loud and Sounds.tv_loud:isPlaying() then
			Sounds.tv_loud:stop()
		end

		if move == true then
			player:movement(dt)
		end

		if ending_leave == true then
			if currentRoom ~= Images["leftRoom"] then
				leave_event_update(dt)
			end
		end

		for _, v in pairs(dialogue) do
			if v.tag == "clock" then
				if move == true then
					v.specialTxt = false
				end
			end
		end


		Timer.update(dt)

		if GAMEOVER == false then
			if event ~= "after_secret_room" and
				ghost_event ~= "no escape" and
				ghost_event ~= "still no escape" and
				ghost_event ~= "fall down" and
				ghost_event ~= "lying down" and
				ghost_event ~= "flashback" and
				ghost_event ~= "limp" then
				if currentRoom ~= Images["basementRoom"] and
					currentRoom ~= Images["leftRoom"] and
					currentRoom ~= Images["rightRoom"] and
					currentRoom ~= Images["storageRoom"] and
					currentRoom ~= Images["daughterRoom"] and
					currentRoom ~= Images["secretRoom"] and
					currentRoom ~= Images["atticRoom"] and
					currentRoom ~= Images["endRoom"] and
					ending_leave ~= true then
					Sounds.lightning:setVolume(lightningVol)
					if not Sounds.lightning:isPlaying() == true then
						Sounds.lightning:play()
					end
				else
					Sounds.lightning:setVolume(0.6)
				end
				lightning()
			else
				Sounds.lightning:stop()
				if ghost_event == "flashback" and
					flash_text_finished == true then
					LIGHT_VALUE = 0
				else
					LIGHT_VALUE = 1
				end
			end
		end

		if ending_leave == true then
			Sounds.rain:stop()
		end

		local choose = math.floor(math.random(1, 3))
		local random = math.floor(math.random(5, 10))
		local num = "breath_"

		if random_breathe_flag == true then
			if RANDOM_BREATHE == true then
				RANDOM_BREATHE = false
				Timer.after(random, function()
					Sounds[num .. tostring(choose)]:play()
					Sounds[num .. tostring(choose)]:setVolume(0.5)
					RANDOM_BREATHE = true
				end)
			end
		end

		if GAMEOVER == false then
			if ON_MOBILE or DEBUGGING then
				--android.lightCircle()
			elseif not ON_MOBILE and (not DEBUGGING) then
				if event_trigger_light == -1 then
					_lightX = mx - Images.light_small:getWidth() / 2 + math.random(-0.05, 0.05)
					_lightY = my - Images.light_small:getHeight() / 2 + math.random(-0.05, 0.05)
				else
					_lightX = mx - Images.light:getWidth() / 2 + math.random(-0.05, 0.05)
					_lightY = my - Images.light:getHeight() / 2 + math.random(-0.05, 0.05)
				end
				LIGHTX = math.clamp(_lightX, player.x - 120, player.x + 100)
				LIGHTY = math.clamp(_lightY, player.y - 20, player.y + 0)

				love.graphics.setCanvas(CANVAS_CUSTOM_MASK)
				love.graphics.clear(0, 0, 0, LIGHT_VALUE)
				love.graphics.setBlendMode("multiply", "premultiplied")
				love.graphics.draw(light, LIGHTX, LIGHTY)
				love.graphics.setBlendMode("alpha")
				love.graphics.setCanvas()
			end
		end

		--game logic
		if LIGHT_BLINK == true and LIGHT_ON == true then
			if math.random(0, 100) <= 5 then
				BLINK = true
			end
			if math.random(0, 50) <= 20 then
				BLINK = false
			end
		end

		if currentRoom == Images["mainRoom"] then
			--windows
			win_left_anim:update(dt)
			win_right_anim:update(dt)
			--Timer.update(dt)

			if WIN_MOVE_L == false then
				Timer.after(10, function()
					WIN_MOVE_L = true
					win_left_anim:resume()
				end)
			end
			if WIN_MOVE_R == false then
				Timer.after(9, function()
					WIN_MOVE_R = true
					win_right_anim:resume()
				end)
			end

			if action_flag == 1 then
				action_flag = -1
				move = false
				tt_update = true
			end
			if tt_update == true then
				triggerTxt(dt)
			end
		elseif currentRoom == Images["leftRoom"] then
			father_anim_update(dt)
		elseif currentRoom == Images["rightRoom"] then
			enemy_update(dt)
		end

		if currentRoom == Images["secretRoom"] then
			SCENE.secretRoom_update(dt)
			Sounds.clock_tick:stop()
		elseif currentRoom == Images["atticRoom"] then
			SCENE.atticRoom_update(dt)
		elseif currentRoom == Images["leftRoom"] then
			left_room_update(dt)
		elseif currentRoom == Images["rightRoom"] then
			rightroom_update(dt)
		else
			Sounds.clock_tick:stop()
		end

		for _, v in ipairs(obj) do
			v:update(dt)
		end
		for _, v in ipairs(dialogue) do
			v:update(dt)
		end

		--enemy logics
		if DOOR_LOCKED == false then
			if ENEMY_EXISTS == true then
				if ghost_event ~= "no escape" then
					if move == true then
						ghost:update(dt)
					end
				else
					if ghost_chase == true then
						ghost:update(dt)
					end
				end
			end
		else
			ghost.x = -100
		end

		player:update(dt)

		if ClockPuzzle.state == true then
			puzzle_update(dt)
		end

		if event_trigger_light ~= -1 then
			if LIGHT_ON == true then
				if BLINK == true then
					light = Images.light2
				else
					light = Images.light
				end
			elseif LIGHT_ON == false then
				light = Images.light2
			end
		else
			if LIGHT_ON == true then
				light = Images.light_small
			elseif LIGHT_ON == false then
				light = Images.light2
			end
		end

		if GAMEOVER == true then
			if go_flag == 0 then
				go_flag = 1
			end
			GameOver.update(dt)
		end

		if go_flag == 1 then
			move = false
			GameOver.load()
			go_flag = -1
		end


		--it's mr. chair's time!
		if move_chair == true then
			mrChair:update(dt)
		end

		if mrChair.exists == false then
			pushing_anim = false
		end

		if candles_light_flag == true then
			if currentRoom == Images["masterRoom"] then
				local rand = 0.05
				local cx = 0 + (math.random(-rand, rand))
				local cy = HEIGHT_HALF - Images.candles_light_mask:getHeight() / 2 + (math.random(-rand, rand))
				love.graphics.setCanvas(CANVAS_CANDLES_FLASH)
				love.graphics.clear(0, 0, 0, LIGHT_VALUE)
				love.graphics.setBlendMode("multiply", "premultiplied")
				love.graphics.draw(Images.candles_light_mask, cx, cy)
				love.graphics.draw(light, LIGHTX, LIGHTY)
				love.graphics.setBlendMode("alpha")
				love.graphics.setCanvas()
			end
		end

		if storage_puzzle == true then
			storage_puzzle_update(dt)
		else
			love.keyboard.setTextInput(false)
		end
	end

	if temp_clock_gun ~= nil then
		move = false
		if temp_clock_gun < CLOCK - 3 then
			check_gun()
			temp_clock_gun = nil
		end
	end
end

local function draw_back_gui()
	if check_gui(gui_pos.b_x, gui_pos.b_y, gui_pos.b_w, gui_pos.b_h) then
		love.graphics.setColor(1, 0, 0, 1)
	else
		love.graphics.setColor(1, 1, 1, 1)
	end
	love.graphics.draw(Images.return_gui, gui_pos.b_x, gui_pos.b_y)
end

function gamestates.draw()
	local mx, my = love.mouse.getPosition()
	mx = mx / RATIO
	my = (my - TY) / RATIO

	local state = gamestates.getState()
	if ON_MOBILE and state == "adshow" then
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.printf(
			adTxt,
			0, 4,
			WIDTH,
			"center"
		)
		-- love.graphics.draw(Images.adIntro, 0, 0)
	elseif state == "splash" then
		love.graphics.setColor(1, 1, 1, 1)
		splash_anim:draw(Images.splash, WIDTH_HALF - 32, HEIGHT_HALF - 16)
	elseif state == "splash2" then
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(Images.wits, WIDTH_HALF - 64, HEIGHT_HALF - 32)
	elseif state == "title" then
		if instruction == false and about == false and questions == false and options == false then
			--main title screen art
			love.graphics.setColor(1, 1, 1, 1)
			local bgw, bgh = Images.bg:getDimensions()
			love.graphics.draw(Images.bg, WIDTH_HALF - bgw / 2, HEIGHT_HALF - bgh / 2)

			local ttw, tth = Images.title_text:getDimensions()
			local scale = 0.4
			love.graphics.draw(Images.title_text, WIDTH / 4, HEIGHT_HALF - 2, 0, scale, scale, ttw / 2, tth / 2)

			--start
			if cursor_pos == 1 then
				love.graphics.setColor(1, 0, 0, 1)
			else
				love.graphics.setColor(1, 1, 1, 1)
			end
			if mouse_select == true then
				if check_gui(gui_pos.start_x, gui_pos.start_y, gui_pos.start_w, gui_pos.start_h) then
					love.graphics.setColor(1, 0, 0, 1)
				else
					love.graphics.setColor(1, 1, 1, 1)
				end
			end
			love.graphics.draw(Images.start, gui_pos.start_x, gui_pos.start_y)

			--exit
			if OS ~= "iOS" then
				if cursor_pos == 2 then
					love.graphics.setColor(1, 0, 0, 1)
				else
					love.graphics.setColor(1, 1, 1, 1)
				end
				if mouse_select == true then
					if check_gui(gui_pos.quit_x, gui_pos.quit_y, gui_pos.quit_w, gui_pos.quit_h) then
						love.graphics.setColor(1, 0, 0, 1)
					else
						love.graphics.setColor(1, 1, 1, 1)
					end
				end

				love.graphics.draw(Images.exit, gui_pos.quit_x, gui_pos.quit_y)
			end

			--website
			if cursor_pos == 8 then
				love.graphics.setColor(1, 0, 0, 1)
			else
				love.graphics.setColor(1, 1, 1, 1)
			end
			if mouse_select == true then
				if check_gui(gui_pos.webx, gui_pos.weby, gui_pos.webw, gui_pos.webh) then
					love.graphics.setColor(1, 0, 0, 1)
				else
					love.graphics.setColor(1, 1, 1, 1)
				end
			end
			love.graphics.draw(Images.website_gui, gui_pos.webx, gui_pos.weby)

			--instruction
			if cursor_pos == 7 then
				love.graphics.setColor(1, 0, 0, 1)
			else
				love.graphics.setColor(1, 1, 1, 1)
			end
			if mouse_select == true then
				if check_gui(gui_pos.i_x, gui_pos.i_y, gui_pos.i_w, gui_pos.i_h) then
					love.graphics.setColor(1, 0, 0, 1)
				else
					love.graphics.setColor(1, 1, 1, 1)
				end
			end
			love.graphics.draw(Images.instruction_gui, gui_pos.i_x, gui_pos.i_y)

			--about
			if cursor_pos == 6 then
				love.graphics.setColor(1, 0, 0, 1)
			else
				love.graphics.setColor(1, 1, 1, 1)
			end
			if mouse_select == true then
				if check_gui(gui_pos.a_x, gui_pos.a_y, gui_pos.a_w, gui_pos.a_h) then
					love.graphics.setColor(1, 0, 0, 1)
				else
					love.graphics.setColor(1, 1, 1, 1)
				end
			end
			love.graphics.draw(Images.about, gui_pos.a_x, gui_pos.a_y)

			--questions
			if cursor_pos == 5 then
				love.graphics.setColor(1, 0, 0, 1)
			else
				love.graphics.setColor(1, 1, 1, 1)
			end
			if mouse_select == true then
				if check_gui(gui_pos.q_x, gui_pos.q_y, gui_pos.q_w, gui_pos.q_h) then
					love.graphics.setColor(1, 0, 0, 1)
				else
					love.graphics.setColor(1, 1, 1, 1)
				end
			end
			love.graphics.draw(Images.question, gui_pos.q_x, gui_pos.q_y)

			--gallery
			if cursor_pos == 4 then
				love.graphics.setColor(1, 0, 0, 1)
			else
				love.graphics.setColor(1, 1, 1, 1)
			end
			if mouse_select == true then
				if check_gui(gui_pos.g_x, gui_pos.g_y, gui_pos.g_w, gui_pos.g_h) then
					love.graphics.setColor(1, 0, 0, 1)
				else
					love.graphics.setColor(1, 1, 1, 1)
				end
			end
			love.graphics.draw(Images.gui_gallery, gui_pos.g_x, gui_pos.g_y)

			--options
			if cursor_pos == 3 then
				love.graphics.setColor(1, 0, 0, 1)
			else
				love.graphics.setColor(1, 1, 1, 1)
			end
			if mouse_select == true then
				if check_gui(gui_pos.options_x, gui_pos.options_y, gui_pos.options_w, gui_pos.options_h) then
					love.graphics.setColor(1, 0, 0, 1)
				else
					love.graphics.setColor(1, 1, 1, 1)
				end
			end
			love.graphics.draw(Images.options, gui_pos.options_x, gui_pos.options_y)

		elseif instruction == true and about == false and questions == false then
			draw_instructions()
			draw_back_gui()
		elseif options then
			love.graphics.setColor(0, 0, 0, 0)
			love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
			love.graphics.setFont(DEF_FONT)

			local str_options = "OPTIONS"
			love.graphics.setColor(1, 0, 0, 1)
			love.graphics.print(
				str_options,
				WIDTH_HALF - DEF_FONT:getWidth(str_options) / 2,
				-TY/4
			)

			love.graphics.setColor(1, 1, 1, 1)

			love.graphics.setLineWidth(1)
			love.graphics.setLineStyle("rough")

			local base_y = 4 + DEF_FONT_HEIGHT
			local rw = 8
			for i, item in ipairs(SaveData.get_opts()) do
				local str, value = item.str, item.value
				if not item.hide then
					local y = base_y + DEF_FONT_HEIGHT * (i - 1)
					local rx = WIDTH - 16 - rw / 2
					local ry = y + rw / 4

					if check_gui(16, y, DEF_FONT:getWidth(str), DEF_FONT_HEIGHT) or
						check_gui(rx, ry, rw, rw)
					then
						love.graphics.setColor(1, 0, 0, 1)
					else
						love.graphics.setColor(1, 1, 1, 1)
					end

					love.graphics.print(str, 16, base_y + DEF_FONT_HEIGHT * (i - 1))
					love.graphics.rectangle("line", rx, ry, rw, rw)
					if value then
						love.graphics.line(rx, ry, rx + rw, ry + rw)
						love.graphics.line(rx, ry + rw, rx + rw, ry)
					end
				end
			end

			draw_back_gui()
		elseif instruction == false and questions == true and about == false then
			--questions/support/contacts
			love.graphics.setColor(0, 0, 0, 0)
			love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
			love.graphics.setFont(DEF_FONT)
			love.graphics.setColor(1, 1, 1)

			local str_contact = "CONTACT US:"
			love.graphics.print(
				str_contact,
				WIDTH_HALF - DEF_FONT:getWidth(str_contact) / 2,
				DEF_FONT_HALF - 2
			)

			love.graphics.setColor(1, 0, 0)
			local str_twitter = "@flamendless"
			love.graphics.print(
				str_twitter,
				WIDTH_HALF - DEF_FONT:getWidth(str_twitter) / 2,
				12 + DEF_FONT_HALF
			)

			if OS ~= "iOS" then
				local str_donate = "donate"
				love.graphics.print(
					str_donate,
					WIDTH_HALF - DEF_FONT:getWidth(str_donate) / 2,
					28 + DEF_FONT_HALF
				)
			end

			local str_email = "e-mail"
			love.graphics.print(
				str_email,
				WIDTH_HALF - DEF_FONT:getWidth(str_email) / 2,
				44 + DEF_FONT_HALF
			)

			--questions
			if cursor_pos == 3 then
				love.graphics.setColor(1, 0, 0, 1)
			else
				love.graphics.setColor(1, 1, 1, 1)
			end

			--twitter
			if mouse_select == true then
				if check_gui(gui_pos.t_x, gui_pos.t_y, gui_pos.t_w, gui_pos.t_h) then
					love.graphics.setColor(1, 0, 0, 1)
				else
					love.graphics.setColor(1, 1, 1, 1)
				end
			end
			love.graphics.draw(Images.twitter, gui_pos.t_x, gui_pos.t_y)

			--paypal
			if OS ~= "iOS" then
				if mouse_select == true then
					if check_gui(gui_pos.p_x, gui_pos.p_y, gui_pos.p_w, gui_pos.p_h) then
						love.graphics.setColor(1, 0, 0, 1)
					else
						love.graphics.setColor(1, 1, 1, 1)
					end
				end
				love.graphics.draw(Images.paypal, gui_pos.p_x, gui_pos.p_y)
			end

			--email
			if mouse_select == true then
				if check_gui(gui_pos.e_x, gui_pos.e_y, gui_pos.e_w, gui_pos.e_h) then
					love.graphics.setColor(1, 0, 0, 1)
				else
					love.graphics.setColor(1, 1, 1, 1)
				end
			end
			love.graphics.draw(Images.email, gui_pos.e_x, gui_pos.e_y)
			draw_back_gui()
		end
		if about == true then
			love.graphics.setColor(0, 0, 0, 0)
			love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
			love.graphics.setFont(DEF_FONT)
			love.graphics.setColor(1, 1, 1)

			for i, str in ipairs(str_about) do
				if i == 1 then
					love.graphics.setColor(1, 0, 0, 1)
				else
					love.graphics.setColor(1, 1, 1, 1)
				end
				love.graphics.print(
					str,
					WIDTH_HALF - DEF_FONT:getWidth(str) / 2,
					DEF_FONT_HEIGHT * (i - 1) - TY/2
				)
			end
			draw_back_gui()
		end
	elseif state == "intro" then
		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
		love.graphics.setFont(DEF_FONT)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.print(intro_txt[intro_count], WIDTH_HALF - DEF_FONT:getWidth(intro_txt[intro_count]) / 2,
			HEIGHT_HALF - DEF_FONT_HALF)
		skip_draw()
	elseif state == "gallery" then
		Gallery.draw()
	elseif state == "rain_intro" then
		intro_draw()
	elseif state == "tutorial" then
		draw_instructions()
	elseif state == "main" then
		if currentRoom == Images["mainRoom"] then
			newRoom = Images["mainRoom_color"]
		elseif currentRoom == Images["livingRoom"] then
			newRoom = Images["livingRoom_color"]
		elseif currentRoom == Images["basementRoom"] then
			newRoom = Images["basementRoom_color"]
		elseif currentRoom == Images["leftRoom"] then
			newRoom = Images["leftRoom"]
		elseif currentRoom == Images["endRoom"] then
			newRoom = Images["endRoom"]
		end

		love.graphics.setColor(1, 1, 1, 1)
		local bgw, bgh = Images.bg:getDimensions()
		if ending_leave == false then
			love.graphics.draw(currentRoom, WIDTH_HALF - bgw / 2, HEIGHT_HALF - bgh / 2)
		else
			love.graphics.draw(newRoom, WIDTH_HALF - bgw / 2, HEIGHT_HALF - bgh / 2)
		end

		if currentRoom == Images["mainRoom"] then
			if ending_leave == false then
				love.graphics.setColor(1, 1, 1, 1)
				win_left_anim:draw(Images.window_left, WIDTH_HALF - bgw / 2, HEIGHT_HALF - bgh / 2)
				win_right_anim:draw(Images.window_right, WIDTH_HALF - bgw / 2, HEIGHT_HALF - bgh / 2)
			else
				love.graphics.setColor(1, 1, 1, 1)
				win_left_anim:draw(Images.window_left_color, WIDTH_HALF - bgw / 2, HEIGHT_HALF - bgh / 2)
				win_right_anim:draw(Images.window_right_color, WIDTH_HALF - bgw / 2, HEIGHT_HALF - bgh / 2)
			end
		elseif currentRoom == Images["leftRoom"] then
			father_anim_draw()
		elseif currentRoom == Images["rightRoom"] then
			enemy_draw()
		end

		for _, v in ipairs(obj) do
			v:draw()
		end

		if ending_leave == false then
			player:checkGlow()
		end

		if currentRoom == Images["secretRoom"] and event == "after_dialogue" then
			if tv_light_flag == true then
				love.graphics.setColor(1, 1, 1, 1)
				tv_anim:draw(Images.tv_anim, 113, 27)
			end
			if corpse_trigger == true then
				love.graphics.setColor(1, 1, 1, 1)
				corpse_fall_anim:draw(Images.corpse_anim, 90, 20)
			end
		end

		if currentRoom == Images["atticRoom"] then
			SCENE.atticRoom_draw()
		end

		--enemy logics
		if ENEMY_EXISTS == true then
			ghost:draw()
			light_check()
		end

		if move_chair == true then
			mrChair:draw()
		end

		player:draw()
		if ON_MOBILE then
			Android.light_draw()
		end

		if storage_puzzle == true then
			storage_puzzle_draw()
		end


		if ClockPuzzle.state == true then
			puzzle_draw()
		end

		if dust_trigger == true then
			particle_draw()
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.draw(Images.overlay, WIDTH_HALF - Images.bg:getWidth() / 2,
				HEIGHT_HALF - Images.bg:getHeight() / 2)
			love.graphics.setColor(0, 0, 0, 1)
			love.graphics.rectangle("fill", 0, HEIGHT_HALF + Images.bg:getHeight() / 2, WIDTH, HEIGHT)
		elseif ghost_event == "fall down" then
			particle_draw()
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.draw(Images.overlay, WIDTH_HALF - Images.bg:getWidth() / 2,
				HEIGHT_HALF - Images.bg:getHeight() / 2)
			love.graphics.setColor(0, 0, 0, 1)
			love.graphics.rectangle("fill", 0, HEIGHT_HALF + Images.bg:getHeight() / 2, WIDTH, HEIGHT)

			love.graphics.setColor(0, 0, 0, 1)
			love.graphics.rectangle("fill", 0, 0, Images.bg:getWidth(), Images.bg:getHeight() / 2)
		end

		if not ON_MOBILE and (not DEBUGGING) then
			if currentRoom == Images["secretRoom"] then
				if tv_light_flag == true then
					love.graphics.draw(CANVAS_TV_FLASH)
					love.graphics.setColor(1, 1, 1, 1)
				else
					love.graphics.draw(CANVAS_CUSTOM_MASK)
					love.graphics.setColor(1, 1, 1, 1)
				end
			elseif currentRoom == Images["masterRoom"] then
				if candles_light_flag == true then
					love.graphics.draw(CANVAS_CANDLES_FLASH)
					love.graphics.setColor(1, 1, 1, 1)
				else
					love.graphics.draw(CANVAS_CUSTOM_MASK)
					love.graphics.setColor(1, 1, 1, 1)
				end
			elseif currentRoom == Images["rightRoom"] then
				if right_light_flag == true then
					love.graphics.draw(CANVAS_RIGHT)
					love.graphics.setColor(1, 1, 1, 1)
				else
					love.graphics.draw(CANVAS_CUSTOM_MASK)
					love.graphics.setColor(1, 1, 1, 1)
				end
			elseif currentRoom == Images["leftRoom"] then
				if left_light_flag == true then
					love.graphics.draw(CANVAS_LEFT)
					love.graphics.setColor(1, 1, 1, 1)
				else
					love.graphics.draw(CANVAS_CUSTOM_MASK)
					love.graphics.setColor(1, 1, 1, 1)
				end
			else
				love.graphics.draw(CANVAS_CUSTOM_MASK)
				love.graphics.setColor(1, 1, 1, 1)
			end
		end

		if currentRoom == Images["secretRoom"] then
			if event == "after_secret_room" then
				if text1_flag == true then
					love.graphics.setColor(1, 1, 1, 1)
					love.graphics.print(txt1, txt1_x, txt1_y)
				end
			end
			SCENE.secretRoom_draw()
		elseif currentRoom == Images["leftRoom"] then
			left_room_draw()
		elseif currentRoom == Images["rightRoom"] then
			rightroom_draw()
		end

		if ending_leave == true then
			if currentRoom ~= Images["leftRoom"] then
				leave_event_draw()
			end
		end

		if ON_MOBILE then
			Android.draw()
		end
		for _, v in ipairs(dialogue) do
			v:draw()
		end
		if GAMEOVER == true then
			GameOver.draw()
		end

		--trigger txt
		if tt_draw == true then
			triggerTxt_draw()
		end
	end

	fade:draw()
end

function gamestates.control()
	if instruction == false and about == false and questions == false and options == false then
		STATES = "rain_intro"
		gamestates.load()
	end
end

function gamestates.nextState(state)
	print(string.format("%s -> %s", STATES, state))
	STATES = state
	gamestates.load()
end

function light_check()
	if ON_MOBILE or DEBUGGING == true then
		Android.light_check()
	else
		local mx = love.mouse.getX() / RATIO
		local my = (love.mouse.getY() - TY) / RATIO
		local rad = 10
		local gx = ghost.x - ghost.ox
		--debugging

		--inside
		if fade.state == false then
			if ENEMY_EXISTS == true and LIGHT_ON == true then
				if mx >= gx - ghost.w / 2 and mx <= gx + ghost.w + ghost.w / 2 then
					if my >= ghost.y - ghost.h / 1.5 and my <= ghost.y + ghost.y + ghost.h / 1.5 then
						ghost:action_inside()
					end
					--near
				elseif mx >= gx - rad and mx <= gx + ghost.w + rad then
					ghost:action_near()
					--no action
				else
					ghost:action_none()
				end
			end
		end
	end
end

function determine_enemy_pos()
	local left = 14
	local right = WIDTH - 14

	if ghost.chaseOn == false then
		if player.x <= WIDTH_HALF - l + 1 then --player is in the left
			ghost.x = right
			ghost.xscale = -1
		elseif player.x >= WIDTH_HALF + r + 1 then --player is in the right
			ghost.x = left
			ghost.xscale = 1
		elseif player.x >= WIDTH_HALF - l then --player in mid
			if player.x <= WIDTH_HALF + r then
				ghost.x = Lume.randomchoice({ left, right })
				ghost.xscale = 1
			end
		end
	else
		if player.x <= WIDTH_HALF - l + 1 then
			ghost.x = right
		elseif player.x >= WIDTH_HALF + r + 1 then
			ghost.x = left
		elseif player.x >= WIDTH_HALF - l then --player in mid
			if player.x <= WIDTH_HALF + r then
				ghost.x = Lume.randomchoice({ left, right })
				ghost.xscale = 1
			end
		end
	end
end

function enemy_check()
	local random = math.floor(math.random(0, 100))
	if ENEMY_EXISTS == true then
		if random <= 40 then
			--enemy disappears
			ENEMY_EXISTS = false
			ghost.timer = 2
			ghost.count = true
			ghost.chaseOn = false
		else
			determine_enemy_pos()
		end
	else --enemy does not exists
		if event_trigger_light == -1 and random <= 60 then
			--enemy appears
			ENEMY_EXISTS = true
			--move enemy
			determine_enemy_pos()
		elseif random <= 50 then
			--enemy appears
			ENEMY_EXISTS = true
			--move enemy
			determine_enemy_pos()
		end
	end
end

local skip_alpha = 0
local skip_dir = 1
function skip_draw()
	if skip_alpha >= 1 then
		skip_dir = -1
	elseif skip_alpha < 0 then
		skip_dir = 1
		return
	end
	skip_alpha = skip_alpha + love.timer.getDelta() * 0.5 * skip_dir
	skip_alpha = math.clamp(skip_alpha, 0, 1)
	love.graphics.setColor(1, 1, 1, skip_alpha)
	local skip_text
	if ON_MOBILE then
		skip_text = "tap to skip"
	else
		skip_text = "press any key to skip"
	end
	love.graphics.print(
		skip_text,
		WIDTH_HALF - DEF_FONT:getWidth(skip_text) / 2,
		HEIGHT - DEF_FONT_HEIGHT
	)
end

function random_page()
	local random = math.floor(math.random(1, 4))
	local sound = Sounds["page" .. tostring(random)]
	sound:play()
	sound:setLooping(false)
end

function light_etc(dt, img_table, img_var, canvas)
	LIGHT_ON = false
	local r = 0.05
	local x = 0 + (math.random(-r, r))
	local y = HEIGHT_HALF - img_table[img_var]:getHeight() / 2 + (math.random(-r, r))
	love.graphics.setCanvas(canvas)
	love.graphics.clear(0, 0, 0, LIGHT_VALUE)
	love.graphics.setBlendMode("multiply", "premultiplied")
	love.graphics.draw(img_table[img_var], x, y)
	if ON_MOBILE or DEBUGGING then
		local lx, ly = Android.get_light_pos()
		love.graphics.draw(mainLight, lx, ly)
	elseif not ON_MOBILE and (not DEBUGGING) then
		love.graphics.draw(light, LIGHTX, LIGHTY)
	end
	love.graphics.setBlendMode("alpha")
	love.graphics.setCanvas()

	function getLightEtc()
		return x, y
	end
end

function lightning(dt)
	if lightning_flash == true then
		local random = math.floor(math.random(0, 1000))
		if random <= 5 then
			if Sounds.lightning:isPlaying() == false then
				Sounds.lightning:play()
				Sounds.lightning:setVolume(lightningVol)
				Sounds.lightning:setLooping(false)
			end
		end
	end
	-- local duration = Sounds.lightning:getDuration("seconds")
	local tell = Sounds.lightning:tell()
	local amount = 0.25
	if fade.state == false then
		if ending_leave_event ~= 2 then
			if (tell >= 6 and tell <= 7) then
				LIGHT_VALUE = Lume.lerp(LIGHT_VALUE, 0, amount)
				lStrike = true
			else
				LIGHT_VALUE = Lume.lerp(LIGHT_VALUE, 1, amount)
				lStrike = false
			end
		end
	else
		LIGHT_VALUE = 1
	end
end

function check_gui(gx, gy, gw, gh)
	local mx, my = love.mouse.getPosition()
	mx = mx / RATIO
	my = (my - TY) / RATIO
	return mx >= gx and mx <= gx + gw and my >= gy and my <= gy + gh
end

function triggerTxt(dt)
	move = false

	if _alarm > 0 then
		_alarm = _alarm - 1 * dt
		tt_draw = true
	elseif _alarm <= 0 then
		if t == 1 then
			_alarm = 2
			t = 2
			move = true
		elseif t == 2 then
			_alarm = 4
			t = 3
			move = false
			Sounds.enemy_scream:play()
			Sounds.enemy_scream:setVolume(0.9)
			Sounds.enemy_scream:setLooping(false)
		elseif t == 3 then
			move = true
			tt_update = false
			tt_draw = false
		end
	end
end

function triggerTxt_draw()
	local as = "What was that?!"
	local as2 = "I have to find them quick!"
	if tt_draw == true then
		if t == 1 then
			love.graphics.print(tt_txt, WIDTH_HALF - DEF_FONT:getWidth(tt_txt) / 2, 0 + DEF_FONT_HEIGHT / 4)
			love.graphics.print(tt_txt2, WIDTH_HALF - DEF_FONT:getWidth(tt_txt2) / 2, HEIGHT - DEF_FONT_HEIGHT)
		elseif t == 2 then
			love.graphics.print("", WIDTH_HALF - DEF_FONT:getWidth(" ") / 2, 0 + DEF_FONT_HEIGHT / 4)
			love.graphics.print("", WIDTH_HALF - DEF_FONT:getWidth(" ") / 2, HEIGHT - DEF_FONT_HEIGHT)
		elseif t == 3 then
			if Sounds.enemy_scream:isPlaying() == false then
				love.graphics.print(as, WIDTH_HALF - DEF_FONT:getWidth(as) / 2, 0 + DEF_FONT_HEIGHT / 4)
				love.graphics.print(as2, WIDTH_HALF - DEF_FONT:getWidth(as2) / 2, HEIGHT - DEF_FONT_HEIGHT)
			end
		end
	end
end

function seconds_to_clock(seconds)
	seconds = tonumber(seconds)
	if seconds <= 0 then
		return "00:00:00"
	else
		local hours = string.format("%02.f", math.floor(seconds / 3600))
		local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))
		return hours .. ":" .. mins .. ":" .. secs
	end
end

function dev_draw()
	if DEBUGGING == true then
		love.graphics.push()
		love.graphics.scale(1 / 4)
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.setFont(DEF_FONT)
		love.graphics.print("DEV VERSION", WIDTH * 3.65, HEIGHT * 3.8)
		love.graphics.pop()
	end
end
