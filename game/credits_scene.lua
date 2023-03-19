local timer = 2
local maxTimer = 2
local minTimer = 1
local n = 1
local timer_to_use = maxTimer
local _vol = 0.25 --ts_theme starting volume
local start = 30
local last = 72




function credits_load()
	sounds.ts_theme:play()
	sounds.ts_theme:setLooping(true)
	credits_flag = true
	random_breathe_flag = false

 	--check previous endings achieved
	--if debug == false then
		--if love.filesystem.exists("save.lua") then
			--for line in love.filesystem.lines("save.lua") do
				--if credits ~= line then
					--love.filesystem.append("save.lua",credits .. "\n")
					--if credits == line then
						--break
					--end
				--end
			--end
		--end
	--end

	credits_txt = {
		"",
		"",
		"Ending: " .. credits,
		"Total Play time: ",
		tostring(final_clock),
		"",

		"'Going Home: Revisited'",
		"a game by:",
		"flamendless",

		"Programmer:",
		"Brandon Blanker Lim-it",

		"Arts:",
		"Conrad Reyes",

		"Tester:",
		"Ian Plaus",

		"Dedicated to:",
		"Hannah Daniella Tamayo",

		"",
		"Special Thanks to",
		"LOVE community",
		"Open-source community",
		"",
		"",
		"Going Home: Revisited",
		"flamendless",
		"Thank you for playing",
		""
	}
end



function credits_update(dt)
	if n < #credits_txt then
		if timer > 0 then
			timer = timer - 1 * dt
			if timer <= 0 then
				timer = timer_to_use
				n = n + 1
			end
		end
	elseif n >= #credits_txt then
		local ts = sounds.ts_theme

		if ts:isPlaying() == true then
			if _vol > 0 then
				_vol = _vol - 0.05 * dt
				if _vol <= 0 then
					love.event.quit("restart")
				end
			end
			ts:setVolume(_vol)
		end
	end
end

function credits_draw()
	love.graphics.setColor(1, 1, 1, 1)
	local t = credits_txt[n]
	local tw = font:getWidth(credits_txt[n])
	local th = font:getHeight(credits_txt[n])

	if n < 18 then
		love.graphics.print(t,width/2 - tw/2, height/2 - th/2)
	elseif n >= 18 and n <= 23 then
		timer_to_use = minTimer
		local s = 18
		for i = 1,5 do
			love.graphics.print(credits_txt[s+i],width/2 - font:getWidth(credits_txt[s+i])/2,10*i - font:getHeight(credits_txt[s+i])/2)
		end
	elseif n >= 24 and n < 29 then
		timer_to_use = maxTimer
		love.graphics.print(t,width/2 - tw/2, height/2 - th/2)
	
	--start
	-- elseif n >= 30 and n < 34 then
	-- 	timer_to_use = minTimer
	-- 	dynamic_print(29)
	-- elseif n >= 35 and n < 39 then
	-- 	dynamic_print(34)
	-- elseif n >= 40 and n < 44 then
	-- 	dynamic_print(39)
	-- elseif n >= 45 and n < 49 then
	-- 	dynamic_print(44)
	-- elseif n >= 50 and n < 54 then
	-- 	dynamic_print(49)
	-- elseif n >= 55 and n < 59 then
	-- 	dynamic_print(54)
	-- elseif n >= 60 and n < 64 then
	-- 	dynamic_print(59)
	-- elseif n >= 65 and n < 69 then
	-- 	dynamic_print(64)
	-- elseif n >= 70 and n < 72 then
	-- 	dynamic_print(69)
	-- elseif n >= 72 then
	-- 	love.graphics.print(t,width/2 - tw/2, height/2 - th/2)
	-- 	timer_to_use = maxTimer
	-- end
	elseif n >= start and n < (start+5-1) then
		timer_to_use = minTimer
		dynamic_print(29)
	elseif n >= start + 5 and n < (start-1) + 10 then
		dynamic_print(34)
	elseif n >= start + 10 and n < (start-1) + 15 then
		dynamic_print(39)
	elseif n >= start + 15 and n < (start-1) + 20 then
		dynamic_print(44)
	elseif n >= start + 20 and n < (start-1) + 25 then
		dynamic_print(49)
	elseif n >= start + 25 and n < (start-1) + 30 then
		dynamic_print(54)
	elseif n >= start + 30 and n < (start-1) + 35 then
		dynamic_print(59)
	elseif n >= start + 35 and n < (start-1) + 40 then
		dynamic_print(64)
	elseif n >= start + 40 and n < last then
		dynamic_print(69)
	elseif n >= last then
		love.graphics.print(t,width/2 - tw/2, height/2 - th/2)
		timer_to_use = maxTimer
	end
end

function dynamic_print(s)
	local s = s
	for i = 1, 5 do
		love.graphics.print(credits_txt[s + i], width/2 - font:getWidth(credits_txt[s + i])/2,10*i - font:getHeight(credits_txt[s+i])/2)
	end
end
