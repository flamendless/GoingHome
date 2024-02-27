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

function SCENES.secretRoom_update(dt)
	if static_fade and SOUNDS.tv_loud:isPlaying() then
		local v = SOUNDS.tv_loud:getVolume()
		if v <= 0 then
			SOUNDS.tv_loud:stop()
			static_fade = false
		end
		SOUNDS.tv_loud:setVolume(v - 0.2 * dt)
	end


	if event == "secret_room_first" then
		ENEMY_EXISTS = false
		LIGHT_ON = false
		RANDOM_BREATHE = false
		MOVE = false
		SOUNDS.rain:setVolume(0.45)
		SOUNDS.main_theme:setVolume(0)
		SOUNDS.finding_home:setVolume(0)
		SOUNDS.main_theme:stop()
		SOUNDS.finding_home:stop()
		SOUNDS.rain:stop()

		if _timer > 0 then
			_timer = _timer - 1 * dt

			local _t = math.floor(math.random(-4, 4))
			if _t == 1 then
				_flag = true
				SOUNDS.fl_toggle:play()
			elseif _t == -1 then
				_flag = false
				SOUNDS.fl_toggle:play()
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
				txt1_x = WIDTH_HALF - DEF_FONT:getWidth(txt1) / 2
				txt1_y = HEIGHT / 4 - DEF_FONT_HALF
				text1_flag = true
			elseif _timer >= 4 and _timer <= 6 then
				txt1 = "The flashlight won't last..."
				txt1_y = HEIGHT_HALF - DEF_FONT_HALF
			elseif _timer >= 1 and _timer <= 3 then
				txt1_x = WIDTH_HALF + DEF_FONT:getWidth(txt1) / 2
				txt1 = "Alex..."
				txt1_y = HEIGHT - 8 - DEF_FONT_HALF
			elseif _timer <= 0 then
				txt1 = ""

				event = "after_dialogue"
				MOVE = true
				--sounds.they_are_gone:play()
				--sounds.they_are_gone:setLooping(true)
				--sounds.they_are_gone:setVolume(0.25)
			end
		end
	elseif event == "after_dialogue" then
		if FADE_OBJ.state == false then
			if tv_trigger == 1 then
				--tv jumpscare
				SOUNDS.tv_loud:play()
				SOUNDS.tv_loud:setLooping(true)
				tv_trigger = -1
				tv_light_flag = true
				static_fade = true

				for i, v in ipairs(DIALOGUES) do
					if v.tag == "tv" then
						table.remove(DIALOGUES, i)
						local tv_open = Interact(false,
							{ "It's just showing random pixels", "H...How?", "There's no electricity", "Turn it off?" },
							{ "Yes", "Leave it be" }, "It won't turn off", "tv")
						table.insert(DIALOGUES, tv_open)
						tv_open_volume = true
						tv_mute = false
					end
				end
			end
		end

		if dust_trigger == true then
			particle_update(dt)
		end
		if CORPSE_TRIGGER == true then
			corpse_fall_anim:update(dt)
		end
	end

	if GHOST_EVENT == "no escape" then
		ENEMY_EXISTS = true
		GHOST.chaseOn = true
		GHOST.x = 64
		GHOST.y = 30
		GHOST_EVENT = "still no escape"
		do return end
	end

	if GHOST_EVENT == "still no escape" then
		ENEMY_EXISTS = true
		GHOST.chaseOn = true
	end

	if GHOST_EVENT == "fall down" then
		particle_update(dt)
		ENEMY_EXISTS = false
		LIGHT_ON = false
		random_breathe_flag = false
	elseif GHOST_EVENT == "lying down" then
		love.mouse.setPosition(131, 326)

		LIGHT_ON = true
		if timer > 0 then
			timer = timer - 1 * dt
			if timer <= 0 then
				timer = 3
				GHOST_EVENT = "flashback"
				MOVE = false
				LIGHT_ON = false

				for i, v in ipairs(ITEMS_LIST) do
					if v.tag == "hole" then
						table.remove(ITEMS_LIST, i)
						break
					end
				end
				local head = Items(IMAGES.st_head, IMAGES["stairRoom"], 80, 22, "head")
				table.insert(ITEMS_LIST, head)
			end
		end
	elseif GHOST_EVENT == "flashback" then
		--set previous rooms to false
		--things to hide while in flashback
		for _, v in ipairs(ITEMS_LIST) do
			for _, m in ipairs(hide) do
				if v.tag == m then
					v.visible = false
					break
				end
			end
		end


		tv_light_flag = false
		SOUNDS.rain:stop()
		SOUNDS.thunder:stop()
		PLAYER.img = IMAGES.player_child_idle
		SOUNDS.main_theme:play()
		SOUNDS.main_theme:setLooping(false)
		SOUNDS.main_theme:setVolume(0.6)
		PLAYER.xspd = 25

		PLAYER.visible = true
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
						MOVE = true
						LIGHT_VALUE = 0
						event_find = true
					end
				end
			elseif event_find == true then
				if move_chair == false then
					--finding parents
					if screamed == 0 then
						if PLAYER.x >= 77 and PLAYER.x <= 80 then
							SOUNDS.floor_squeak:play()
							MOVE = false
							screamed = 1
							timer = 3
						end
					elseif screamed == 1 then
						if timer > 0 then
							timer = timer - 1 * dt
							if timer <= 0 then
								screamed = -1
								MOVE = true
							end
						end
					elseif screamed == -1 then
						--here is the part where we are going to find a chair
						--create the chair
						LIGHT_ON = true
						if insert_chair == false then
							local chair = Items(IMAGES.store_chair, IMAGES["storageRoom"], 37, 34, "chair")
							table.insert(ITEMS_LIST, chair)
							local cd = Interact(false, { "It's a chair", "What to do?" }, { "Take it", "Push it" },
								"It's too big", "chair")
							table.insert(DIALOGUES, cd)
							insert_chair = true
						end
					end
				end
				LIGHT_ON = true
			end
		else
			for i, v in ipairs(ITEMS_LIST) do
				if v.tag == "head" then
					table.remove(ITEMS_LIST, i)
					break
				end
			end
			local holes = Items(IMAGES.st_hole, IMAGES["stairRoom"], 80, 22, "hole")
			table.insert(ITEMS_LIST, holes)

			--set previous rooms configs to true
			for _, v in ipairs(ITEMS_LIST) do
				for _, m in ipairs(hide) do
					if v.tag == m then
						v.visible = true
						break
					end
				end
			end

			SOUNDS.rain:play()
			SOUNDS.thunder:play()
			PLAYER.img = IMAGES.player_idle
			SOUNDS.main_theme:stop()
			PLAYER.xspd = 25
			c = 1
			timer = 3

			MOVE = false
			GHOST_EVENT = "limp"
		end
	elseif GHOST_EVENT == "limp" then
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
					GHOST_EVENT = "after limp"
				end
			end
		end
	elseif GHOST_EVENT == "after limp" then
		txt = false
		MOVE = true
		GHOST_EVENT = "finished"
		tv_light_flag = true

		--remove corpse
		for _, v in ipairs(ITEMS_LIST) do
			if v.tag == "corpse" then
				--table.remove(obj,k)
				v.visible = false
			elseif v.tag == "st_hole" then
				v.visible = false
			elseif v.tag == "store_hoop_ball" then
				v.visible = false
			end
		end
	elseif GHOST_EVENT == "finished" then
		PLAYER.state = "normal"
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
		love.graphics.draw(IMAGES.tv_light, 104, 11)
		love.graphics.draw(light, LIGHTX, LIGHTY)
		love.graphics.setBlendMode("alpha")
		love.graphics.setCanvas()
		tv_anim:update(dt)
	end
