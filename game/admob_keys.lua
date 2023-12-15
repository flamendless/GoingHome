local admob_keys = {}

if ON_MOBILE and not PRO_VERSION then
	print("using test ads")
	admob_keys.ids = {
		banner = "ca-app-pub-1904940380415570/5316808222",
		inter = "ca-app-pub-1904940380415570/6784080368",
		reward = "",
	}
else
	print("using real ads")
	admob_keys.ids = {
		banner = "",
		inter = "",
		reward = "",
	}
end

return admob_keys
