local Battery = require("battery")

local BatteriesManager = {
	batteries = {},
	current_charge = 1,
	has_collision = false,
	collision_idx = 0,
}

function BatteriesManager.init()
	BatteriesManager.timer = HumpTimer:new()
	BatteriesManager.timer:every(2.5, function()
		local drain = love.math.random(0.01, 0.05)
		-- local drain = love.math.random(0.1, 0.3)
		BatteriesManager.current_charge = BatteriesManager.current_charge - drain
	end)
end

function BatteriesManager.randomize()
	local chance = love.math.random()
	if chance <= 0.6 then return end

	local charge = love.math.random(0.15, 0.2)
	local x = Lume.random(8, WIDTH - 32)
	local y = HEIGHT - 24
	local r = 0

	local battery = Battery(charge, x, y, r)
	table.insert(BatteriesManager.batteries, battery)
end

function BatteriesManager.update(dt)
	BatteriesManager.timer:update(dt)

	BatteriesManager.has_collision = false
	BatteriesManager.collision_idx = 0

	for _, battery in ipairs(BatteriesManager.batteries) do
		battery.colliding = false
	end

	for idx, battery in ipairs(BatteriesManager.batteries) do
		if PLAYER:check_collision(battery) then
			battery.colliding = true
			BatteriesManager.has_collision = true
			BatteriesManager.collision_idx = idx
			break
		end
	end
end

function BatteriesManager.check_interact()
	if (not BatteriesManager.has_collision) or (BatteriesManager.current_charge >= 1.0) then
		return false
	end

	local battery = BatteriesManager.batteries[BatteriesManager.collision_idx]
	if not battery then
		return false
	end

	BatteriesManager.current_charge = BatteriesManager.current_charge + battery.charge
	BatteriesManager.current_charge = math.clamp(BatteriesManager.current_charge, 0.0, 1.0)

	table.remove(BatteriesManager.batteries, BatteriesManager.collision_idx)
	BatteriesManager.collision_idx = 0
	BatteriesManager.has_collision = false

	SOUNDS.re_sound:play()
	SOUNDS.re_sound:setLooping(false)

	return true
end

function BatteriesManager.draw()
	for _, battery in ipairs(BatteriesManager.batteries) do
		battery:draw()
	end
end

return BatteriesManager
