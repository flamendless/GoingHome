local Interact = Object:extend()

local trigger = 0
sink_trigger = 0

function Interact:new(state,txt,opt_txt,sm,tag)
	self.sm = sm
	self.simpleMessage = false
	self.maxT = 1.5 --2.5
	self.timer = self.maxT
	self.specialTxt = false

	self.sp_1 = ""
	self.sp_2 = ""

	self.txt = txt or {}
	self.font = font
	self.font:setFilter("nearest","nearest",1)

	self.x = {}
	self.y = {}
	for i = 1, #self.txt do
		self.x[i] = width/2 - self.font:getWidth(self.txt[i])/2
		self.y[i] = 0 + self.font:getHeight(self.txt[i])/4
	end

	self.tag = tag
	self.state = state
	self.n = 1

	self.opt_txt = opt_txt or {}
	self.option = false

	white = {1, 1, 1, 1}
	red = {1, 0, 0, 1}

	self.cursor = 1
	self.opt1 = white
	self.opt2 = white


	self.sp_2_show = false

	self.toRemove = ""
	self._door = false
	self._dt = "I have to find them first"
end

function Interact:update(dt)

	if gameover == true then
		self.state = false
	end

	if self.state == false then

	end

	if self.state == true then
		if self.n > #self.txt then
			self.option = true
		end

		if self.option == true then
			if self.cursor == 1 then
				self.opt1 = red
				self.opt2 = white
			elseif self.cursor == 2 then
				self.opt1 = white
				self.opt2 = red
			end
		end

	elseif self.state == false and self.option == false then
		self.n = 1
	elseif self.state == false or self.option == false then
		self.n = 1
	end

	if self.simpleMessage == true then
		self.timer = self.timer - 1 * dt
		if self.timer <= 0 then
			self.timer = self.maxT
			self.simpleMessage = false
			self.specialTxt = false
			self.state = false
			self.option = false
			move = true
		end
	end

	if self.specialTxt == true then
		if self.sp_2_show == true then
			self.timer = self.timer - 1 * dt
			if self.timer <= 0 then
				self.timer = self.maxT
				self.simpleMessage = false
				self.specialTxt = false
				self.sp_2_show = false
				self.state = false
				self.option = false
				self.simpleMessage = false
				move = true
				setRemove(self.toRemove)
			end
		else
			self.timer = self.timer - 1 * dt
			if self.timer <= 1 then
				self.timer = self.maxT
				self.sp_2_show = true
			end
		end
	end

	if self._door == true then
		self.timer = self.timer -1 * dt
		if self.timer <= 0 then
			self.timer = self.maxT
			self.simpleMessage = false
			self.state = false
			self._door = false
			move = true
		end
	end
end

