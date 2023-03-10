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
	sounds.thunder:play()
	random_breathe_flag = true
	sounds.ts_theme:stop()
	lightningVol = 0.3
end


function pause.draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(pauseTxt,width/2 - font:getWidth(pauseTxt)/2,8)
	if (OS == "Android") or (OS == "iOS") then
		love.graphics.draw(images.gui_sBack,gSettingsBack.x,gSettingsBack.y)
		love.graphics.draw(images.gui_quit,gQuit.x,gQuit.y)
	end
	love.graphics.draw(gSound.img,gSound.x,gSound.y)
end

return pause
