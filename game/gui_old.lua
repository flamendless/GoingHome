local android = {}
androidMove = 0
androidInteract = false
androidVertical = 0
androidEnter = 0
androidEsc = 0

function android.load()
	gLeft = {
		x = 4,
		y = height - 12,
		w = 12,
		h = 8
	}
	gRight = {
		x = gLeft.x + gLeft.w + 4,
		y = gLeft.y,
		w = 12,
		h = 8
	}
	gLeft2 = {
		x = 2,
		y = height/2,
		w = 12,
		h = 8
	}
	gRight2 = {
		x = gLeft2.x + gLeft2.w + 2,
		y = gLeft2.y,
		w = 12,
		h = 8
	}
	gUp = {
		x = gLeft2.x + gLeft2.w/2 + 2,
		y = gLeft2.y - gLeft2.h - 2,
		w = 12,
		h = 8
	}
	gDown = {
		x = gUp.x,
		y = gLeft2.y + gLeft2.h + 2,
		w = 12,
		h = 8
	}

	gEnter = {
		x = width - 16,
		y = height/2 - 4,
		w = 12,
		h = 8
	}
	gEsc = {
		x = gEnter.x - gEnter.w - 2,
		y = gEnter.y,
		w = 12,
		h = 8
	}
	

	gLight = {
		x = width - 32,
		y = gLeft.y,
		w = 12,
		h = 8
	}
	gAct = {
		x = width - 16,
		y = gLeft.y,
		w = 12,
		h = 8
	}

	gSettings = {
		x = 1,
		y = 1,
		w = 7,
		h = 7
	}
	gSettingsBack = {
		x = width/2 - 13,
		y = height/2 - 8,
		w = 26,
		h = 12
	}
	gQuit = {
		x = width/2 - 10,
		y = height/2 + 8,
		w = 20,
		h = 12
	}
end

function android.update(dt)
	local state = gamestates.getState()
	if state == "main" then
		android.keypressed()
		android.keyreleased()
		android.light_update(dt)
	end
end

function android.draw()
	local state = gamestates.getState()
	love.graphics.setColor(1,1,1,1)
	if state == "main" then
		android.light_draw()
	 if move == true then
	   love.graphics.setColor(1,1,1,1)
	   love.graphics.draw(images.gui_left,gLeft.x,gLeft.y)
	   love.graphics.draw(images.gui_right,gRight.x,gRight.y)
	   love.graphics.draw(images.gui_light,gLight.x,gLight.y)
	   love.graphics.draw(images.gui_act,gAct.x,gAct.y)
	   love.graphics.draw(images.gui_settings,gSettings.x,gSettings.y)
	 else
	   love.graphics.setColor(1,1,1,150/255)
	   love.graphics.draw(images.gui_left,gLeft.x,gLeft.y)
	   love.graphics.draw(images.gui_right,gRight.x,gRight.y)
	   love.graphics.draw(images.gui_act,gAct.x,gAct.y)
	 end
	  if clock_puzzle == true then
	  	love.graphics.setColor(1,1,1,1)
	  	love.graphics.draw(images.gui_left,gLeft2.x,gLeft2.y)
	 	  love.graphics.draw(images.gui_right,gRight2.x,gRight2.y)
	  	love.graphics.draw(images.gui_up,gUp.x,gUp.y)
	  	love.graphics.draw(images.gui_down,gDown.x,gDown.y)
	  	love.graphics.draw(images.gui_enter,gEnter.x,gEnter.y)
	  	love.graphics.draw(images.gui_esc,gEsc.x,gEsc.y)
			love.graphics.draw(images.gui_settings,gSettings.x,gSettings.y)
	  end
	end
end

function android.mousepressed(x,y,button,istouch)
	local state = gamestates.getState()
	if state == "main" then
	if button == 1 then
		if clock_puzzle == true then
			if guiCheck(gLeft2) then
				androidMove = -1
			elseif guiCheck(gRight2) then
				androidMove = 1
			elseif guiCheck(gUp) then
				androidVertical = 1
			elseif guiCheck(gDown) then
				androidVertical = -1
			elseif guiCheck(gEnter) then
				androidEnter = 1
			elseif guiCheck(gEsc) then
				androidEsc = 1
			end
		end
		if pauseFlag == false then
			if guiCheck(gSettings) then
				pause.load()
				if debug == true then
					door_locked = false
				end
			end
		else
			if guiCheck(gSettingsBack) then
				pause.exit()
			end
		end
	end
end
end

