local Battery = require("battery")

local BatteriesManager = {
	current_battery = nil,
	current_charge = 1,
	has_collision = false,
}

function BatteriesManager.init()
	BatteriesManager.timer = HumpTimer:new()
	BatteriesManager.timer:every(2.5, function()
		if not LIGHT_ON then return end
		local drain = love.math.random(0.01, 0.05)
		BatteriesManager.current_charge = BatteriesManager.current_charge - drain
	end)
end

function BatteriesManager.randomize()
	BatteriesManager.current_battery = nil

	local chance = love.math.random()
	if chance <= 0.6 then return end

	local x = Lume.random(8, WIDTH - 32)
	local y = HEIGHT - 24
	local r = 0

	BatteriesManager.current_battery = Battery(x, y, r)
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
	if (
		(not BatteriesManager.current_battery) or
		(not BatteriesManager.has_collision) or
		(BatteriesManager.current_charge >= 1.0)
	) then
		return false
	end

	BatteriesManager.current_charge = 1
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

function BatteriesManager.get_light_scale()
	local scale = 1
	if DifficultySelect.idx == 2 then
		scale = BatteriesManager.current_charge
		scale = math.max(scale, 0.4)
	end
	return scale
end

return BatteriesManager
