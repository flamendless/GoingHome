local timer = 2

function particle_set()
	local img = Images.dust

	PSYSTEM = love.graphics.newParticleSystem(img, 10)
	PSYSTEM:setParticleLifetime(2, 5) -- Particles live at least 2s and at most 5s.
	PSYSTEM:setEmissionRate(10)
	PSYSTEM:setSizeVariation(1)
	PSYSTEM:setLinearAcceleration(-20,50,20, 100) -- Random movement in all directions.
	PSYSTEM:setColors(1, 1, 1, 150/255, 1, 1, 1, 0) -- Fade to transparency.
	--psystem:setSpeed(10, 50)
	PSYSTEM:setDirection(270 * math.pi / 180 )
	--psystem:setSpread(45 * math.pi/180)\
end

function particle_draw()
	-- Draw the particle system at the center of the game window.

	if ghost_event == "fall down" then
		love.graphics.draw(PSYSTEM,20,19)
	else love.graphics.draw(PSYSTEM, 90,19) end
end

function particle_update(dt)
	PSYSTEM:update(dt)

	if dust_trigger == true then
		if timer > 0 then
			timer = timer - 1 * dt
		end
		if timer <= 0 then
			dust_trigger = false
		end
	end

	if ghost_event == "fall down" then
		if timer > 0 then
			timer = timer - 1 * dt
		end
		if timer <= 0 then
			--fade.state = true
			ghost_event = "lying down"
			Sounds.body_fall:play()
			Sounds.body_fall:setLooping(false)
		end
	end
end
