local pause = {}

pauseTxt = "The Game is Paused"
local c = 1

function pause.gui()
	gSound = {
		img = Images.gui_sound,
		w = Images.gui_sound:getWidth(),
		h = Images.gui_sound:getHeight(),
		x = WIDTH - 24,
		y = HEIGHT - 7 - 2
	}
end

function pause.sound(state)
	local state = state
	if state == "off" then
		gSound.img = Images.gui_sound_off
		love.audio.setVolume(0)
	elseif state == "on" then
		love.audio.setVolume(1)
		gSound.img = Images.gui_sound
	end
end

function pause.load()
	pause.gui()

	TEMP_MOVE = move
	move = false
	pauseFlag = true

	Sounds.thunder:pause()
	random_breathe_flag = false
	Sounds.ts_theme:play()
	Sounds.ts_theme:setVolume(0.3)
	lightningVol = 0
end


function pause.exit()
	move = TEMP_MOVE
	pauseFlag = false
	Sounds.thunder:play()
	random_breathe_flag = true
	Sounds.ts_theme:stop()
	lightningVol = 0.3
end


function pause.draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(pauseTxt,WIDTH/2 - DEF_FONT:getWidth(pauseTxt)/2,8)
	if ON_MOBILE then
		love.graphics.draw(Images.gui_sBack,gSettingsBack.x,gSettingsBack.y)
		love.graphics.draw(Images.gui_quit,gQuit.x,gQuit.y)
	end
	love.graphics.draw(gSound.img,gSound.x,gSound.y)
end

return pause
