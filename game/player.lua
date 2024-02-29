local Player = Object:extend()

function Player:new(x, y, w, h)
	self.x = x - w / 2
	self.y = y - h / 2
	self.w = w
	self.h = h
	self.grav = 1
	self.xspd = 20
	self.moveLeft = true
	self.moveRight = true
	self.isMoving = false
	self.dir = 1
	self.txt = ""
	self.maxT = 2
	self.t = self.maxT
	self.dead = false
	self.img = IMAGES.player_idle
	self.visible = true
	self.state = "normal"
	self.right = false
	self.left = false
	self.android = 0
end

function Player:update(dt)
	local state = gamestates.getState()
	if ENDING_LEAVE == false then
		if self.y < HEIGHT - 20 - self.h then
			self.y = self.y + self.grav
		end
	end
	if state == "main" then
		if self.x <= 8 then
			self.moveLeft = false
		else
			self.moveLeft = true
		end

		if self.x >= WIDTH - 24 + self.w then
			self.moveRight = false
		else
			self.moveRight = true
		end
	end

	if PUSHING_ANIM == true then
		player_push:update(dt)
	end

	if ENDING_ANIMATE == true then
		if reload_animate == true then
			reload_anim:update(dt)
		end
		if shoot_pose_animate == true then
			shoot_pose_anim:update(dt)
		end
		--route 2
		if leave_animate == true then
			leave_anim:update(dt)
		end
		if wait_animate == true then
			wait_anim:update(dt)
		end
		if ending_final == -1 then
			player_panic:update(dt)
		elseif ending_final == -2 then
			player_killed:update(dt)
		end
	end

	idle:update(dt)
	walk_right:update(dt)
	walk_left:update(dt)
	child:update(dt)

	if ON_MOBILE and self.android == 0 then
		self.isMoving = false
	end
end

function Player:draw()
	love.graphics.setColor(1, 1, 1)
	--love.graphics.rectangle("fill", self.x,self.y, self.w, self.h)
	if self.visible == true then
		if self.dead == false then
			if ENDING_ANIMATE == false then
				if GHOST_EVENT ~= "flashback" then
					local player_sheet
					if player_color == false then
						player_sheet = IMAGES.player_sheet
					else
						player_sheet = IMAGES.player_sheet_color
					end

					if self.isMoving == false then
						idle:draw(player_sheet, self.x, self.y)
					else
						if self.right == true then
							walk_right:resume()
							walk_right:draw(player_sheet, self.x, self.y)
						elseif self.left == true then
							walk_left:resume()
							walk_left:draw(player_sheet, self.x, self.y)
						end
					end
				else
					if final_flashback == false then
						if PUSHING_ANIM == false then
							if self.isMoving == false then
								child:pauseAtStart()
							else
								child:resume()
							end
							child:draw(IMAGES.player_child_sheet, self.x, self.y)
						else
							player_push:draw(IMAGES.player_child_push, self.x, self.y)
						end
					end
				end
			else
				if ending_final == 0 then
					if reload_animate == true then
						reload_anim:draw(IMAGES.reload_sheet, self.x, self.y)
					elseif shoot_pose_animate == true then
						shoot_pose_anim:draw(IMAGES.shoot_pose_sheet, self.x, self.y)
					elseif leave_animate == true then
						leave_anim:draw(IMAGES.leave_sheet, PLAYER.x, PLAYER.y)
					elseif wait_animate == true then
						wait_anim:draw(IMAGES.shoot_pose_sheet, PLAYER.x, PLAYER.y)
					end
				elseif ending_final == -1 then
					player_panic:draw(IMAGES.player_panic_sheet, self.x, self.y)
				elseif ending_final == -2 then
					player_killed:draw(IMAGES.player_killed_sheet, self.x, self.y)
				end
			end
		else
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.draw(self.img, self.x, self.y)
		end
	else
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(self.img, self.x, self.y)
	end
end

function Player:moveRoom(posX, nextRoom)
	if ENDING_LEAVE == false then
		FADE_OBJ.state = true
	end
	self.x = posX
	currentRoom = nextRoom

	if currentRoom == IMAGES["hallwayRight"] then
		l = 6
		r = 14
	else
		l = 12
		r = 7
	end
	leaveRoom()
