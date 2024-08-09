local Battery = require("battery")

local BatteriesManager = {
	batteries = {},
	current_charge = 1,
}

function BatteriesManager.init()
	BatteriesManager.timer = HumpTimer:new()
	BatteriesManager.timer:every(2.5, function()
		local drain = love.math.random(0.05, 0.09)
		BatteriesManager.current_charge = BatteriesManager.current_charge - drain
	end)
end

function BatteriesManager.randomize()
	local chance = love.math.random()
	if chance <= 0.6 then return end

	local charge = love.math.random(0.2, 0.4)
	local x = Lume.random(8, WIDTH - 32)
	local y = HEIGHT - 24
	local r = 0

	local battery = Battery(charge, x, y, r)
	table.insert(BatteriesManager.batteries, battery)

	BatteriesManager.has_collision = false
	BatteriesManager.collision_idx = 0
end

function BatteriesManager.update(dt)
	BatteriesManager.timer:update(dt)

	BatteriesManager.has_collision = false
	BatteriesManager.collision_idx = 0
	for idx, e in ipairs(BatteriesManager.batteries) do
		e.colliding = false
		if PLAYER:check_collision(e) then
			e.colliding = true
			BatteriesManager.has_collision = true
			BatteriesManager.collision_idx = idx
			break
		end
	end
end

function BatteriesManager.check_interact()
	if not BatteriesManager.has_collision then
		return false
	end

	if BatteriesManager.current_charge >= 1.0 then
		return false
	end

	local battery = BatteriesManager.batteries[BatteriesManager.collision_idx]
	if not battery then
		return false
	end

	BatteriesManager.current_charge = BatteriesManager.current_charge + battery.charge
	BatteriesManager.current_charge = math.clamp(BatteriesManager.current_charge, 0.0, 1.0)

	return true
end

function BatteriesManager.draw()
	for _, e in ipairs(BatteriesManager.batteries) do
		e:draw()
	end
end

return BatteriesManager
