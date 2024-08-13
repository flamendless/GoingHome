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
	if ENDING_LEAVE_EVENT == 1 then
		player_color = true
		LIGHT_ON = false
		LIGHT_VALUE = 1
		MOVE = false
		if c < #text1 then
			if timer > 0 then
				timer = timer - 1 * dt
				if timer <= 0 then
					timer = maxTimer
					c = c + 1
				end
			end
		else
			ENDING_LEAVE_EVENT = 2
		end
	elseif ENDING_LEAVE_EVENT == 2 then
		if LIGHT_VALUE > 0 then
			LIGHT_VALUE = LIGHT_VALUE - 60 * dt
			if LIGHT_VALUE <= 0 then
				LIGHT_VALUE = 0
				MOVE = true
			end
		else
			LIGHT_ON = true
		end
	end

	if currentRoom == IMAGES["mainRoom"] then
		if SOUNDS.knock:isPlaying() == false then
			SOUNDS.knock:play()
			SOUNDS.knock:setLooping(true)
		end
	end

	--end room
	if currentRoom == IMAGES["endRoom"] then
		MOVE = false
		random_breathe_flag = false
		SOUNDS.knock:setLooping(false)
		SOUNDS.knock:stop()
		LIGHT_ON = false
		if LIGHT_VALUE > 0 then
			MOVE = false
			LIGHT_VALUE = LIGHT_VALUE - 60 * dt
			if LIGHT_VALUE <= 0 then
				LIGHT_VALUE = 0
				--activate the player panic animation
				ENDING_ANIMATE = true
				ending_final = -1
			end
		elseif LIGHT_VALUE <= 0 then
			LIGHT_VALUE = 0
			--activate the player panic animation
			ENDING_ANIMATE = true
			ending_final = -1
		end
		if player_ending_shot == true then
			if va < 1 then
				va = va + 500 * dt
			elseif va >= 1 then
				if shotTimer > 0 then
					shotTimer = shotTimer - 1 * dt
					if shotTimer > 0 and shotTimer < 1 then
						if gun_click_flag == false then
							gun_click_flag = true
							SOUNDS.gun_click:play()
							SOUNDS.gun_click:setLooping(false)
						end
					elseif shotTimer <= 0 then
						if ending_shot == 0 then
							shotTimer = 2
							ending_shot = 1
							SOUNDS.gunshot:play()
							SOUNDS.gunshot:setLooping(false)
							final_clock = seconds_to_clock(CLOCK)
						elseif ending_shot == 1 then
							-- sounds.ts_theme:play()
							-- sounds.ts_theme:setLooping(true)
							ending_shot = -1
							credit_set_ending("leaving home")
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
	if ENDING_LEAVE_EVENT == 1 then
		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.rectangle("fill", 0, 16, 128, 32)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.print(text1[c], WIDTH / 2 - DEF_FONT:getWidth(text1[c]) / 2, HEIGHT_HALF - DEF_FONT_HALF)
	end

	--end room
	if currentRoom == IMAGES["endRoom"] then
		if player_ending_shot == true then
			love.graphics.setColor(0, 0, 0, va)
			love.graphics.rectangle("fill", 0, 16, 128, 32)
		end
		if credits_flag == true then
			credits_draw()
		end
	end
end
