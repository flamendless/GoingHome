local squeak = false

local timer = 3

function SCENE.atticRoom_update(dt)
	attic_clock_anim:update(dt)
	Sounds.clock_tick:play()
	Sounds.clock_tick:setVolume(0.5)
	Sounds.clock_tick:setLooping(true)

	if player.x < 10 then
		if squeak == true then
			Sounds.floor_squeak:play()
			Sounds.floor_squeak:setLooping(false)
			squeak = false
		end
	else
		squeak = true
	end

	if ghost_event == "no escape" then
		--if player goes to the far left do some falling
		--print(player.x) --22.86

		player.state = "child"

		if ghost.x >= 19 then
			ghost.chaseOn = true
		else
			if gameover == false then
				ghost.chaseOn = false
				Sounds.floor_hole:play()
				Sounds.floor_hole:setLooping(false)

				ghost_event = "fall down"
				LIGHT_ON = false
				move = false
				player.y = -32
				player.grav = 1
				currentRoom = Images["secretRoom"]

				player.visible = false
				player.img = Images.player_down
			end
		end
	elseif ghost_event == "flashback" then
		if final_flashback == true then
			LIGHT_ON = true
			player.x = 80
			player.y = 37
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
			random_breathe = false
			timer = timer - 1 * dt
			move = false
			player.visible = false
			local _t = math.floor(math.random(-6,6))
			if _t == 1 then
				_flag = true
				Sounds.fl_toggle:play()
			elseif _t == -1 then
				_flag = false
				Sounds.fl_toggle:play()
			end
			LIGHT_ON = _flag
		elseif timer <= 0 then
			event_trigger_light = 2
			random_breathe = true
			timer = 3
		end
	elseif event_trigger_light == 2 then
		if timer > 0 then
			timer = timer - 1 * dt
			LIGHT_ON = false

		elseif timer <= 0 then
			event_trigger_light = -1
			LIGHT_ON = true
			move = true
			player.visible = true
		end
	end
end


-- local txt1 = "I have to find them faster"
-- local txt2 = "The light's running out"

function SCENE.atticRoom_draw()
	love.graphics.setColor(1, 1, 1, 1)
	attic_clock_anim:draw(Images.clock_anim,WIDTH/2-12,22)

	if flashback_epic == true then
		epic_scene_draw()
	end
end


------
--puzzle clock default variables
hour = 1
minute = 1
second = 1
ampm = "am"
selected = "hour"
solved = false


--PUZZLE!
function puzzle_update(dt)
	move = false
	if clock_puzzle then
		if hour == 10 and minute == 2 and second == 8 and ampm == "pm" then
			clock_puzzle = false
			Sounds.item_got:play()
			solved = true
			move = true
			Sounds.main_theme:stop()
			Sounds.intro_soft:stop()
			Sounds.finding_home:stop()
			Sounds.ts_theme:stop()
		end
	end
end

function puzzle_draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(Images.clock_base,WIDTH/2  - Images.clock_base:getWidth()/2, HEIGHT_HALF - Images.clock_base:getHeight()/2)

	--arrow
	if selected == "hour" then
		c_x = WIDTH/2 - 27.5
		c_y = HEIGHT_HALF - 7
		c_xs = 1
		c_ys = 1
	elseif selected == "minute" then
		c_x = WIDTH/2 - 13.5
		c_y = HEIGHT_HALF - 7
		c_xs = 1
		c_ys = 1

	elseif selected == "second" then
		c_x = WIDTH/2 + 0.5
		c_y = HEIGHT_HALF - 7
		c_xs = 1
		c_ys = 1

	elseif selected == "ampm" then
		c_x = WIDTH/2 + 13.5
		c_y = HEIGHT_HALF - 7
		c_xs = 1.25
		c_ys = 1
	end
	local offY = Images.clock_digits_glow:getHeight() - Images.clock_digits:getHeight()
	local offX = Images.clock_digits_glow:getWidth() - Images.clock_digits:getWidth()

	love.graphics.draw(Images.clock_digits_glow,c_x,c_y ,0,c_xs,c_ys,offX/2,offY/2)

	--love.graphics.setColor(150,100,125,255)
	--love.graphics.rectangle("fill", width/2 - 32, height/2 - 12, 64, 24)

	--hour
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(Images.clock_digits,WIDTH/2 - 27.5 , HEIGHT_HALF - 7)
	love.graphics.print(hour, WIDTH/2 - 22 - DEF_FONT:getWidth(hour)/2, HEIGHT_HALF - DEF_FONT_HALF)

	--minute
	love.graphics.draw(Images.clock_digits,WIDTH/2 - 13.5 , HEIGHT_HALF - 7)
	love.graphics.print(minute, WIDTH/2 - 8 - DEF_FONT:getWidth(minute)/2, HEIGHT_HALF - DEF_FONT_HALF)

	--second
	love.graphics.draw(Images.clock_digits,WIDTH/2 + 0.5, HEIGHT_HALF - 7)
	love.graphics.print(second, WIDTH/2 + 6 - DEF_FONT:getWidth(second)/2, HEIGHT_HALF - DEF_FONT_HALF)

	--ampm
	love.graphics.draw(Images.clock_digits,WIDTH/2 + 13.5 , HEIGHT_HALF - 7,0,1.25,1)
	love.graphics.print(ampm, WIDTH/2 + 20 - DEF_FONT:getWidth(ampm)/2, HEIGHT_HALF - DEF_FONT_HALF)
end
