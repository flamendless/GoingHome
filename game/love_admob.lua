local love_admob = require("admob")

love_admob.timer = 0
love_admob.updateTime = 1 --Seconds

function love_admob.update(dt)
	if love_admob.timer > 1 then
		love_admob.checkForAdsCallbacks()
		love_admob.timer = 0
	end
	love_admob.timer = love_admob.timer + dt
end

function love_admob.checkForAdsCallbacks()
	print(2, love_admob.coreInterstitialError)
	if love_admob.coreInterstitialError() then --Interstitial failed to load
		if love_admob.interstitialFailedToLoad then
			love_admob.interstitialFailedToLoad()
		end
	end

	print(3, love_admob.coreInterstitialClosed)
	if love_admob.coreInterstitialClosed() then --User has closed the ad
		if love_admob.interstitialClosed then
			love_admob.interstitialClosed()
		end
	end

	print(4, love_admob.coreRewardedAdError)
	if love_admob.coreRewardedAdError() then --Rewarded ad failed to load
		if love_admob.rewardedAdFailedToLoad then
			love_admob.rewardedAdFailedToLoad()
		end
	end

	print(5, love_admob.coreRewardedAdDidFinish)
	if love_admob.coreRewardedAdDidFinish() then --Video has finished playing
		local rewardType = "???"
		local rewardQuantity = 1
		rewardType = love_admob.coreGetRewardType() or "???"
		rewardQuantity = love_admob.coreGetRewardQuantity() or 1

		if love_admob.rewardUserWithReward then
			love_admob.rewardUserWithReward(rewardType,rewardQuantity)
		end
	end

	print(6, love_admob.coreRewardedAdDidStop)
	if love_admob.coreRewardedAdDidStop() then --Video has stopped by user
		if love_admob.rewardedAdDidStop then
			love_admob.rewardedAdDidStop()
		end
	end
end

return love_admob
