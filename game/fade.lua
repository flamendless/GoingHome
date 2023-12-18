local Fade = Object:extend()

function Fade:new(alpha,timer)
	self.a = alpha
	self.t = timer
	self.state = false
end

function Fade:update(dt)
	if self.state == true then
		self.a = self.a-(1/self.t * dt)
	end
	if self.a <= 1 then
		self.state = false
		self.a = 1
		if DOOR_LOCKED == false then
			if action_flag == 0 then
				action_flag = 1
			end
		end
	end
end

function Fade:draw()
	if self.state == true then
		love.graphics.setColor(0,0,0,self.a)
		love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
	end
end

return Fade
