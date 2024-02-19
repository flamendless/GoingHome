local android = {}

local androidKey
local leftHold, rightHold = false, false
-- androidInteract = false
local changed = false
-- local temp_light = 0
local lx, ly = 0, 0

local gLeft, gRight, gLeft2, gRight2, gUp, gDown, gEnter, gEsc, gLight, gAct, gSettings, gSettingsBack, gQuit

function android.load()
	gLeft = {
		x = 4,
		y = HEIGHT - 12,
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
		y = HEIGHT_HALF,
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
		x = gLeft2.x + gLeft2.w / 2 + 2,
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
		x = WIDTH - 16,
		y = HEIGHT_HALF - 4,
		w = 12,
		h = 8
	}
	gEsc = {
		x = WIDTH - 16,
		y = 1,
		w = 12,
		h = 8
	}
	gLight = {
		x = WIDTH - 32,
		y = gLeft.y,
		w = 12,
		h = 8
	}
	gAct = {
		x = WIDTH - 16,
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
		x = WIDTH_HALF - 13,
		y = HEIGHT_HALF - 8,
		w = 26,
		h = 12
	}
	gQuit = {
		x = WIDTH_HALF - 10,
		y = HEIGHT_HALF + 8,
		w = 20,
		h = 12
	}
end

function android.getgui(key)
	if key == "settings_back" then
		return gSettingsBack
	elseif key == "quit" then
		return gQuit
	end
end

function android.get_light_pos() return lx, ly end

function android.update(dt)
	local state = gamestates.getState()
	if state ~= "main" then return end
	if not Images.lightOutline then return end

	local lo_w, lo_h = Images.lightOutline:getDimensions()

	lx = PLAYER.x - lo_w / 2 + math.random(-0.05, 0.05)
	ly = PLAYER.y - lo_h / 2.5 + math.random(-0.05, 0.05)
	android.light_update(dt)
	if MOVE == false then
		PLAYER.android = 0
	end

	if leftHold == true then
		PLAYER.android = -1
	elseif rightHold == true then
		PLAYER.android = 1
	elseif leftHold == false and rightHold == false then
		PLAYER.android = 0
	end

	if move_chair then
		local touches = love.touch.getTouches()
		for i, id in ipairs(touches) do
			local x, y = love.touch.getPosition(id)
			if guiCheck_touch(id, x, y, gAct) then
				MRCHAIR:keypressed(dt, "e")
			end
		end
	end
end

function android.draw()
	local state = gamestates.getState()
	if (not GAMEOVER) and (state == "main") then
		love.graphics.setColor(1, 1, 1, 1)
		--android.light_draw()
		if MOVE == true or doodle_flag == true then
			love.graphics.draw(Images.gui_left, gLeft.x, gLeft.y)
			love.graphics.draw(Images.gui_right, gRight.x, gRight.y)
			love.graphics.draw(Images.gui_light, gLight.x, gLight.y)
			love.graphics.draw(Images.gui_act, gAct.x, gAct.y)
			love.graphics.draw(Images.gui_settings, gSettings.x, gSettings.y)
		else
			love.graphics.setColor(1, 1, 1, 50 / 255)
			love.graphics.draw(Images.gui_left, gLeft.x, gLeft.y)
			love.graphics.draw(Images.gui_right, gRight.x, gRight.y)
			love.graphics.draw(Images.gui_act, gAct.x, gAct.y)
		end
		if word_puzzle then
			love.graphics.draw(Images.gui_esc, gEsc.x, gEsc.y)
		end
		if ClockPuzzle.state == true then
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.draw(Images.gui_left, gLeft2.x, gLeft2.y)
			love.graphics.draw(Images.gui_right, gRight2.x, gRight2.y)
			love.graphics.draw(Images.gui_up, gUp.x, gUp.y)
			love.graphics.draw(Images.gui_down, gDown.x, gDown.y)
			love.graphics.draw(Images.gui_enter, gEnter.x, gEnter.y)
			love.graphics.draw(Images.gui_esc, gEsc.x, gEsc.y)
		end
		if doodle_flag == true then
			love.graphics.draw(Images.gui_esc, gEsc.x, gEsc.y)
		end
	end
end

function android.touchpressed(id, x, y)
	local state = gamestates.getState()
	if state == "splash" or state == "splash2" then
		love.keypressed("e")
	elseif state == "gallery" then
		Gallery.interactions(id, x, y)
	elseif state == "main" and not Pause.flag then
		if MOVE == true then
			if guiCheck_touch(id, x, y, gLeft) then
				love.keypressed("a")
				leftHold = true
				rightHold = false
			elseif guiCheck_touch(id, x, y, gRight) then
				love.keypressed("d")
				rightHold = true
				leftHold = false
			elseif guiCheck_touch(id, x, y, gAct) then
				love.keypressed("e")
			elseif guiCheck_touch(id, x, y, gSettings) then
				Pause.toggle()
			end
		elseif MOVE == false then
			android.dialogue()
			android.endingDialogue()
			if guiCheck_touch(id, x, y, gAct) then
				love.keypressed("e")
			elseif guiCheck_touch(id, x, y, gLeft) then
				love.keypressed("a")
			elseif guiCheck_touch(id, x, y, gRight) then
				love.keypressed("d")
			end
		end

		if doodle_flag or ClockPuzzle.state or word_puzzle then
			if guiCheck_touch(id, x, y, gEsc) then
				love.keypressed("escape")
			end
		end
		if ClockPuzzle.state then
			if guiCheck_touch(id, x, y, gEnter) then
				love.keypressed("return")
			elseif guiCheck_touch(id, x, y, gLeft2) then
				love.keypressed("a")
			elseif guiCheck_touch(id, x, y, gRight2) then
				love.keypressed("d")
			elseif guiCheck_touch(id, x, y, gUp) then
				love.keypressed("w")
			elseif guiCheck_touch(id, x, y, gDown) then
				love.keypressed("s")
			end
		end
		if guiCheck_touch(id, x, y, gLight) then
			love.keypressed("f")
		end
	end
	-- if move then
	-- 	if pauseFlag == true then
	-- 		if guiCheck_touch(id,x,y,gSound) then
	-- 			if gSound.img == images.gui_sound then
	-- 				pause.sound("off")
	-- 			else
	-- 				pause.sound("on")
	-- 			end
	-- 		elseif guiCheck_touch(id,x,y,gSettingsBack) then
	-- 			pause.exit()
	-- 		elseif guiCheck_touch(id,x,y,gQuit) then
	-- 			if OS ~= "iOS" then
	-- 				love.event.quit()
	-- 			end
	-- 		end
	-- 	else
	-- 		if guiCheck_touch(id,x,y,gSettings) then
	-- 			pause.load()
	-- 		end
	-- 	end
	-- end
