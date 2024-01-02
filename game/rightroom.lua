rl_img = 1
local timer = 6
local maxTimer = 6
local light_timer = 2.5
local light_maxTimer = 2.5
local n = 1
local top = false
local bot = false
local convo = {
	"",
	"",
	"I just got home, mom",
	"H-how are you?",
	"",
	"",
	"M-mom? A-are you alright?",
	"D-did something happen?",
	"D-dad? H-he's resting",
	"I d-did not do anything!",
	"H-he's safe!",
	"M-mom? W-what are y-",
	"A-are you angry?",
	"Stop!",
	"Don't come any closer!",
	"",
	"S-stop!", --17th
	"W-why? Because of him",
	"you died, so why?!",
	"I'm going to shoot you!",
	"",
	"S-stop!", --22nd
	"", --23rd
	"",
	"S-sto-",
	"",
	""
}
local enemy_posX = 98
local en_anim = "mys"
local flip_once = false
local scream_once = false
local p_flip_once = false
local click_once = false
local shot_once = false
local a = 0


function rightroom_update(dt)
	lightning_flash = false

	function getRightRoom()
		return rl_img
	end

	if right_light_flag == true then
		light_etc(dt,rl,rl_img,CANVAS_RIGHT)
	end

	if player.x >= 23 then
		--event_route = him_convo
		if rr_event == 0 then
			rr_event = 1
			final_clock = seconds_to_clock(CLOCK)
			if event_route == him_convo then
				credit_set_ending("destroying home")
			elseif event_route == leave_convo then
				credit_set_ending("leaving home")
			elseif event_route == wait_convo then
				if ammo_available == true then
					credit_set_ending("saving home")
				else
					credit_set_ending("dying home")
				end
			end
		end
	end

	if event_route == him_convo or wait_convo then
		if rr_event == 1 then
			if rl_img < 3 then
				move = false
				if light_timer > 0 then
					 light_timer = light_timer - 1 * dt
					 if light_timer <= 0 then
					 	light_timer = light_maxTimer
					 	rl_img = rl_img + 1
					 	Sounds.fl_toggle:play()
					 	Sounds.fl_toggle:setLooping(false)
					 end
				end
			else
				rr_event = 2
				enemy_mys:flipH()
			end
		elseif rr_event == 2 then
			convo_update(dt)
			if n == 1 then
				enemy_posX = Lume.lerp(enemy_posX,98,0.1)
			elseif n == 5 then
				enemy_posX = Lume.lerp(enemy_posX,75,0.1)
			elseif n == 7 then
				enemy_posX = Lume.lerp(enemy_posX,62,0.1)
				if flip_once == false then
					enemy_idle:flipH()
					flip_once = true
				end
				
			elseif n == 13 then
				enemy_posX = Lume.lerp(enemy_posX,39,0.1)
			elseif n == 15 then
				--player shoot pose
				ending_animate = true
				ending_final = 0
				shoot_pose_animate = true
				if p_flip_once == false then
					p_flip_once = true
					shoot_pose_anim:flipH()
					enemy_dead:flipH()
				end
			elseif n == 17 then
				enemy_posX = Lume.lerp(enemy_posX,35,0.1)
			elseif n == 19 then
				enemy_posX = Lume.lerp(enemy_posX,33,0.1)
			elseif n == 21 then
				if ammo_available == true then
					if event_route == wait_convo then
						en_anim = "idle"
						if scream_once == false then
							Sounds.enemy_scream:play()
							Sounds.enemy_scream:setLooping(false)	
							scream_once = true	
						end
					end
				end
			elseif n-1 == 22 then
				if ammo_available == true then
					--player has gun with ammo
					if event_route == him_convo then	
						--player already used the ammo on him
						if click_once == false then
							click_once = true
							Sounds.gun_click:play()
							Sounds.gun_click:setLooping(false)
						end
					elseif event_route == wait_convo then
						--player chose wait
						--with bullet
						if shot_once == false then
							shot_once = true
							Sounds.gunshot:play()
							Sounds.gunshot:setVolume(1)
							Sounds.gunshot:setLooping(false)
							enemy_posX = enemy_posX + 10
						end
						--enemy dies animation
						en_anim = "dies"
					end
				else
					--player has picked a no ammo revolver
					if event_route == wait_convo then
						en_anim = "idle"
						if click_once == false then
							click_once = true
							Sounds.gun_click:play()
							Sounds.gun_click:setLooping(false)
						end
					end
				end
			elseif n == 25 then
				if ammo_available == true then
					if event_route == him_convo then
						if scream_once == false then
							Sounds.enemy_scream:play()
							Sounds.enemy_scream:setLooping(false)	
							scream_once = true	
						end
						enemy_posX = Lume.lerp(enemy_posX,player.x-10,0.1)
						ending_animate = true
						ending_final = -2

					elseif event_route == wait_convo then
						ending_animate = false
						shoot_pose_animate = false
					end
				else
					if event_route == wait_convo then
						if scream_once == false then
							Sounds.enemy_scream:play()
							Sounds.enemy_scream:setLooping(false)	
							scream_once = true	
						end
						enemy_posX = Lume.lerp(enemy_posX,player.x-10,0.1)
						ending_animate = true
						ending_final = -2
					end
				end
			end
		end
	end
	if fade_to_black == true then
		if a < 1 then
			a = Lume.lerp(a, 1,0.01)
			if a >= 200/255 then
				credits_load()
			end
		end
	end
	if credits_flag == true then
		credits_update(dt)
	end
end

function rightroom_draw()
	love.graphics.setColor(1, 1, 1, 1)
	if event_route == him_convo or wait_convo then
		if rr_event == 2 then
			convo_draw()
		end
	end
	if fade_to_black == true then
		love.graphics.setColor(0,0,0,a)
		love.graphics.rectangle("fill",0,16,128,32)
	end
	if credits_flag == true then
		credits_draw()
	end
end

function convo_update(dt)
	if n < #convo-2 then
		if timer > 0 then
			timer = timer - 1 * dt
			if timer > 4 and timer < 6 then
				top = true
			elseif timer > 0.1 and timer < 3.99 then
				bot = true
			elseif timer <= 0 then
				timer = maxTimer
				n = n+2
				top = false
				bot = false
			end
		end
	end
end

function convo_draw()
	--draw convo
	love.graphics.setColor(1, 1, 1, 1)
	if top == true then
		love.graphics.print(convo[n], WIDTH/2 - DEF_FONT:getWidth(convo[n])/2,DEF_FONT_HALF - 3)
	end
	if bot == true then
		love.graphics.print(convo[n+1], WIDTH/2 - DEF_FONT:getWidth(convo[n+1])/2,HEIGHT - DEF_FONT_HALF - 2)
	end
end

function enemy_update(dt)
	if en_anim == "mys" then
		enemy_mys:update(dt)
	elseif en_anim == "idle" then
		enemy_idle:update(dt)
	elseif en_anim == "dies" then
		enemy_dead:update(dt)
	end
end

function enemy_draw()
	if rr_event == 2 then
		love.graphics.setColor(1, 1, 1, 1)
		if en_anim == "mys" then
			enemy_mys:draw(Images.enemy_sheet,enemy_posX,30)
		elseif en_anim == "idle" then
			enemy_idle:draw(Images.enemy_sheet,enemy_posX,30)
		elseif en_anim == "dies" then
			enemy_dead:draw(Images.enemy_dead_sheet,enemy_posX,30)
		end
	end
end
