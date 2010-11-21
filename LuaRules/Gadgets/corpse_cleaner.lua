function gadget:GetInfo()
	return {
		name      = "Corpse cleaner",
		desc      = "Removes infantry corpses over time",
		author    = "Gnome",
		date      = "June 2008",
		license   = "PD",
		layer     = 0,
		enabled   = true
	}
end

if (gadgetHandler:IsSyncedCode()) then

local GetAllFeatures = Spring.GetAllFeatures
local GetFeatureDefID = Spring.GetFeatureDefID
local GetFeatureHealth = Spring.GetFeatureHealth
local GetFeaturePosition = Spring.GetFeaturePosition
local DestroyFeature = Spring.DestroyFeature
local SetFeatureHealth = Spring.SetFeatureHealth
local SetFeaturePosition = Spring.SetFeaturePosition
local ValidFeatureID = Spring.ValidFeatureID

local featureSink = {}

function gadget:GameFrame(n)
	if(n % 30 < 1) then
		local features = GetAllFeatures()
		for _,fid in ipairs(features) do
			local fdid = GetFeatureDefID(fid)
			local fmetal = FeatureDefs[fdid].metal
			if(fmetal == 1 and featureSink[fid] == nil) then --don't get rid of corpses that can change gameplay, and also don't get rid of trees, don't re-add corpses
				featureSink[fid] = n
			end
		end
	end

	for fid,frame in pairs(featureSink) do
		if(ValidFeatureID(fid)) then
			local fhp, fmaxhp = GetFeatureHealth(fid)
			local subtract = fmaxhp * 0.0011 --always make it take about 30 seconds regardless of the feature
			fhp = fhp - subtract
			if(fhp <= 0) then
				DestroyFeature(fid)
				featureSink[fid] = nil
			else
				SetFeatureHealth(fid,fhp)
				if(n - frame > 800) then
					local x,y,z = GetFeaturePosition(fid)
					y = y - 0.078
					SetFeaturePosition(fid,x,y,z)
				end
			end
		end
	end
end

end