end

function android.touchreleased(id, x, y)
	local state = gamestates.getState()
	if state == "main" and not Pause.flag then
		if guiCheck_touch(id, x, y, gLight) then

		else
			leftHold = false
			rightHold = false
			PLAYER.android = 0
		end
		androidKey = ""
	end
end

function guiCheck_touch(id, x, y, gui)
	x = x / RATIO
	y = (y - TY) / RATIO
	return (
		x > gui.x and
		x < gui.x + gui.w and
		y > gui.y and
		y < gui.y + gui.h
	)
end

function android.dialogue()
	local key = android.getKey()
	for _, v in ipairs(dialogue) do
		for _, k in ipairs(obj) do
			if (v.tag == k.tag) and v.state then
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
					elseif key == "e" then
						v:returnChoices(v.cursor)
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
		elseif key == "e" then
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

function android.setKey(key) androidKey = key end

function android.getKey() return androidKey end

function android.light_update(dt)
	if changed == false then
		if light == Images.light then
			mainLight = Images.lightOutline
		elseif light == Images.light2 then
			mainLight = Images.light2
		end
	else
		mainLight = Images.light3
	end

	if ON_MOBILE then
		love.graphics.setCanvas(CANVAS_CUSTOM_MASK)
		love.graphics.clear(0, 0, 0, LIGHT_VALUE)
		love.graphics.setBlendMode("multiply", "premultiplied")
		if changed == false then
			love.graphics.draw(mainLight, lx, ly)
			if candles_light_flag and currentRoom == Images["masterRoom"] then
				local rand = 0.05
				local cx = 0 + (math.random(-rand, rand))
				local cy = HEIGHT_HALF - Images.candles_light_mask:getHeight() / 2 + (math.random(-rand, rand))
				love.graphics.draw(Images.candles_light_mask, cx, cy)
			end
			if tv_light_flag and currentRoom == Images["secretRoom"] then
				local tx, ty = 104, 11
				love.graphics.draw(Images.tv_light, tx, ty)
			end
			if left_light_flag and currentRoom == Images["leftRoom"] then
				local img = getLeftRoom()
				light_etc(dt, ll, img, CANVAS_CUSTOM_MASK)
			end
			if right_light_flag and currentRoom == Images["rightRoom"] then
				local img = getRightRoom()
				light_etc(dt, rl, img, CANVAS_CUSTOM_MASK)
			end
		else
			love.graphics.draw(mainLight, 0, 0)
		end
		love.graphics.setBlendMode("alpha")
		love.graphics.setCanvas()
	end
end

function android.light_draw()
	if ON_MOBILE or DEBUGGING then
		love.graphics.draw(CANVAS_CUSTOM_MASK)
	end
end

function android.light_check()
	local near_range = Images.lightOutline:getWidth() / 2.5
	local inside_range = Images.lightOutline:getWidth() / 3
	if FADE_OBJ.state == false then
		if ENEMY_EXISTS == true and LIGHT_ON == true then
			if PLAYER.x >= GHOST.x - inside_range and
				PLAYER.x <= GHOST.x + inside_range then
				GHOST:action_inside()
			elseif PLAYER.x >= GHOST.x - near_range and
				PLAYER.x <= GHOST.x + near_range then
				GHOST:action_near()
			else
				GHOST:action_none()
			end
		end
	end
end

function android.lightChange(bool)
	changed = bool
end

function android.mouse_gui(x, y, button, istouch)
	if not ON_MOBILE then return end
	local state = gamestates.getState()

	if button == 1 then
		if state == "title" then
			if instruction == false and about == false and questions == false then
				if check_gui(gui_pos.start_x, gui_pos.start_y, gui_pos.start_w, gui_pos.start_h) then
					--start
					gamestates.control()
				elseif check_gui(gui_pos.quit_x, gui_pos.quit_y, gui_pos.quit_w, gui_pos.quit_h) then
					--exit
					love.event.quit()
				end
			end
		elseif state == "rain_intro" then
			if check_gui(gui_pos.skip_x, gui_pos.skip_y, gui_pos.skip_w, gui_pos.skip_h) then
				PRESSED = true
				FADE_OBJ.state = true
				STATES = "intro"
				gamestates.load()
			end
		elseif state == "intro" then
			if check_gui(gui_pos.skip_x, gui_pos.skip_y, gui_pos.skip_w, gui_pos.skip_h) then
				PRESSED = true
				FADE_OBJ.state = true
				STATES = "main"
				gamestates.load()
			end
		end
	end
end

return android
