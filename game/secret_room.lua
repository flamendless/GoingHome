local timer = 4
local txt = false
local c = 1
local _txt = {
	" ",
	"...",
	"I'm still alive aren't I?",
	".",
	"..",
	"...",
	"I remember now.",
	"He killed her...",
	"Then I-d",
	"I-",
	"...",
	"I-",
	"..uugghh..",
	"..I can't remember all!",
	".",
	"..",
	"...",
	"..I- I can't stop..",
	"..I have to look for t-",
	" ",
}
local _txt_2 = {
	" ",
	"*faint sound*", --remove this and the block comments
	"...",
	"Mom?",
	"Dad?",
	"I had a nightmare",
	"...",
	"*sobs*",
	"m-mom?",
	"..."
}

local hide = {
	"corpse",
	"head",
	"safe vault"
}

parent_found = false
local insert_chair = false
screamed = 0
event_find = false

local static_fade = false

function SCENE.secretRoom_update(dt)
	if static_fade and Sounds.tv_loud:isPlaying() then
		local v = Sounds.tv_loud:getVolume()
		if v <= 0 then
			Sounds.tv_loud:stop()
			static_fade = false
		end
		Sounds.tv_loud:setVolume(v - 0.2 * dt)
	end


	if event == "secret_room_first" then
		ENEMY_EXISTS = false
		LIGHT_ON = false
		RANDOM_BREATHE = false
		move = false
		Sounds.rain:setVolume(0.3)
		Sounds.main_theme:setVolume(0)
		Sounds.finding_home:setVolume(0)
		Sounds.main_theme:stop()
		Sounds.finding_home:stop()
		Sounds.rain:stop()

		if _timer > 0 then
			_timer = _timer - 1 * dt

			local _t = math.floor(math.random(-4, 4))
			if _t == 1 then
				_flag = true
				Sounds.fl_toggle:play()
			elseif _t == -1 then
				_flag = false
				Sounds.fl_toggle:play()
			end


			--play sounds on breaking flashlight
			LIGHT_ON = _flag
		elseif _timer <= 0 then
			event = "after_secret_room"
			RANDOM_BREATHE = true
			_timer = 10
		end
	elseif event == "after_secret_room" then
		--sounds.rain:setVolume(0.1)
		--sounds.finding_home:setVolume(0.40)

		LIGHT_ON = false

		if _timer > 0 then
			_timer = _timer - 1 * dt
			if _timer >= 7 and _timer <= 9 then
				txt1 = "I have to find them quick..."
				txt1_x = WIDTH / 2 - DEF_FONT:getWidth(txt1) / 2
				txt1_y = HEIGHT / 4 - DEF_FONT_HALF
				text1_flag = true
			elseif _timer >= 4 and _timer <= 6 then
				txt1 = "The flashlight won't last..."
				txt1_y = HEIGHT_HALF - DEF_FONT_HALF
			elseif _timer >= 1 and _timer <= 3 then
				txt1_x = WIDTH / 2 + DEF_FONT:getWidth(txt1) / 2
				txt1 = "Alex..."
				txt1_y = HEIGHT - 8 - DEF_FONT_HALF
			elseif _timer <= 0 then
				txt1 = ""

				event = "after_dialogue"
				move = true
				--sounds.they_are_gone:play()
				--sounds.they_are_gone:setLooping(true)
				--sounds.they_are_gone:setVolume(0.25)
			end
		end
	elseif event == "after_dialogue" then
		if FADE_OBJ.state == false then
			if tv_trigger == 1 then
				--tv jumpscare
				Sounds.tv_loud:play()
				Sounds.tv_loud:setLooping(true)
				tv_trigger = -1
				tv_light_flag = true
				static_fade = true

				for i, v in ipairs(dialogue) do
					if v.tag == "tv" then
						table.remove(dialogue, i)
						local tv_open = Interact(false,
							{ "It's just showing random pixels", "H...How?", "There's no electricity", "Turn it off?" },
							{ "Yes", "Leave it be" }, "It won't turn off", "tv")
						table.insert(dialogue, tv_open)
						tv_open_volume = true
						tv_mute = false
					end
				end
			end
		end

		if dust_trigger == true then
			particle_update(dt)
		end
		if corpse_trigger == true then
			corpse_fall_anim:update(dt)
		end
	end

	if ghost_event == "no escape" then
		ENEMY_EXISTS = true
		ghost.chaseOn = true
		ghost.x = 64
		ghost.y = 30
		ghost_event = "still no escape"
		do return end
	end

	if ghost_event == "still no escape" then
		ENEMY_EXISTS = true
		ghost.chaseOn = true
	end

	if ghost_event == "fall down" then
		particle_update(dt)
		ENEMY_EXISTS = false
		LIGHT_ON = false
		random_breathe_flag = false
	elseif ghost_event == "lying down" then
		love.mouse.setPosition(131, 326)

		LIGHT_ON = true
		if timer > 0 then
			timer = timer - 1 * dt
			if timer <= 0 then
				timer = 3
				ghost_event = "flashback"
				move = false
				LIGHT_ON = false

				for i, v in ipairs(obj) do
					if v.tag == "hole" then
						table.remove(obj, i)
						break
					end
				end
				local head = Items(Images.st_head, Images["stairRoom"], 80, 22, "head")
				table.insert(obj, head)
			end
		end
	elseif ghost_event == "flashback" then
		--set previous rooms to false
		--things to hide while in flashback
		for _, v in ipairs(obj) do
			for _, m in ipairs(hide) do
				if v.tag == m then
					v.visible = false
					break
				end
			end
		end


		tv_light_flag = false
		Sounds.rain:stop()
		Sounds.thunder:stop()
		player.img = Images.player_child_idle
		Sounds.main_theme:play()
		Sounds.main_theme:setLooping(false)
		Sounds.main_theme:setVolume(0.3)
		player.xspd = 25

		player.visible = true
		if parent_found == false then
			--texts intro
			if event_find == false then
				if timer > 0 then
					LIGHT_ON = false
					if c < #_txt_2 then
						txt = true
						timer = timer - 1 * dt
						if timer <= 0 then
							timer = 4
							c = c + 1
						end
					elseif c >= #_txt_2 then
						flash_text_finished = true
						txt = false
						move = true
						LIGHT_VALUE = 0
						event_find = true
					end
				end
			elseif event_find == true then
				if move_chair == false then
					--finding parents
					if screamed == 0 then
						if player.x >= 77 and player.x <= 80 then
							Sounds.floor_squeak:play()
							move = false
							screamed = 1
							timer = 3
						end
					elseif screamed == 1 then
						if timer > 0 then
							timer = timer - 1 * dt
							if timer <= 0 then
								screamed = -1
								move = true
							end
						end
					elseif screamed == -1 then
						--here is the part where we are going to find a chair
						--create the chair
						LIGHT_ON = true
						if insert_chair == false then
							local chair = Items(Images.store_chair, Images["storageRoom"], 37, 34, "chair")
							table.insert(obj, chair)
							local cd = Interact(false, { "It's a chair", "What to do?" }, { "Take it", "Push it" },
								"It's too big", "chair")
							table.insert(dialogue, cd)
							insert_chair = true
						end
					end
				end
				LIGHT_ON = true
			end
		else
			for i, v in ipairs(obj) do
				if v.tag == "head" then
					table.remove(obj, i)
					break
				end
			end
			local holes = Items(Images.st_hole, Images["stairRoom"], 80, 22, "hole")
			table.insert(obj, holes)

			--set previous rooms configs to true
			for _, v in ipairs(obj) do
				for _, m in ipairs(hide) do
					if v.tag == m then
						v.visible = true
						break
					end
				end
			end

			Sounds.rain:play()
			Sounds.thunder:play()
			player.img = Images.player_idle
			Sounds.main_theme:stop()
			player.xspd = 25
			c = 1
			timer = 3

			move = false
			ghost_event = "limp"
		end
	elseif ghost_event == "limp" then
		LIGHT_ON = false
		ENEMY_EXISTS = false
		LIGHT_VALUE = 1

		if timer > 0 then
			timer = timer - 1 * dt
			txt = true
			if timer <= 0 then
				timer = 3
				if c < #_txt then
					c = c + 1
				elseif c >= #_txt then
					txt = false
					c = 1
					timer = 3
					ghost_event = "after limp"
				end
			end
		end
	elseif ghost_event == "after limp" then
		txt = false
		move = true
		ghost_event = "finished"
		tv_light_flag = true

		--remove corpse
		for _, v in ipairs(obj) do
			if v.tag == "corpse" then
				--table.remove(obj,k)
				v.visible = false
			elseif v.tag == "st_hole" then
				v.visible = false
			elseif v.tag == "store_hoop_ball" then
				v.visible = false
			end
		end
	elseif ghost_event == "finished" then
		player.state = "normal"
		flashback_epic = false

		-- for i, v in ipairs(obj) do
		-- 	if v.tag == "head" then
		-- 		table.remove(obj, i)
		-- 		break
		-- 	end
		-- end
		-- local holes = Items(images.st_hole,images["stairRoom"], 80, 22, "hole")
		-- table.insert(obj, holes)
	end
	--tv illum
	if tv_light_flag == true then
		love.graphics.setCanvas(CANVAS_TV_FLASH)
		love.graphics.clear(0, 0, 0, LIGHT_VALUE)
		love.graphics.setBlendMode("multiply", "premultiplied")
		love.graphics.draw(Images.tv_light, 104, 11)
		love.graphics.draw(light, LIGHTX, LIGHTY)
		love.graphics.setBlendMode("alpha")
		love.graphics.setCanvas()
		tv_anim:update(dt)
	end
end

function SCENE.secretRoom_draw()
	if ghost_event == "flashback" then
		if txt == true then
			love.graphics.setColor(180 / 255, 180 / 255, 180 / 255, 1)
			local subtext = _txt_2[c]
			love.graphics.print(subtext, WIDTH / 2 - DEF_FONT:getWidth(subtext) / 2, HEIGHT_HALF - DEF_FONT_HALF)
		end

		if screamed == 1 then
			local t1 = "They're in the attic"
			local t2 = "I can't reach the ladder"
			love.graphics.setColor(180 / 255, 180 / 255, 180 / 255, 1)
			love.graphics.print(t1, WIDTH / 2 - DEF_FONT:getWidth(t1) / 2, 0 + DEF_FONT_HEIGHT / 4)
			love.graphics.print(t2, WIDTH / 2 - DEF_FONT:getWidth(t2) / 2, HEIGHT - DEF_FONT_HEIGHT)
		end
	elseif ghost_event == "limp" then
		if txt == true then
			love.graphics.setColor(1, 1, 1, 1)
			local subtext = _txt[c]
			love.graphics.print(subtext, WIDTH / 2 - DEF_FONT:getWidth(subtext) / 2, HEIGHT_HALF - DEF_FONT_HALF)
		end
	end
end
