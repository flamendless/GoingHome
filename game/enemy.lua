local Enemy = Object:extend()

function Enemy:new(x,y,w,h)
	self.x = x -- w/2
	self.y = y -- h/2
	self.w,self.h = w,h
	self.grav = 1
	self.image = enemy_idle
	self.rot,self.xscale,self.yscale = 0,1,1
	self.ox = w/2
	self.timer = 2
	self.count = true
	self.chaseOn = false
	self.spd = 25 --30
	self.trigger = false
end

function Enemy:update(dt)

	if MOVE == false then
		self.image = enemy_idle
	end

	--lightning
	if LIGHTNING_STRIKE == true then
		if self.x <= PLAYER.x and self.x >= PLAYER.x + PLAYER.w then
			GAMEOVER = true
		end
		if PLAYER.x < self.x and PLAYER.x > self.x - 14 or PLAYER.x > self.x and PLAYER.x < self.x + 8 then
			self.chaseOn = true
		end
	end

	--special events
	if GHOST_EVENT == "no escape" then
		--collision
		if MOVE == true then
			if self.x >= PLAYER.x and self.x <= PLAYER.x + PLAYER.w then
				self.chaseOn = false
				GAMEOVER = true
			else
				self.chaseOn = true
			end
		else
			self.chaseOn = false
		end
	elseif GHOST_EVENT == "fall down" or GHOST_EVENT == "lying down" or GHOST_EVENT == "flashback" then
		ENEMY_EXISTS = false
	end
	----

	if self.trigger == false then
		ENEMY_EXISTS = false
	end

	if currentRoom == IMAGES["hallwayLeft"] or
		currentRoom == IMAGES["hallwayRight"] or
		currentRoom == IMAGES["masterRoom"] or
		currentRoom == IMAGES["kitchen"] or
		currentRoom == IMAGES["daughterRoom"] or
		currentRoom == IMAGES["storageRoom"] or
		currentRoom == IMAGES["mainRoom"] or
		currentRoom == IMAGES["livingRoom"] then
		self.trigger = true
	end

	if event == "secret_room_first" or event == "after_secret_room" or event == "after_dialogue" then
		if currentRoom == IMAGES["secretRoom"] then
			ENEMY_EXISTS = false
		end
	end

	if self.y < HEIGHT - 20 - self.h then
		self.y = self.y + self.grav
	end

	self.image:update(dt)

	if ENEMY_EXISTS == true then
		if self.image == enemy_move then
			--move towards player
			--set image orientation
			if self.x <= PLAYER.x then
				self.xscale = 1
			else self.xscale = -1 end
		end

		if MOVE == true and SEEN == true and self.count == true then
			self.timer = self.timer - dt
			if self.timer <= 0 then
				self:chase(dt)
				self.count = false
				self.chaseOn = true
			end

			if self.chaseOn == false then
				SOUNDS.enemy_mys_sound:play()
			else
				SOUNDS.enemy_mys_sound:stop()
			end
		end
	end

	if self.chaseOn == true then self:chase(dt) end
end

function Enemy:draw()
	self.image:draw(IMAGES.enemy_sheet,self.x,self.y,self.rot,self.xscale,self.yscale,self.ox)
end

--enemy actions

function Enemy:chase(dt)

	--sounds
	if SOUNDS.enemy_scream:isPlaying() == false then
		SOUNDS.enemy_chase:play()
	end
	----

	self.image = enemy_move

	--move towards player
	if PLAYER.x <= self.x then --if player is in the left
		self.x = self.x - self.spd * dt
	else self.x = self.x + self.spd * dt end

	--collision
	if self.x >= PLAYER.x and self.x <= PLAYER.x + PLAYER.w then
		self.chaseOn = false
		GAMEOVER = true
	end

	--avoid
	if self.chaseOn == true then
		if GHOST_EVENT ~= "still no escape" then
			if LIGHT_ON == false then
				local random = math.floor(math.random(100))
				if random <= 20 then
					self.chaseOn = false
				end
			end
		end
	end
end

function Enemy:action_inside()
	self.image = enemy_move
	SEEN = true
	self.chaseOn = true
end

function Enemy:action_near()
	self.image = enemy_mys
	self.count = true
	SEEN = true
end

function Enemy:action_none()
	if self.chaseOn == false then
		self.image = enemy_idle
	end
	SEEN = false
end

return Enemy
