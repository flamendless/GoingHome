local ClockPuzzle = {
	state = false,
	hour = 1,
	minute = 1,
	second = 1,
	ampm = "am",
	selected = "hour",
	solved = false,
}

function ClockPuzzle.ev_up()
	if ClockPuzzle.selected == "hour" then
		if ClockPuzzle.hour < 12 then
			ClockPuzzle.hour = ClockPuzzle.hour + 1
		else
			ClockPuzzle.hour = 1
		end
	elseif ClockPuzzle.selected == "minute" then
		if ClockPuzzle.minute < 60 then
			ClockPuzzle.minute = ClockPuzzle.minute + 1
		else
			ClockPuzzle.minute = 1
		end
	elseif ClockPuzzle.selected == "second" then
		if ClockPuzzle.second < 60 then
			ClockPuzzle.second = ClockPuzzle.second + 1
		else
			ClockPuzzle.second = 1
		end
	elseif ClockPuzzle.selected == "ampm" then
		if ClockPuzzle.ampm == "am" then
			ClockPuzzle.ampm = "pm"
		else
			ClockPuzzle.ampm = "am"
		end
	end
end

function ClockPuzzle.ev_down()
	if ClockPuzzle.selected == "hour" then
		if ClockPuzzle.hour > 1 then
			ClockPuzzle.hour = ClockPuzzle.hour - 1
		else
			ClockPuzzle.hour = 12
		end
	elseif ClockPuzzle.selected == "minute" then
		if ClockPuzzle.minute > 1 then
			ClockPuzzle.minute = ClockPuzzle.minute - 1
		else
			ClockPuzzle.minute = 60
		end
	elseif ClockPuzzle.selected == "second" then
		if ClockPuzzle.second > 1 then
			ClockPuzzle.second = ClockPuzzle.second - 1
		else
			ClockPuzzle.second = 60
		end
	elseif ClockPuzzle.selected == "ampm" then
		if ClockPuzzle.ampm == "am" then
			ClockPuzzle.ampm = "pm"
		else
			ClockPuzzle.ampm = "am"
		end
	end
end

function ClockPuzzle.ev_left()
	if ClockPuzzle.selected == "minute" then
		ClockPuzzle.selected = "hour"
	elseif ClockPuzzle.selected == "second" then
		ClockPuzzle.selected = "minute"
	elseif ClockPuzzle.selected == "ampm" then
		ClockPuzzle.selected = "second"
	end
end

function ClockPuzzle.ev_right()
	if ClockPuzzle.selected == "hour" then
		ClockPuzzle.selected = "minute"
	elseif ClockPuzzle.selected == "minute" then
		ClockPuzzle.selected = "second"
	elseif ClockPuzzle.selected == "second" then
		ClockPuzzle.selected = "ampm"
	end
end

function ClockPuzzle.ev_enter()
	ClockPuzzle.state = false
	if ClockPuzzle.hour == 10 and ClockPuzzle.minute == 2 and ClockPuzzle.second == 8 and ClockPuzzle.ampm == "pm" then
		ClockPuzzle.solved = true

		Sounds.item_got:play()
		Sounds.main_theme:stop()
		Sounds.intro_soft:stop()
		Sounds.finding_home:stop()
		Sounds.ts_theme:stop()
	end
end

return ClockPuzzle
