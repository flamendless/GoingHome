local game_over = {}

local timer = 10
local timer_starts = false
local splash = false
local message = false

local go_text = "The Fear Caught Up With You"

function game_over.load()
	timer_starts = true
	SOUNDS.main_theme:stop()
	SOUNDS.rain:stop()
	SOUNDS.thunder:stop()
	SOUNDS.enemy_scream:play()
	LIGHT_ON = false
	PLAYER.dead = true
end

function game_over.update(dt)
	ENEMY_EXISTS = false
	game_over.init(dt)

	if timer_starts == true then
		if timer > -4 then
			timer = timer - 1 * dt
		elseif timer <= -4 then
			game_over.exit()
		end
	end

	local lw, lh = IMAGES.light:getDimensions()
	LIGHTX = PLAYER.x - lw + 4
	LIGHTY =  PLAYER.y - lh + 4

	if timer >= 8 and timer <= 9 then
		PLAYER.img = IMAGES.player_idle
		LIGHT_ON = true

	end
	if timer >= 7 and timer <= 8 then
		LIGHT_ON = false
	end
	--
	if timer >= 6 and timer <= 7 then
		PLAYER.img = IMAGES.player_red_eyes
		LIGHT_ON = true
	end
	if timer >= 5 and timer <= 6 then
		LIGHT_ON = false
	end
	--
	if timer >= 3 and timer <= 4 then
		PLAYER.img = IMAGES.player_eyes_bleed
		LIGHT_ON = true
	end
	if timer >= 2 and timer <= 3 then
		LIGHT_ON = false
	end
	--
	if timer >= 1 and timer <= 1.2 then
		PLAYER.img = IMAGES.player_dead
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
	SOUNDS.rain:stop()
	SOUNDS.main_theme:stop()
	GAMEOVER = false
	SaveData.save()
	if PRO_VERSION == false then
		if ON_MOBILE then
			ShowRewardedAds(true, function(reward_type, reward_qty)
				print("rewardUserWithReward callback", reward_type, reward_qty)
				gamestates.nextState("title")
				RESET_STATES()
			end)
		else
			gamestates.nextState("title")
			RESET_STATES()
		end
	else
		gamestates.nextState("title")
		RESET_STATES()
	end
end

function game_over.init(dt)
	local vol = SOUNDS.rain:getVolume()
	if vol > 0 then
		vol = vol - 0.025 * dt
		SOUNDS.rain:setVolume(vol)
		SOUNDS.main_theme:setVolume(vol)
	elseif vol <= 0 then
		SOUNDS.rain:stop()
		SOUNDS.main_theme:stop()
	end

	SOUNDS.thunder:stop()
	RANDOM_BREATHE = false
end

return game_over
