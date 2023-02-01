pic_number = 1

local a = 1
local rx = 128/2 + 22
local lx = 128/2 - 22



function validate_input()
	if user_input == correct then
		--correct
		sounds.vault_unlock:play()
		sounds.vault_unlock:setLooping(false)
		user_input = ""
		final_puzzle_solved = true
		storage_puzzle = false
		word_puzzle = false
		move = true
		if love.system.getOS() == "Android" or love.system.getOS() == "iOS" or  debug == true then
			android.lightChange(false)
		end
	else
		--wrong
		sounds.wrong_input:play()
		sounds.wrong_input:setLooping(false)
		user_input = ""
		if love.system.getOS() == "Android" or love.system.getOS() == "iOS" or debug == true then
			love.keyboard.setTextInput(false)
		end
	end
end



function storage_puzzle_update(dt) 
	--main update
	if final_puzzle_solved == false then
		if word_puzzle == true then
			if string.len(user_input) == string.len(correct) or love.keyboard.isDown("return") then
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

		if rx >= width/2 + 22 and rx <= width/2 + 24 then
			rx = rx + 5 * dt
		else
			rx = width/2 + 22
		end

		if lx <= width/2 - 22 and lx >= width/2 - 24 then
			lx = lx - 5 * dt
		else
			lx = width/2 - 22
		end
	end
end

function storage_puzzle_draw() 
	if doodle_flag == true then
		if pic_number > 0 and pic_number < #puzzle_pics then
			love.graphics.setColor(1, 1, 1, a)
			love.graphics.draw(images.arrow,rx, height/2 - images.arrow:getHeight()/2 + 12  ,0,0.25,0.25)
		end
		if pic_number <= #puzzle_pics and pic_number > 1 then
			love.graphics.setColor(1, 1, 1, a)
			love.graphics.draw(images.arrow,lx, height/2 - images.arrow:getHeight()/2 + 12 ,0,-0.25,0.25)
		end

		--main draw
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(puzzle_pics[pic_number],width/2,height/2,0,1.25,1.25,16.5,12)
	end
	if word_puzzle == true then
		love.graphics.setColor(1, 1, 1, 1)		
		love.graphics.draw(images.input_base,width/2 - images.input_base:getWidth()/2,height/2 - images.input_base:getHeight()/2)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.print(user_input,28,height/2 - 10)
	end	
end
