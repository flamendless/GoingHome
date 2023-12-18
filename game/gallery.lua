local Gallery = {}

local music = {}
local current = 1
local title = 1
local song = 2
local stringWidth = 0
local volume = 1

local isPlaying = false

local galleryGui = {}

local gPlay, gNext, gPrevious, gVolume, gSlider, gExit

function Gallery.load()
	music = {
		{ "On The Way Home", Sounds.intro_soft },
		{ "Peaceful Home",   Sounds.finding_home },
		{ "A Home's Melody", Sounds.ts_theme },
		{ "Finding Home",    Sounds.main_theme },
		{ "Alone Home",      Sounds.they_are_gone },
	}

	gPlay = {
		img = Images.galleryPlay,
		x = WIDTH_HALF,
		y = HEIGHT - 10,
		w = Images.galleryPlay:getWidth(),
		h = Images.galleryPlay:getHeight()
	}
	gNext = {
		img = Images.galleryNext,
		x = gPlay.x + 24,
		y = gPlay.y,
		w = Images.galleryNext:getWidth(),
		h = Images.galleryNext:getHeight()
	}
	gPrevious = {
		img = Images.galleryPrevious,
		x = gPlay.x - 24,
		y = gNext.y,
		w = Images.galleryPrevious:getWidth(),
		h = Images.galleryPrevious:getHeight()
	}
	gVolume = {
		img = Images.galleryVolume,
		x = WIDTH - 16,
		y = HEIGHT - 16,
		w = Images.galleryVolume:getWidth(),
		h = Images.galleryVolume:getHeight()
	}
	gSlider = {
		img = Images.gallerySlider,
		x = WIDTH - 16,
		y = HEIGHT - 16,
		w = Images.gallerySlider:getWidth(),
		h = Images.gallerySlider:getHeight()
	}
	gExit = {
		img = Images.return_gui,
		x = 5,
		y = 2,
		w = Images.gui_settings:getWidth(),
		h = Images.gui_settings:getHeight(),
		is_button = true,
	}


	table.insert(galleryGui, gPlay)
	table.insert(galleryGui, gNext)
	table.insert(galleryGui, gPrevious)
	table.insert(galleryGui, gExit)
	--table.insert(galleryGui,gSlider)
	--table.insert(galleryGui,gVolume)

	for _, v in ipairs(music) do
		v[song]:setVolume(1)
	end

	Gallery.pause()
end

function Gallery.update(dt)
	local cur = music[current]
	local title = cur[title]
	stringWidth = DEF_FONT:getWidth(title) / 2

	isPlaying = cur[song]:isPlaying()
	imgPlay = isPlaying == true and Images.galleryPlay or Images.galleryPause
	gPlay.img = imgPlay
end

function Gallery.keypressed(key)
	if key == "b" then
		Gallery.prev()
	elseif key == "n" then
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
	love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(
		music[current][title],
		WIDTH_HALF - stringWidth,
		HEIGHT_HALF - DEF_FONT_HEIGHT
	)

	for _, obj in ipairs(galleryGui) do
		if obj.is_button and check_gui(obj.x, obj.y, obj.w, obj.h) then
			love.graphics.setColor(1, 0, 0, 1)
		else
			love.graphics.setColor(1, 1, 1, 1)
		end

		love.graphics.draw(obj.img,
			obj.x, obj.y,
			0, 1, 1,
			obj.w / 2, obj.h / 2
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

function Gallery.interactions(id, x, y)
	if Gallery.touch(id, x, y, gPlay) then
		love.keypressed("space")
	elseif Gallery.touch(id, x, y, gNext) then
		love.keypressed("n")
	elseif Gallery.touch(id, x, y, gPrevious) then
		love.keypressed("b")
	elseif Gallery.touch(id, x, y, gExit) then
		Gallery.exit()
	end
end

function Gallery.touch(id, x, y, gui)
	x = x / RATIO
	y = (y - TY) / RATIO
	return x > gui.x - gui.w / 2 and x < gui.x + gui.w and
		y > gui.y - gui.h / 2 and y < gui.y + gui.h
end

function Gallery.touchmoved(id, x, y)
	x = x / RATIO
	y = (y - TY) / RATIO

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

function math.normalize(x, y)
	local l = (x * x + y * y) ^ .5
	if l == 0 then
		return 0, 0, 0
	else
		return x / l, y / l, l
	end
end

function Gallery.mouse(x, y, gui)
	return x > gui.x - gui.w / 2 and x < gui.x + gui.w and
		y > gui.y - gui.h / 2 and y < gui.y + gui.h
end

function Gallery.exit()
	love.audio.setVolume(1)
	Gallery.stop()
	gamestates.nextState("title")
end

return Gallery