function android.mousereleased(x,y,button,istouch)
end

function guiCheck(gui)
	local gui = gui
	local x = love.mouse.getX()/ratio
	local y = (love.mouse.getY()-ty)/ratio
	return x > gui.x and x < gui.x + gui.w and
		y > gui.y and y < gui.y + gui.h 
end

function guiCheck_touch(id,x,y,gui)
	local gui = gui
	local x = x/ratio
	local y = y/ratio
	return x > gui.x and x < gui.x + gui.w and
		y > gui.y and y < gui.y + gui.h
end



function android.keyreleased()
	
	if lr_event == 3 then
		if androidMove == -1 then
			e_c = 1
		elseif androidMove == 1 then
			e_c = 2
		elseif androidInteract == true then
			if route == 1 then
				if e_c == 1 then
					event_route = him_convo
				elseif e_c == 2 then
					event_route = wait_convo
				end
			elseif route == 2 then
				if e_c == 1 then
					event_route = leave_convo
				elseif e_c == 2 then
					event_route = wait_convo
				end
			end
			lr_event = 4
		end
	end
end

function android.keypressed()
	if move == true then
	if pushing_anim == false then
		if androidMove == -1 then
			if player.moveLeft == true then
				player.isMoving = true
			end
			if player.dir == 1 then
				player.dir = -1
				child:flipH()
				player_push:flipH()
				idle:flipH()
			end

			if ghost_event == "no escape" then
				if ghost_chase == false then
					ghost_chase = true
				end
			end
		elseif androidMove == 1 then
			if player.moveRight == true then
				player.isMoving = true
			end
			if player.dir == -1 then
				player.dir = 1
				child:flipH()
				player_push:flipH()
				idle:flipH()
			end
			if ghost_event == "no escape" then
				if ghost_chase == false then
					ghost_chase = true
				end
			end
		else
			if androidInteract == true then
				if currentRoom == images["leftRoom"] or currentRoom == images["rightRoom"] then
					if lightOn == false then
						player:checkItems()
						player:checkDoors()
					end
				end	
				if move_chair == false then
					if event_find == false then
						if lightOn == true then
							player:checkItems()
							player:checkDoors()
						end
					else
						player:checkItems()
						player:checkDoors()
					end
				end
			end
		end
	end
	end
	if doodle_flag == true then
		move = false
		if androidEsc == 1 then
			doodle_flag = false
			move = true
			storage_puzzle = false
			androidEsc = 0
		elseif androidMove == -1 then
			if pic_number > 1 then
				pic_number = pic_number - 1
				random_page()
			else
				pic_number = 1
			end
		elseif androidMove == 1 then
			if pic_number < #puzzle_pics then
				pic_number = pic_number + 1
				random_page()
			else
				pic_number = #puzzle_pics
			end
		end
	end
	if clock_puzzle == true then
		if androidEsc == 1 then
			clock_puzzle = false
			move = true
			androidEsc = 0
		elseif androidVertical == 1 then
		    if selected == "hour" then
		    	if hour < 12 then
		    		hour = hour + 1
		    	else
		    		hour = 1
		    	end
		    elseif selected == "minute" then
		    	if minute < 60 then
		    		minute = minute + 1
		    	else 
		    		minute = 1
		    	end
		    elseif selected == "second" then
		    	if second < 60 then
		    		second = second + 1
		    	else
		    		second = 1
		    	end
		    elseif selected == "ampm" then
		    	if ampm == "am" then
		    		ampm = "pm"
		    	else
		    		ampm = "am"
		    	end
		    end
		    androidVertical = 0

		elseif androidVertical == -1 then
			if selected == "hour" then
		    	if hour > 1 then
		    		hour = hour - 1
		    	else
		    		hour = 12
		    	end
		    elseif selected == "minute" then
		    	if minute > 1 then
		    		minute = minute - 1
		    	else 
		    		minute = 60
		    	end
		    elseif selected == "second" then
		    	if second > 1 then
		    		second = second - 1
		    	else
		    		second = 60
		    	end
		    elseif selected == "ampm" then
		    	if ampm == "am" then
		    		ampm = "pm"
		    	else
		    		ampm = "am"
		    	end
		    end
		    androidVertical = 0

		elseif androidMove == -1 then
			if selected == "minute" then
				selected = "hour"
			elseif selected == "second" then
				selected = "minute"
			elseif selected == "ampm" then
				selected = "second"
			end
			androidMove = 0
		elseif androidMove == 1 then
			if selected == "hour" then
				selected = "minute"
			elseif selected == "minute" then
				selected = "second"
			elseif selected == "second" then
				selected = "ampm"
			end
			androidMove = 0
		else
			if androidEnter == 1 then
				clock_puzzle = false
				move = true
				androidEnter = 0
				if hour == 10 and minute == 2 and second == 8 and ampm == "pm" then
					clock_puzzle = false
					sounds.item_got:play()
					solved = true
					sounds.main_theme:stop()
					sounds.intro_soft:stop()
					sounds.finding_home:stop()
					sounds.ts_theme:stop()
				end
			end
		end
	end
