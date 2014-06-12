function widget:GetInfo()
	return {
		name      = "IW/Clock & FPS",
		desc      = "Game clock and FPS display that doesn't overlap the IW UI",
		author    = "Gnome",
		date      = "March 1, 2009",
		license   = "PD",
		layer     = 0,
		enabled   = true
	}
end

-------------- speedups

local IsGUIHidden = Spring.IsGUIHidden
local GetFPS = Spring.GetFPS
local GetGameSeconds = Spring.GetGameSeconds

local fhUseFont = fontHandler.UseFont
local fhGetTextWidth = fontHandler.GetTextWidth
local fhDraw = fontHandler.Draw

local glColor = gl.Color
local stformat = string.format

-------------- some initialization

include("Config/iwui.config.lua")







-------------- initialization/setup functions

function widget:ViewResize(viewx, viewy)
	if(viewx <= 1) or (viewx == nil) or (viewy <= 1) or (viewy == nil) then
		return
	end

	vsx = viewx
	vsy = viewy

	TooltipConfig(vsx, vsy)
end

function widget:Initialize()
	local vsx, vsy = widgetHandler:GetViewSizes()
	widget:ViewResize(vsx, vsy)
	Spring.SendCommands({"clock 0"})
	Spring.SendCommands({"fps 0"})
end

function widget:Shutdown()
	Spring.SendCommands({"clock 1"})
	Spring.SendCommands({"fps 1"})
end







function Secs2Clock(seconds)
	if(seconds == 0) then
		return "00:00:00";
	else
		hours = stformat("%02.f", math.floor(seconds/3600));
		mins = stformat("%02.f", math.floor(seconds/60 - (hours*60)));
		secs = stformat("%02.f", math.floor(seconds - hours*3600 - mins *60));
		return hours .. ":" .. mins .. ":" .. secs
	end
end

function widget:DrawScreen()
	local ui = IsGUIHidden()
	if(not ui) then
		local fps = GetFPS()
		local gametime = Secs2Clock(GetGameSeconds())
		fhUseFont(fontBaseName .. descsize)
		glColor(resrcolor)
		fhDraw(gametime, vsx - fhGetTextWidth("00:00:00") - 5, vsy - descsize * 0.8)
		glColor(respcolor)
		fhDraw("FPS: " .. fps, vsx - fhGetTextWidth("00:00:00") - 5, vsy - descsize * 1.6)
		glColor(1,1,1,1)
	end
end