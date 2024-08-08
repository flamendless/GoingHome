local Shaders = require("shaders")

local DifficultySelect = {
	idx = 1,
}

local diffs = {
	"ORDINARY",
	"DETERMINED",
}

local txt_diff_explain = {
	"With enough benevolence, survive.",
	"Not for the faint, scarce hope.",
}

function DifficultySelect.goto_next()
	SaveData.data.difficulty_idx = DifficultySelect.idx
	SaveData.save()
	gamestates.nextState("rain_intro")
end

function DifficultySelect.interact()
	local imgh = IMAGES["basementRoom"]:getHeight()
	local dw1 = DEF_FONT:getWidth(diffs[1])
	local dw2 = DEF_FONT:getWidth(diffs[2])
	local dx1 = WIDTH_HALF - dw1 - 8
	local dx2 = WIDTH_HALF + 8
	local dy = HEIGHT_HALF + imgh/2 + 4

	if check_gui(dx1, dy, dw1, DEF_FONT_HEIGHT) then
		DifficultySelect.idx = 1
		return true
	end

	if check_gui(dx2, dy, dw2, DEF_FONT_HEIGHT) then
		DifficultySelect.idx = 2
		return true
	end

	return false
end

function DifficultySelect.enter()
	SaveData.data.difficulty_idx = DifficultySelect.idx
	SaveData.save()
	gamestates.nextState("rain_intro")
end

function DifficultySelect.draw()
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)

	local imgh = IMAGES["basementRoom"]:getHeight()

	love.graphics.setShader(Shaders.grayscale)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(
		IMAGES["basementRoom"],
		0,
		HEIGHT_HALF - imgh/2
	)
	love.graphics.setShader()

	love.graphics.setFont(DEF_FONT)

	local txt_diff = "COURAGE FACTOR"
	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.print(
		txt_diff,
		WIDTH_HALF - DEF_FONT:getWidth(txt_diff) / 2,
		4
	)

	local txt_explain = txt_diff_explain[DifficultySelect.idx]
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf(
		txt_explain,
		8,
		HEIGHT_HALF - imgh/2 + DEF_FONT_HALF,
		WIDTH - 16,
		"center"
	)

	for i, diff in ipairs(diffs) do
		if i == DifficultySelect.idx then
			love.graphics.setColor(1, 0, 0, 1)
		else
			love.graphics.setColor(1, 1, 1, 1)
		end
		local x
		if i == 1 then
			x = WIDTH_HALF - DEF_FONT:getWidth(diff) - 8
		elseif i == 2 then
			x = WIDTH_HALF + 8
		end
		love.graphics.print(
			diff,
			x,
			HEIGHT_HALF + imgh/2 + 4
		)
	end
end

function DifficultySelect.keyreleased(key)
	if key == "w" or key == "a" then
		DifficultySelect.idx = DifficultySelect.idx - 1
		if DifficultySelect.idx <= 0 then
			DifficultySelect.idx = 2
		end
	elseif key == "s" or key == "d" then
		DifficultySelect.idx = DifficultySelect.idx + 1
		if DifficultySelect.idx > 2 then
			DifficultySelect.idx = 1
		end
	elseif key == "return" or key == "e" then
		DifficultySelect.goto_next()
	end
end

return DifficultySelect
