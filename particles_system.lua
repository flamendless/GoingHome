particle = {}

function particle:init()
	psystem = {}
	psystem.rain = love.graphics.newParticleSystem(images.rain,1000)
	psystem.rain:setParticleLifetime(1,3) 
	psystem.rain:setEmissionRate(1000)
	psystem.rain:setSizeVariation(1)
	psystem.rain:setLinearAcceleration(0,200,0,500) 
	psystem.rain:setAreaSpread("normal",width,0)
	psystem.rain:setPosition(0,-8)
end


function particle:update(dt,sytem)
	local system = system
	sytem:update(dt)
end

function particle:draw(sytem)
	local system = sytem
	local xx,yy = psystem.rain:getPosition()
	love.graphics.setColor(0,0, 1)
	love.graphics.draw(system,xx,yy)
end

