local Items = Object:extend()

function Items:new(image,room,x,y,tag)
	self.x = x -- w/2
	self.y =  y -- h/2
	self.image = image
	self.w, self.h = self.image:getDimensions()
	self.room = room
	self.tag = tag
	self.visible = true
end

function Items:draw()
	if not self.visible then return end
	if currentRoom ~= self.room then return end

	if ending_leave == false then
		love.graphics.setColor(1, 1, 1, 1)
		if currentRoom == self.room then
			love.graphics.draw(self.image,self.x,self.y)
		end
	else
		if self.image == Images["m_shoerack"] then
			img_color = Images["m_shoerack_color"]
		elseif self.image == Images["m_shelf"] then
			img_color = Images["m_shelf_color"]
		elseif self.image == Images["lr_display"] then
			img_color = Images["lr_display_color"]
		elseif self.image == Images["lr_portraits"] then
			img_color = Images["lr_portraits_color"]
		elseif self.image == Images["basement_battery"] then
			img_color = Images["basement_battery_color"]
		end

		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(img_color,self.x,self.y)
	end

	-- love.graphics.setColor(1, 0, 0, 1)
	-- love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

function Items:returnTag()
	if currentRoom ~= self.room then return end
	for k,v in pairs(DIALOGUES) do
		if v.tag == self.tag then
			if v.state == false then v.state = true end
			-- if v.simpleMessage == true then v.simpleMessage = false end
			if v.simpleMessage == false then
				MOVE = false
			end
		end
	end
end

function Items:specialTag()
	if currentRoom ~= self.room then return end
	for k,v in pairs(DIALOGUES) do
		if v.tag == self.tag then
			if v.tag == "chair" then
				if v.state == false then v.state = true end
				-- if v.simpleMessage == true then v.simpleMessage = false end
				if v.simpleMessage == false then
					MOVE = false
				end
			end
		end
	end
end

function Items:stillLocked()
	if currentRoom ~= self.room then return end
	for _,v in pairs(DIALOGUES) do
		if v.tag == self.tag then
			--if v.state == false then v.state = true end
			--if v.simpleMessage == true then v.simpleMessage = false end
			MOVE = false
			v._door = true
		end
	end
end

function Items:glow()
	if move_chair == false then
		if currentRoom == self.room then
			for k,v in pairs(Images) do
				if self.image == v then
					_glow = k
				end
			end

			local glow = _glow .. "_glow"

			local iw, ih = self.image:getDimensions()
			local gw, gh = Images[glow]:getDimensions()
			local offX, offY = gw - iw, gh - ih
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.draw(Images[glow],self.x,self.y,0,1,1,offX/2,offY/2)
			--love.graphics.rectangle("line",self.x,self.y,self.w,self.h)
		end
	end
end

