local Items = Object:extend()

function Items:new(image,room,x,y,tag)
	self.x = x -- w/2
	self.y =  y -- h/2
	self.image = image
	self.w = self.image:getWidth()
	self.h = self.image:getHeight()
	self.room = room
	self.tag = tag
	self.visible = true
end

function Items:update(dt)
		
end

function Items:draw()
	if self.visible == true then
		if ending_leave == false then
			love.graphics.setColor(1, 1, 1, 1)
			if currentRoom == self.room then
				love.graphics.draw(self.image,self.x,self.y)
			end
		else
			if self.image == images["m_shoerack"] then
				img_color = images["m_shoerack_color"]
			elseif self.image == images["m_shelf"] then
				img_color = images["m_shelf_color"]
			elseif self.image == images["lr_display"] then
				img_color = images["lr_display_color"]
			elseif self.image == images["lr_portraits"] then
				img_color = images["lr_portraits_color"]
			elseif self.image == images["basement_battery"] then
				img_color = images["basement_battery_color"]
			end

			love.graphics.setColor(1, 1, 1, 1)
			if currentRoom == self.room then
				love.graphics.draw(img_color,self.x,self.y)
			end
		end
	end
end

function Items:returnTag()
	if currentRoom == self.room then
		for k,v in pairs(dialogue) do 
			if v.tag == self.tag then
				if v.state == false then v.state = true end
				-- if v.simpleMessage == true then v.simpleMessage = false end
				if v.simpleMessage == false then
					move = false
				end
			end
		end
	end
end

function Items:specialTag()
	if currentRoom == self.room then
		for k,v in pairs(dialogue) do
			if v.tag == self.tag then
				if v.tag == "chair" then
					if v.state == false then v.state = true end
					-- if v.simpleMessage == true then v.simpleMessage = false end
					if v.simpleMessage == false then
						move = false
					end
				end
			end
		end
	end
end

function Items:stillLocked()
	if currentRoom == self.room then
		for k,v in pairs(dialogue) do
			if v.tag == self.tag then
				--if v.state == false then v.state = true end
				--if v.simpleMessage == true then v.simpleMessage = false end
				move = false
				v._door = true
			end
		end
	end
end

function Items:glow()
	if move_chair == false then
		if currentRoom == self.room then
			for k,v in pairs(images) do
				if self.image == v then
					_glow = k
				end
			end

			local glow = _glow .. "_glow"
			local offY = images[glow]:getHeight()-self.image:getHeight()
			local offX = images[glow]:getWidth()-self.image:getWidth()
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.draw(images[glow],self.x,self.y,0,1,1,offX/2,offY/2)
			--love.graphics.rectangle("line",self.x,self.y,self.w,self.h)
		end
	end
end

