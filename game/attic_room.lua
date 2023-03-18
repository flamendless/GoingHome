local squeak = false

local timer = 3

function SCENE.atticRoom_update(dt)
	attic_clock_anim:update(dt)
	sounds.clock_tick:play()
	sounds.clock_tick:setVolume(0.5)
	sounds.clock_tick:setLooping(true)

	if player.x < 10 then
		if squeak == true then
			sounds.floor_squeak:play()
			sounds.floor_squeak:setLooping(false)
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
				sounds.floor_hole:play()
				sounds.floor_hole:setLooping(false)

				ghost_event = "fall down"
				lightOn = false
				move = false
				player.y = -32
				player.grav = 1
				currentRoom = images["secretRoom"]

				player.visible = false
				player.img = images.player_down
			end
		end
	elseif ghost_event == "flashback" then
		if final_flashback == true then
			lightOn = true
			player.x = 80
			player.y = 37
			--here is the epic flashback scene -_-
			flashback_epic = true
			epic_scene_update(dt)
			lv = 1
		end
	end
	if temp_clock ~= nil then
		if temp_clock < clock - 3 then
			if event_trigger_light == 0 then
				if OS ~= "Android" or OS ~= "iOS" then
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
				sounds.fl_toggle:play()
			elseif _t == -1 then
				_flag = false
				sounds.fl_toggle:play()
			end
			lightOn = _flag
		elseif timer <= 0 then
			event_trigger_light = 2
			random_breathe = true
			timer = 3
		end
	elseif event_trigger_light == 2 then
		if timer > 0 then
			timer = timer - 1 * dt
			lightOn = false

		elseif timer <= 0 then
			event_trigger_light = -1
			lightOn = true
			move = true
			player.visible = true
		end
	end
end


local txt1 = "I have to find them faster"
local txt2 = "The light's running out"

function SCENE.atticRoom_draw()
	love.graphics.setColor(1, 1, 1, 1)
	attic_clock_anim:draw(images.clock_anim,width/2-12,22)

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
			sounds.item_got:play()
			solved = true
			move = true
			sounds.main_theme:stop()
			sounds.intro_soft:stop()
			sounds.finding_home:stop()
			sounds.ts_theme:stop()
		end
	end
end

function puzzle_draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(images.clock_base,width/2  - images.clock_base:getWidth()/2, height/2 - images.clock_base:getHeight()/2)

	--arrow
	if selected == "hour" then
		c_x = width/2 - 27.5
		c_y = height/2 - 7
		c_xs = 1
		c_ys = 1
	elseif selected == "minute" then
		c_x = width/2 - 13.5
		c_y = height/2 - 7
		c_xs = 1
		c_ys = 1

	elseif selected == "second" then
		c_x = width/2 + 0.5
		c_y = height/2 - 7
		c_xs = 1
		c_ys = 1

	elseif selected == "ampm" then
		c_x = width/2 + 13.5
		c_y = height/2 - 7
		c_xs = 1.25
		c_ys = 1
	end
	local offY = images.clock_digits_glow:getHeight() - images.clock_digits:getHeight()
	local offX = images.clock_digits_glow:getWidth() - images.clock_digits:getWidth()

	love.graphics.draw(images.clock_digits_glow,c_x,c_y ,0,c_xs,c_ys,offX/2,offY/2)

	--love.graphics.setColor(150,100,125,255)
	--love.graphics.rectangle("fill", width/2 - 32, height/2 - 12, 64, 24)

	--hour
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(images.clock_digits,width/2 - 27.5 , height/2 - 7)
	love.graphics.print(hour, width/2 - 22 - font:getWidth(hour)/2, height/2 - font:getHeight(hour)/2)

	--minute
	love.graphics.draw(images.clock_digits,width/2 - 13.5 , height/2 - 7)
	love.graphics.print(minute, width/2 - 8 - font:getWidth(minute)/2, height/2 - font:getHeight(minute)/2)

	--second
	love.graphics.draw(images.clock_digits,width/2 + 0.5, height/2 - 7)
	love.graphics.print(second, width/2 + 6 - font:getWidth(second)/2, height/2 - font:getHeight(second)/2)

	--ampm
	love.graphics.draw(images.clock_digits,width/2 + 13.5 , height/2 - 7,0,1.25,1)
	love.graphics.print(ampm, width/2 + 20 - font:getWidth(ampm)/2, height/2 - font:getHeight(ampm)/2)
end
