local squeak = false

local timer = 3

function SCENES.atticRoom_update(dt)
	attic_clock_anim:update(dt)
	SOUNDS.clock_tick:play()
	SOUNDS.clock_tick:setVolume(0.7)
	SOUNDS.clock_tick:setLooping(true)

	if PLAYER.x < 10 then
		if squeak == true then
			SOUNDS.floor_squeak:play()
			SOUNDS.floor_squeak:setLooping(false)
			squeak = false
		end
	else
		squeak = true
	end

	if GHOST_EVENT == "no escape" then
		--if player goes to the far left do some falling
		--print(player.x) --22.86

		PLAYER.state = "child"

		if GHOST.x >= 19 then
			GHOST.chaseOn = true
		else
			if GAMEOVER == false then
				GHOST.chaseOn = false
				SOUNDS.floor_hole:play()
				SOUNDS.floor_hole:setLooping(false)

				GHOST_EVENT = "fall down"
				LIGHT_ON = false
				MOVE = false
				PLAYER.y = -32
				PLAYER.grav = 1
				currentRoom = IMAGES["secretRoom"]

				PLAYER.visible = false
				PLAYER.img = IMAGES.player_down
			end
		end
	elseif GHOST_EVENT == "flashback" then
		if final_flashback == true then
			LIGHT_ON = true
			PLAYER.x = 80
			PLAYER.y = 37
			--here is the epic flashback scene -_-
			flashback_epic = true
			epic_scene_update(dt)
			LIGHT_VALUE = 1
		end
	end
	if temp_clock ~= nil then
		if temp_clock < CLOCK - 3 then
			if event_trigger_light == 0 then
				if not ON_MOBILE then
					event_trigger_light = 1
				end
			end
		end
	end
	if event_trigger_light == 1 then
		if timer > 0 then
			RANDOM_BREATHE = false
			timer = timer - 1 * dt
			MOVE = false
			PLAYER.visible = false
			local _t = math.floor(math.random(-6, 6))
			if _t == 1 then
				_flag = true
				SOUNDS.fl_toggle:play()
			elseif _t == -1 then
				_flag = false
				SOUNDS.fl_toggle:play()
			end
			LIGHT_ON = _flag
		elseif timer <= 0 then
			event_trigger_light = 2
			RANDOM_BREATHE = true
			timer = 3
		end
	elseif event_trigger_light == 2 then
		if timer > 0 then
			timer = timer - 1 * dt
			LIGHT_ON = false
		elseif timer <= 0 then
			event_trigger_light = -1
			LIGHT_ON = true
			MOVE = true
			PLAYER.visible = true
		end
	end
end

-- local txt1 = "I have to find them faster"
-- local txt2 = "The light's running out"

function SCENES.atticRoom_draw()
	love.graphics.setColor(1, 1, 1, 1)
	attic_clock_anim:draw(IMAGES.clock_anim, WIDTH / 2 - 12, 22)

	if flashback_epic == true then
		epic_scene_draw()
	end
end

------


--PUZZLE!
function puzzle_update(dt)
	MOVE = false
	if ClockPuzzle.state then
		if ClockPuzzle.hour == 10 and ClockPuzzle.minute == 2 and ClockPuzzle.second == 8 and ClockPuzzle.ampm == "pm" then
			ClockPuzzle.state = false
			SOUNDS.item_got:play()
			ClockPuzzle.solved = true
			MOVE = true
			SOUNDS.main_theme:stop()
			SOUNDS.intro_soft:stop()
			SOUNDS.finding_home:stop()
			SOUNDS.ts_theme:stop()
			if ON_MOBILE then
				Android.lightChange(false)
			end
		end
	end
end

function puzzle_draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(IMAGES.clock_base, WIDTH / 2 - IMAGES.clock_base:getWidth() / 2,
		HEIGHT_HALF - IMAGES.clock_base:getHeight() / 2)

	--arrow
	if ClockPuzzle.selected == "hour" then
		c_x = WIDTH / 2 - 27.5
		c_y = HEIGHT_HALF - 7
		c_xs = 1
		c_ys = 1
	elseif ClockPuzzle.selected == "minute" then
		c_x = WIDTH / 2 - 13.5
		c_y = HEIGHT_HALF - 7
		c_xs = 1
		c_ys = 1
	elseif ClockPuzzle.selected == "second" then
		c_x = WIDTH / 2 + 0.5
		c_y = HEIGHT_HALF - 7
		c_xs = 1
		c_ys = 1
	elseif ClockPuzzle.selected == "ampm" then
		c_x = WIDTH / 2 + 13.5
		c_y = HEIGHT_HALF - 7
		c_xs = 1.25
		c_ys = 1
	end
	local offY = IMAGES.clock_digits_glow:getHeight() - IMAGES.clock_digits:getHeight()
	local offX = IMAGES.clock_digits_glow:getWidth() - IMAGES.clock_digits:getWidth()

	love.graphics.draw(IMAGES.clock_digits_glow, c_x, c_y, 0, c_xs, c_ys, offX / 2, offY / 2)

	--love.graphics.setColor(150,100,125,255)
	--love.graphics.rectangle("fill", width/2 - 32, height/2 - 12, 64, 24)

	--hour
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(IMAGES.clock_digits, WIDTH / 2 - 27.5, HEIGHT_HALF - 7)
	love.graphics.print(ClockPuzzle.hour, WIDTH / 2 - 22 - DEF_FONT:getWidth(ClockPuzzle.hour) / 2,
		HEIGHT_HALF - DEF_FONT_HALF)

	--minute
	love.graphics.draw(IMAGES.clock_digits, WIDTH / 2 - 13.5, HEIGHT_HALF - 7)
	love.graphics.print(ClockPuzzle.minute, WIDTH / 2 - 8 - DEF_FONT:getWidth(ClockPuzzle.minute) / 2,
		HEIGHT_HALF - DEF_FONT_HALF)

	--second
	love.graphics.draw(IMAGES.clock_digits, WIDTH / 2 + 0.5, HEIGHT_HALF - 7)
	love.graphics.print(ClockPuzzle.second, WIDTH / 2 + 6 - DEF_FONT:getWidth(ClockPuzzle.second) / 2,
		HEIGHT_HALF - DEF_FONT_HALF)

	--ampm
	love.graphics.draw(IMAGES.clock_digits, WIDTH / 2 + 13.5, HEIGHT_HALF - 7, 0, 1.25, 1)
	love.graphics.print(ClockPuzzle.ampm, WIDTH / 2 + 20 - DEF_FONT:getWidth(ClockPuzzle.ampm) / 2,
		HEIGHT_HALF - DEF_FONT_HALF)
end