end

function Player:checkDoors()
	local checkLeft = self.x <= 8 and self.dir == -1
	local checkRight = self.x >= WIDTH - 16 and self.dir == 1
	local checkMid = self.x + IMAGES.player_idle:getWidth() >= WIDTH / 2 - 6 and self.x <= WIDTH / 2 + 4
	local left = 8
	local right = WIDTH - 16

	--main room
	if currentRoom == IMAGES["mainRoom"] then
		if checkLeft then
			PLAYER:moveRoom(right, IMAGES["livingRoom"])
		elseif checkRight then
			if ENDING_LEAVE == false then
				if LOCKED["mainRoom_right"] == false then
					PLAYER:moveRoom(left, IMAGES["kitchen"])
				else
					doorTxt("It's locked from the other side", "Maybe I should go around")
					SOUNDS.locked:play()
				end
			else
				doorTxt("I must not go there", "I have to go to work")
			end
		elseif checkMid then
			if ENDING_LEAVE == false then
				if GHOST_EVENT == "flashback" then
					doorTxt("I've just got home", "I have to find mom and dad")
				else
					doorTxt("I've just got home", "and it's raining outside.")
				end
				SOUNDS.locked:play()
			else
				LIGHT_VALUE = 1
				PLAYER:moveRoom(8, IMAGES["endRoom"])
				PLAYER.y = 22
			end
		end
		--living room
	elseif currentRoom == IMAGES["livingRoom"] then
		if checkLeft then
			if ENDING_LEAVE == false and ending_shoot == false then
				PLAYER:moveRoom(right, IMAGES["stairRoom"])
			else
				doorTxt("I must not go there", "I have to go to work")
			end
		elseif checkRight then
			PLAYER:moveRoom(left, IMAGES["mainRoom"])
		elseif checkMid then
			if ENDING_LEAVE == false or ending_shoot == false or ending_shoot == false then
				if OBTAINABLES["chest"] == false then
					if basement_unlocked == true then
						if ending == false then
							if AMMO_AVAILABLE == true then
								if gun_obtained == true then
									table.insert(ending_options, "Shoot Him")
									table.insert(ending_options, "Wait")
									ROUTE = 1
								else
									doorTxt("", "I must rebuild the gun first.")
								end
							else
								table.insert(ending_options, "Leave Him")
								table.insert(ending_options, "Wait")
								ROUTE = 2

								local dialogue_broken_revolver = Interact(
									false,
									{
										"It's a revolver",
										"the cylinder is broken",
										"I can't open it",
										"I can' tell",
										"if it's loaded",
										"Take it?",
									},
									{"Yes", "No"},
									"",
									"revolver2"
								)
								table.insert(DIALOGUES, dialogue_broken_revolver)
								local item_broken_revolver = Items(IMAGES.br, IMAGES["leftRoom"], 41, 34, "revolver2")
								table.insert(ITEMS_LIST, item_broken_revolver)
							end
							if ROUTE ~= 0 then
								PLAYER:moveRoom(PLAYER.x, IMAGES["basementRoom"])
								SOUNDS.rain:stop()
								thunder_play = false
								lightning_flash = false
							end
						end
					else
						SOUNDS.unlock:play()
						SOUNDS.unlock:setLooping(false)
						doorTxt("You've used the key", "It's unlocked now")
						basement_unlocked = true
					end
				else
					doorTxt("It's locked", "I need a key")
					SOUNDS.locked:play()
				end
			else
				doorTxt("I must not go there", "I have to go to work")
			end
		end
		--basement room
	elseif currentRoom == IMAGES["basementRoom"] then
		if checkMid then
			if ENDING_LEAVE == false and ending_shoot == false then
				if basement_lock == true then
					doorTxt("It's locked from the other side", "I Guess there's no turning back")
					SOUNDS.locked:play()
				else
					PLAYER:moveRoom(self.x, IMAGES["livingRoom"])
				end
			elseif ending_shoot == true then
				doorTxt("It's locked from the other side", "I Guess there's no turning back")
				SOUNDS.locked:play()
			elseif ENDING_LEAVE == true then
				PLAYER:moveRoom(self.x, IMAGES["livingRoom"])
			end
		elseif checkLeft then
			if ENDING_LEAVE == false and ending_shoot == false then
				PLAYER:moveRoom(right, IMAGES["leftRoom"])
			elseif ending_shoot == true then
				PLAYER:moveRoom(right, IMAGES["leftRoom"])
			elseif ENDING_LEAVE == true then
				doorTxt("I must not go there", "I have to go to work")
			end

			if lr_event == 0 then
				lr_event = 1
			end
		elseif checkRight then
			if ENDING_LEAVE == false and ending_shoot == false and ending_wait == false then
				if rightroom_unlocked == true then
					PLAYER:moveRoom(left, IMAGES["rightRoom"])
				else
					SOUNDS.locked:play()
					SOUNDS.locked:setLooping(false)
					doorTxt("", "It's locked from the other side")
				end
			elseif ending_shoot == true then
				PLAYER:moveRoom(left, IMAGES["rightRoom"])
			elseif ENDING_LEAVE == true then
				doorTxt("I have to hurry", "I have to go to work")
			elseif ending_wait == true then
				PLAYER:moveRoom(left, IMAGES["rightRoom"])
			end
		end
		--leftRoom
	elseif currentRoom == IMAGES["leftRoom"] then
		if checkRight then
			if ending_shoot == true or ending_wait == true then
				LIGHT_ON = true
				PLAYER:moveRoom(left, IMAGES["basementRoom"])
			else
				PLAYER:moveRoom(left, IMAGES["basementRoom"])
			end
		end
	elseif currentRoom == IMAGES["rightRoom"] then
		if checkLeft then
			--locked
			-- player:moveRoom(right,images["basementRoom"])
			doorTxt("", "It's locked from the other side")
			SOUNDS.locked:play()
			SOUNDS.locked:setLooping(false)
		end

		--stair room
	elseif currentRoom == IMAGES["stairRoom"] then
		if checkLeft then
			PLAYER:moveRoom(left, IMAGES["hallwayLeft"])
		elseif checkRight then
			PLAYER:moveRoom(left, IMAGES["livingRoom"])
		end
		--hallway left
	elseif currentRoom == IMAGES["hallwayLeft"] then
		if checkLeft then
			PLAYER:moveRoom(left, IMAGES["stairRoom"])
		elseif checkRight then
			PLAYER:moveRoom(left, IMAGES["masterRoom"])
		elseif checkMid then
			PLAYER:moveRoom(PLAYER.x, IMAGES["storageRoom"])
		end
		--storage room
	elseif currentRoom == IMAGES["storageRoom"] then
		if checkMid then
			PLAYER:moveRoom(PLAYER.x, IMAGES["hallwayLeft"])
		end
		--master room
	elseif currentRoom == IMAGES["masterRoom"] then
		if checkLeft then
			PLAYER:moveRoom(right, IMAGES["hallwayLeft"])
		elseif checkRight then
			PLAYER:moveRoom(left, IMAGES["hallwayRight"])
		elseif checkMid then
			if mid_dial == 0 then
				if LOCKED["masterRoom_mid"] == true then
					doorTxt("It's locked", "I need to find the key")
					SOUNDS.locked:play()
				end
			elseif mid_dial == 1 then
				SOUNDS.item_got:play()
				doorTxt("You've used the key", "It's open now.")
				mid_dial = -1
				LOCKED["masterRoom_mid"] = false
				do return end
			elseif mid_dial == -1 then
				PLAYER:moveRoom(PLAYER.x, IMAGES["secretRoom"])
				MOVE = true
			end
		end
		--secret room
	elseif currentRoom == IMAGES["secretRoom"] then
		if checkMid then
			if event_find == false then
				PLAYER:moveRoom(PLAYER.x, IMAGES["masterRoom"])
			else
				if screamed ~= -1 then
					doorTxt("I'm scared..", "")
				else
					PLAYER:moveRoom(PLAYER.x, IMAGES["masterRoom"])
				end
			end
		end
		--hallway right
	elseif currentRoom == IMAGES["hallwayRight"] then
		if checkLeft then
			PLAYER:moveRoom(right, IMAGES["masterRoom"])
		elseif checkRight then
			PLAYER:moveRoom(right, IMAGES["kitchen"])
		elseif checkMid then
			PLAYER:moveRoom(PLAYER.x - 8, IMAGES["daughterRoom"])
		end
		--daughter room
	elseif currentRoom == IMAGES["daughterRoom"] then
		if checkMid then
			PLAYER:moveRoom(PLAYER.x + 8, IMAGES["hallwayRight"])
		end
		--kitchen
	elseif currentRoom == IMAGES["kitchen"] then
		if checkLeft then
			PLAYER:moveRoom(right, IMAGES["mainRoom"])
			if LOCKED["mainRoom_right"] == true then
				MOVE = false
			end
			LOCKED["mainRoom_right"] = false
			DOOR_LOCKED = false

			SaveData.data.door_locked = false
			SaveData.save()

			for _, v in ipairs(DIALOGUES) do
				v.maxT = 2.5
			end
		elseif checkRight then
			PLAYER:moveRoom(right, IMAGES["hallwayRight"])
		end
	end
