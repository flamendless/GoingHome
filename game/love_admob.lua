local love_admob = require("admob")

love_admob.timer = 0
love_admob.updateTime = 1 --Seconds
love_admob.debugging = false

love_admob.ad_timers = {
	banner = 0,
	interstitial = 0,
	rewarded = 0,
}

love_admob.showing = {
	interstitial = false,
	rewarded = false,
}

love_admob.shown_count = {
	interstitial = 0,
	rewarded = 0,
}

local test_done = false

--[[
	debugging: bool = false
	timer: int = 0
	updateTime: int = 1

	changeEUConsent: function
	checkForAdsCallbacks: function
	coreGetRewardQuantity: function
	coreGetRewardType: function
	coreInterstitialClosed: function
	coreInterstitialError: function
	coreRewardedAdDidFinish: function
	coreRewardedAdDidStop: function
	coreRewardedAdError: function
	createBanner: function
	getDeviceLanguage: function
	hideBanner: function
	isInterstitialLoaded: function
	isRewardedAdLoaded: function
	requestInterstitial: function
	requestRewardedAd: function
	showBanner: function
	showInterstitial: function
	showRewardedAd: function
	test: function
	update: function
--]]

function love_admob.update(dt)
	if love_admob.timer > 1 then
		if not test_done and love_admob.debugging then
			print(Inspect(love_admob))
			test_done = love_admob.test()
			print("AdMob Test", test_done)
		end
		love_admob.checkForAdsCallbacks()
		love_admob.timer = 0
	end
	love_admob.ad_timers.banner = love_admob.ad_timers.banner + dt
	love_admob.ad_timers.interstitial = love_admob.ad_timers.interstitial + dt
	love_admob.ad_timers.rewarded = love_admob.ad_timers.rewarded + dt
	love_admob.timer = love_admob.timer + dt
end

function love_admob.checkForAdsCallbacks()
	if love_admob.coreInterstitialError() then --Interstitial failed to load
		love_admob.showing.interstitial = false
		if love_admob.interstitialFailedToLoad then
			love_admob.interstitialFailedToLoad()
		end
	end

	if love_admob.coreInterstitialClosed() then --User has closed the ad
		love_admob.showing.interstitial = false
		if love_admob.interstitialClosed then
			love_admob.interstitialClosed()
		end
	end

	if love_admob.coreRewardedAdError() then --Rewarded ad failed to load
		love_admob.showing.rewarded = false
		if love_admob.rewardedAdFailedToLoad then
			love_admob.rewardedAdFailedToLoad()
		end
	end

	if love_admob.coreRewardedAdDidFinish() then --Video has finished playing
		love_admob.showing.rewarded = false
		local reward_type = love_admob.coreGetRewardType() or "???"
		local reward_qty = love_admob.coreGetRewardQuantity() or 1
		print("AdMob reward:", reward_type, reward_qty)

		if love_admob.rewardUserWithReward then
			love_admob.rewardUserWithReward(reward_type, reward_qty)
		end
	end

	if love_admob.coreRewardedAdDidStop() then --Video has stopped by user
		love_admob.showing.rewarded = false
		if love_admob.rewardedAdDidStop then
			love_admob.rewardedAdDidStop()
		end
	end
end

return love_admob
