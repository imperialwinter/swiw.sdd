function widget:GetInfo()
	return {
		name      = "Center camera",
		desc      = "Centers camera on your command unit on game start",
		author    = "Gnome",
		date      = "June 2008",
		license   = "Public domain",
		layer     = -5,
		enabled   = true  --  loaded by default?
	}
end

function widget:GameFrame(n)
	if(n > 5 and n < 10) then
		local teamID = Spring.GetLocalTeamID()
		local units = Spring.GetTeamUnits(teamID)
		local x,y,z = Spring.GetUnitPosition(units[1])
		Spring.SelectUnitArray({units[1]})
		Spring.SetCameraTarget(x,y,z)
		widgetHandler:RemoveWidget()
	elseif(n > 10) then
		widgetHandler:RemoveWidget()
	end
end