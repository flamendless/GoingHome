local SaveData = {
	out_filename = "saved_data.lua",
	data = {
		use_grayscale = false,
		door_locked = true,
	}
}

function SaveData.save()
	love.filesystem.write(SaveData.out_filename, JSON.encode(SaveData.data))
end

function SaveData.load()
	local str_save_data = love.filesystem.read(SaveData.out_filename)
	if not str_save_data then return end

	local save_data = JSON.decode(str_save_data)
	for k, v in pairs(save_data) do
		if SaveData.data[k] then
			SaveData.data[k] = v
		end
	end
end

return SaveData