end

function android.light()
	if event_trigger_light == -1 then
		_lightX = player.x + player.w/2 - images.light_small:getWidth()/2 + math.random(-0.05,0.05) 
		_lightY = player.y + player.h/3 - images.light_small:getHeight()/2 + math.random(-0.05,0.05)
	else
		_lightX = player.x + player.w/2 - images.light:getWidth()/2 + math.random(-0.05,0.05) 
		_lightY = player.y + player.h/3 - images.light:getHeight()/2 + math.random(-0.05,0.05)
	end
	lightX = _lightX
	lightY = _lightY 
end

function android.light_update(dt)
	if light == images.light then
		mainLight = images.lightOutline
	elseif light == images.light2 then
		mainLight = images.light2
	end
	local lx = player.x - images.lightOutline:getWidth()/2 + math.random(-0.05,0.05)
	local ly = player.y - images.lightOutline:getHeight()/2.5 + math.random(-0.05,0.05)
	if OS == "Android" or OS == "iOS" or debug == true then
		love.graphics.setCanvas(custom_mask)
		love.graphics.clear(0,0,0,lv)
		love.graphics.setBlendMode("multiply", "premultiplied")
		love.graphics.draw(mainLight,lx,ly)
		love.graphics.setBlendMode("alpha")
		love.graphics.setCanvas()
	end
end

function android.light_draw()
	if OS == "Android" or OS == "iOS" or debug == true then
		love.graphics.draw(custom_mask)
	end
end

function android.light_check()
	local near_range = images.lightOutline:getWidth()/2.5
	local inside_range = images.lightOutline:getWidth()/3
	if fade.state == false then
		if enemy_exists == true and lightOn == true then
			if player.x >= ghost.x - inside_range and
				player.x <= ghost.x + inside_range then
					ghost:action_inside()
			elseif player.x >= ghost.x - near_range and
				player.x <= ghost.x + near_range then
				ghost:action_near()
			else
				ghost:action_none()
			end
		end
	end
end

function android.dialogue()
	for k,v in pairs(dialogue) do
		for j,k in pairs(obj) do
			if v.tag == k.tag then
				if v.state == true then
					if androidInteract == true then
						if v.n <= #v.txt then
							v.n = v.n + 1
						end
					end
					if v.option == true then
						if androidMove == -1 then
							v.cursor = 1
						elseif androidMove == 1 then
							v.cursor = 2
						elseif androidInteract == true  then
							v:returnChoices(v.cursor)
							androidInteract = false
						end
						androidMove = 0
					end
				end
			end
		end
	end
end

function android.touchpressed(id,x,y)
	local state = gamestates.getState()
	if state == "main" and pauseFlag == false then
		if move == true then
			if guiCheck_touch(id,x,y,gLeft) then
				player.android = -1
				androidMove = -1
			elseif guiCheck_touch(id,x,y,gRight) then
				player.android = 1
				androidMove = 1
			end
			if guiCheck_touch(id,x,y,gAct) then
				androidInteract = true
			end
		elseif move == false then
			android.dialogue()
			if guiCheck_touch(id,x,y,gAct) then
				androidInteract = true
			end
			if guiCheck_touch(id,x,y,gLeft) then
				androidMove = -1
			elseif guiCheck_touch(id,x,y,gRight) then
				androidMove = 1
			end
		end
		if guiCheck_touch(id,x,y,gLight) then
			turnLight()
		end
	end
	if pauseFlag == true then
		if guiCheck_touch(id,x,y,gSound) then
			if gSound.img == images.gui_sound then
				pause.sound("off")
			else
				pause.sound("on")
			end
		end
	end
end

function android.touchreleased(id,x,y) 
	local state = gamestates.getState()
	if state == "main" and pauseFlag == false then
		if move == true then
			player.android = 0
			androidVertical = 0
			androidMove = 0
			androidInteract = false
		end
	end
end

return android
