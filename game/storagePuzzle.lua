pic_number = 1

local a = 1
local rx = 128/2 + 22
local lx = 128/2 - 22



function validate_input()
	if string.lower(USER_INPUT) == string.lower(CORRECT) then
		--correct
		Sounds.vault_unlock:play()
		Sounds.vault_unlock:setLooping(false)
		USER_INPUT = ""
		final_puzzle_solved = true
		storage_puzzle = false
		word_puzzle = false
		move = true
		if ON_MOBILE or debug then
			Android.lightChange(false)
		end
	else
		--wrong
		Sounds.wrong_input:play()
		Sounds.wrong_input:setLooping(false)
		USER_INPUT = ""
		if OS == "Android" or OS == "iOS" or debug == true then
			love.keyboard.setTextInput(false)
		end
	end
end



function storage_puzzle_update(dt)
	--main update
	if final_puzzle_solved == false then
		if word_puzzle == true then
			if (string.len(USER_INPUT) == string.len(CORRECT)) or love.keyboard.isDown("return") then
				validate_input()
			end
		end
	end
	if doodle_flag == true then
		if a >= 0 then
			a = a - 1 * dt
		elseif a <= 0 then
			a = 1
		end

		if rx >= WIDTH/2 + 22 and rx <= WIDTH/2 + 24 then
			rx = rx + 5 * dt
		else
			rx = WIDTH/2 + 22
		end

		if lx <= WIDTH/2 - 22 and lx >= WIDTH/2 - 24 then
			lx = lx - 5 * dt
		else
			lx = WIDTH/2 - 22
		end
	end
end

function storage_puzzle_draw()
	if doodle_flag == true then
		if pic_number > 0 and pic_number < #puzzle_pics then
			love.graphics.setColor(1, 1, 1, a)
			love.graphics.draw(Images.arrow,rx, HEIGHT_HALF - Images.arrow:getHeight()/2 + 12  ,0,0.25,0.25)
		end
		if pic_number <= #puzzle_pics and pic_number > 1 then
			love.graphics.setColor(1, 1, 1, a)
			love.graphics.draw(Images.arrow,lx, HEIGHT_HALF - Images.arrow:getHeight()/2 + 12 ,0,-0.25,0.25)
		end

		--main draw
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(puzzle_pics[pic_number],WIDTH/2,HEIGHT_HALF,0,1.25,1.25,16.5,12)
	end
	if word_puzzle == true then
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(Images.input_base,WIDTH/2 - Images.input_base:getWidth()/2,HEIGHT_HALF - Images.input_base:getHeight()/2)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.print(USER_INPUT,28,HEIGHT_HALF - 10)
	end
end
