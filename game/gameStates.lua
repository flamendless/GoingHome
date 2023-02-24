gamestates = {}

about = false
questions = false
door_locked = true
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

clock_puzzle = false

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
credits = ""
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
l,r = 0,0
adTimer = 5
adTxt = {
"Please Allow Ads In The Game",
"To Support The Developer",
"The Ads will be unintrusive",
"to the gameplay.",
"or buy the adless version" }
lightningVol = 0.3

function gamestates.load()

	go_flag = 0
	mid_dial = 0

	random_breathe = true

	txt = "press I for instruction"
	fade = Fade(1,6)
	instruction = false
	doors_locked = true
	action_flag = 0
	tt_update = false

	intro_txt = {
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

	intro_count = 1
	intro_timer = 2.5
	intro_finished = false

	local state = gamestates.getState()
	if state == "gallery" then
		sounds.ts_theme:stop()
	end

	if state == "adshow" then
		assets.load()
		FC:init()
		FC:GDPR_init()
	end
	if state == "splash" then
		if pro_version then
			assets.load()
		end
		splash_timer = hump_timer:new()
		splash_timer:after(3, function()
			--states = "splash2"
			gamestates.nextState("splash2")
		end)
		logoTimer = hump_timer:new()
		logoTimer:after(3, function()
			--states = "title"
			gamestates.nextState("title")
		end)
	end

	if state == "title" then
		--set music
		sounds.ts_theme:setLooping(true)
		sounds.ts_theme:play()
		sounds.ts_theme:setVolume(0.5)
		sounds.fl_toggle:setLooping(false)
		sounds.fl_toggle:setVolume(1)

		if love.system.getOS() == "Android" then
			if pro_version == false then
				--love.system.createBanner("ca-app-pub-1904940380415570/7680044440", "top", "SMART_BANNER")
				--love.system.createInterstitial("ca-app-pub-1904940380415570/4174848045")
				--love.system.createBanner("ca-app-pub-8754873203122588/8539475757","top","SMART_BANNER")
				--love.system.createInterstitial("ca-app-pub-8754873203122588/1016208959")
				--love.system.createBanner("ca-app-pub-8754873203122588/6992910037","top","SMART_BANNER")
				--love.system.createInterstitial("ca-app-pub-8754873203122588/1596101364")
				show_ads()
				--love.ads.createBanner(_ads.banner,"top")
				--love.ads.requestInterstitial(_ads.inter)
				--love.ads.showBanner()
				--if love.ads.isInterstitialLoaded() then
					--print("show interstitial ad")
					--love.ads.showInterstitial()
				--end
			end
		end
	end

	if state == "rain_intro" then
		sounds.ts_theme:stop()
		intro_load()
	end

	if state == "intro" then
		sounds.knock:play()
		sounds.enemy_scream:setLooping(false)
		sounds.intro_soft:stop()
	end

	if state == "main" then

		sounds.rain:setLooping(true)
		sounds.rain:setVolume(0.8)
		sounds.rain:play()
		sounds.ts_theme:stop()

		fade.state = true
		move = true
		lv = 1

		--create dynamic objects
		player = Player(width/2,height/2 ,8,16)
		ghost = Enemy(42, 30,12,14)

		mrChair = Chair()

		enemy_exists = false
		seen = false
		gameover = false

		currentRoom = images["mainRoom"]
		--locked doors
		locked = Set{
			"mainRoom_right",
			"livingRoom_mid",
			"masterRoom_mid"
		}

		obtainables = Set{
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
		}
	end
end

function gamestates.getState()
	return states
end



function gamestates.update(dt)
	local mx, my = love.mouse.getPosition()
	mx = mx/ratio
	my = (my+ty)/ratio

	if currentRoom == images["leftRoom"] or
		currentRoom == images["rightRoom"] or
		currentRoom == images["basementRoom"] or
		ending_leave == true then

		 enemy_exists = false
	end

	local state = gamestates.getState()
	fade:update(dt)

	if state == "gallery" then
		Gallery.update(dt)
	end

	if state == "adshow" then
		if love.system.getOS() == "Android" then
			if adTimer > 0 then
				adTimer = adTimer - 1 * dt
				if adTimer <= 0 then
					states = "splash"
					gamestates.load()
				end
			end
		else
			states = "splash"
			gamestates.load()
		end
	end

	if state == "splash" then
		splash_anim:update(dt)
		if splash_finished then
			splash_timer:update(dt)
		end
	end
	if state == "splash2" then
		logoTimer:update(dt)
	end
	if state == "title" then
		if instruction == false and about == false and questions == false then
			if check_gui(gui_pos.start_x,gui_pos.start_y,gui_pos.start_w,gui_pos.start_h) or
				check_gui(gui_pos.quit_x,gui_pos.quit_y,gui_pos.quit_w,gui_pos.quit_h) or
				check_gui(gui_pos.i_x,gui_pos.i_y,gui_pos.i_w,gui_pos.i_h) or
				check_gui(gui_pos.a_x,gui_pos.a_y,gui_pos.a_w,gui_pos.a_h) or
				check_gui(gui_pos.q_x,gui_pos.q_y,gui_pos.q_w,gui_pos.q_h) or
				check_gui(gui_pos.webx,gui_pos.weby,gui_pos.webw,gui_pos.webh) or
				check_gui(gui_pos.g_x, gui_pos.g_y, gui_pos.g_w, gui_pos.g_h)
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

		--windows
		win_left_anim:update(dt)
		win_right_anim:update(dt)
		Timer.update(dt)

		if win_move_l == false then
			Timer.after(10, function() win_move_l = true  win_left_anim:resume() end)
		end
		if win_move_r == false then
			Timer.after(9, function() win_move_r = true win_right_anim:resume() end)
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

			if sounds.unlock:isPlaying() == false then
				sounds.unlock:play()
			end
			states = "main"
			gamestates.load()
		end

		--sounds
		--loop rain and thunder
		--knock
		--unlock
		if thunder_play == true then
			local c = intro_count % 2
			if c ~= 1 then
				sounds.thunder:play()
			end
		end

		if sounds.knock:isPlaying() == false then
			if sounds.rain:isPlaying() == false then
				sounds.rain:play()
			end
		end

		skip_button:update(dt)

			-----MAIN-------
	elseif  state == "main" then

		if move == true then
			player:movement(dt)
		end

		if ending_leave == true then
			if currentRoom ~= images["leftRoom"] then
				leave_event_update(dt)
			end
		end

		for k,v in pairs(dialogue) do
			if v.tag == "clock" then
				if move == true then
					v.specialTxt = false
				end
			end
		end


		Timer.update(dt)

		if gameover == false then
			if event ~= "after_secret_room" and
				ghost_event ~= "no escape" and
				ghost_event ~= "still no escape" and
				ghost_event ~= "fall down" and
				ghost_event ~= "lying down" and
				ghost_event ~= "flashback" and
				ghost_event ~= "limp" then
				if currentRoom ~= images["basementRoom"] and
					currentRoom ~= images["leftRoom"] and
					currentRoom ~= images["rightRoom"] and
					currentRoom ~= images["storageRoom"] and
					currentRoom ~= images["daughterRoom"] and
					currentRoom ~= images["secretRoom"] and
					currentRoom ~= images["atticRoom"] and
					currentRoom ~= images["endRoom"] and
					ending_leave ~= true then
					sounds.lightning:setVolume(lightningVol)
					if not sounds.lightning:isPlaying() == true then
						sounds.lightning:play()
					end
				else
					sounds.lightning:setVolume(0.6)
				end
				lightning()
			else
				sounds.lightning:stop()
				if ghost_event == "flashback" and
				flash_text_finished == true then
					lv = 0
				else
					lv = 1
				end
			end
		end

		if ending_leave == true then
			sounds.rain:stop()
		end

		local choose = math.floor(math.random(1,3))
		local random = math.floor(math.random(5,10))
		local num = "breath_"

		if random_breathe_flag == true then
			if random_breathe == true then
				random_breathe = false
				Timer.after(random,function()
					sounds[num .. tostring(choose)]:play()
					sounds[num .. tostring(choose)]:setVolume(0.5)
					random_breathe = true
				end)
			end
		end
		---------------------------
		if gameover == false then
			if love.system.getOS() == "Android" or love.system.getOS() == "iOS" or debug == true then
				--android.lightCircle()
			elseif love.system.getOS() ~= "Android" or love.system.getOS() == "iOS" and debug == false then
				if event_trigger_light == -1 then
					_lightX = mx - images.light_small:getWidth()/2 + math.random(-0.05,0.05)
					_lightY = my - images.light_small:getHeight()/2 + math.random(-0.05,0.05)
				else
					_lightX = mx - images.light:getWidth()/2 + math.random(-0.05,0.05)
					_lightY = my - images.light:getHeight()/2 + math.random(-0.05,0.05)
				end
				lightX = math.clamp(_lightX, player.x - 120, player.x + 100)
				lightY = math.clamp(_lightY, player.y - 20, player.y + 0)

				love.graphics.setCanvas(custom_mask)
				love.graphics.clear(0,0,0,lv)
				love.graphics.setBlendMode("multiply", "premultiplied")
				love.graphics.draw(light,lightX,lightY)
				love.graphics.setBlendMode("alpha")
				love.graphics.setCanvas()
			end
		end

		--game logic
		if light_blink == true and lightOn == true then
			if math.random(0,100) <= 5 then
				blink = true
			end
			if math.random(0,50) <= 20 then
				blink = false
			end
		end

		if currentRoom == images["mainRoom"] then
			--windows
			win_left_anim:update(dt)
			win_right_anim:update(dt)
			--Timer.update(dt)

			if win_move_l == false then
				Timer.after(10, function() win_move_l = true  win_left_anim:resume() end)
			end
			if win_move_r == false then
				Timer.after(9, function() win_move_r = true win_right_anim:resume() end)
			end

			if action_flag == 1 then
				action_flag = -1
				move = false
				tt_update = true
			end
			if tt_update == true then
				triggerTxt(dt)
			end
		elseif currentRoom == images["leftRoom"] then
			father_anim_update(dt)
		elseif currentRoom == images["rightRoom"] then
			enemy_update(dt)
		end

		if currentRoom == images["secretRoom"] then
			SCENE.secretRoom_update(dt)
			sounds.clock_tick:stop()
		elseif currentRoom == images["atticRoom"] then
			SCENE.atticRoom_update(dt)
		elseif currentRoom == images["leftRoom"] then
			left_room_update(dt)
		elseif currentRoom == images["rightRoom"] then
			rightroom_update(dt)
		else
			sounds.clock_tick:stop()
		end

		for k,v in pairs(obj) do
			v:update(dt)
		end
		for k,v in pairs(dialogue) do
			v:update(dt)
		end

		--enemy logics
		if door_locked == false then
			if enemy_exists == true then
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

		if clock_puzzle == true then
			puzzle_update(dt)
		end

		if event_trigger_light ~= -1 then
			if lightOn == true then
				if blink == true then
					light = images.light2
				else
					light = images.light
				end
			elseif lightOn == false then
				light = images.light2
			end
		else
			if lightOn == true then
				light = images.light_small
			elseif lightOn == false then
				light = images.light2
			end
		end

		if gameover == true then
			if go_flag == 0 then
				go_flag = 1
			end
			game_over.update(dt)
		end

		if go_flag == 1 then
			move = false
			game_over.load()
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
			if currentRoom == images["masterRoom"] then
				local rand = 0.05
				local cx = 0 + (math.random(-rand,rand))
				local cy = height/2 - images.candles_light_mask:getHeight()/2 + (math.random(-rand,rand))
				function getCandles()
					return cx,cy
				end
				love.graphics.setCanvas(candles_flash)
				love.graphics.clear(0,0,0,lv)
				love.graphics.setBlendMode("multiply", "premultiplied")
				love.graphics.draw(images.candles_light_mask,cx,cy)
				love.graphics.draw(light,lightX,lightY)
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
		if temp_clock_gun < clock - 3 then
			check_gun()
			temp_clock_gun = nil
		end
	end
end

function gamestates.draw()
	local mx, my = love.mouse.getPosition()
	mx = mx/ratio
	my = (my-ty)/ratio

	local state = gamestates.getState()
	if state == "adshow" then
		if love.system.getOS() == "Android" or love.system.getOS() == "iOS" then
				love.graphics.setColor(1, 1, 1, 1)
				love.graphics.draw(images.adIntro,0,0)
		end
	end
	if state == "splash" then
		love.graphics.setColor(1, 1, 1, 1)
		splash_anim:draw(images.splash,width/2 - 32,height/2 - 16 )
	end
	if state == "splash2" then
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(images.gigadrill, width/2 - 64,height/2 - 32)
	end
	if state == "title" then
		if instruction == false and about == false and questions == false then
			--main title screen art
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.draw(images.bg,width/2 - images.bg:getWidth()/2,height/2 - images.bg:getHeight()/2)


			--start
			if cursor_pos == 1 then
				love.graphics.setColor(1, 0, 0, 1)
			else
				love.graphics.setColor(1, 1, 1, 1)
			end
			if mouse_select == true then
				if check_gui(gui_pos.start_x,gui_pos.start_y,gui_pos.start_w,gui_pos.start_h)  then
					love.graphics.setColor(1, 0, 0, 1)
				else
				 	love.graphics.setColor(1, 1, 1, 1)
				end
			end
			love.graphics.draw(images.start,gui_pos.start_x,gui_pos.start_y)
			--exit
			if love.system.getOS() ~= "iOS" then
				if cursor_pos == 2 then
					love.graphics.setColor(1, 0, 0, 1)
				else
					love.graphics.setColor(1, 1, 1, 1)
				end
				if mouse_select == true then
					if check_gui(gui_pos.quit_x,gui_pos.quit_y,gui_pos.quit_w,gui_pos.quit_h)   then
						love.graphics.setColor(1, 0, 0, 1)
					else
				 		love.graphics.setColor(1, 1, 1, 1)
					end
				end

				love.graphics.draw(images.exit, gui_pos.quit_x , gui_pos.quit_y)
			end

			--if love.system.getOS() == "Android" or debug == true then
--
			--else

			--website
			if cursor_pos == 6 then
				love.graphics.setColor(1, 0, 0, 1)
			else
				love.graphics.setColor(1, 1, 1, 1)
			end
			if mouse_select == true then
				if check_gui(gui_pos.webx,gui_pos.weby,gui_pos.webw,gui_pos.webh) then
					love.graphics.setColor(1, 0, 0, 1)
				else
					love.graphics.setColor(1, 1, 1, 1)
				end
			end
			love.graphics.draw(images.website_gui,gui_pos.webx,gui_pos.weby)

			--instruction
			if cursor_pos == 5 then
				love.graphics.setColor(1, 0, 0, 1)
			else
				love.graphics.setColor(1, 1, 1, 1)
			end
			if mouse_select == true then
				if check_gui(gui_pos.i_x,gui_pos.i_y,gui_pos.i_w,gui_pos.i_h) then
					love.graphics.setColor(1, 0, 0, 1)
				else
					love.graphics.setColor(1, 1, 1, 1)
				end
			end
			love.graphics.draw(images.instruction_gui,gui_pos.i_x, gui_pos.i_y)

			--about
			if cursor_pos == 4 then
				love.graphics.setColor(1, 0, 0, 1)
			else
				love.graphics.setColor(1, 1, 1, 1)
			end
			if mouse_select == true then
				if check_gui(gui_pos.a_x,gui_pos.a_y,gui_pos.a_w,gui_pos.a_h)then
					love.graphics.setColor(1, 0, 0, 1)
				else
					love.graphics.setColor(1, 1, 1, 1)
				end
			end
			love.graphics.draw(images.about,gui_pos.a_x , gui_pos.a_y)

			--questions
			if cursor_pos == 3 then
				love.graphics.setColor(1, 0, 0, 1)
			else
				love.graphics.setColor(1, 1, 1, 1)
			end
			if mouse_select == true then
				if check_gui(gui_pos.q_x,gui_pos.q_y,gui_pos.q_w,gui_pos.q_h) then
					love.graphics.setColor(1, 0, 0, 1)
				else
					love.graphics.setColor(1, 1, 1, 1)
				end
			end
			love.graphics.draw(images.question,gui_pos.q_x,gui_pos.q_y)
		--end

		if pro_version then
			if mouse_select == true and check_gui(gui_pos.g_x, gui_pos.g_y, gui_pos.g_w, gui_pos.g_h) then
				love.graphics.setColor(1, 0, 0, 1)
			else
				love.graphics.setColor(1, 1, 1, 1)
			end
			love.graphics.draw(images.gui_gallery, gui_pos.g_x, gui_pos.g_y)
		end

		elseif instruction == true and about == false and questions == false then
			love.graphics.setColor(0,0,0,0)
			love.graphics.rectangle("fill",0,0,width,height)
			love.graphics.setFont(font)
			love.graphics.setColor(1, 1, 1)
			if love.system.getOS() == "Android" or love.system.getOS() == "iOS" or debug == true then
				love.graphics.print("Navigate through the house",width/2 - font:getWidth("Navigate through the house")/2,0+font:getHeight("Navigate through the house")/2)
				love.graphics.print("using but a little light.",width/2 - font:getWidth("using but a little light.")/2,10+font:getHeight("using but a little light.")/2)
				-- love.graphics.print("Avoid the fear that haunts.", width/2 - font:getWidth("Avoid the fear that haunts.")/2,height - 8 - font:getHeight("Avoid the fear that haunts.")/2)
				love.graphics.setColor(1, 1, 1)
				love.graphics.print("Avoid the fear that haunts.",width/2 - font:getWidth("Avoid the fear that haunts.")/2,22+font:getHeight("Avoid the fear that haunts.")/2)
				love.graphics.setColor(1, 0, 0)
				love.graphics.print("It must not be exposed to light.",width/2-font:getWidth("It must not be exposed to light.")/2,34+font:getHeight("It must not be exposed to light.")/2)
			else
				love.graphics.print("F to toggle flashlight",width/2 - font:getWidth("F to toggle flashlight")/2,0+font:getHeight("F to toggle flashlight")/2)
				love.graphics.print("E to perform actions",width/2 - font:getWidth("E to perform actions")/2,10+font:getHeight("E to perform actions")/2)
				love.graphics.print("P to pause", width/2 - font:getWidth("P to pause")/2,height - 8 - font:getHeight("P to return")/2)
				love.graphics.setColor(1, 1, 1)
				love.graphics.print("A and D to move",width/2 - font:getWidth("W and D to move")/2,22+font:getHeight("W and D to move")/2)
				love.graphics.setColor(1, 0, 0)
				love.graphics.print("ENTER/ESC on Puzzle Events",width/2-font:getWidth("ENTER/ESC on Puzzle Events")/2,34+font:getHeight("ENTER/ESC on Puzzle Events")/2)
			end
			--back gui
			if check_gui(gui_pos.b_x,gui_pos.b_y,gui_pos.b_w,gui_pos.b_h) then
				love.graphics.setColor(1, 0, 0, 1)
			else
				love.graphics.setColor(1, 1, 1, 1)
			end
			love.graphics.draw(images.return_gui,gui_pos.b_x,gui_pos.b_y)

		elseif instruction == false and questions == true and about == false then

			--questions/support/contacts
			love.graphics.setColor(0,0,0,0)
			love.graphics.rectangle("fill",0,0,width,height)
			love.graphics.setFont(font)
			love.graphics.setColor(1, 1, 1)
			love.graphics.print("Contact me on the following:",width/2 - font:getWidth("Contact me on the following:")/2,font:getHeight("Contact me on the following:")/2 - 4)

			love.graphics.setColor(1, 0, 0)
			love.graphics.print("Twitter: @flamendless",20,15)
			if love.system.getOS() ~= 'iOS' then
				love.graphics.print("Donate: Paypal",36,32)
			end
			love.graphics.print("E-Mail: google mail",25,49)
			--questions
			if cursor_pos == 3 then
				love.graphics.setColor(1, 0, 0, 1)
			else
				love.graphics.setColor(1, 1, 1, 1)
			end
			--twitter
			if mouse_select == true then
				if check_gui(gui_pos.t_x,gui_pos.t_y,gui_pos.t_w,gui_pos.t_h) then
					love.graphics.setColor(1, 0, 0, 1)
				else
					love.graphics.setColor(1, 1, 1, 1)
				end
			end
			love.graphics.draw(images.twitter,gui_pos.t_x,gui_pos.t_y)
			--paypal
			if love.system.getOS() ~= "iOS" then
			if mouse_select == true then
				if check_gui(gui_pos.p_x,gui_pos.p_y,gui_pos.p_w,gui_pos.p_h) then
					love.graphics.setColor(1, 0, 0, 1)
				else
					love.graphics.setColor(1, 1, 1, 1)
				end
			end
			love.graphics.draw(images.paypal,gui_pos.p_x,gui_pos.p_y)
			end
			--email
			if mouse_select == true then
				if check_gui(gui_pos.e_x,gui_pos.e_y,gui_pos.e_w,gui_pos.e_h) then
					love.graphics.setColor(1, 0, 0, 1)
				else
					love.graphics.setColor(1, 1, 1, 1)
				end
			end
			love.graphics.draw(images.email,gui_pos.e_x,gui_pos.e_y)
			--back gui
			if check_gui(gui_pos.b_x,gui_pos.b_y,gui_pos.b_w,gui_pos.b_h) then
				love.graphics.setColor(1, 0, 0, 1)
			else
				love.graphics.setColor(1, 1, 1, 1)
			end
			love.graphics.draw(images.return_gui,gui_pos.b_x,gui_pos.b_y)
		end
		if about == true then
			love.graphics.setColor(0,0,0,0)
			love.graphics.rectangle("fill",0,0,width,height)
			love.graphics.setFont(font)
			love.graphics.setColor(1, 1, 1)
			love.graphics.print("Softwares Used:",width/2 - font:getWidth("Softwares Used:")/2,font:getHeight("Softwares Used:")/2 - 4)
			love.graphics.print("ide: sublime text 3",width/2 - font:getWidth("ide: sublime text 3")/2,font:getHeight("ide: sublime text 3") + 20)
			love.graphics.print("pixel art: aseprite",width/2 - font:getWidth("pixel art: aseprite")/2,font:getHeight("pixel art: aseprite") + 28)
			love.graphics.print("source control: git",width/2 - font:getWidth("source control: git")/2,font:getHeight("source control: git") + 36)
			love.graphics.print("os: xubuntu xenial xerxus",width/2 - font:getWidth("os: xubuntu xenial xerxus")/2,font:getHeight("os: xubuntu xenial xerxus") + 12)
			love.graphics.print("sounds: musescore & audacity",width/2 - font:getWidth("sounds: musescore & audacity")/2,font:getHeight("sounds: musescore & audacity") + 4)
			--back gui
			if check_gui(gui_pos.b_x,gui_pos.b_y,gui_pos.b_w,gui_pos.b_h) then
				love.graphics.setColor(1, 0, 0, 1)
			else
				love.graphics.setColor(1, 1, 1, 1)
			end
			love.graphics.draw(images.return_gui,gui_pos.b_x,gui_pos.b_y)
		end
	elseif state == "intro" then

		love.graphics.setColor(0,0,0,1)
		love.graphics.rectangle("fill",0,0,width,height)
		love.graphics.setFont(font)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.print(intro_txt[intro_count],width/2 - font:getWidth(intro_txt[intro_count])/2,height/2 - font:getHeight(intro_txt[intro_count])/2)
		skip_draw()

	elseif state == "gallery" then
		Gallery.draw()
	elseif state == "rain_intro" then
		intro_draw()

	elseif state == "main" then

		if currentRoom == images["mainRoom"] then
			newRoom = images["mainRoom_color"]
		elseif currentRoom == images["livingRoom"] then
			newRoom = images["livingRoom_color"]
		elseif currentRoom == images["basementRoom"] then
			newRoom = images["basementRoom_color"]
		elseif currentRoom == images["leftRoom"] then
			newRoom = images["leftRoom"]
		elseif currentRoom == images["endRoom"] then
			newRoom = images["endRoom"]
		end

		love.graphics.setColor(1, 1, 1, 1)
		if ending_leave == false then
			love.graphics.draw(currentRoom,width/2 - images.bg:getWidth()/2,height/2 - images.bg:getHeight()/2)
		else
			love.graphics.draw(newRoom,width/2 - images.bg:getWidth()/2,height/2 - images.bg:getHeight()/2)
		end

		if currentRoom == images["mainRoom"] then
			if ending_leave == false then
				love.graphics.setColor(1, 1, 1, 1)
				win_left_anim:draw(images.window_left,width/2 - images.bg:getWidth()/2,height/2 - images.bg:getHeight()/2)
				win_right_anim:draw(images.window_right,width/2 - images.bg:getWidth()/2,height/2 - images.bg:getHeight()/2)
			else
				love.graphics.setColor(1, 1, 1, 1)
				win_left_anim:draw(images.window_left_color,width/2 - images.bg:getWidth()/2,height/2 - images.bg:getHeight()/2)
				win_right_anim:draw(images.window_right_color,width/2 - images.bg:getWidth()/2,height/2 - images.bg:getHeight()/2)
			end
		elseif currentRoom == images["leftRoom"] then
			father_anim_draw()
		elseif currentRoom == images["rightRoom"] then
			enemy_draw()
		end

		for k,v in pairs(obj) do
			v:draw()
		end

		if ending_leave == false then
			player:checkGlow()
		end

		if currentRoom == images["secretRoom"] then
			if event == "after_dialogue" then
				if tv_light_flag == true then
					love.graphics.setColor(1, 1, 1, 1)
			    	tv_anim:draw(images.tv_anim,113,27)
			    end
			    if corpse_trigger == true then
					love.graphics.setColor(1, 1, 1, 1)
					corpse_fall_anim:draw(images.corpse_anim,90,20)
				end
			end
		end
		if currentRoom == images["atticRoom"] then
			SCENE.atticRoom_draw()
		end

		--enemy logics
		if enemy_exists == true then
			ghost:draw()
			light_check()
		end

		if move_chair == true then
			mrChair:draw()
		end

		player:draw()
		if love.system.getOS() == "Android" or love.system.getOS() == "iOS" or debug == true then
			android.light_draw()
		end

		if storage_puzzle == true then
			storage_puzzle_draw()
		end


		if clock_puzzle == true then
			puzzle_draw()
		end

		if dust_trigger == true then
			particle_draw()
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.draw(images.overlay,width/2 - images.bg:getWidth()/2,height/2 - images.bg:getHeight()/2)
			love.graphics.setColor(0,0,0,1)
			love.graphics.rectangle("fill",0,height/2 + images.bg:getHeight()/2,width,height)
		elseif ghost_event == "fall down" then
			particle_draw()
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.draw(images.overlay,width/2 - images.bg:getWidth()/2,height/2 - images.bg:getHeight()/2)
			love.graphics.setColor(0,0,0,1)
			love.graphics.rectangle("fill",0,height/2 + images.bg:getHeight()/2,width,height)

			love.graphics.setColor(0,0,0,1)
			love.graphics.rectangle("fill",0,0,images.bg:getWidth(),images.bg:getHeight()/2)
		end

		if love.system.getOS() ~= "Android" or love.system.getOS() ~= "iOS" and debug == false then
		if currentRoom == images["secretRoom"] then
			if tv_light_flag == true then
				love.graphics.draw(tv_flash)
				love.graphics.setColor(1, 1, 1, 1)
			else
				love.graphics.draw(custom_mask)
				love.graphics.setColor(1, 1, 1, 1)
			end
		elseif currentRoom == images["masterRoom"] then
			if candles_light_flag == true then
				love.graphics.draw(candles_flash)
				love.graphics.setColor(1, 1, 1, 1)
			else
				love.graphics.draw(custom_mask)
				love.graphics.setColor(1, 1, 1, 1)
			end
		elseif currentRoom == images["rightRoom"] then
			if right_light_flag == true then
				love.graphics.draw(right_canvas)
				love.graphics.setColor(1, 1, 1, 1)
			else
				love.graphics.draw(custom_mask)
				love.graphics.setColor(1, 1, 1, 1)
			end
		elseif currentRoom == images["leftRoom"] then
			if left_light_flag == true then
				love.graphics.draw(left_canvas)
				love.graphics.setColor(1, 1, 1, 1)
			else
				love.graphics.draw(custom_mask)
				love.graphics.setColor(1, 1, 1, 1)
			end
		else
			love.graphics.draw(custom_mask)
			love.graphics.setColor(1, 1, 1, 1)
		end
		end

		if currentRoom == images["secretRoom"] then
			if event == "after_secret_room" then
				if text1_flag == true then
					love.graphics.setColor(1, 1, 1, 1)
					love.graphics.print(txt1,txt1_x,txt1_y)
				end
			end
			SCENE.secretRoom_draw()
		elseif currentRoom == images["leftRoom"] then
			left_room_draw()
		elseif currentRoom == images["rightRoom"] then
			rightroom_draw()
		end

		if ending_leave == true then
			if currentRoom ~= images["leftRoom"] then
				leave_event_draw()
			end
		end

		if love.system.getOS() == "Android" or love.system.getOS() == "iOS" then
			if gameplay_record == false then
				android.draw()
			end
		end
		for k,v in pairs(dialogue) do
			v:draw()
		end
		if gameover == true then
			game_over.draw()
		end

		--trigger txt
		if tt_draw == true then
			triggerTxt_draw()
		end
	end

	fade:draw()
end

function gamestates.control()
	if instruction == false and about == false then
		states = "rain_intro"
		gamestates.load()
	end
end

function gamestates.nextState(state)
	states = state
	gamestates.load()
end

function light_check()
	if love.system.getOS() == "Android" or love.system.getOS() == "iOS" or debug == true then
		android.light_check()
	else
		local mx = love.mouse.getX()/ratio
		local my = (love.mouse.getY()-ty)/ratio
		local lw,lh = images.light:getWidth(),images.light:getHeight()
		local rad = 10
		local gx = ghost.x-ghost.ox
		--debugging

		--inside
		if fade.state == false then
			if enemy_exists == true and lightOn == true then
				if mx >= gx - ghost.w/2 and mx <= gx + ghost.w + ghost.w/2 then
					if my >= ghost.y - ghost.h/1.5 and my <= ghost.y + ghost.y + ghost.h/1.5 then
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

function enemy_pos()
	local gx,gy = ghost.x, ghost.y
	local left = width/2 - 8 - math.floor(math.random(width/4))
	local right = width - width/6 - math.floor(math.random(width/2))
	local mid_left = math.floor(math.random(12,32))
	local mid_right = math.floor(math.random(width-32,width-12))


	if ghost.chaseOn == false then
		if player.x <= width/2 - l + 1 then --player is in the left
			ghost.x = right
			ghost.xscale = -1
		elseif player.x >= width/2 + r + 1 then --player is in the right
			ghost.x = left
			ghost.xscale = 1
		elseif player.x >= width/2 - l then --player in mid
			if player.x <= width/2 + r then
				ghost.x = mid_left or mid_right
				ghost.xscale = 1
			end
		end
	elseif ghost.chaseOn == true then --if enemy is chasing
		if player.x <= width/2 - l + 1 then
			ghost.x = mid_right
		elseif player.x >= width/2 + r + 1 then
			ghost.x = mid_left
		elseif player.x >= width/2 - l then --player in mid
			if player.x <= width/2 + r then
				ghost.x = mid_left or mid_right
				ghost.xscale = 1
			end
		end
	end
end

function enemy_check()
	local random = math.floor(math.random(0,100))
	if enemy_exists == true then
		if random <= 40 then
			--enemy disappears
			enemy_exists = false
			ghost.timer = 2
			ghost.count = true
			ghost.chaseOn = false
		else
			enemy_pos()
		end
	else --enemy does not exists
		if event_trigger_light == -1 then
			if random <= 60 then
				--enemy appears
				enemy_exists = true
				--move enemy
				enemy_pos()
			end
		else
			if random <= 50 then
				--enemy appears
				enemy_exists = true
				--move enemy
				enemy_pos()
			end
		end
	end

end

function skip_draw()
	if pressed == false then
		love.graphics.setColor(1, 1, 1, 1)
	else
		love.graphics.setColor(1, 0, 0, 1)
	end
	skip_button:draw(images.skip ,gui_pos.skip_x,gui_pos.skip_y )
end

function random_page()
	local random = math.floor(math.random(1,4))
	sounds["page" .. tostring(random)]:play()
	sounds["page" .. tostring(random)]:setLooping(false)
end

function light_etc(dt,img_table,img_var,canvas)
	lightOn = false
	local r = 0.05
	local x = 0 + (math.random(-r,r))
	local y = height/2 - img_table[img_var]:getHeight()/2 + (math.random(-r,r))
	love.graphics.setCanvas(canvas)
	love.graphics.clear(0,0,0,lv)
	love.graphics.setBlendMode("multiply", "premultiplied")
	love.graphics.draw(img_table[img_var],x,y)
	if love.system.getOS() == "Android" or love.system.getOS() == "iOS" or debug then
		love.graphics.draw(mainLight,lx,ly)
	elseif love.system.getOS() ~= "Android" or love.system.getOS() ~= "iOS" and debug == false then
		love.graphics.draw(light,lightX,lightY)
	end
	love.graphics.setBlendMode("alpha")
	love.graphics.setCanvas()

	function getLightEtc()
		return x,y
	end
end

function lightning(dt)
	if lightning_flash == true  then
		local random = math.floor(math.random(0,1000))
		if random <= 5 then
			if sounds.lightning:isPlaying() == false then
				sounds.lightning:play()
				sounds.lightning:setVolume(lightningVol)
				sounds.lightning:setLooping(false)
			end
		end
	end
	local duration = sounds.lightning:getDuration("seconds")
	local tell = sounds.lightning:tell()
	local amount = 0.25
	if fade.state == false then
		if ending_leave_event ~= 2 then
			if (tell >= 6 and tell <= 7) then
				lv = lume.lerp(lv,0,amount)
				lStrike = true
			else
				lv = lume.lerp(lv,1,amount)
				lStrike = false
			end
		end
	else
		lv = 1
	end
end

function check_gui(gx,gy,gw,gh)
	local mx = love.mouse.getX()/ratio
	local my = (love.mouse.getY()-ty)/ratio

	local gx,gy,gw,gh = gx,gy,gw,gh
	return mx >= gx and mx <= gx + gw and my >= gy and my <= gy + gh
end

function triggerTxt(dt)
	move = false

	if _alarm > 0 then
		_alarm = _alarm -1 * dt
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
			sounds.enemy_scream:play()
			sounds.enemy_scream:setVolume(0.9)
			sounds.enemy_scream:setLooping(false)
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
			love.graphics.print(tt_txt, width/2 - font:getWidth(tt_txt)/2, 0 + font:getHeight(tt_txt)/4)
			love.graphics.print(tt_txt2, width/2 - font:getWidth(tt_txt2)/2, height - font:getHeight(tt_txt2))
		elseif t == 2 then
			love.graphics.print("",width/2 - font:getWidth(" ")/2, 0 + font:getHeight(" ")/4)
			love.graphics.print("",width/2 - font:getWidth(" ")/2, height - font:getHeight(" "))
		elseif t == 3 then
			if sounds.enemy_scream:isPlaying() == false then
				love.graphics.print(as,width/2 - font:getWidth(as)/2, 0 + font:getHeight(as)/4)
				love.graphics.print(as2,width/2 - font:getWidth(as2)/2, height - font:getHeight(as2))
			end
		end
	end
end


function seconds_to_clock(seconds)
	local seconds = tonumber(seconds)
	if seconds <= 0 then
		return "00:00:00"
	else
		hours = string.format("%02.f",math.floor(seconds/3600))
		mins = string.format("%02.f",math.floor(seconds/60 - (hours*60)))
		secs = string.format("%02.f",math.floor(seconds-hours*3600-mins*60))
		return hours..":"..mins..":"..secs
	end
end

function dev_draw()
	if debug == true then
		love.graphics.push()
		love.graphics.scale(1/4)
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.setFont(font)
		love.graphics.print("DEV VERSION",width * 3.65, height * 3.8)
		love.graphics.pop()
	end
end