end

function Player:checkItems()
	for _, v in ipairs(ITEMS_LIST) do
		if self.x >= v.x and self.x + self.w <= v.x + v.w or
			self.x + self.w >= v.x + v.w / 6 and self.x + self.w <= v.x + v.w or
			self.x >= v.x and self.x <= v.x + v.w - v.w / 6
		then
			if self.state == "normal" and v.visible then
				if event_find == false then
					if DOOR_LOCKED == false then
						v:returnTag()
					else
						v:stillLocked()
					end
				else
					v:specialTag()
				end
			else
				if v.visible and (v.tag == "chair" or v.tag == "chair_final") then
					if event_find == false then
						if DOOR_LOCKED == false then
							v:returnTag()
						else
							v:stillLocked()
						end
					else
						v:specialTag()
					end
				end
			end
		end
	end
end

function Player:checkGlow()
	for _, v in ipairs(ITEMS_LIST) do
		if self.x >= v.x and self.x + self.w <= v.x + v.w or
			self.x + self.w >= v.x + v.w / 6 and self.x + self.w <= v.x + v.w or
			self.x >= v.x and self.x <= v.x + v.w - v.w / 6
		then
			if self.state == "normal" then
				if v.visible == true then
					v:glow()
				end
			else
				if v.tag == "chair" or v.tag == "chair_final" then
					if v.visible == true then
						v:glow()
					end
				end
			end
		end
	end
