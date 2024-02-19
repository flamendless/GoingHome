local Interact = Object:extend()

local trigger = 0
local sink_trigger = 0
local white = { 1, 1, 1, 1 }
local red = { 1, 0, 0, 1 }


function Interact:new(state, txt, opt_txt, sm, tag)
	self.sm = sm
	self.simpleMessage = false
	self.maxT = 1.5 --2.5
	self.timer = self.maxT
	self.specialTxt = false

	self.sp_1 = ""
	self.sp_2 = ""

	self.txt = txt or {}

	self.x = {}
	self.y = {}
	for i = 1, #self.txt do
		self.x[i] = WIDTH_HALF - DEF_FONT:getWidth(self.txt[i]) / 2
		self.y[i] = 0 + DEF_FONT_HEIGHT / 4
	end

	self.tag = tag
	self.state = state
	self.n = 1

	self.opt_txt = opt_txt or {}
	self.option = false

	self.cursor = 1
	self.opt1 = white
	self.opt2 = white


	self.sp_2_show = false

	self.toRemove = ""
	self._door = false
	self._dt = "I have to find them first"
end

function Interact:update(dt)
	if GAMEOVER == true then
		self.state = false
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
			MOVE = true
		end
	elseif self.specialTxt == true then
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
				MOVE = true
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
		self.timer = self.timer - 1 * dt
		if self.timer <= 0 then
			self.timer = self.maxT
			self.simpleMessage = false
			self.state = false
			self._door = false
			MOVE = true
		end
	end
end

function Interact:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setFont(DEF_FONT)
	if self.state == true then
		if self.option == false then
			love.graphics.print(self.txt[self.n], self.x[self.n], self.y[self.n])
		else
			local ll = #self.txt
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.print(self.txt[ll], self.x[ll], self.y[ll])

			local choices_xpad
			local choices_y
			if ON_MOBILE then
				choices_xpad = 8
				choices_y = HEIGHT_HALF - DEF_FONT_HALF
			else
				choices_xpad = 2
				choices_y = HEIGHT - DEF_FONT_HALF - 8
			end

			love.graphics.setColor(self.opt1)
			love.graphics.print(
				self.opt_txt[1],
				WIDTH / choices_xpad - DEF_FONT:getWidth(self.opt_txt[1]) / 2,
				choices_y
			)

			love.graphics.setColor(self.opt2)
			love.graphics.print(
				self.opt_txt[2],
				WIDTH - DEF_FONT:getWidth(self.opt_txt[2]) / 2 - WIDTH / choices_xpad,
				choices_y
			)
		end
	end
	if self.simpleMessage == true then
		if DEF_FONT:getWidth(self.sm) >= WIDTH - 16 then
			local sw = string.len(self.sm) / 2
			local s1 = string.sub(self.sm, 1, sw)
			local s2 = string.sub(self.sm, sw + 1)

			love.graphics.print(s1, WIDTH_HALF - DEF_FONT:getWidth(s1) / 2, DEF_FONT_HEIGHT / 4)
			love.graphics.print(s2, WIDTH_HALF - DEF_FONT:getWidth(s2) / 2, HEIGHT - DEF_FONT_HALF - 8)
		else
			love.graphics.print(self.sm, WIDTH_HALF - DEF_FONT:getWidth(self.sm) / 2, HEIGHT - DEF_FONT_HALF - 8)
		end
	elseif self.specialTxt == true then
		love.graphics.print(self.sp_1, WIDTH_HALF - DEF_FONT:getWidth(self.sp_1) / 2, 0 + DEF_FONT_HEIGHT / 4)

		if self.sp_2_show == true then
			love.graphics.print(self.sp_2, WIDTH_HALF - DEF_FONT:getWidth(self.sp_2) / 2, HEIGHT - DEF_FONT_HALF - 8)
		end
	end

	if self._door == true then
		love.graphics.print(self._dt, WIDTH_HALF - DEF_FONT:getWidth(self._dt) / 2, 0 + DEF_FONT_HEIGHT / 4)
	end
end

function Interact:returnChoices(choice)
	if choice == 1 then
		for _, v in ipairs(obj_properties.static) do
			if self.tag == v then
				self.simpleMessage = true
			end
		end

		for _, v in ipairs(obj_properties.dynamic) do
			if self.tag == v then
				for _, m in ipairs(obj) do
					if self.tag == m.tag then
						m:checkFunction()
						break
					end
				end
			end
		end

		self:checkItem()
	else
		if self.tag == "refrigerator" then
			self:special_text("There's a note:", "'Ephesians 2:8'")
		elseif self.tag == "chair" then
			self:special_text("I will just push it", "")

			for _, v in ipairs(obj) do
				if v.tag == "chair" then
					v.visible = false
					break
				end
			end

			self.state = false
			MOVE = true
			self.option = false
			move_chair = true
		else
			self.state = false
			MOVE = true
			self.option = false
		end
	end

	self.state = false
	self.option = false
