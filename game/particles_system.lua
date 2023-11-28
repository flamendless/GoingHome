ParticleSystem = {}

function ParticleSystem:init()
	PSYSTEM = {}
	PSYSTEM.rain = love.graphics.newParticleSystem(Images.rain,1000)
	PSYSTEM.rain:setParticleLifetime(1,3)
	PSYSTEM.rain:setEmissionRate(1000)
	PSYSTEM.rain:setSizeVariation(1)
	PSYSTEM.rain:setLinearAcceleration(0,200,0,500)
	PSYSTEM.rain:setAreaSpread("normal",WIDTH,0) --FIXME: (Brandon)
	PSYSTEM.rain:setPosition(0,-8)
end


function ParticleSystem:update(dt,sytem)
	sytem:update(dt)
end

function ParticleSystem:draw(sytem)
	local system = sytem
	local xx,yy = PSYSTEM.rain:getPosition()
	love.graphics.setColor(0,0, 1)
	love.graphics.draw(system,xx,yy)
end

