local talk_count = 1
local shout_count = 1
local done = false
local shout_again = false
local stop_walk = false
mother_gone = false

father_animation_count = 1
father_x = 12
father_speed = 15

mother_animation_count = 1
mother_x = 20
mother_speed = 15


function animation_set()
	local state = gamestates.getState()
	if state == "splash" then
		local splash = anim8.newGrid(64,32,images.splash:getDimensions())
		splash_anim = anim8.newAnimation(splash('1-5',1),0.25, function()
			splash_anim:pauseAtEnd()
			--states = "title"
			splash_finished = true
		end)
	elseif state == "intro" or state == "rain_intro" then
		--moving car
		local _car = anim8.newGrid(32,48,images.car_moving:getWidth(),images.car_moving:getHeight())
		car_anim = anim8.newAnimation(_car('1-17',1),0.1,"pauseAtEnd")
		local _skip = anim8.newGrid(8, 8, images.skip:getDimensions())
		skip_button = anim8.newAnimation(_skip("1-1",1),0.1)
	elseif state == "main" then
		--window left
		local wl = anim8.newGrid(128,32,images.window_left:getWidth(),images.window_left:getHeight())
		win_left_anim = anim8.newAnimation(wl('1-6',1),0.1, function()
			win_left_anim:gotoFrame(4)
			Timer.after(3, function() win_left_anim:pauseAtStart() win_move_l = false end)
		end)
		--window right
		local wr = anim8.newGrid(128,32,images.window_right:getWidth(),images.window_right:getHeight())
		win_right_anim = anim8.newAnimation(wr('1-5',1),0.1, function()
			win_right_anim:gotoFrame(3)
			Timer.after(2,function() win_right_anim:pauseAtStart() win_move_r = false end)

		end)

		local g = anim8.newGrid(8,16, images.player_sheet:getWidth(), images.player_sheet:getHeight())
		idle = anim8.newAnimation(g('1-2',1),1)
		walk_right = anim8.newAnimation(g('3-6',1), 0.25)
		walk_left = anim8.newAnimation(g('3-6',1), 0.25):flipH()

		local _fs = anim8.newGrid(11,18,images.f_shot_sheet:getWidth(),images.f_shot_sheet:getHeight())
		f_shot_anim = anim8.newAnimation(_fs('1-5',1),0.2,function()
				f_shot_anim:pauseAtEnd()
				f_shot_anim2_flag = true
				sounds.gunshot:play()
				sounds.gunshot:setLooping(false)
			end)
		f_shot_anim2 = anim8.newAnimation(_fs('6-15',1),0.1, function()
				f_shot_anim2:pauseAtEnd()
				lr_event = 5
			end)

		--leave sequence
		local _fleave = anim8.newGrid(11,18,images.f_leave:getWidth(),images.f_leave:getHeight())
		f_leave = anim8.newAnimation(_fleave('1-45',1),0.5,function()
				f_leave:pauseAtEnd()
			end)
		f_headbang = anim8.newAnimation(_fleave('39-45',1),0.5,function()
				sounds.smash_head:play()
				sounds.smash_head:setLooping(false)
			end)


		local _pk = anim8.newGrid(8,16,images.player_killed_sheet:getWidth(),images.player_killed_sheet:getHeight())
		player_killed = anim8.newAnimation(_pk('1-14',1),0.2, function()
				player_killed:pauseAtEnd()
				en_anim = "mys"
				fade_to_black = true
			end)


		local _pp = anim8.newGrid(8,16,images.player_panic_sheet:getWidth(),images.player_panic_sheet:getHeight())
		player_panic = anim8.newAnimation(_pp('1-8',1),1,function()
				player_panic:pauseAtEnd()
				player_ending_shot = true
			end)

		local _shoot_pose = anim8.newGrid(8,16, images.shoot_pose_sheet:getWidth(),
			images.shoot_pose_sheet:getHeight())
		shoot_pose_anim = anim8.newAnimation(_shoot_pose('1-3',1),0.3, "pauseAtEnd")

		local _reload = anim8.newGrid(8,16, images.reload_sheet:getWidth(),images.reload_sheet:getHeight())
		reload_anim = anim8.newAnimation(_reload('1-4',1),0.3,function()
				reload_anim:pauseAtStart()
				reload_animate = false
				ending_animate = false
			end)

		local _leave = anim8.newGrid(8,16,images.leave_sheet:getWidth(),images.leave_sheet:getHeight())
		leave_anim = anim8.newAnimation(_leave('1-4',1),0.3, function()
				leave_anim:pauseAtEnd()
			end)
		wait_anim = anim8.newAnimation(_shoot_pose('3-1',1),0.3,function()
				wait_anim:pauseAtEnd()
			end)

		--father
		local _f = anim8.newGrid(11,18,images.father_sheet:getWidth(),images.father_sheet:getHeight())
		father_anim = {
			--talk
			anim8.newAnimation(_f('1-2',1),0.5, function()
				if done == true then
					father_anim[1]:pauseAtStart()
				end
				if talk_count < 4 then
					talk_count = talk_count + 1
				else
					father_anim[1]:pauseAtStart()
					father_animation_count = father_animation_count + 1
				end
			end),

			-- shout
			anim8.newAnimation(_f('3-4',1),0.5, function()
				if father_move == true then
					father_anim[2]:pauseAtStart()
					father_animation_count = father_animation_count + 1
				end
				if shout == true then
					father_anim[2]:pauseAtEnd()
					father_animation_count = 4
					mother_animation_count = 4
				end
			end),

		--walk
			anim8.newAnimation(_f('5-8',1),0.15, function()
				if father_x >= 55 then
					father_x = 60
					shout_again = false
					father_move = false
					father_anim[3]:pauseAtStart()
					father_animation_count = 2
					father_anim[2]:resume()
					shout = true
				end
			end),

			--push
			anim8.newAnimation(_f('9-14',1),0.25, function()
				sounds.mother_scream:play()
				sounds.mother_scream:setLooping(false)
				done = true
				father_animation_count = 1
			end)
		}

		--mother
		local _m = anim8.newGrid(11,17,images.mother_sheet:getWidth(),images.mother_sheet:getHeight())
		mother_anim = {
			--talk
			anim8.newAnimation(_m('1-2',1),0.5, function()
				if talk_count < 2 then
					talk_count = talk_count + 1
				else
					mother_anim[1]:pauseAtStart()
					mother_animation_count = mother_animation_count + 1
				end
			end),

			--shout
			anim8.newAnimation(_m('3-4',1),0.5, function()
				if shout_again == false then
					if stop_walk == false then
						if shout_count < 2 then
							shout_count = shout_count + 1
						else
							mother_anim[2]:pauseAtStart()
							mother_animation_count = father_animation_count + 1
							mother_move = true
						end
					end
				end
			end),

			--walk
			anim8.newAnimation(_m('5-8',1),0.15, function()
				if mother_x >= 65 then
					mother_move = false
					mother_animation_count = 2
					mother_anim[2]:resume()
					stop_walk = true
					shout_again = true
					mother_anim[3]:pauseAtStart()
				elseif mother_x >= 50 then
					father_move = true
				end
			end),

			--fall
			anim8.newAnimation(_m('9-14',1),0.25, function()
				mother_gone = true
			end),
		}


		--child
		local _child = anim8.newGrid(8,16,images.player_child_sheet:getWidth(),images.player_child_sheet:getHeight())
		child = anim8.newAnimation(_child('1-4',1),0.05)

		--player child pushing chair
		local _push = anim8.newGrid(8,16,images.player_child_push:getWidth(),images.player_child_push:getHeight())
		player_push = anim8.newAnimation(_push('1-4',1),0.25)


		--enemy
		local en = anim8.newGrid(12,14,images.enemy_sheet:getWidth(),images.enemy_sheet:getHeight())
		enemy_idle = anim8.newAnimation(en('4-5',1),1)
		enemy_mys = anim8.newAnimation(en('1-3',1),1)
		enemy_move = anim8.newAnimation(en('6-7',1),0.5)

		local _ed = anim8.newGrid(12,14,images.enemy_dead_sheet:getWidth(),images.enemy_dead_sheet:getHeight())
		enemy_dead = anim8.newAnimation(_ed('1-8',1),0.1,function()
				enemy_dead:pauseAtEnd()
				fade_to_black = true
			end)


		--player door
		local _pd = anim8.newGrid(16,24,images.player_door:getWidth(),images.player_door:getHeight())
		pd_anim = anim8.newAnimation(_pd('1-14',1),0.1,function()
		pd_anim:pauseAtEnd()
		end)

		--in house
		local _ih = anim8.newGrid(128,32,images.in_house:getWidth(),images.in_house:getHeight())
		ih_anim = anim8.newAnimation(_ih('1-10',1),0.1,"pauseAtEnd")

		--tv
		local _tv = anim8.newGrid(8,17,images.tv_anim:getWidth(),images.tv_anim:getHeight())
		tv_anim = anim8.newAnimation(_tv('1-5',1),0.1,false)

		--corpse
		local _corpse = anim8.newGrid(17,24,images.corpse_anim:getWidth(),images.corpse_anim:getHeight())
		corpse_fall_anim = anim8.newAnimation(_corpse('1-13',1),0.075, function()
			sounds.body_fall:play()
			sounds.body_fall:setLooping(false)
			corpse_fall_anim:pauseAtEnd()
			corpse_trigger = false
			local corpse = Items(images.corpse,images["secretRoom"],90,40,"corpse")
			table.insert(obj,corpse)

			local corpse_dial = Interact(false,{"A corpse!?","What?!...","Why is there a corpse here!?...","Touch it?"},{"Yes","No"},"It's not responding","corpse")
			table.insert(dialogue,corpse_dial)
		end)

		--clock
		local _clock = anim8.newGrid(12,22,images.clock_anim:getWidth(),images.clock_anim:getHeight())
		attic_clock_anim = anim8.newAnimation(_clock('1-9',1),1)
		--sit to stand
		local _f1 = anim8.newGrid(11,18,images.f1:getWidth(),images.f1:getHeight())
		f1_anim = anim8.newAnimation(_f1('1-12',1),0.5,"pauseAtEnd")
	end
 end

function epic_scene_update(dt)
	mother_anim[mother_animation_count]:update(dt)
	father_anim[father_animation_count]:update(dt)
	if father_move == true then
		father_x = father_x + father_speed * dt
	end
	if mother_move == true then
		mother_x = mother_x + mother_speed * dt
	end
end

function epic_scene_draw()
	love.graphics.setColor(1, 1, 1, 1)
	if mother_gone == false then
		if OS == "Android" then
			android.lightChange(true)
		end
		mother_anim[mother_animation_count]:draw(images.mother_sheet,mother_x,27)
	else
		if OS == "Android" then
			android.lightChange(false)
		end
		player.visible = true
		player.x = 14
		player.y = 27
		parent_found = true
		fade.state = true
		currentRoom = images["secretRoom"]
	end
	father_anim[father_animation_count]:draw(images.father_sheet,father_x,26)
end
