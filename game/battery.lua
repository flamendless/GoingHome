local Battery = Object:extend()

function Battery:new(x, y, r)
	self.image = IMAGES.battery
	self.image_glow = IMAGES.battery_glow

	self.w, self.h = self.image:getDimensions()

	self.x = x
	self.y = y
	self.r = r

	self.colliding = false
end

function Battery:draw()
	love.graphics.setColor(1, 1, 1, 1)

	if self.colliding then
		love.graphics.draw(
			self.image_glow,
			self.x - 1,
			self.y - 1,
			self.r
		)
	else
		love.graphics.draw(self.image, self.x, self.y, self.r)
	end
	love.graphics.setColor(1, 1, 1, 1)
end

return Battery
