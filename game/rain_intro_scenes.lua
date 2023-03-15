local has_played = false
local car_alpha = -250/255
local pd_alpha = -250/255
local ih_alpha = -200/255
local ih_text = "A Game By: \n Brandon"
local pd_text = "Art by: \n Wits"
local car_moving_text = "Music by: \n Brandon"
local _timer = 2
local text_flag = false
local current_text, current_text_x, current_text_y
local car_show = true
local pd_show = false
local in_house_show = false
local timer_start = false
local anim_timer = 0
local begin_fade_out = false
local fade_alpha = 0


function intro_load()
	timer_start = false
	anim_timer = 0
	begin_fade_out = false
	fade_alpha = 0

	car_alpha = -250/255
	pd_alpha = -250/255
	ih_alpha = -200/255

	pd_text = "A Game By: \n Brandon"
	ih_text = "Art by: \n Wits"
	car_moving_text = "Music by: \n Brandon"
	_timer = 2
	text_flag = false

	current_text = car_moving_text
	current_text_x = width/2 - 32 - font:getWidth(current_text)/2
	current_text_y = height/2 - font:getHeight()/2

	car_show = true
	pd_show = false
	in_house_show = false
end

function intro_next()
	if not timer_start then
		anim_timer = 0
		timer_start = true
		return
	end

	if car_show then
		current_text = pd_text
		current_text_x = width/2  +10 - font:getWidth(current_text)/2
		current_text_y = height/2 - font:getHeight()/2
		pd_show = true
		car_show = false
	end
end

function intro_update(dt)
	if not has_played then
		sounds.intro_soft:play()
		sounds.intro_soft:setLooping(false)
		has_played = true
	end

	if begin_fade_out then
		fade_alpha = fade_alpha + 0.2 * dt

		if fade_alpha >= 1 then
			in_house_show = false
			text_flag = false
			sounds.intro_soft:stop()
		end
	end

	if timer_start then
		anim_timer = anim_timer + dt

		if car_show and anim_timer >= 2 then
			intro_next()
		end
	end

	skip_button:update(dt)
	-- if pressed == true then
	-- 	skip_button_glow:update(dt)
	-- end

	--car moving
	if car_show == true then
		if car_alpha < 1 then
			car_alpha = car_alpha + (40/100) * dt
		end
		if car_alpha >= 0.6 then
			text_flag = true
			car_anim:update(dt)
		end
	end

	--player door
	if pd_show == true then
		if pd_alpha < 1 then
			pd_alpha = pd_alpha + 30/100 * dt
		end
		if pd_alpha >= 0.7 then
			pd_anim:update(dt)
		end
		if pd_alpha >= 0.5 then
			text_flag = true
		end
		if pd_alpha >= 1 then
			in_house_show = true
		end
	end

	--in house
	if in_house_show == true then
		current_text = ih_text
		current_text_x = width/2 + 10- font:getWidth(current_text)/2
		current_text_y = height/2 - 12 - font:getHeight()/2

		ih_anim:update(dt)

		ih_alpha = ih_alpha + 40/100 * dt

		if ih_alpha >= 0.6 then
			pd_show = false
		end
		if ih_alpha >= 1 then
			begin_fade_out = true
		end
	end

	if not sounds.intro_soft:isPlaying() then
		fade.state = true
		states = "tutorial"
		-- states = "intro"
		gamestates.load()
		sounds.intro_soft:stop()
	end

	if text_flag == true then
		if _timer <= 2 then
			_timer = _timer - 1 * dt
		end
		if _timer <= 0 then
		 	text_flag = false
		 	_timer = 2
		end
	end
end

function intro_draw()
	love.graphics.setBackgroundColor(0,0,0,1)
	love.graphics.setColor(1, 1, 1)
	--car moving
	if car_show == true then
		love.graphics.setColor(1, 1, 1, car_alpha)
		car_anim:draw(images.car_moving,width - 32 - 16,height/2 - 24)
	end

	--in house
	if in_house_show == true then
	love.graphics.setColor(1, 1, 1, 1)
		ih_anim:draw(images.in_house,0,0)
	end

	--player door
	if pd_show == true then
		love.graphics.setColor(1, 1, 1, pd_alpha)
		pd_anim:draw(images.player_door,width/2 - 32 - 8, height/2 - 12)
	end

	--texts
	if text_flag == true then
		love.graphics.setFont(font)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.print(current_text, current_text_x, current_text_y)
	end

	skip_draw()

	love.graphics.setColor(0, 0, 0, fade_alpha)
	love.graphics.rectangle("fill", 0, 0, width, height)
	love.graphics.setColor(1, 1, 1, 1)
end
