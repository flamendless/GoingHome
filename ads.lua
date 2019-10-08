local ads = {}

ads.main = "ca-app-pub-1904940380415570~5126309882"
ads.banner = "ca-app-pub-1904940380415570/4061953303"
ads.inter = "ca-app-pub-1904940380415570/2964494052"
ads.reward = "ca-app-pub-1904940380415570/7679436558"

--if love.system.getOS() == "Android" and not pro_version then
	--print("requesting reward ad")
	--love.ads.requestRewardedAd(_ads.reward)
	--print("requesting interstitial")
	--love.ads.requestInterstitial(_ads.inter)
--
	--if love.ads.isRewardedAdLoaded() then
	--print("show reward ad")
	--love.ads.showRewardedAd()
	--elseif love.ads.isInterstitialLoaded() then
	--print("show interstitial ad")
	--love.ads.showInterstitial()
	--end
--end
--
return ads
