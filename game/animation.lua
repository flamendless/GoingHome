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
	if state == "adshow" or state == "splash" then
		local splash = Anim8.newGrid(64, 32, IMAGES.splash:getDimensions())
		splash_anim = Anim8.newAnimation(splash("1-5", 1), 0.25, function()
			splash_anim:pauseAtEnd()
			--states = "title"
			SPLASH_FINISHED = true
		end)
	elseif state == "intro" or state == "rain_intro" then
		--moving car
		local _car = Anim8.newGrid(32, 48, IMAGES.car_moving:getDimensions())
		car_anim = Anim8.newAnimation(_car("1-17", 1), 0.1, function()
			car_anim:pauseAtEnd()
			intro_next()
		end)
		local _skip = Anim8.newGrid(8, 8, IMAGES.skip:getDimensions())
		skip_button = Anim8.newAnimation(_skip("1-1", 1), 0.1)

		--player door
		local _pd = Anim8.newGrid(16, 24, IMAGES.player_door:getDimensions())
		pd_anim = Anim8.newAnimation(_pd("1-14", 1), 0.1, "pauseAtEnd")
		--in house
		local _ih = Anim8.newGrid(128, 32, IMAGES.in_house:getDimensions())
		ih_anim = Anim8.newAnimation(_ih("1-10", 1), 0.1, "pauseAtEnd")
	elseif state == "main" then
		--window left
		local curtain_dur = 0.3
		local wl = Anim8.newGrid(128, 32, IMAGES.window_left:getDimensions())
		win_left_anim = Anim8.newAnimation(wl("1-6", 1), curtain_dur, function()
			win_left_anim:gotoFrame(4)
			Timer.after(3, function()
				win_left_anim:pauseAtStart()
				WIN_MOVE_L = false
			end)
		end)
		--window right
		local wr = Anim8.newGrid(128, 32, IMAGES.window_right:getDimensions())
		win_right_anim = Anim8.newAnimation(wr("1-5", 1), curtain_dur, function()
			win_right_anim:gotoFrame(3)
			Timer.after(2, function()
				win_right_anim:pauseAtStart()
				WIN_MOVE_R = false
			end)
		end)

		local g = Anim8.newGrid(8, 16, IMAGES.player_sheet:getDimensions())
		idle = Anim8.newAnimation(g("1-2", 1), 1)
		walk_right = Anim8.newAnimation(g("3-6", 1), 0.25)
		walk_left = Anim8.newAnimation(g("3-6", 1), 0.25):flipH()

		local _fs = Anim8.newGrid(11, 18, IMAGES.f_shot_sheet:getDimensions())
		f_shot_anim = Anim8.newAnimation(_fs("1-5", 1), 0.2, function()
			f_shot_anim:pauseAtEnd()
			f_shot_anim2_flag = true
			SOUNDS.gunshot:play()
			SOUNDS.gunshot:setLooping(false)
		end)
		f_shot_anim2 = Anim8.newAnimation(_fs("6-15", 1), 0.1, function()
			f_shot_anim2:pauseAtEnd()
			lr_event = 5
		end)

		--leave sequence
		local _fleave = Anim8.newGrid(11, 18, IMAGES.f_leave:getDimensions())
		f_leave = Anim8.newAnimation(_fleave("1-45", 1), 0.5, function()
			f_leave:pauseAtEnd()
		end)
		f_headbang = Anim8.newAnimation(_fleave("39-45", 1), 0.5, function()
			SOUNDS.smash_head:play()
			SOUNDS.smash_head:setLooping(false)
		end)


		local _pk = Anim8.newGrid(8, 16, IMAGES.player_killed_sheet:getDimensions())
		player_killed = Anim8.newAnimation(_pk("1-14", 1), 0.2, function()
			player_killed:pauseAtEnd()
			en_anim = "mys"
			fade_to_black = true
		end)


		local _pp = Anim8.newGrid(8, 16, IMAGES.player_panic_sheet:getDimensions())
		player_panic = Anim8.newAnimation(_pp("1-8", 1), 1, function()
			player_panic:pauseAtEnd()
			player_ending_shot = true
		end)

		local _shoot_pose = Anim8.newGrid(8, 16, IMAGES.shoot_pose_sheet:getDimensions())
		shoot_pose_anim = Anim8.newAnimation(_shoot_pose("1-3", 1), 0.3, "pauseAtEnd")

		local _reload = Anim8.newGrid(8, 16, IMAGES.reload_sheet:getDimensions())
		reload_anim = Anim8.newAnimation(_reload("1-4", 1), 0.3, function()
			reload_anim:pauseAtStart()
			reload_animate = false
			ENDING_ANIMATE = false
		end)

		local _leave = Anim8.newGrid(8, 16, IMAGES.leave_sheet:getDimensions())
		leave_anim = Anim8.newAnimation(_leave("1-4", 1), 0.3, function()
			leave_anim:pauseAtEnd()
		end)
		wait_anim = Anim8.newAnimation(_shoot_pose("3-1", 1), 0.3, function()
			wait_anim:pauseAtEnd()
		end)

		--father
		local _f = Anim8.newGrid(11, 18, IMAGES.father_sheet:getDimensions())
		father_anim = {
			--talk
			Anim8.newAnimation(_f("1-2", 1), 0.5, function()
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
			Anim8.newAnimation(_f("3-4", 1), 0.5, function()
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
			Anim8.newAnimation(_f("5-8", 1), 0.15, function()
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
			Anim8.newAnimation(_f("9-14", 1), 0.25, function()
				SOUNDS.mother_scream:play()
				SOUNDS.mother_scream:setLooping(false)
				done = true
				father_animation_count = 1
			end)
		}

		--mother
		local _m = Anim8.newGrid(11, 17, IMAGES.mother_sheet:getDimensions())
		mother_anim = {
			--talk
			Anim8.newAnimation(_m("1-2", 1), 0.5, function()
				if talk_count < 2 then
					talk_count = talk_count + 1
				else
					mother_anim[1]:pauseAtStart()
					mother_animation_count = mother_animation_count + 1
				end
			end),

			--shout
			Anim8.newAnimation(_m("3-4", 1), 0.5, function()
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
			Anim8.newAnimation(_m("5-8", 1), 0.15, function()
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
			Anim8.newAnimation(_m("9-14", 1), 0.25, function()
				mother_gone = true
			end),
		}


		--child
		local _child = Anim8.newGrid(8, 16, IMAGES.player_child_sheet:getDimensions())
		child = Anim8.newAnimation(_child("1-4", 1), 0.05)

		--player child pushing chair
		local _push = Anim8.newGrid(8, 16, IMAGES.player_child_push:getDimensions())
		player_push = Anim8.newAnimation(_push("1-4", 1), 0.25)

		--enemy
		local en = Anim8.newGrid(12, 14, IMAGES.enemy_sheet:getDimensions())
		enemy_idle = Anim8.newAnimation(en("4-5", 1), 1)
		enemy_mys = Anim8.newAnimation(en("1-3", 1), 1)
		enemy_move = Anim8.newAnimation(en("6-7", 1), 0.5)

		local _ed = Anim8.newGrid(12, 14, IMAGES.enemy_dead_sheet:getDimensions())
		enemy_dead = Anim8.newAnimation(_ed("1-8", 1), 0.1, function()
			enemy_dead:pauseAtEnd()
			fade_to_black = true
		end)

		--tv
		local _tv = Anim8.newGrid(8, 17, IMAGES.tv_anim:getDimensions())
		tv_anim = Anim8.newAnimation(_tv("1-5", 1), 0.1, false)

		--corpse
		local _corpse = Anim8.newGrid(17, 24, IMAGES.corpse_anim:getDimensions())
		corpse_fall_anim = Anim8.newAnimation(_corpse("1-13", 1), 0.075, function()
			SOUNDS.body_fall:play()
			SOUNDS.body_fall:setLooping(false)
			corpse_fall_anim:pauseAtEnd()
			CORPSE_TRIGGER = false

			for i = #ITEMS_LIST, 1, -1 do
				if ITEMS_LIST[i].tag == "corpse" then
					table.remove(ITEMS_LIST, i)
				end
			end
			for i = #DIALOGUES, 1, -1 do
				if DIALOGUES[i].tag == "corpse" then
					table.remove(DIALOGUES, i)
				end
			end

			local corpse = Items(IMAGES.corpse, IMAGES["secretRoom"], 90, 40, "corpse")
			table.insert(ITEMS_LIST, corpse)

			local corpse_dial = Interact(
				false,
				{ "A corpse!?", "What?!...", "Why is there a corpse here!?...", "Touch it?" },
				{ "Yes", "No" },
				"It's not responding",
				"corpse"
			)
			table.insert(DIALOGUES, corpse_dial)
		end)

		--clock
		local _clock = Anim8.newGrid(12, 22, IMAGES.clock_anim:getDimensions())
		attic_clock_anim = Anim8.newAnimation(_clock("1-9", 1), 1)
		--sit to stand
		local _f1 = Anim8.newGrid(11, 18, IMAGES.f1:getDimensions())
		f1_anim = Anim8.newAnimation(_f1("1-12", 1), 0.5, "pauseAtEnd")
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
		if ON_MOBILE then
			Android.lightChange(true)
		end
		mother_anim[mother_animation_count]:draw(IMAGES.mother_sheet, mother_x, 27)
	else
		if ON_MOBILE then
			Android.lightChange(false)
		end
		PLAYER.visible = true
		PLAYER.x = 14
		PLAYER.y = 27
		parent_found = true
		FADE_OBJ.state = true
		currentRoom = IMAGES["secretRoom"]
	end
	father_anim[father_animation_count]:draw(IMAGES.father_sheet, father_x, 26)
end
