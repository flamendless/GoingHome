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
	if ClockPuzzle.selected == "ampm" then
		if ClockPuzzle.ampm == "am" then
			ClockPuzzle.ampm = "pm"
		else
			ClockPuzzle.ampm = "am"
		end
		return
	end

	if ClockPuzzle.selected == "hour" then
		ClockPuzzle.hour = ClockPuzzle.hour + 1
		ClockPuzzle.hour = math.wrap(ClockPuzzle.hour, 1, 12 + 1)
	elseif ClockPuzzle.selected == "minute" then
		ClockPuzzle.minute = ClockPuzzle.minute + 1
		ClockPuzzle.minute = math.wrap(ClockPuzzle.minute, 1, 60 + 1)
	elseif ClockPuzzle.selected == "second" then
		ClockPuzzle.second = ClockPuzzle.second + 1
		ClockPuzzle.second = math.wrap(ClockPuzzle.second, 1, 60 + 1)
	end
end

function ClockPuzzle.ev_down()
	if ClockPuzzle.selected == "ampm" then
		if ClockPuzzle.ampm == "am" then
			ClockPuzzle.ampm = "pm"
		else
			ClockPuzzle.ampm = "am"
		end
		return
	end

	if ClockPuzzle.selected == "hour" then
		ClockPuzzle.hour = ClockPuzzle.hour - 1
		ClockPuzzle.hour = math.wrap(ClockPuzzle.hour, 1, 12 + 1)
	elseif ClockPuzzle.selected == "minute" then
		ClockPuzzle.minute = ClockPuzzle.minute - 1
		ClockPuzzle.minute = math.wrap(ClockPuzzle.minute, 1, 60 + 1)
	elseif ClockPuzzle.selected == "second" then
		ClockPuzzle.second = ClockPuzzle.second - 1
		ClockPuzzle.second = math.wrap(ClockPuzzle.second, 1, 60 + 1)
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

		SOUNDS.item_got:play()
		SOUNDS.main_theme:stop()
		SOUNDS.intro_soft:stop()
		SOUNDS.finding_home:stop()
		SOUNDS.ts_theme:stop()
	end
end

return ClockPuzzle
