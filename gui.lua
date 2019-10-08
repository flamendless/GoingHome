local android = {}

local androidKey
leftHold, rightHold = false, false
androidInteract = false
local changed = false
local temp_light = 0
lx,ly = 0,0

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
		x = width - 16,
		y = 1,
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
		lx = player.x - images.lightOutline:getWidth()/2 + math.random(-0.05,0.05)
		ly = player.y - images.lightOutline:getHeight()/2.5 + math.random(-0.05,0.05)
		android.light_update(dt)
		if move == false then
			player.android = 0
		end

		if leftHold == true then
			player.android = -1
		elseif rightHold == true then
			player.android = 1
		elseif leftHold == false and rightHold == false then
			player.android = 0
		end

		if move_chair then
			local touches = love.touch.getTouches()
			for i,id in ipairs(touches) do
				local x,y = love.touch.getPosition(id)
				if guiCheck_touch(id,x,y,gAct) then
					mrChair:keypressed(dt,"e")
				end
			end
		end
	end
end

function android.draw()
	local state = gamestates.getState()
	love.graphics.setColor(1, 1, 1, 1)
	if state == "main" then
		--android.light_draw()
	 if move == true then
	   love.graphics.setColor(1, 1, 1, 1)
	   love.graphics.draw(images.gui_left,gLeft.x,gLeft.y)
	   love.graphics.draw(images.gui_right,gRight.x,gRight.y)
	   love.graphics.draw(images.gui_light,gLight.x,gLight.y)
	   love.graphics.draw(images.gui_act,gAct.x,gAct.y)
	   love.graphics.draw(images.gui_settings,gSettings.x,gSettings.y)
	 else
	   love.graphics.setColor(1, 1, 1, 50/255)
	   love.graphics.draw(images.gui_left,gLeft.x,gLeft.y)
	   love.graphics.draw(images.gui_right,gRight.x,gRight.y)
	   love.graphics.draw(images.gui_act,gAct.x,gAct.y)
	 end
	 	if word_puzzle then
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.draw(images.gui_esc,gEsc.x,gEsc.y)
	 	end
	  if clock_puzzle == true then
	  	love.graphics.setColor(1, 1, 1, 1)
	  	love.graphics.draw(images.gui_left,gLeft2.x,gLeft2.y)
	 	  love.graphics.draw(images.gui_right,gRight2.x,gRight2.y)
	  	love.graphics.draw(images.gui_up,gUp.x,gUp.y)
	  	love.graphics.draw(images.gui_down,gDown.x,gDown.y)
	  	love.graphics.draw(images.gui_enter,gEnter.x,gEnter.y)
	  	love.graphics.draw(images.gui_esc,gEsc.x,gEsc.y)
	  end
	  if doodle_flag == true then
			love.graphics.setColor(1, 1, 1, 1)
	  	love.graphics.draw(images.gui_esc,gEsc.x,gEsc.y)
	  end
	end
end

function android.touchpressed(id,x,y)
	local state = gamestates.getState()
	if state == "splash" or state == "splash2" then
		love.keypressed("e")
	end
	if state == "gallery" then
		if Gallery.touch(id,x,y,gPlay) then
			love.keypressed("space")
		elseif Gallery.touch(id,x,y,gNext) then
			love.keypressed("n")
		elseif Gallery.touch(id,x,y,gPrevious) then
			love.keypressed("b")
		elseif Gallery.touch(id,x,y,gExit) then
			love.keypressed("escape")
		end
	end
	if state == "main" and pauseFlag == false then
		if move == true then
			if guiCheck_touch(id,x,y,gLeft) then
				love.keypressed("a")
				leftHold = true
				rightHold = false
			elseif guiCheck_touch(id,x,y,gRight) then
				love.keypressed("d")
				rightHold = true
				leftHold = false
			end
			if guiCheck_touch(id,x,y,gAct) then
				love.keypressed("e")
			end
		elseif move == false then
			android.dialogue()
			android.endingDialogue()
			if guiCheck_touch(id,x,y,gAct) then
				love.keypressed("e")
			elseif guiCheck_touch(id,x,y,gLeft) then
				love.keypressed("a")
			elseif guiCheck_touch(id,x,y,gRight) then
				love.keypressed("d")
			end
		end

		if doodle_flag or clock_puzzle or word_puzzle then
			if guiCheck_touch(id,x,y,gEsc) then
				love.keypressed("escape")
			end
		end
		if clock_puzzle then
			if guiCheck_touch(id,x,y,gEnter) then
				love.keypressed("return")
			elseif guiCheck_touch(id,x,y,gLeft2) then
				love.keypressed("a")
			elseif guiCheck_touch(id,x,y,gRight2) then
				love.keypressed("d")
			elseif guiCheck_touch(id,x,y,gUp) then
				love.keypressed("w")
			elseif guiCheck_touch(id,x,y,gDown) then
				love.keypressed("s")
			end
		end
		if guiCheck_touch(id,x,y,gLight) then
			love.keypressed("f")
		end
	end
	if move then
		if pauseFlag == true then
			if guiCheck_touch(id,x,y,gSound) then
				if gSound.img == images.gui_sound then
					pause.sound("off")
				else
					pause.sound("on")
				end
			elseif guiCheck_touch(id,x,y,gSettingsBack) then
				pause.exit()
			elseif guiCheck_touch(id,x,y,gQuit) then
				if love.system.getOS() ~= "iOS" then
					love.event.quit()
				end
			end
		else
			if guiCheck_touch(id,x,y,gSettings) then
				pause.load()
			end
		end
	end
