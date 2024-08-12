local Battery = require("battery")

local BatteriesManager = {
	current_battery = nil,
	current_charge = 1,
	has_collision = false,
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
	BatteriesManager.current_battery = nil

	local chance = love.math.random()
	if chance <= 0.6 then return end

	local charge = love.math.random(0.15, 0.2)
	local x = Lume.random(8, WIDTH - 32)
	local y = HEIGHT - 24
	local r = 0

	BatteriesManager.current_battery = Battery(charge, x, y, r)
end

function BatteriesManager.update(dt)
	BatteriesManager.timer:update(dt)

	BatteriesManager.has_collision = false

	if not BatteriesManager.current_battery then return end

	BatteriesManager.current_battery.colliding = false
	if PLAYER:check_collision(BatteriesManager.current_battery) then
		BatteriesManager.current_battery.colliding = true
		BatteriesManager.has_collision = true
	end
end

function BatteriesManager.check_interact()
	if (not BatteriesManager.has_collision) or (BatteriesManager.current_charge >= 1.0) then
		return false
	end

	if not BatteriesManager.current_battery then
		return false
	end

	BatteriesManager.current_charge = BatteriesManager.current_charge + BatteriesManager.current_battery.charge
	BatteriesManager.current_charge = math.clamp(BatteriesManager.current_charge, 0.0, 1.0)

	BatteriesManager.current_battery = nil
	BatteriesManager.has_collision = false

	SOUNDS.re_sound:play()
	SOUNDS.re_sound:setLooping(false)

	return true
end

function BatteriesManager.draw()
	if not BatteriesManager.current_battery then return end
	BatteriesManager.current_battery:draw()
end

return BatteriesManager
