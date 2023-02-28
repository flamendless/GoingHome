local Shaders = {
	grayscale = love.graphics.newShader("shaders/grayscale.glsl"),
	-- palette_swap = love.graphics.newShader("shaders/palette_swap.glsl"),
}

function Shaders.update(shader)
	-- if shader == Shaders.palette_swap then
	-- 	Shaders.palette_swap:send("u_tex_palette", images.tex_palette_ref)
	-- 	Shaders.palette_swap:send("u_tex_size", {images.tex_palette_ref:getDimensions()})
	-- end
end

return Shaders