end

function android.touchreleased(id,x,y)
	local state = gamestates.getState()
	if state == "main" and pauseFlag == false then
		if guiCheck_touch(id,x,y,gLight) then

		else
			leftHold = false
			rightHold = false
			player.android = 0
		end
		androidKey = ""
	end
end


function guiCheck_touch(id,x,y,gui)
	local gui = gui
	local x = x/ratio
	local y = (y - ty)/ratio
	return x > gui.x and x < gui.x + gui.w and
		y > gui.y and y < gui.y + gui.h
end

function android.dialogue()
	local key = android.getKey()
	for k,v in pairs(dialogue) do
		for j,k in pairs(obj) do
			if v.tag == k.tag then
				if v.state == true then
					if key == "e" then
						if v.n <= #v.txt then
							v.n = v.n + 1
						end
					end
					if v.option == true then
						if key == "a" then
							v.cursor = 1
						elseif key == "d" then
							v.cursor = 2
						elseif key == "e"  then
							v:returnChoices(v.cursor)
						end
					end
				end
			end
		end
	end
end

function android.endingDialogue()
	local key = android.getKey()
	if lr_event == 3 then
		if key == "a" then
			e_c = 1
		elseif key == "d" then
			e_c = 2
		elseif key == "e"  then
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
			if event_route ~= nil then
				lr_event = 4
			end
		end
	end
end

function android.setKey(key)
	androidKey = key
end

function android.getKey()
	return androidKey
end

function android.light_update(dt)
	if changed == false then
		if light == images.light then
			mainLight = images.lightOutline
		elseif light == images.light2 then
			mainLight = images.light2
		end
	else
		mainLight = images.light3
	end

	if love.system.getOS() == "Android" or love.system.getOS() == "iOS" or debug == true then
		love.graphics.setCanvas(custom_mask)
		love.graphics.clear(0,0,0,lv)
		love.graphics.setBlendMode("multiply", "premultiplied")
		if changed == false then
			love.graphics.draw(mainLight,lx,ly)
			if candles_light_flag and currentRoom == images["masterRoom"] then
				local cx,cy = getCandles()
				love.graphics.draw(images.candles_light_mask,cx,cy)
			end
			if tv_light_flag and currentRoom == images["secretRoom"] then
				local tx,ty = 104,11
				love.graphics.draw(images.tv_light,tx,ty)
			end
			if left_light_flag and currentRoom == images["leftRoom"] then
				local img = getLeftRoom()
				light_etc(dt,ll,img,custom_mask)
			end
			if right_light_flag and currentRoom == images["rightRoom"] then
				local img = getRightRoom()
				light_etc(dt,rl,img,custom_mask)
			end
		else
			love.graphics.draw(mainLight,0,0)
		end
		love.graphics.setBlendMode("alpha")
		love.graphics.setCanvas()
	end
end

function android.light_draw()
	if love.system.getOS() == "Android" or love.system.getOS() == "iOS" or debug == true then
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

function android.lightChange(bool)
	changed = bool
end

function android.mouse_gui(x,y,button,istouch)
if love.system.getOS() == "Android" or love.system.getOS() == "iOS" then
	local state = gamestates.getState()
	local mx= x/ratio
	local my = (y-ty)/ratio
	
	if button == 1 then
		if state == "title" then
			if instruction == false and about == false and questions == false then
				if  check_gui(gui_pos.start_x,gui_pos.start_y,gui_pos.start_w,gui_pos.start_h) then
					--start
					gamestates.control()
				elseif check_gui(gui_pos.quit_x,gui_pos.quit_y,gui_pos.quit_w,gui_pos.quit_h) then
					--exit
					love.event.quit()
				end
			end
		elseif state == "rain_intro" then
			if check_gui(gui_pos.skip_x,gui_pos.skip_y,gui_pos.skip_w,gui_pos.skip_h) then
				pressed = true
				fade.state = true
				states = "intro"
				gamestates.load()
			end
		elseif state == "intro" then
			if check_gui(gui_pos.skip_x,gui_pos.skip_y,gui_pos.skip_w,gui_pos.skip_h) then
				pressed = true
				fade.state = true
				states = "main"
				gamestates.load()
			end
		end
	end
end
end

return android
