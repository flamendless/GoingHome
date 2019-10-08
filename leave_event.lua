local timer = 3
local maxTimer = 3
local c = 1
local text1 = {
	 "",
	 "",
	 "It's already morning",
	 "Down there...",
	 "That felt like eternity",
	 "I don't know what to do..",
	 "...",
	 "I know mother would",
	 "not like it if",
	 "I kill or dispose him",
	 "...",
	 "I must prepare for work",
	 "It's true",
	 "...",
	 "I am just alone",
	 "",
	 "Everyday it's like this",
	 "Going home...",
	"for me...",
	"is going insane..",
	"more and more...",
	"",
}
local va = 0
local shotTimer = 2


function leave_event_update(dt)
	if ending_leave_event == 1 then
		player_color = true
		lightOn = false
		lv = 255
		move = false
		if c < #text1 then
			if timer > 0 then
				timer = timer - 1 * dt
				if timer <= 0 then
					timer = maxTimer
					c = c + 1
				end
			end
		else
			ending_leave_event = 2
		end
	elseif ending_leave_event == 2 then
		if lv > 0 then
			lv = lv - 60 * dt
			if lv <= 0 then
				lv = 0
				move = true
			end
		else
			lightOn = true
		end
	end


	if currentRoom == images["mainRoom"] then
		if sounds.knock:isPlaying() == false then
			sounds.knock:play()
			sounds.knock:setLooping(true)
		end
	end

	--end room
	if currentRoom == images["endRoom"] then
		move = false
		random_breathe_flag = false
		sounds.knock:setLooping(false)
		sounds.knock:stop()
		lightOn = false
		if lv > 0 then
			move = false
			lv = lv - 60 * dt
			if lv <= 0 then
				lv = 0
				--activate the player panic animation
				ending_animate = true
				ending_final = -1
			end
		elseif lv <= 0 then
			lv = 0
			--activate the player panic animation
			ending_animate = true
			ending_final = -1
		end
		if player_ending_shot == true then
			if va < 255 then
				va = va + 1000 * dt
			elseif va >= 255 then
				if shotTimer > 0 then
					shotTimer = shotTimer - 1 * dt
					if shotTimer >0 and shotTimer <1 then
						if gun_click_flag == false then
							gun_click_flag = true
							sounds.gun_click:play()
							sounds.gun_click:setLooping(false)
						end
					elseif shotTimer <= 0 then
						if ending_shot == 0 then
							shotTimer = 2
							ending_shot = 1
							sounds.gunshot:play()
							sounds.gunshot:setLooping(false)
							final_clock = seconds_to_clock(clock)
						elseif ending_shot == 1 then
							-- sounds.ts_theme:play()
							-- sounds.ts_theme:setLooping(true)
							ending_shot = -1
							credits = "leaving home"
							credits_load()
						end
					end
				end
			end
		end
	end
	if credits_flag == true then
		credits_update(dt)
	end
end

function leave_event_draw()
	if ending_leave_event == 1 then
		love.graphics.setColor(0,0,0,1)
		love.graphics.rectangle("fill",0,16,128,32)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.print(text1[c],width/2 - font:getWidth(text1[c])/2, height/2 - font:getHeight(text1[c])/2)
	end

	--end room
	if currentRoom == images["endRoom"] then
		if player_ending_shot == true then
			love.graphics.setColor(0,0,0,va)
			love.graphics.rectangle("fill",0,16,128,32)
		end
		if credits_flag == true then
			credits_draw()
		end
	end
end

