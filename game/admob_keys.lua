local admob_keys = {}

if ON_MOBILE and not PRO_VERSION then
	admob_keys.ids = {
		banner = "",
		inter = "ca-app-pub-1904940380415570/6784080368",
		reward = "",
	}
	print("using test ads")
else
	admob_keys.ids = {
		banner = "",
		inter = "",
		reward = "",
	}
	print("using real ads")
end

return admob_keys
