local SaveData = {
	out_filename = "saved_data.lua",
	data = {
		use_grayscale = false,
		door_locked = true,
		music_sounds = true,
		hide_cursor = false,
	},
}

local opts = {
	{
		str = "classic effect",
		value = false,
	},
	{
		str = "sound/music",
		value = true,
	},
	{
		str = "hide cursor",
		value = false,
	},
}

function SaveData.save()
	love.filesystem.write(SaveData.out_filename, JSON.encode(SaveData.data))
	print("SaveData saved")
end

function SaveData.load()
	local str_save_data = love.filesystem.read(SaveData.out_filename)
	if not str_save_data then return end

	local save_data = JSON.decode(str_save_data)
	for k, v in pairs(save_data) do
		if SaveData.data[k] ~= nil then
			SaveData.data[k] = v
		end
	end
	SaveData.get_opts()
	print("SaveData loaded")
end

function SaveData.get_opts()
	opts[1].value = SaveData.data.use_grayscale
	opts[2].value = SaveData.data.music_sounds
	opts[3].value = SaveData.data.hide_cursor
	return opts
end

function SaveData.toggle_opts(i)
	local o = opts[i]
	o.value = not o.value
	SaveData.data.use_grayscale = opts[1].value
	SaveData.data.music_sounds = opts[2].value
	SaveData.data.hide_cursor = opts[3].value

	if SaveData.data.music_sounds then
		love.audio.setVolume(1)
	else
		love.audio.setVolume(0)
	end
end

return SaveData
