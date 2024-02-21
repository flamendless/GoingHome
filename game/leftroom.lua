convo = {
	 "",
	 "",
	 "Have I gotten any mercy?",
	 "What brings you here?",
	 "Family? You only got us!",
	 "We're your family!",
	 "Hahaha!",
	 "Are you insane?",
	 "You've killed her!",
	 "It's you that caused everthing!",
	 "You are one crazy son!",
	 "She was still alive!",
	 "Y-you've ended her misery!",
	 "Y-you took it, didn't you?",
	 "HAHAHAHA! ",
	 "You thought you could 'save'",
	"her with your foolishness!",
	"you thought you could repa--",
	"",
	"",

}

him_convo = {
	"Hahahaha!",
	"Now you're going to shoot me?",
	"You want no more guilt?",
	"That bullet was waiting",
	"there the whole time",
	"What took you so long?",
	"Can't take any more guilt?",
	"C'mon kid! Shoot me!",
	"Oh, are you looking for",
	"you're family? Shut up!",
	"What makes you think you",
	"c-could have one?",
	"You are in guilt of what",
	"happened to your mom!",
	"S-stop that foolish fantasy!",
	"Let me tell you a secret in",
	"case you forgot something",
	"Everytime you go here, you",
	"ask me 'Where's my family?'",
	"That hobby of yours started a",
	"year ago! HAHAHAHA!",
	"Karen and Anne?",
	"Margueritte and Zoe?",
	"Evaline and Chloe?",
	"OK OK, I'll stop the truth",
	"from purging you. HAHAHA!",
	"So, tell me, who's the new",
	"pair of made-up names now?",
	"",
	"",
}

local a = 0
local flash = false

wait_convo = {
	"",
	"",
	"What are you idling there?",
	"That bullet was waiting",
	"there the whole time",
	"C'mon kid! Shoot me!",
	"",
	"",
	"What are you waiting for?",
	"C'mon kid! Pull the trigger!",
	"She loves you more than me!",
	"I-it's you! Y-you killed her!",
	"If it was not for your stupidity",
	"She would not have fell",
	"I didn't mean to shove her...",
	"I was mad...",
	"B-but you-",
	"Because of you she fell!",
	"Now shoot me so I ",
	"could be with her!",
	"",
	"",
	"Are you listening to me!",
	"Stop thinking, start shooting!",
	"I aint going to forget",
	"What you did!",
	"P-please! Just shoot me!",
	"I want to live!",
	"I c-can't bear this!",
	"Leave me alone!",
	"",
	"...",
	"",
	""
}

local leave_scream = false
f_leave2_flag = false

leave_convo = {
	"What? Are you just going",
	"to leave me? HAHAHA!",
	"I thought you're looking",
	"for your family? ",
	"or did you forget them?",
	"Already? That was quick.",
	"What is it this time?",
	"S-stop! S-stop bugging me!",
	"I've told you his insane!",
	"S-stop! Leave me alone!",
	"",
	""
}
local flash = false

ending_options = {}

local c = 1
local timer = 6
local maxTimer = 6
local show_top = false
local show_bot = false
e_c = 1

ll_img = 1
_ev = 0
local wait_ev = 0



function left_room_update(dt)

	function getLeftRoom()
		return ll_img
	end

	if left_light_flag == true then
		light_etc(dt,LL,ll_img,CANVAS_LEFT)
	end
	----------------MAIN STUFFS--------------
	if lr_event == 1 then
		left_light_flag = true
		if AMMO_AVAILABLE == false then
			if broken_revolver == true then
				lr_event = 2
			end
		else
			if ammo_picked == true then
				lr_event = 2
			end
		end

	elseif lr_event == 2 then
		MOVE = false

		ll_img = 2
		_ev = 1

		if c < #convo - 2 then
			if timer > 0 then
				timer = timer - 1 * dt
				if timer > 4 and timer < 6 then
					show_top = true
				elseif timer > 0 and timer < 3.99 then
					show_bot = true
				elseif timer <= 0 then
					timer = maxTimer
					show_top = false
					show_bot = false
					c = c + 2
				end
			end
		else
			c = 1
			timer = maxTimer
			lr_event = 3
			-- sounds.fl_toggle:play()
			-- sounds.fl_toggle:setLooping(false)
			left_light_flag = true
		end
	elseif lr_event == 3 then

		if AMMO_AVAILABLE == true then
			--route 1
			ending_animate = true
			shoot_pose_animate = true
		else
			--route 2
			ending_animate = true
			leave_animate = true
		end


	elseif lr_event == 4 then

		_ev = 2

		if c < #event_route - 2 then
			if timer > 0 then
				timer = timer - 1 * dt
				if timer > 4 and timer < 6 then
					show_top = true
				elseif timer > 0 and timer < 2.99 then
					show_bot = true
				elseif timer <= 0 then
					timer = maxTimer
					show_top = false
					show_bot = false
					c = c + 2
				end
			end
			if event_route == leave_convo then
				if (event_route[c+1] == "S-stop! Leave me alone!") then
					ending_animate = false
				elseif event_route[c] == "" then
					f_leave2_flag = true
					lr_event = 5
					MOVE = true
				end
			elseif event_route == him_convo then
				if (event_route[c] == "") then
					random_breathe_flag = false
					timer = maxTimer
					f_shot_anim_flag = true
				end
			elseif event_route == wait_convo then
				if event_route[c-1] == 	"could be with her!" then
					ending_animate = true
					wait_animate = true
					shoot_pose_animate = false
				elseif event_route[c] == "Are you listening to me!" then
					ending_animate = true
					wait_animate = false
					leave_animate = true
					f_leave2_flag = true
				elseif event_route[c+1] == "..." then
					if leave_scream == false then
						SOUNDS.enemy_scream:play()
						SOUNDS.enemy_scream:setLooping(false)
						leave_scream = true
						ending_animate = false
						leave_animate = false
						lr_event = 5
					end
				end
			end
		end
	elseif lr_event == 5 then
		if event_route == leave_convo then
			basement_lock = false
			ending_leave = true
			ending_leave_event = 1
		elseif event_route == him_convo then
			basement_lock = false
			ending_shoot = true
			ending_shoot_event = 1

			if timer > 0 then
				timer = timer - 1 * dt
				if timer <= 0 then
					SOUNDS.enemy_scream:play()
					SOUNDS.enemy_scream:setLooping(false)
					lr_event = 6
					MOVE = true
					ending_animate = false

					--insert note
					local note_item = Interact(false,{"It's a note","It's written using blood","Read it?"},{"Yes","No"},"","note")
					table.insert(DIALOGUES,note_item)
					local note_dial = Items(IMAGES.note,IMAGES["leftRoom"],10,40,"note")
			  		table.insert(ITEMS_LIST,note_dial)
			  		random_breathe_flag = true
				end
			end
		elseif event_route == wait_convo then
			ending_wait = true
			MOVE = true
		end
	elseif lr_event == 6 then
		LIGHT_VALUE = 1
		left_light_flag = true
	end
