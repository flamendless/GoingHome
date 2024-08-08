local Battery = require("battery")

local BatteriesManager = {
	batteries = {},
}

function BatteriesManager.randomize()
	local chance = love.math.random()
	if chance <= 0.6 then return end

	local x = Lume.random(8, WIDTH - 32)
	local y = HEIGHT - 24
	local r = 0

	local battery = Battery(x, y, r)
	table.insert(BatteriesManager.batteries, battery)

	BatteriesManager.has_collision = false
end

function BatteriesManager.update(dt)
	BatteriesManager.has_collision = false
	for _, e in ipairs(BatteriesManager.batteries) do
		e.colliding = false
		if PLAYER.x >= e.x and PLAYER.x + PLAYER.w <= e.x + e.w or
			PLAYER.x + PLAYER.w >= e.x + e.w / 6 and PLAYER.x + PLAYER.w <= e.x + e.w or
			PLAYER.x >= e.x and PLAYER.x <= e.x + e.w - e.w / 6
		then
			e.colliding = true
			BatteriesManager.has_collision = true
			break
		end
	end
end

function BatteriesManager.draw()
	for _, e in ipairs(BatteriesManager.batteries) do
		e:draw()
	end
end

return BatteriesManager
