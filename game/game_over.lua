game_over = {}

local timer = 10
local timer_starts = false
local splash = false
-- local alpha = 100

local go_text = "The Fear Caught Up With You"

function game_over.load()

	timer_starts = true

	Sounds.main_theme:stop()
	Sounds.rain:stop()
	Sounds.thunder:stop()

	Sounds.enemy_scream:play()

	LIGHT_ON = false

	player.dead = true
end

function game_over.update(dt)

	enemy_exists = false
	game_over.init(dt)

	if timer_starts == true then
		if timer > -4 then
			timer = timer - 1 * dt
		elseif timer <= -4 then
			game_over.exit()
		end
	end

	lightX = player.x - Images.light:getWidth()/2 + 4
	lightY =  player.y - Images.light:getHeight()/2 + 4



	if timer >= 8 and timer <= 9 then
		player.img = Images.player_idle
		LIGHT_ON = true

	end
	if timer >= 7 and timer <= 8 then
		LIGHT_ON = false
	end
	--
	if timer >= 6 and timer <= 7 then
		player.img = Images.player_red_eyes
		LIGHT_ON = true
	end
	if timer >= 5 and timer <= 6 then
		LIGHT_ON = false
	end
	--
	if timer >= 3 and timer <= 4 then
		player.img = Images.player_eyes_bleed
		LIGHT_ON = true
	end
	if timer >= 2 and timer <= 3 then
		LIGHT_ON = false
	end
	--
	if timer >= 1 and timer <= 1.2 then
		player.img = Images.player_dead
		LIGHT_ON = true
	end
	if timer >= 0.5 and timer <= 0.9 then
		splash = true
	end
	if timer >= 0 and timer <= 1 then
		LIGHT_ON = false
	end
	if timer >= -4 and timer <= -0.9 then
		message = true
	end
end

function game_over.draw()
	if splash == true then
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.rectangle("fill",0,0,WIDTH,HEIGHT)
	end
	if message == true then
		love.graphics.setColor(0,0,0,1)
		love.graphics.rectangle("fill",0,16,128,32)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.print(go_text,WIDTH/2 - DEF_FONT:getWidth(go_text)/2, HEIGHT_HALF - DEF_FONT_HALF)
	end
end

function game_over.exit()
	--sounds.ts_theme:play()
	Sounds.rain:stop()
	Sounds.main_theme:stop()
	gameover = false
	--return to title screen
	--states = "title"
	--gamestates.load()
	if PRO_VERSION == false then
		if ON_MOBILE then
			if LoveAdmob.isInterstitialLoaded() == true then
				LoveAdmob.showInterstitial()
				love.event.quit("restart")
			else
				love.event.quit("restart")
			end
		else
			love.event.quit("restart")
		end
	else
		love.event.quit("restart")
	end
end

function game_over.init(dt)
	local vol = Sounds.rain:getVolume()
	if vol > 0 then
		vol = vol - 0.025 * dt
		Sounds.rain:setVolume(vol)
		Sounds.main_theme:setVolume(vol)
	elseif vol <= 0 then
		Sounds.rain:stop()
		Sounds.main_theme:stop()
	end

	Sounds.thunder:stop()
	random_breathe = false

end

function unrequire(m)
  package.loaded[m] = nil
  _G[m] = nil
  require(m)
end

