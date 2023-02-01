local timer = 2

function particle_set()
	local img = images.dust
 
	psystem = love.graphics.newParticleSystem(img, 10)
	psystem:setParticleLifetime(2, 5) -- Particles live at least 2s and at most 5s.
	psystem:setEmissionRate(10)
	psystem:setSizeVariation(1)
	psystem:setLinearAcceleration(-20,50,20, 100) -- Random movement in all directions.
	psystem:setColors(1, 1, 1, 150/255, 1, 1, 1, 0) -- Fade to transparency.
	--psystem:setSpeed(10, 50)
	psystem:setDirection(270 * math.pi / 180 )
	--psystem:setSpread(45 * math.pi/180)\
end

function particle_draw()
	-- Draw the particle system at the center of the game window.

	if ghost_event == "fall down" then
		love.graphics.draw(psystem,20,19)
	else love.graphics.draw(psystem, 90,19) end
end

function particle_update(dt)
	psystem:update(dt)

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
			sounds.body_fall:play()
			sounds.body_fall:setLooping(false)
		end
	end
end
