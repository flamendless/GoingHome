local Chair = Object:extend()

function Chair:new()
	self.img = IMAGES.store_chair
	self.x, self.y = 37, 34
	if self.img then
		self.w = self.img:getWidth()
		self.img_glow = IMAGES.store_chair_glow
	end
	self.glow = false
	self.push = 0
	self.vspeed = 10
	self.exists = true
end

function Chair:update(dt)
	if self.x < 16 then
		self.x = 16
	end

	self.glow = false

	if PLAYER.x + PLAYER.w < self.x + 2 and PLAYER.x + PLAYER.w > self.x then
		if PLAYER.dir == 1 then
			self.glow = true
			self.push = 1
		end
	elseif PLAYER.x > self.x + self.w - 2 and PLAYER.x < self.x + self.w then
		if PLAYER.dir == -1 then
			self.glow = true
			self.push = -1
		end
	else
		self.push = 0
		self.glow = false
	end

	if currentRoom == IMAGES["storageRoom"] then
		if self.x + self.w / 2 > WIDTH / 2 then
			PLAYER:moveRoom(PLAYER.x, IMAGES["hallwayLeft"])
		end
	elseif currentRoom == IMAGES["hallwayLeft"] then
		if self.x + self.w / 2 > WIDTH - 16 then
			PLAYER:moveRoom(10, IMAGES["masterRoom"])
			self.x = PLAYER.x + PLAYER.w
		end
	elseif currentRoom == IMAGES["masterRoom"] then
		if self.x + self.w / 2 > WIDTH / 2 - 10 then
			PLAYER:moveRoom(PLAYER.x + 10, IMAGES["secretRoom"])
			self.x = PLAYER.x + PLAYER.w
		end
	elseif currentRoom == IMAGES["secretRoom"] then
		if self.x > 77 then
			PUSHING_ANIM = false
			MOVE_CHAIR = false
			self.exists = false
			event_find = false
			chair_finished = true
			--insert new interactable chair
			if chair_final == false then
				local chair = Items(IMAGES.store_chair, IMAGES["secretRoom"], self.x, 34, "chair_final")
				table.insert(ITEMS_LIST, chair)
				local cd = Interact(false, { "With this chair", "You can now reach the ladder", "Go up?" }, { "Yes", "No" },
					"", "chair_final")
				table.insert(DIALOGUES, cd)
				chair_final = true
			end
		end
	end

	if FADE_OBJ.state == false then
		if love.keyboard.isDown("e") then
			if self.glow == true then
				if SOUNDS.chair_move:isPlaying() == false then
					SOUNDS.chair_move:play()
					SOUNDS.chair_move:setVolume(0.8)
					SOUNDS.chair_move:setLooping(false)
				end
				PLAYER.x = PLAYER.x + self.push * self.vspeed * dt
				self.x = self.x + self.push * self.vspeed * dt
				PUSHING_ANIM = true
			end
		else
			PUSHING_ANIM = false
		end
	else
		PUSHING_ANIM = false
	end
end

function Chair:keypressed(dt, key)
	if FADE_OBJ.state or (key ~= "e") then
		PUSHING_ANIM = false
		return
	end

	if not self.glow then return end

	if SOUNDS.chair_move:isPlaying() == false then
		SOUNDS.chair_move:play()
		SOUNDS.chair_move:setVolume(0.7)
		SOUNDS.chair_move:setLooping(false)
	end
	PLAYER.x = PLAYER.x + self.push * self.vspeed * dt
	self.x = self.x + self.push * self.vspeed * dt
	PUSHING_ANIM = true
end

function Chair:draw()
	love.graphics.setColor(1, 1, 1, 1)

	local offY = self.img_glow:getHeight() - self.img:getHeight()
	local offX = self.img_glow:getWidth() - self.img:getWidth()

	--love.graphics.rectangle("line",self.x,self.y,self.w,10)
	--love.graphics.rectangle("line",player.x,player.y,player.w,32)

	if self.glow == true then
		love.graphics.draw(self.img_glow, self.x, self.y, 0, 1, 1, offX / 2, offY / 2)
	else
		love.graphics.draw(self.img, self.x, self.y)
	end
end

return Chair
