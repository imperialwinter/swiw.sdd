function widget:GetInfo()
	return {
		name      = "Minimap scaler",
		desc      = "Scales the minimap to a certain width, retaining aspect ratio",
		author    = "Gnome",
		date      = "October 2008",
		license   = "PD",
		layer     = 5,
		enabled   = true  --  loaded by default?
	}
end

--------------

include("Config/iwui.config.lua")

--------------

local oPosX, oPosY, oSizeX, oSizeY = Spring.GetMiniMapGeometry()	--cache it so it can be reset if the user turns off the widget

function widget:ViewResize(viewSizeX, viewSizeY)
	if (viewSizeX <= 1) or (viewSizeX == nil) or (viewSizeY <= 1) or (viewSizeY == nil) then
		return
	end

	vsx = viewSizeX
	vsy = viewSizeY

	MinimapConfig(vsx, vsy)

	local mapX = Game.mapSizeX
	local mapY = Game.mapSizeZ
	local ratio = 0

	if(mapX > mapY) then
		ratio = mapY / mapX
		minimapX = minimapscale * vsx
		minimapY = minimapX * ratio
	elseif(mapY > mapX) then
		ratio = mapX / mapY
		minimapY = minimapscale * vsx
		minimapX = minimapY * ratio
	else
		minimapX = minimapscale * vsx
		minimapY = minimapX
	end

	gl.ConfigMiniMap(posX, posY, minimapX, minimapY)
end

function widget:Initialize()
	oPosX, oPosY, oSizeX, oSizeY = Spring.GetMiniMapGeometry()
	vsx, vsy = widgetHandler:GetViewSizes()
	widget:ViewResize(vsx, vsy)
end

function widget:Shutdown()
	gl.ConfigMiniMap(oPosX, oPosY, oSizeX, oSizeY)	
end