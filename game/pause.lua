local pause = {}

pauseTxt = "The Game is Paused"
local c = 1

function pause.gui()
	gSound = {
		img = images.gui_sound,
		w = images.gui_sound:getWidth(),
		h = images.gui_sound:getHeight(),
		x = width - 24,
		y = height - 7 - 2
	}
end

function pause.sound(state)
	local state = state
	if state == "off" then
		gSound.img = images.gui_sound_off
		love.audio.setVolume(0)
	elseif state == "on" then
		love.audio.setVolume(1)
		gSound.img = images.gui_sound
	end
end

function pause.load()
	pause.gui()

	temp_move = move
	move = false
	pauseFlag = true

	sounds.thunder:pause()
	random_breathe_flag = false
	sounds.ts_theme:play()
	sounds.ts_theme:setVolume(0.3)
	lightningVol = 0
end


function pause.exit()
	move = temp_move
	pauseFlag = false
	sounds.thunder:resume()
	random_breathe_flag = true
	sounds.ts_theme:stop()
	lightningVol = 0.3

	if love.system.getOS() == "Android" or love.system.getOS() == "iOS" then
		if debug then

			door_locked = false
			mid_dial = 1
			event = "after_dialogue"
			obtainables["match"] = false
			obtainables["chest"] = false

			if c == 1 then
				obtainables["gun1"] = false
				obtainables["gun2"] = false
				obtainables["gun3"] = false
				check_gun()
				currentRoom = images["kitchen"]
				c = c + 1
			elseif c == 2 then
				currentRoom = images["livingRoom"]
				c = 1
			end

		end
	end
end


function pause.draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(pauseTxt,width/2 - font:getWidth(pauseTxt)/2,8)
	love.graphics.draw(images.gui_sBack,gSettingsBack.x,gSettingsBack.y)
	if love.system.getOS() ~= "iOS" then
		love.graphics.draw(images.gui_quit,gQuit.x,gQuit.y)
	end
	love.graphics.draw(gSound.img,gSound.x,gSound.y)
end

return pause