function Items:checkFunction()
	for k,v in pairs(obj) do
		for i,o in pairs(dialogue) do
			if o.tag == v.tag then
				if v.tag and o.tag == "head" then
					if obtainables["cabinet"] == false then
						if self.tag == v.tag then					
							--sound
							sounds.wood_drop:play()

							o:special_text("You've used the hammer","the painting fell")
							table.remove(obj,k)
							local holes = Items(images.st_hole,images["stairRoom"],80,22,"hole")
							table.insert(obj,holes)
						end
					end
				elseif v.tag and o.tag == "ball" then
					if obtainables["toy"] == false then
						if self.tag == v.tag then
							sounds.air_pump:play()
							o:special_text("you used the air pumper","you've got the basketball")
							table.remove(obj,k)
							obtainables["toy"] = false
							obtainables["gotBall"] = false
						end
					end
				elseif v.tag and o.tag == "hoop" then
					if obtainables["toy"] == false and obtainables["gotBall"] == false then
						if self.tag == v.tag then
							sounds.ball_in_hoop:play()
							o:special_text("you put the ball inside","something clicked")
							--remove a locked room
							obtainables["hole"] = false
							--locked["masterRoom_mid"] = false
							if event == "" then event = "secret_room_first" end
							--change the image or object of the hoop
							table.remove(obj,k)
							local hoop_ball = Items(images.store_hoop_ball,images["storageRoom"],115,22,"hoop_ball")
							table.insert(obj,hoop_ball)

							for k,v in pairs(dialogue) do 
								if v.tag == "hole" then
									table.remove(dialogue,k)
									local holes_box_open = Interact(false,{"The holes look like slashes","The box is open","Check inside?"},{"Check","Leave it"},"","hole")
									table.insert(dialogue,holes_box_open)
								end
							end

						end
					end
				elseif v.tag and o.tag == "sink" then
					if self.tag == v.tag then 
						if obtainables["kitchen key"] == false and obtainables["crowbar"] == true then
							sounds.item_got:play()
							if tv_trigger == 0 then
								tv_trigger = 1
							end
							o:special_text("there's a crowbar inside","you've picked it")
							obtainables["crowbar"] = false
						end
					end
				elseif v.tag and o.tag == "safe vault" then
					if self.tag == v.tag then
						if obtainables["crowbar"] == false then
							--sound of crowbar hitting
							sounds.crowbar:play()
							sounds.crowbar:setLooping(false)

							o:special_text("you've used the crowbar","the frame broke")
							table.remove(obj,k)
							local open_vault = Items(images.open_vault,images["secretRoom"],40,26,"open_vault")
							table.insert(obj,open_vault)
						end
					end
				elseif v.tag and o.tag == "rope" then
					if self.tag == v.tag then
						if attic_trigger == false then
							--body falls with rats and dust
							dust_trigger = true
							attic_trigger = true
							corpse_trigger = true

							table.remove(obj,k)
							local ladder = Items(images.ladder,images["secretRoom"],78,20,"ladder")
							table.insert(obj,ladder)
							local lad = Interact(false,{"It leads to the attic","Climb up?"},{"Yes","No"},"","ladder")
							table.insert(dialogue,lad)
							
						end
					end
				elseif v.tag and o.tag == "chest" then

					if self.tag == v.tag then
						if chest_open == false then
							if obtainables["chest"] == false then

								sounds.re_sound:play()
								sounds.re_sound:setLooping(false)

								o:special_text("You've got a key","It's for the basement")
								chest_open = true
								
								--event_trigger_light = 1
								move = false
								temp_clock = math.floor(clock)

								do return end

							else --still locked
								if obtainables["clock"] == false then
									obtainables["chest"] = false

									sounds.item_got:play()
									sounds.item_got:setLooping(false)

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
						if solved == false then
							o:special_text(""," I must input the combination")
							clock_puzzle = true
						elseif solved == true then
							if obtainables["clock"] == true then--not yet acquired
								o:special_text("there's a key inside","you've got a clock key")
								obtainables["clock"] = false
								sounds.item_got:play()
								
								enemy_exists = true
								ghost.trigger = true
								ghost.x = width + 10
								ghost.y = 30
								ghost.xscale = -1

								ghost_event = "no escape"
								ghost_chase = false

								sounds.main_theme:stop()
								sounds.intro_soft:stop()
								sounds.finding_home:stop()
								sounds.ts_theme:stop()
								--sounds.they_are_gone:play()
								--sounds.they_are_gone:setLooping(false)
								--sounds.they_are_gone:setVolume(0.3)

								do return end
							elseif obtainables["clock"] == false then
								o:special_text("","there's nothing more here")
							end
						end
					end

				--gun parts
				elseif v.tag and o.tag == "shelf" then
					if self.tag == v.tag then
						if obtainables["gun1"] == true then
							sounds.re_sound:play()
							sounds.re_sound:setLooping(false)
							o:special_text("you've got a revolver part","It's a barrel")
							obtainables["gun1"] = false
							temp_clock_gun = math.floor(clock)
						end
					end

				elseif v.tag and o.tag == "candles left" or v.tag and o.tag == "candles right" then
					if self.tag == v.tag then
						if candles_light == false then
							if obtainables["match"] == false then
								--play sounds
								sounds.match:play()
								sounds.match:setLooping(false)
								o:special_text("You've used the matchstick","Something clicked")
								candles_light = true
								candles_light_flag = true

								--insert secret drawer
								local secret_drawer = Items(images.s_drawer,images["masterRoom"],103,36,"secret drawer")
								table.insert(obj,secret_drawer)
								local secret_drawer_dial = Interact(false,{"It's a drawer","Search in it?"},{"yes","no"},"There's nothing more here","secret drawer")
								table.insert(dialogue,secret_drawer_dial)


								do return end
							else
								o:special_text("","there's nothing to light it with")
							end
						end
					end
				elseif v.tag and o.tag == "trash bin" then
					if self.tag == v.tag then
						if obtainables["match"] == true then
							sounds.re_sound:play()
							sounds.re_sound:setLooping(false)
							obtainables["match"] = false
							o:special_text("There's a matchstick","You've picked it up")
						else 
							o:special_text("","There's nothing more here")
						end
					end
				elseif v.tag and o.tag == "secret drawer" then
					if self.tag == v.tag then
						if obtainables["gun2"] == true then
							obtainables["gun2"] = false
							sounds.re_sound:play()
							o:special_text("you've got a revolver part","It's a cylinder")
							temp_clock_gun = math.floor(clock)
						else
							o:special_text("","There's nothing more here")
						end
					end
				elseif v.tag and o.tag == "storage puzzle" then
					if self.tag == v.tag then
						if final_puzzle_solved == false then
							if love.system.getOS() == "Android" or love.system.getOS() == "iOS" or debug == true then
								love.keyboard.setTextInput(true)
							end
							word_puzzle = true
							storage_puzzle = true
							o:special_text("","")
							do return end
						else
							if obtainables["gun3"] == true then
								o:special_text("You've got a revolver part","It's the hammer")
								sounds.re_sound:play()
								obtainables["gun3"] = false
								temp_clock_gun = math.floor(clock)
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
							if obtainables["gun1"] == false and 
								obtainables["gun2"] == false and
								obtainables["gun3"] == false then
								o:special_text("","I can rebuild the gun here")
								gun_rebuild = true
								gun_obtained = true
							end
						else
							if obtainables["revolver"] == true then
								sounds.re_sound:play()
								sounds.re_sound:setLooping(false)
								o:special_text("Done! It felt like ages.","You've got a revolver")
								obtainables["revolver"] = false
							else
								o:special_text("","There's nothing more here")
							end
						end
					end
				elseif v.tag and o.tag == "battery" then
					if self.tag == v.tag then
						if light_refilled == false then
							sounds.battery_refill:play()
							sounds.battery_refill:setLooping(false)
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
							sounds.reload:play()
							sounds.reload:setLooping(false)	
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
							sounds.item_got:play()
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
