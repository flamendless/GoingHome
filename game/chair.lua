local Chair = Object:extend()

function Chair:new()
	self.img = Images.store_chair
	self.x, self.y = 37,34
	self.w = self.img:getWidth()
	self.img_glow = Images.store_chair_glow
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
	
	if player.x + player.w < self.x + 2 and player.x + player.w > self.x then
		if player.dir == 1 then
			self.glow = true
			self.push = 1
		end
	elseif player.x > self.x + self.w - 2 and player.x < self.x + self.w then
		if player.dir == -1 then
			self.glow = true
			self.push = -1
		end
	else 
		self.push = 0
		self.glow = false
	end

	if currentRoom == Images["storageRoom"] then
		if self.x + self.w/2 > WIDTH/2 then
			player:moveRoom(player.x, Images["hallwayLeft"])
		end
	elseif currentRoom == Images["hallwayLeft"] then
		if self.x + self.w/2 > WIDTH - 16 then
			player:moveRoom(10,Images["masterRoom"])
			self.x = player.x + player.w
		end
	elseif currentRoom == Images["masterRoom"] then
		if self.x + self.w/2 > WIDTH/2 - 10 then
			player:moveRoom(player.x+10,Images["secretRoom"])
			self.x = player.x + player.w
		end
	elseif currentRoom == Images["secretRoom"] then
		if self.x > 77 then
			pushing_anim = false
			move_chair = false
			self.exists = false
			event_find = false
			chair_finished = true
			--insert new interactable chair
			if chair_final == false then
		    	local chair = Items(Images.store_chair,Images["secretRoom"],self.x,34,"chair_final")
		    	table.insert(obj,chair)
		    	local cd = Interact(false,{"With this chair","You can now reach the ladder","Go up?"},{"Yes","No"},"","chair_final")
				table.insert(dialogue,cd)
				chair_final = true
			end
		end
	end

	if fade.state == false then
		if love.keyboard.isDown("e") then
			if self.glow == true then
				if Sounds.chair_move:isPlaying() == false then
					Sounds.chair_move:play()
					Sounds.chair_move:setVolume(0.7)
					Sounds.chair_move:setLooping(false)
				end
				player.x = player.x + self.push * self.vspeed * dt
				self.x = self.x + self.push * self.vspeed * dt
				pushing_anim = true
			end
		else
			pushing_anim = false 
		end
	else pushing_anim = false end

end

function Chair:keypressed(dt,key)
	if fade.state == false then
		if key == "e" then
			if self.glow == true then
				if Sounds.chair_move:isPlaying() == false then
					Sounds.chair_move:play()
					Sounds.chair_move:setVolume(0.7)
					Sounds.chair_move:setLooping(false)
				end
				player.x = player.x + self.push * self.vspeed * dt
				self.x = self.x + self.push * self.vspeed * dt
				pushing_anim = true
			end
		else
			pushing_anim = false
		end
	else pushing_anim = false end
end

function Chair:draw()
	love.graphics.setColor(1, 1, 1, 1)

	local offY = self.img_glow:getHeight()-self.img:getHeight()
	local offX = self.img_glow:getWidth()-self.img:getWidth()

	--love.graphics.rectangle("line",self.x,self.y,self.w,10)
	--love.graphics.rectangle("line",player.x,player.y,player.w,32)

	if self.glow == true then
		love.graphics.draw(self.img_glow,self.x,self.y,0,1,1,offX/2,offY/2)
	else
		love.graphics.draw(self.img,self.x,self.y)
	end
end

return Chair
