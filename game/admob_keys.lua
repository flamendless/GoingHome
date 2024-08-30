local admob_keys = {}

function admob_keys.init(test_ads)
	if test_ads then
		print("using test ads")
		admob_keys.ids = {
			banner = "ca-app-pub-3940256099942544/9214589741",
			inter = "ca-app-pub-3940256099942544/1033173712",
			reward = "ca-app-pub-3940256099942544/5224354917",
		}
	else
		print("using real ads")
		admob_keys.ids = {
			banner = "ca-app-pub-1904940380415570/5316808222",
			inter = "ca-app-pub-1904940380415570/6784080368",
			reward = "ca-app-pub-1904940380415570/8531210645",
		}
	end
end

return admob_keys