end

function doorTxt(str1, str2)
	local str1 = str1
	local str2 = str2
	for _, v in ipairs(DIALOGUES) do
		v:special_text(str1, str2)
		MOVE = false
	end
end

function leaveRoom()
	for _, v in ipairs(DIALOGUES) do
		if v.state == true then v.state = false end
		if v.option == true then v.option = false end
		if v.specialTxt == true then v.specialTxt = false end
		if v.simpleMessage == true then v.simpleMessage = false end
	end

	enemy_check()

	local doorSound = math.floor(math.random(0, 1))
	if doorSound == 1 then
		SOUNDS.door_fast:play()
	else
		SOUNDS.squeak_fast:play()
	end

	if SOUNDS.tv_loud:isPlaying() == true then
		SOUNDS.tv_loud:stop()
	end
end

function Player:movement(dt)
	if love.keyboard.isDown("a") or self.android == -1 then
		if self.x >= 8 then
			self.isMoving = true
			self.x = self.x - self.xspd * dt
			self.left = true
			self.right = false
		end
	elseif love.keyboard.isDown("d") or self.android == 1 then
		if self.x <= WIDTH - 24 + self.w then
			self.isMoving = true
			self.x = self.x + self.xspd * dt
			self.right = true
			self.left = false
		end
	else
		self.isMoving = false
	end
end

return Player