end

function left_room_draw()

	if lr_event == 2 then

		love.graphics.setColor(100/255, 100/255, 100/255, 1)

		if show_top == true then
			love.graphics.print(convo[c],WIDTH/2 - DEF_FONT:getWidth(convo[c])/2, DEF_FONT_HALF - 3)
		end
		if show_bot == true then
			love.graphics.print(convo[c+1],WIDTH/2 - DEF_FONT:getWidth(convo[c+1])/2, HEIGHT - DEF_FONT_HEIGHT - 2)
		end

		love.graphics.setColor(1, 1, 1, 1)


	elseif lr_event == 3 then
		if e_c == 1 then
			love.graphics.setColor(1,0,0,1)
		else
			love.graphics.setColor(1, 1, 1, 1)
		end
		love.graphics.print(ending_options[1],DEF_FONT:getWidth(ending_options[1])/2 - 10,HEIGHT - DEF_FONT_HEIGHT - 2)
		if e_c == 2 then
			love.graphics.setColor(1, 0, 0, 1)
		else
			love.graphics.setColor(1, 1, 1, 1)
		end
		love.graphics.print(ending_options[2],WIDTH - DEF_FONT:getWidth(ending_options[2]) - 6,HEIGHT - DEF_FONT_HEIGHT - 2)

	--choices
	elseif lr_event == 4 then
		love.graphics.setColor(100/255, 100/255, 100/255, 1)
		if show_top == true then
			love.graphics.print(event_route[c],WIDTH/2 - DEF_FONT:getWidth(event_route[c])/2, DEF_FONT_HALF - 3)
		end
		if show_bot == true then
			love.graphics.print(event_route[c+1],WIDTH/2 - DEF_FONT:getWidth(event_route[c+1])/2, HEIGHT - DEF_FONT_HEIGHT - 2)
		end

	--ending sequences
	elseif lr_event == 5 then
		if event_route == him_convo then

		end
	elseif lr_event == 6 then

	end
end

function father_anim_update(dt)
	if _ev == 1 then
		f1_anim:update(dt)
	elseif _ev == 2 then
		if event_route == leave_convo then
			if f_leave2_flag == true then
				f_headbang:update(dt)
			else
				f_leave:update(dt)
			end
		elseif event_route == him_convo then
			if f_shot_anim_flag == true then
				if f_shot_anim2_flag == false then
					f_shot_anim:update(dt)
				else
					f_shot_anim2:update(dt)
				end
			else
				f1_anim:update(dt)
			end
		elseif event_route == wait_convo then
			if f_leave2_flag == true then
				f_headbang:update(dt)
			else
				f_leave:update(dt)
			end
		end
	end
end

function father_anim_draw()
	if _ev == 1 then
		f1_anim:draw(IMAGES.f1,8,25)
	elseif _ev == 2 then
		if event_route == leave_convo then
			if f_leave2_flag == true then
				f_headbang:draw(IMAGES.f_leave,8,25)
			else
				f_leave:draw(IMAGES.f_leave,8,25)
			end
		elseif event_route == him_convo then
			if f_shot_anim_flag == true then
				if f_shot_anim2_flag == false then
					f_shot_anim:draw(IMAGES.f_shot_sheet,8,25)
				else
					f_shot_anim2:draw(IMAGES.f_shot_sheet,8,25)
				end
			else
				f1_anim:draw(IMAGES.f1,8,25)
			end
		elseif event_route == wait_convo then
			if f_leave2_flag == true then
				f_headbang:draw(IMAGES.f_leave,8,25)
			else
				f_leave:draw(IMAGES.f_leave,8,25)
			end
		end
	end
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(IMAGES.jail,0,16)
end



