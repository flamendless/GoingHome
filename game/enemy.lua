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

	if move == false then
		self.image = enemy_idle
	end

	--lightning
	if lStrike == true then
		if self.x <= player.x and self.x >= player.x + player.w then
			gameover = true
		end
		if player.x < self.x and player.x > self.x - 14 or player.x > self.x and player.x < self.x + 8 then
			self.chaseOn = true
		end
	end

	--special events
	if ghost_event == "no escape" then
		--collision
		if move == true then
			if self.x >= player.x and self.x <= player.x + player.w then
				self.chaseOn = false
				gameover = true
			else
				self.chaseOn = true
			end
		else
			self.chaseOn = false
		end
	elseif ghost_event == "fall down" or ghost_event == "lying down" or ghost_event == "flashback" then
		enemy_exists = false
	end
	----

	if self.trigger == false then
		enemy_exists = false
	end

	if currentRoom == Images["hallwayLeft"] or
		currentRoom == Images["hallwayRight"] or
		currentRoom == Images["masterRoom"] or
		currentRoom == Images["kitchen"] or
		currentRoom == Images["daughterRoom"] or
		currentRoom == Images["storageRoom"] or
		currentRoom == Images["mainRoom"] or
		currentRoom == Images["livingRoom"] then
		self.trigger = true
	end

	if event == "secret_room_first" or event == "after_secret_room" or event == "after_dialogue" then
		if currentRoom == Images["secretRoom"] then
			enemy_exists = false
		end
	end

	if self.y < HEIGHT - 20 - self.h then
		self.y = self.y + self.grav
	end

	self.image:update(dt)

	if enemy_exists == true then
		if self.image == enemy_move then
			--move towards player
			--set image orientation
			if self.x <= player.x then
				self.xscale = 1
			else self.xscale = -1 end
		end

		if move == true and seen == true and self.count == true then
			self.timer = self.timer - dt
			if self.timer <= 0 then
				self:chase(dt)
				self.count = false
				self.chaseOn = true
			end

			if self.chaseOn == false then
				Sounds.enemy_mys_sound:play()
			else
				Sounds.enemy_mys_sound:stop()
			end
		end
	end

	if self.chaseOn == true then self:chase(dt) end
end

function Enemy:draw()
	self.image:draw(Images.enemy_sheet,self.x,self.y,self.rot,self.xscale,self.yscale,self.ox)
end

--enemy actions

function Enemy:chase(dt)

	--sounds
	if Sounds.enemy_scream:isPlaying() == false then
		Sounds.enemy_chase:play()
	end
	----

	self.image = enemy_move

	--move towards player
	if player.x <= self.x then --if player is in the left
		self.x = self.x - self.spd * dt
	else self.x = self.x + self.spd * dt end

	--collision
	if self.x >= player.x and self.x <= player.x + player.w then
		self.chaseOn = false
		gameover = true
	end

	--avoid
	if self.chaseOn == true then
		if ghost_event ~= "still no escape" then
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
	seen = true
	self.chaseOn = true
end

function Enemy:action_near()
	self.image = enemy_mys
	self.count = true
	seen = true
end

function Enemy:action_none()
	if self.chaseOn == false then
		self.image = enemy_idle
	end
	seen = false
end

return Enemy
