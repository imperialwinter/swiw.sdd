function widget:GetInfo()
	return {
		name      = "Simplified radar colors",
		desc      = "Makes enemies red and allies blue on the minimap",
		author    = "Gnome",
		date      = "June 2008",
		license   = "Public domain",
		layer     = -5,
		enabled   = false  --  loaded by default?
	}
end

function widget:Initialize()
	Spring.SendCommands({"minimap simplecolors 1"})
end

function widget:Shutdown()
	Spring.SendCommands({"minimap simplecolors 0"})
end