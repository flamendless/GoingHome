game_over = {}

local timer = 10
local timer_starts = false
local splash = false
local alpha = 100

local go_text = "The Fear Caught Up With You"

function game_over.load()

	timer_starts = true

	sounds.main_theme:stop()
	sounds.rain:stop()
	sounds.thunder:stop()

	sounds.enemy_scream:play()	

	lightOn = false

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

	lightX = player.x - images.light:getWidth()/2 + 4
	lightY =  player.y - images.light:getHeight()/2 + 4



	if timer >= 8 and timer <= 9 then
		player.img = images.player_idle
		lightOn = true

	end
	if timer >= 7 and timer <= 8 then
		lightOn = false
	end
	--
	if timer >= 6 and timer <= 7 then
		player.img = images.player_red_eyes
		lightOn = true
	end
	if timer >= 5 and timer <= 6 then
		lightOn = false
	end
	--
	if timer >= 3 and timer <= 4 then
		player.img = images.player_eyes_bleed
		lightOn = true
	end
	if timer >= 2 and timer <= 3 then
		lightOn = false
	end
	--
	if timer >= 1 and timer <= 1.2 then
		player.img = images.player_dead
		lightOn = true
	end
	if timer >= 0.5 and timer <= 0.9 then
		splash = true
	end
	if timer >= 0 and timer <= 1 then
		lightOn = false
	end
	if timer >= -4 and timer <= -0.9 then
		message = true
	end
end

function game_over.draw()
	if splash == true then
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.rectangle("fill",0,0,width,height)
	end
	if message == true then
		love.graphics.setColor(0,0,0,1)
		love.graphics.rectangle("fill",0,16,128,32)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.print(go_text,width/2 - font:getWidth(go_text)/2, height/2 - font:getHeight(go_text)/2)
	end
end

function game_over.exit()
	--sounds.ts_theme:play()
	sounds.rain:stop()
	sounds.main_theme:stop()
	gameover = false
	--return to title screen
	--states = "title"
	--gamestates.load()
	if pro_version == false then
		if OS == "Android" then
			if love.system.isInterstitialLoaded() == true then
				love.system.showInterstitial()
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
	local vol = sounds.rain:getVolume() 
	if vol > 0 then
		vol = vol - 0.025 * dt
		sounds.rain:setVolume(vol)
		sounds.main_theme:setVolume(vol)
	elseif vol <= 0 then 
		sounds.rain:stop()
		sounds.main_theme:stop()
	end

	sounds.thunder:stop()
	random_breathe = false

end

function unrequire(m)
  package.loaded[m] = nil
  _G[m] = nil
  require(m)
end

