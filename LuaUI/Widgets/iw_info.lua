function widget:GetInfo()
	return {
		name = "IW/Info panel",
		desc = "Gives some information about the current game world",
		author = "Gnome",
		date = "Dec 2008",
		license = "Public Domain",
		layer = 1,
		enabled = true
	}
end

--- speedups
local GetConfigInt = Spring.GetConfigInt
local SendCommands = Spring.SendCommands
local IsGUIHidden = Spring.IsGUIHidden
local MakeFont = Spring.MakeFont

local fhUseFont = fontHandler.UseFont
local fhDraw = fontHandler.Draw
local fhDrawRight = fontHandler.DrawRight

local glColor = gl.Color
local glTex = gl.Texture
local glText = gl.Text
local glTexRect = gl.TexRect
local glRect = gl.Rect
local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix


---------------------

include("Config/iwui.config.lua")

---------------------

local ui = IsGUIHidden()
local active = false

local ghosts = Game.ghostedBuildings or true
if ghosts then ghosts = "Enabled" else ghosts = "Disabled" end

local endMode = Spring.GetModOptions().deathmode
if endMode == "com" then endMode = "Command death" else endMode = "Annihilate" end

local versionCutoffPos = string.find(Game.version,"(", 1, true)

local info = {
	{
		name = "Imperial Winter version:",
		val = string.gsub(Game.modName, "Imperial Winter ", " "),
	}, {
		name = "Spring Engine version:",
		val = string.sub(Game.version, 1, versionCutoffPos - 2),
	}, {
		name = "Victory condition:",
		val = endMode,
	}, {
		name = "Game speed:",
		val = math.floor(Game.gameSpeed * 100) .. "%",
	}, {
		name = "Building ghosts:",
		val = ghosts,
	}, {
		name = "Map:",
		val = Game.mapName,
	}, {
		name = "Map size:",
		val = Game.mapX .. "x" .. Game.mapY,
	}, {
		name = "Map gravity:",
		val = math.floor(Game.gravity / 130 * 100) .. "%",
	},
}

---------------------

local function infomenu()
	if(not active) then
		active = true
	else
		active = false
	end
end

function widget:ViewResize(viewx, viewy)
	if(viewx <= 1) or (viewx == nil) or (viewy <= 1) or (viewy == nil) then
		return
	end

	vsx = viewx
	vsy = viewy

	OptionsConfig(vsx, vsy)
	MakeFont(fontVirtualName,{ inData = VFS.LoadFile(fontRealName), height = namesize, minChar = 0, maxChar = 255, outlineMode = 0, outlineRadius = 0, outlineWeight = 0})
end

function widget:Initialize()
	local vsx, vsy = widgetHandler:GetViewSizes()
	widget:ViewResize(vsx, vsy)

	widgetHandler:AddAction("infomenu", infomenu)
	SendCommands({"unbind i gameinfo"})
	SendCommands({"bind i luaui infomenu"})
end

function widget:Shutdown()
	SendCommands({"unbind i luaui infomenu"})
	SendCommands({"bind i gameinfo"})
	widgetHandler:RemoveAction("optmenu", infomenu)
end



function widget:IsAbove(x, y)
	if(not ui and active) then
		x1 = optbgx
		y1 = optbgy
		x2 = optbgx + optbgwidth
		y2 = optbgy + optbgheight
		if(x > x1 and x < x2 and y > y1 and y < y2) then
			return true
		end
		return false
	end
end

function widget:GetTooltip(x, y)
	if(not ui and active) then
		x1 = optbgx
		y1 = optbgy
		x2 = optbgx + optbgwidth
		y2 = optbgy + optbgheight
		if(x > x1 and x < x2 and y > y1 and y < y2) then
			local tooltip = "UI: Game Information Panel - Shows basic game information"
			return tooltip
		end
	end
	return false
end


function widget:DrawScreen()
	ui = IsGUIHidden()
	if(not ui and active) then

		_,gameSpeed,paused = Spring.GetGameSpeed()
		if paused then info[4].val = "Paused" else info[4].val = math.floor(gameSpeed * 100) .. "%" end

		glPushMatrix()

		glColor(1,1,1,1)
		glTex("LuaUI/zui/imp/options/bg.png")
		glTexRect(optbgx, optbgy, optbgx + optbgwidth, optbgy + optbgheight)
		glTex(false)

		glColor(namecolor)
		fhUseFont(fontBaseName .. namesize)
		fhDraw("Game Information", optbgx + optpaddingleft, optbgy + optbgheight - optpaddingtop / 2)

		glColor(1,1,1,1)

		for i, value in ipairs(info) do
			fhDraw(tostring(value.name), optbgx + optpaddingleft, optbgy + optbgheight - optpaddingtop - (namesize * (i - 1)))
			fhDrawRight(tostring(value.val), optbgx + optbgwidth - optpaddingleft, optbgy + optbgheight - optpaddingtop - (namesize * (i - 1)))
		end

		glPopMatrix()
		glColor(1,1,1,1)
	end
end