local pause = {
	flag = false,
}

local pauseTxt = "The Game is Paused"

local gSound

function pause.toggle()
	if pause.flag then
		Pause.exit()
	else
		Pause.load()
	end
end

function pause.init()
	gSound = {
		img = Images.gui_sound,
		w = Images.gui_sound:getWidth(),
		h = Images.gui_sound:getHeight(),
		x = WIDTH - 24,
		y = HEIGHT - 7 - 2
	}
end

function pause.sound(state)
	if state == "off" then
		gSound.img = Images.gui_sound_off
		love.audio.setVolume(0)
	elseif state == "on" then
		love.audio.setVolume(1)
		gSound.img = Images.gui_sound
	end
end

function pause.load()
	TEMP_MOVE = MOVE
	MOVE = false
	pause.flag = true

	Sounds.thunder:pause()
	random_breathe_flag = false
	Sounds.ts_theme:play()
	Sounds.ts_theme:setVolume(0.3)
	lightningVol = 0
end

function pause.exit()
	MOVE = TEMP_MOVE
	pause.flag = false
	Sounds.thunder:play()
	random_breathe_flag = true
	Sounds.ts_theme:stop()
	lightningVol = 0.3
end

function pause.draw()
	if not pause.flag then return end
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(pauseTxt, WIDTH_HALF - DEF_FONT:getWidth(pauseTxt) / 2, 8)
	if ON_MOBILE then
		local gSettingsBack = Android.getgui("settings_back")
		local gQuit = Android.getgui("quit")
		love.graphics.draw(Images.gui_sBack, gSettingsBack.x, gSettingsBack.y)
		love.graphics.draw(Images.gui_quit, gQuit.x, gQuit.y)
	end
	love.graphics.draw(gSound.img, gSound.x, gSound.y)
end

function pause.mousepressed(mx, my, mb)
	if not pause.flag then return end
	if mb ~= 1 then return end
	if check_gui(gSound.x, gSound.y, gSound.w, gSound.h) then
		if gSound.img == Images.gui_sound then
			pause.sound("off")
		else
			pause.sound("on")
		end
	else
		local gSettingsBack = Android.getgui("settings_back")
		local gQuit = Android.getgui("quit")
		if check_gui(gSettingsBack.x, gSettingsBack.y, gSettingsBack.w, gSettingsBack.h) then
			pause.toggle()
		elseif check_gui(gQuit.x, gQuit.y, gQuit.w, gQuit.h) then
			pause.toggle()
			if ON_MOBILE and not PRO_VERSION then
				ShowRewardedAds(true, function(reward_type, reward_qty)
					print("rewardUserWithReward callback", reward_type, reward_qty)
					gamestates.nextState("title")
				end)
			else
				gamestates.nextState("title")
			end
		end
	end
end

return pause