end

function Interact:special_text(str1, str2)
	self.simpleMessage = false
	self.specialTxt = true
	self.sp_1 = str1
	self.sp_2 = str2
	self.sp_2_show = false
end

function Interact:checkItem()
	for _, _ in pairs(OBTAINABLES) do
		for _, m in ipairs(dialogue) do
			for _, o in ipairs(obj) do
				if o.tag and self.tag == "cabinet" and OBTAINABLES["cabinet"] == true then
					m:special_text("There's a toy hammer", "You've got a toy hammer")
					self.toRemove = "cabinet"
					--sound of item acquired
					Sounds.item_got:play()
				elseif o.tag and self.tag == "toy" and OBTAINABLES["toy"] == true then
					m:special_text("There's an air pumper.", "You've got an air pumper")
					self.toRemove = "toy"
					--sound of item acquired
					Sounds.item_got:play()
				elseif o.tag and self.tag == "hoop" and OBTAINABLES["ball"] == false then
					self.toRemove = "ball"
					--sound of item acquired
					Sounds.item_got:play()
				elseif o.tag and self.tag == "hole" and OBTAINABLES["hole"] == false then
					--self.toRemove = "hole"
					if OBTAINABLES["head_key"] == true then
						m:special_text("", "you've picked up the key")
						OBTAINABLES["head_key"] = false
						--sound of item acquired
						Sounds.item_got:play()
						if mid_dial == 0 then mid_dial = 1 end
						trigger = 1
						do return end
					elseif OBTAINABLES["head_key"] == false then
						if trigger == 1 then
							m:special_text("", "There's nothing more here")
						end
					end
				elseif o.tag and self.tag == "sink" then
					if OBTAINABLES["kitchen key"] == true then
						m:special_text("", "its locked")
					elseif OBTAINABLES["kitchen key"] == false then
						self.toRemove = "sink"
						if OBTAINABLES["crowbar"] == false then
							if sink_trigger == 0 then
								sink_trigger = 1
								do return end
							elseif sink_trigger == 1 then
								m:special_text("", "Nothing more here")
							end
						end
					end
				elseif o.tag and self.tag == "master bed" then
					--self.toRemove = ""
					if OBTAINABLES["kitchen key"] == true then
						m:special_text("There's a key", "it has a spatula keychain")
						Sounds.item_got:play()
						--self.toRemove = "master bed"
						OBTAINABLES["kitchen key"] = false
						if bed_trigger == 0 then
							bed_trigger = 1
							do return end
						elseif bed_trigger == 1 then
							m:special_text("", "Nothing else here")
						end
					elseif OBTAINABLES["kitchen key"] == false then
						m:special_text("", "Nothing else here")
					end
				elseif o.tag and self.tag == "tv" then
					if tv_open_volume == true then
						m:special_text("I'll just mute it", "")
						Sounds.tv_loud:stop()
						tv_open_volume = false
					end
				elseif o.tag and self.tag == "open_vault" then
					if OBTAINABLES["rope"] == true then
						if rope_trigger == 0 then
							m:special_text("", "Something fell")
							local rope = Items(Images.rope, Images["secretRoom"], 80, 20, "rope")
							table.insert(obj, rope)
							Sounds.item_got:play()
							self.toRemove = "open_vault"
							OBTAINABLES["rope"] = false
							rope_trigger = 1
							do return end
						end
					else
						if rope_trigger == 1 then
							m:special_text("It's stucked", "It's already pulled")
						end
					end
				elseif o.tag and self.tag == "ladder" then
					--player:moveRoom(player.x,images["atticRoom"])
					Sounds.climb:play()
					Sounds.climb:setLooping(false)
					FADE_OBJ.state = true
					currentRoom = Images["atticRoom"]
				elseif o.tag and self.tag == "attic_ladder" then
					--player:moveRoom(player.x,images["secretRoom"])
					Sounds.climb:play()
					Sounds.climb:setLooping(false)
					FADE_OBJ.state = true
					currentRoom = Images["secretRoom"]
				elseif o.tag and self.tag == "chair_final" then
					Sounds.climb:play()
					Sounds.climb:setLooping(false)
					FADE_OBJ.state = true
					currentRoom = Images["atticRoom"]
					MOVE = false
					final_flashback = true
					if Sounds.clock_tick:isPlaying() == false then
						Sounds.clock_tick:play()
						Sounds.clock_tick:setLooping(true)
						Sounds.clock_tick:setVolume(1)
					end
					Sounds.main_theme:stop()
					child:flipH()

					for i, v2 in ipairs(obj) do
						if v2.tag == "chair_final" then
							table.remove(obj, i)
							break
						end
					end
				end
			end
		end
	end
end

function setRemove(item)
	for i, o in pairs(obj_properties.dynamic) do
		if o == item then
			table.remove(obj_properties.dynamic, i)
		end
	end
	OBTAINABLES[item] = false
end

return Interact