function Interact:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setFont(self.font)
	if self.state == true then
		if self.option == false then
			love.graphics.print(self.txt[self.n],self.x[self.n],self.y[self.n])
		else
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.print(self.txt[#self.txt],self.x[#self.txt],self.y[#self.txt])

			love.graphics.setColor(self.opt1)
			love.graphics.print(self.opt_txt[1],width/4 - self.font:getWidth(self.opt_txt[1])/2, height - self.font:getHeight(self.opt_txt[1])/2 - 8)

			love.graphics.setColor(self.opt2)
			love.graphics.print(self.opt_txt[2],width - self.font:getWidth(self.opt_txt[2])/2 - width/4, height - self.font:getHeight(self.opt_txt[2])/2 - 8)
		end
	end
	if self.simpleMessage == true then
		if self.font:getWidth(self.sm) >= width - 16 then
			local sw = string.len(self.sm)
			local s1 = string.sub(self.sm,1,sw/2)
			local s2 =	string.sub(self.sm,sw/2+1)

			love.graphics.print(s1,width/2 - self.font:getWidth(s1)/2,0 + self.font:getHeight(s1)/4)
			love.graphics.print(s2,width/2 - self.font:getWidth(s2)/2,height - self.font:getHeight(s2)/2 - 8)
		else
			love.graphics.print(self.sm,width/2 - self.font:getWidth(self.sm)/2,height - self.font:getHeight(self.sm)/2 - 8)
		end
	end

	if self.specialTxt == true then
		love.graphics.print(self.sp_1,width/2 - self.font:getWidth(self.sp_1)/2,0 + self.font:getHeight(self.sp_1)/4)

		if self.sp_2_show == true then
			love.graphics.print(self.sp_2,width/2 - self.font:getWidth(self.sp_2)/2,height - self.font:getHeight(self.sp_2)/2 - 8)
		end
	end

	if self._door == true then
		love.graphics.print(self._dt, width/2 - self.font:getWidth(self._dt)/2,0+self.font:getHeight(self._dt)/4)

	end

end

function Interact:returnChoices(choice)
	local choice = choice
	if choice == 1 then
		for k,v in pairs(obj_properties.static) do
			if self.tag == v then
				self.simpleMessage = true
			end
		end

		for k,v in pairs(obj_properties.dynamic) do
			if self.tag == v then
				for n,m in pairs(obj) do
					if self.tag == m.tag then
						m:checkFunction()
					end
				end
			end
		end

		self:checkItem()
	else
		if self.tag == "refrigerator" then
			self:special_text("There's a note:","'Ephesians 2:8'")

		elseif self.tag == "chair" then
			self:special_text("I will just push it","")

			for k,v in pairs(obj) do
				if v.tag == "chair" then
					v.visible = false
				end
			end

			self.state = false
			move = true
			self.option = false
			move_chair = true
		else
			self.state = false
			move = true
			self.option = false
		end
	end

	self.state = false
	self.option = false
end

function Interact:special_text(str1,str2)
	self.simpleMessage = false
	self.specialTxt = true
	self.sp_1 = str1
	self.sp_2 = str2
	self.sp_2_show = false
end

function Interact:checkItem()
	for k,v in pairs(obtainables) do
		for n,m in pairs(dialogue) do
			for i,o in pairs(obj) do
				if o.tag and self.tag == "cabinet" and obtainables["cabinet"] == true then
					m:special_text("There's a toy hammer","You've got a toy hammer")
					self.toRemove = "cabinet"
					--sound of item acquired
					sounds.item_got:play()
				elseif o.tag and self.tag == "toy" and obtainables["toy"] == true then
					m:special_text("There's an air pumper.","You've got an air pumper")
					self.toRemove = "toy"
					--sound of item acquired
					sounds.item_got:play()
				elseif o.tag and self.tag == "hoop" and obtainables["ball"] == false then
					self.toRemove = "ball"
					--sound of item acquired
					sounds.item_got:play()
				elseif o.tag and self.tag == "hole" and obtainables["hole"] == false then
					--self.toRemove = "hole"
					if obtainables["head_key"] == true then
						m:special_text("","you've picked up the key")
						obtainables["head_key"] = false
						--sound of item acquired
						sounds.item_got:play()
						if mid_dial == 0 then mid_dial = 1 end
						trigger = 1
						do return end
					elseif obtainables["head_key"] == false then
						if trigger == 1 then
							m:special_text("","There's nothing more here")
						end
					end
				elseif o.tag and self.tag == "sink" then
					if obtainables["kitchen key"] == true then
						m:special_text("","its locked")

					elseif obtainables["kitchen key"] == false then
						self.toRemove = "sink"
						if obtainables["crowbar"] == false then
							if sink_trigger == 0 then
								sink_trigger = 1
								do return end
							elseif sink_trigger == 1 then
								m:special_text("","Nothing more here")
							end
						end
					end

				elseif o.tag and self.tag == "master bed" then
					--self.toRemove = ""
					if obtainables["kitchen key"] == true then
						m:special_text("There's a key","it has a spatula keychain")
						sounds.item_got:play()
						--self.toRemove = "master bed"
						obtainables["kitchen key"] = false
						if bed_trigger == 0 then
							bed_trigger = 1
							do return end
						elseif bed_trigger == 1 then
							m:special_text("","Nothing else here")
						end
					elseif obtainables["kitchen key"] == false then
						m:special_text("","Nothing else here")
					end
				elseif o.tag and self.tag == "tv" then
					if tv_open_volume == true then
						m:special_text("I'll just mute it","")
						sounds.tv_loud:stop()
						tv_open_volume = false
					end
				elseif o.tag and self.tag == "open_vault" then
					if obtainables["rope"] == true then
						if rope_trigger == 0 then
							m:special_text("","Something fell")
							local rope = Items(images.rope,images["secretRoom"],80,20,"rope")
							table.insert(obj,rope)
							sounds.item_got:play()
							self.toRemove = "open_vault"
							obtainables["rope"] = false
							rope_trigger = 1
							do return end
						end
					else
						if rope_trigger == 1 then
							m:special_text("It's stucked","It's already pulled")
						end
					end
				elseif o.tag and self.tag == "ladder" then
					--player:moveRoom(player.x,images["atticRoom"])
					sounds.climb:play()
					sounds.climb:setLooping(false)
					fade.state = true
					currentRoom = images["atticRoom"]


				elseif o.tag and self.tag == "attic_ladder" then

						--player:moveRoom(player.x,images["secretRoom"])
						sounds.climb:play()
						sounds.climb:setLooping(false)
						fade.state = true
						currentRoom = images["secretRoom"]

				elseif o.tag and self.tag == "chair_final" then
					sounds.climb:play()
					sounds.climb:setLooping(false)
					fade.state = true
					currentRoom = images["atticRoom"]
					move = false
					final_flashback = true
					if sounds.clock_tick:isPlaying() == false then
						sounds.clock_tick:play()
						sounds.clock_tick:setLooping(true)
						sounds.clock_tick:setVolume(1)
					end
					sounds.main_theme:stop()
					child:flipH()

					for k,v in pairs(obj) do
						if v.tag == "chair_final" then
							table.remove(obj,k)
						end
					end
				end
			end
		end
	end
end

function setRemove(item)
	local item = item
	for i,o in pairs(obj_properties.dynamic) do
		if o == item then
			table.remove(obj_properties.dynamic,i)
		end
	end
	obtainables[item] = false
end

return Interact