function Items:checkFunction()
	for k,v in ipairs(ITEMS_LIST) do
		for i,o in ipairs(DIALOGUES) do
			if o.tag == v.tag then
				if v.tag and o.tag == "head" then
					if OBTAINABLES["cabinet"] == false then
						if self.tag == v.tag then
							--sound
							Sounds.wood_drop:play()
							o:special_text("You've used the hammer","the painting fell")
							table.remove(ITEMS_LIST, k)
							local holes = Items(Images.st_hole,Images["stairRoom"], 80, 22, "hole")
							table.insert(ITEMS_LIST, holes)
						end
					end
				elseif v.tag and o.tag == "ball" then
					if OBTAINABLES["toy"] == false then
						if self.tag == v.tag then
							Sounds.air_pump:play()
							o:special_text("you used the air pumper","you've got the basketball")
							table.remove(ITEMS_LIST,k)
							OBTAINABLES["toy"] = false
							OBTAINABLES["gotBall"] = false
						end
					end
				elseif v.tag and o.tag == "hoop" then
					if OBTAINABLES["toy"] == false and OBTAINABLES["gotBall"] == false then
						if self.tag == v.tag then
							Sounds.ball_in_hoop:play()
							o:special_text("you put the ball inside","something clicked")
							--remove a locked room
							OBTAINABLES["hole"] = false
							--locked["masterRoom_mid"] = false
							if event == "" then event = "secret_room_first" end
							--change the image or object of the hoop
							table.remove(ITEMS_LIST,k)
							local hoop_ball = Items(Images.store_hoop_ball,Images["storageRoom"],115,22,"hoop_ball")
							table.insert(ITEMS_LIST,hoop_ball)

							for k,v in ipairs(DIALOGUES) do
								if v.tag == "hole" then
									table.remove(DIALOGUES,k)
									local holes_box_open = Interact(false,{"The holes look like slashes","The box is open","Check inside?"},{"Check","Leave it"},"","hole")
									table.insert(DIALOGUES,holes_box_open)
								end
							end

						end
					end
				elseif v.tag and o.tag == "sink" then
					if self.tag == v.tag then
						if OBTAINABLES["kitchen key"] == false and OBTAINABLES["crowbar"] == true then
							Sounds.item_got:play()
							if tv_trigger == 0 then
								tv_trigger = 1
							end
							o:special_text("there's a crowbar inside","you've picked it")
							OBTAINABLES["crowbar"] = false
						end
					end
				elseif v.tag and o.tag == "safe vault" then
					if self.tag == v.tag then
						if OBTAINABLES["crowbar"] == false then
							--sound of crowbar hitting
							Sounds.crowbar:play()
							Sounds.crowbar:setLooping(false)

							o:special_text("you've used the crowbar","the frame broke")
							table.remove(ITEMS_LIST,k)
							local open_vault = Items(Images.open_vault,Images["secretRoom"],40,26,"open_vault")
							table.insert(ITEMS_LIST,open_vault)
						end
					end
				elseif v.tag and o.tag == "rope" then
					if self.tag == v.tag then
						if attic_trigger == false then
							--body falls with rats and dust
							dust_trigger = true
							attic_trigger = true
							corpse_trigger = true

							table.remove(ITEMS_LIST,k)
							local ladder = Items(Images.ladder,Images["secretRoom"],78,20,"ladder")
							table.insert(ITEMS_LIST,ladder)
							local lad = Interact(false,{"It leads to the attic","Climb up?"},{"Yes","No"},"","ladder")
							table.insert(DIALOGUES,lad)

						end
					end
				elseif v.tag and o.tag == "chest" then

					if self.tag == v.tag then
						if chest_open == false then
							if OBTAINABLES["chest"] == false then

								Sounds.re_sound:play()
								Sounds.re_sound:setLooping(false)

								o:special_text("You've got a key","It's for the basement")
								chest_open = true

								--event_trigger_light = 1
								MOVE = false
								temp_clock = math.floor(CLOCK)

								do return end

							else --still locked
								if OBTAINABLES["clock"] == false then
									OBTAINABLES["chest"] = false

									Sounds.item_got:play()
									Sounds.item_got:setLooping(false)

									o:special_text("You've used the clock key","You've opened it")
									do return end
								else
									o:special_text("","It's locked")
								end
							end
						else
							o:special_text("","there's nothing more here")
						end
					end
				elseif v.tag and o.tag == "clock" then
					if self.tag == v.tag then
						if ClockPuzzle.solved == false then
							o:special_text(""," I must input the combination")
							ClockPuzzle.state = true
						elseif ClockPuzzle.solved == true then
							if OBTAINABLES["clock"] == true then--not yet acquired
								o:special_text("there's a key inside","you've got a clock key")
								OBTAINABLES["clock"] = false
								Sounds.item_got:play()

								ENEMY_EXISTS = true
								GHOST.trigger = true
								GHOST.x = WIDTH + 10
								GHOST.y = 30
								GHOST.xscale = -1

								GHOST_EVENT = "no escape"
								GHOST_CHASE = false

								Sounds.main_theme:stop()
								Sounds.intro_soft:stop()
								Sounds.finding_home:stop()
								Sounds.ts_theme:stop()
								--sounds.they_are_gone:play()
								--sounds.they_are_gone:setLooping(false)
								--sounds.they_are_gone:setVolume(0.3)

								do return end
							elseif OBTAINABLES["clock"] == false then
								o:special_text("","there's nothing more here")
							end
						end
					end

				--gun parts
				elseif v.tag and o.tag == "shelf" then
					if self.tag == v.tag then
						if OBTAINABLES["gun1"] == true then
							Sounds.re_sound:play()
							Sounds.re_sound:setLooping(false)
							o:special_text("you've got a revolver part","It's a barrel")
							OBTAINABLES["gun1"] = false
							temp_clock_gun = math.floor(CLOCK)
						end
					end

				elseif v.tag and o.tag == "candles left" or v.tag and o.tag == "candles right" then
					if self.tag == v.tag then
						if candles_light == false then
							if OBTAINABLES["match"] == false then
								--play sounds
								Sounds.match:play()
								Sounds.match:setLooping(false)
								o:special_text("You've used the matchstick","Something clicked")
								candles_light = true
								candles_light_flag = true

								--insert secret drawer
								local secret_drawer = Items(Images.s_drawer,Images["masterRoom"],103,36,"secret drawer")
								table.insert(ITEMS_LIST,secret_drawer)
								local secret_drawer_dial = Interact(false,{"It's a drawer","Search in it?"},{"yes","no"},"There's nothing more here","secret drawer")
								table.insert(DIALOGUES,secret_drawer_dial)


								do return end
							else
								o:special_text("","there's nothing to light it with")
							end
						end
					end
				elseif v.tag and o.tag == "trash bin" then
					if self.tag == v.tag then
						if OBTAINABLES["match"] == true then
							Sounds.re_sound:play()
							Sounds.re_sound:setLooping(false)
							OBTAINABLES["match"] = false
							o:special_text("There's a matchstick","You've picked it up")
						else
							o:special_text("","There's nothing more here")
						end
					end
				elseif v.tag and o.tag == "secret drawer" then
					if self.tag == v.tag then
						if OBTAINABLES["gun2"] == true then
							OBTAINABLES["gun2"] = false
							Sounds.re_sound:play()
							o:special_text("you've got a revolver part","It's a cylinder")
							temp_clock_gun = math.floor(CLOCK)
						else
							o:special_text("","There's nothing more here")
						end
					end
				elseif v.tag and o.tag == "storage puzzle" then
					if self.tag == v.tag then
						if final_puzzle_solved == false then
							if ON_MOBILE or DEBUGGING then
								love.keyboard.setTextInput(true)
							end
							word_puzzle = true
							storage_puzzle = true
							o:special_text("","")
							do return end
						else
							if OBTAINABLES["gun3"] == true then
								o:special_text("You've got a revolver part","It's the hammer")
								Sounds.re_sound:play()
								OBTAINABLES["gun3"] = false
								temp_clock_gun = math.floor(CLOCK)
							else
								o:special_text("","There's nothing more here")
							end
						end
					end
				elseif v.tag and o.tag == "crib" then
					if self.tag == v.tag then
						random_page()
						storage_puzzle = true
						doodle_flag = true
					end
				elseif v.tag and o.tag == "kitchen table" then
					if self.tag == v.tag then
						if gun_rebuild == false then
							if OBTAINABLES["gun1"] == false and
								OBTAINABLES["gun2"] == false and
								OBTAINABLES["gun3"] == false then
								o:special_text("","I can rebuild the gun here")
								gun_rebuild = true
								gun_obtained = true
							end
						else
							if OBTAINABLES["revolver"] == true then
								Sounds.re_sound:play()
								Sounds.re_sound:setLooping(false)
								o:special_text("Done! It felt like ages.","You've got a revolver")
								OBTAINABLES["revolver"] = false
							else
								o:special_text("","There's nothing more here")
							end
						end
					end
				elseif v.tag and o.tag == "battery" then
					if self.tag == v.tag then
						if light_refilled == false then
							Sounds.battery_refill:play()
							Sounds.battery_refill:setLooping(false)
							o:special_text("","You've found a battery")
							light_refilled = true
							event_trigger_light = -2
						else
							o:special_text("","there's nothing more here")
						end
					end
				elseif v.tag and o.tag == "ammo" then
					if self.tag == v.tag then
						if ammo_picked == false then
							Sounds.reload:play()
							Sounds.reload:setLooping(false)
							o:special_text("","You've loaded the ammo")
							ending_animate = true
							reload_animate = true
							ammo_picked = true
						else
							o:special_text("","There's nothing more here")
						end
					end
				elseif v.tag and o.tag == "revolver2" then
					if self.tag == v.tag then
						if broken_revolver == false then
							Sounds.item_got:play()
							o:special_text("","")
							broken_revolver = true
							v.visible = false
						else
							o:special_text("","There's nothing more here")
						end
					end
				elseif v.tag and o.tag == "note" then
					if self.tag == v.tag then
						o:special_text("'She's still alive","S-stop her")
					end
				end
			end
		end
	end
end


return Items
