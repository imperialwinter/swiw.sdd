function widget:GetInfo()
	return {
		name      = "Square Buildpics",
		desc      = "Forces square buildpics at any resolution",
		author    = "Gnome, Maelstrom",
		date      = "December 7, 2007", --Updated October 2008
		license   = "PD",
		layer     = 5,
		enabled   = true  --  loaded by default?
	}
end

--------------------

include("Config/iwui.config.lua")

--------------------

local function SetupCtrlPanel(iconSizeX, iconSizeY, iconsY, xSelectPos, ySelectPos)
	local f = io.open("modpanel.txt", "w+")
	if (f) then
		f:write("xIcons " .. iconsX .. "\n")
		f:write("yIcons " .. iconsY .. "\n")
		f:write("xIconSize " .. iconSizeX .. "\n")
		f:write("yIconSize " .. iconSizeY .. "\n")
		f:write("xPos " .. xPos .. "\n")
		f:write("yPos " .. yPos .. "\n")
		f:write("xSelectionPos " .. xSelectPos .. "\n")
		f:write("ySelectionPos " .. ySelectPos .. "\n")

		f:write("textBorder " .. textBorder .. "\n")
		f:write("iconBorder " .. iconBorder .. "\n")
		f:write("frameBorder " .. frameBorder .. "\n")
		f:write("frameAlpha " .. frameAlpha .. "\n")

		f:write("outlinefont " .. outlinefont .. "\n")
		f:write("textureAlpha " .. textureAlpha .. "\n")
		f:write("selectGaps " .. selectGaps .. "\n")
		f:write("selectThrough " .. selectThrough .. "\n")
		f:write("frontByEnds " .. frontByEnds .. "\n")
		
		f:close()
		Spring.SendCommands({"ctrlpanel modpanel.txt"})
	end
	os.remove("modpanel.txt")
end

function widget:ViewResize(vsx, vsy)
	if (vsx <= 1) or (vsx == nil) or (vsy <= 1) or (vsy == nil) then
		return
	end

	BuildmenuConfig(vsx, vsy)

	SetupCtrlPanel(iconSizeX, iconSizeY, iconsY, xSelectPos, ySelectPos)
end

function widget:Initialize()
	local vsx, vsy = widgetHandler:GetViewSizes()
	widget:ViewResize(vsx, vsy)
end

function widget:Shutdown()
	Spring.SendCommands({'ctrlpanel LuaUI/ctrlpanel.txt'})
end