end

function SCENES.secretRoom_draw()
	if GHOST_EVENT == "flashback" then
		if txt == true then
			love.graphics.setColor(180 / 255, 180 / 255, 180 / 255, 1)
			local subtext = _txt_2[c]
			love.graphics.print(subtext, WIDTH_HALF - DEF_FONT:getWidth(subtext) / 2, HEIGHT_HALF - DEF_FONT_HALF)
		end

		if screamed == 1 then
			local t1 = "They're in the attic"
			local t2 = "I can't reach the ladder"
			love.graphics.setColor(180 / 255, 180 / 255, 180 / 255, 1)
			love.graphics.print(t1, WIDTH_HALF - DEF_FONT:getWidth(t1) / 2, 0 + DEF_FONT_HEIGHT / 4)
			love.graphics.print(t2, WIDTH_HALF - DEF_FONT:getWidth(t2) / 2, HEIGHT - DEF_FONT_HEIGHT)
		end
	elseif GHOST_EVENT == "limp" then
		if txt == true then
			love.graphics.setColor(1, 1, 1, 1)
			local subtext = _txt[c]
			love.graphics.print(subtext, WIDTH_HALF - DEF_FONT:getWidth(subtext) / 2, HEIGHT_HALF - DEF_FONT_HALF)
		end
	end
end
