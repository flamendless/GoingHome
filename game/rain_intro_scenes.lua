local has_played = false

function intro_load()
	_timer = 2 --seconds

	car_alpha = -250/255
	pd_alpha = -250/255
	ih_alpha = -200/255

	ih_text = "A Game By: \n Brandon"
	pd_text = "Art by: \n Brandon"
	car_moving_text = "Music by: \n Brandon"


	text_flag = false


	current_text = car_moving_text
	current_text_x = width/2 - 32 - font:getWidth(current_text)/2
	current_text_y = height/2 - font:getHeight(current_text)/2

	car_show = true
	pd_show = false
	in_house_show = false
end

function intro_update(dt)
	if not has_played then
		sounds.intro_soft:play()
		sounds.intro_soft:setLooping(false)
		has_played = true
	end

	skip_button:update(dt)
	-- if pressed == true then
	-- 	skip_button_glow:update(dt)
	-- end

	--car moving
	if car_show == true then
		if car_alpha < 1 then
			car_alpha = car_alpha + 40/255 * dt
		end
		if car_alpha >= 1 then
			text_flag = true
			car_anim:update(dt)
		end
		if car_alpha >= 1 then
			current_text = pd_text
			current_text_x = width/2  +10 - font:getWidth(current_text)/2
			current_text_y = height/2 - font:getHeight(current_text)/2
			pd_show = true
			car_show = false
		end
	end

	--player door
	if pd_show == true then
		if pd_alpha < 1 then
			pd_alpha = pd_alpha + 30/255 * dt
		end
		if pd_alpha >= 60/255 then
			pd_anim:update(dt)
		end
		if pd_alpha >= 40/255 then
			text_flag = true
		end
		if pd_alpha >= 200/255 then
			in_house_show = true
		end
	end

	--in house
	if in_house_show == true then

		current_text = ih_text
		current_text_x = width/2 + 10- font:getWidth(current_text)/2
		current_text_y = height/2 + 12 - font:getHeight()/2

		ih_anim:update(dt)

		if ih_alpha < 1 then
			ih_alpha = ih_alpha + 40/255 * dt
		end
		if ih_alpha >= 100/255 then
			pd_show = false
		end
		if ih_alpha >= 200/255 then
			in_house_show = false
			text_flag = false
		end
	end

	if not sounds.intro_soft:isPlaying() then
		fade.state = true
		states = "intro"
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
end
