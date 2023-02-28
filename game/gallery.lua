local Gallery = {}

local music = {}
local current = 1
local title = 1
local song = 2
local stringWidth = 0
local stringHeight = 0
local volume = 1

local isPlaying = false

local galleryGui = {}

function Gallery.load()
	music[1] = {"On The Way Home", sounds.intro_soft }
	music[2] = {"Peaceful Home", sounds.finding_home }
	music[3] = {"A Home's Melody", sounds.ts_theme }
	music[4] = {"Finding Home",sounds.main_theme}
	music[5] = {"Alone Home",sounds.they_are_gone}

	gPlay = {
		img = images.galleryPlay,
		x = width/2,
		y = height - 10,
		w = images.galleryPlay:getWidth(),
		h = images.galleryPlay:getHeight()
	}
	gNext = {
		img = images.galleryNext,
		x = gPlay.x + 24,
		y = gPlay.y,
		w = images.galleryNext:getWidth(),
		h = images.galleryNext:getHeight()
	}
	gPrevious = {
		img = images.galleryPrevious,
		x = gPlay.x - 24,
		y = gNext.y,
		w = images.galleryPrevious:getWidth(),
		h = images.galleryPrevious:getHeight()
	}
	gVolume = {
		img = images.galleryVolume,
		x = width - 16,
		y = height - 16,
		w = images.galleryVolume:getWidth(),
		h = images.galleryVolume:getHeight()
	}
	gSlider = {
		img = images.gallerySlider,
		x = width - 16,
		y = height - 16,
		w = images.gallerySlider:getWidth(),
		h = images.gallerySlider:getHeight()
	}
	gExit = {
		img = images.return_gui,
		x = 5,
		y = 1,
		w = images.gui_settings:getWidth(),
		h = images.gui_settings:getHeight(),
		is_button = true,
	}


	table.insert(galleryGui,gPlay)
	table.insert(galleryGui,gNext)
	table.insert(galleryGui,gPrevious)
	table.insert(galleryGui,gExit)
	--table.insert(galleryGui,gSlider)
	--table.insert(galleryGui,gVolume)

	for k,v in pairs(music) do
		music[k][song]:setVolume(1)
	end

	Gallery.pause()
end

function Gallery.update(dt)
	local cur = music[current]
	local title = cur[title]
	stringWidth = font:getWidth(title)/2
	stringHeight = font:getHeight(title)

	isPlaying = cur[song]:isPlaying()
	imgPlay = isPlaying == true and images.galleryPlay or images.galleryPause
	gPlay.img = imgPlay
end

function Gallery.keypressed(key)
	if key == "b" then
		--ternary for next
		Gallery.prev()
	elseif key == "n" then
		--ternary for previous
		Gallery.next()
	elseif key == "space" then
		if isPlaying then
			Gallery.pause()
		else
			Gallery.play()
		end
	elseif key == "i" then
		Gallery.increase()
	elseif key == "k" then
		Gallery.decrease()
	end
end

function Gallery.draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.rectangle("fill",0,0,width,height)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(music[current][title],width/2 - stringWidth,height/2 - stringHeight)

	for k,v in pairs(galleryGui) do
		local obj = galleryGui[k]

		if obj.is_button and check_gui(obj.x, obj.y, obj.w, obj.h) then
			love.graphics.setColor(1, 0, 0, 1)
		else
			love.graphics.setColor(1, 1, 1, 1)
		end

		love.graphics.draw(obj.img,
			obj.x, obj.y,
			0, 1, 1,
			obj.w/2, obj.h/2
		)
	end
end

function Gallery.play()
	music[current][song]:play()
	music[current][song]:setLooping(true)
end

function Gallery.pause()
	music[current][song]:pause()
end

function Gallery.stop()
	music[current][song]:stop()
end

function Gallery.next()
	Gallery.stop()
	current = current < #music and current + 1 or 1
	Gallery.play()
end

function Gallery.prev()
	Gallery.stop()
	current = current > 1 and current - 1 or #music
	Gallery.play()
end

function Gallery.increase()
	volume = volume < 1 and volume + 0.1 or 1
	love.audio.setVolume(volume)
end

function Gallery.decrease()
	volume = volume > 0 and volume - 0.1 or 0
	love.audio.setVolume(volume)
end

function Gallery.touch(id,x,y,gui)
	local gui = gui
	local x = x/ratio
	local y = (y-ty)/ratio
	return x > gui.x - gui.w/2 and x < gui.x + gui.w and
		y > gui.y - gui.h/2 and y < gui.y + gui.h
end

function Gallery.touchmoved(id,x,y)
	local x = x/ratio
	local y = (y-ty)/ratio

	if gVolume.y > gSlider.y then
		gVolume.y = y
	else
		gVolume.y = gSlider.y
	end

	if gVolume.y < gSlider.y + gSlider.h then
		gVolume.y = y
	else
		gVolume.y = gSlider.y + gSlider.h
	end
end

function math.normalize(x,y)
	local l=(x*x+y*y)^.5
	if l==0 then
		return 0,0,0
	else
		return x/l,y/l,l
	end
end

function Gallery.mouse(x,y,gui)
	return x > gui.x - gui.w/2 and x < gui.x + gui.w and
		y > gui.y - gui.h/2 and y < gui.y + gui.h
end

function Gallery.exit()
	love.audio.setVolume(1)
	Gallery.stop()
end

return Gallery
