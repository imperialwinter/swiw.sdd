function widget:GetInfo()
	return {
		name = "IW Icon Distance",
		desc = "Sets Icon Distance to a suitable level for Imperial Winter",
		author = "Craig Lawrence",
		date = "09-12-2008",
		license = "Public Domain",
		layer = 1,
		enabled = true
	}
end

local unitIconDist = 0

function widget:Initialize()
  unitIconDist = Spring.GetConfigInt('UnitIconDist')
	Spring.SendCommands("disticon 300")
end

function widget:Shutdown()
  Spring.SendCommands("disticon " .. unitIconDist)
end