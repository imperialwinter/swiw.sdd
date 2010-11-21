---------------------------------------------------------------
-- iwui.config.lua
-- Configuration file for Imperial Winter's GUI
-- Last update: March 1, 2009
---------------------------------------------------------------

-------------- Please don't touch the following
viewx, viewy = gl.GetViewSizes()
_,_,_,_,myFaction = Spring.GetTeamInfo(Spring.GetLocalTeamID())
impBuildpic = UnitDefNames["imp_p_flag"].buildpicname
rebBuildpic = UnitDefNames["reb_p_flag"].buildpicname



-------------- Fonts

fontRealName = "LuaUI/Fonts/bombardier.ttf"
fontVirtualName = "bomba"

fontBaseName = fontVirtualName .. "_"



-------------- Options menu

function OptionsConfig(vsx, vsy)
	vsx = vsx or viewx
	vsy = vsy or viewy

	optbgheight = math.floor(vsy * 0.398)
	optbgwidth = math.floor(optbgheight * 1.395)
	optbgx = vsx / 2 - optbgwidth / 2
	optbgy = vsy / 2 - optbgheight / 2

	optbarwidth = vsy * 0.25
	optbarheight = optbarwidth * 0.04
	optbarx = optbgx + optbgwidth * 0.4

	optpaddingtop = optbgheight * 0.22
	optpaddingleft = optbgwidth * 0.08

	namesize = resbarfontlarge
	namecolor = {1, 1, 0.25, 1}
end



-------------- Resource bars
resbarfontlarge = math.floor(viewy * 0.026)
resbarfontmed = math.floor(viewy * 0.018)

function ResbarConfig(vsx, vsy)
	vsx = vsx or viewx
	vsy = vsy or viewy

	resbarh = math.floor(0.0521 * vsy)
	resbarw = resbarh * 25.592
	resbarbarh = math.floor(resbarh * 0.25)
	resbarbarbgxmin = math.floor(resbarw * 0.148)
	resbarbarbgxmax = math.floor(resbarw * 0.48)
	resbarbarxmin = math.floor(resbarw * 0.157)
	resbarbarxmax = math.floor(resbarw * 0.255) --0.479
	resbarbarxoffset = math.floor((resbarbarxmax - resbarbarxmin) * 0.0297)
	resbaruseoffset = math.floor(resbarw * 0.23)
	resbarincoffset = math.floor(resbarw * 0.063)

	resbarfontlarge = math.floor(vsy * 0.026)
	resbarfontmed = math.floor(vsy * 0.018)
	resbarfontsm = math.floor(vsy * 0.015)

	allyfrillh = vsy * 0.059
	allyfrillw = allyfrillh * 4.033
	allyfrilloffset = vsy - allyfrillh
	allypanelh = vsy * 0.061
	allypanelhoffset = allypanelh * 0.163
	allybarw = allyfrillw * 0.5
	allybarh = allypanelh * 0.129
	allybarhoffset = vsy * 0.026
	allybarwoffset = allyfrillw * 0.32
	allysidepic = vsy * 0.01
	allyexpandbuttonh = allyfrillh * 0.35
	allyexpandbuttonw = allyexpandbuttonh * 3.5
	allyexpandoffsetx = allysidepic * 0.6
	allyexpandoffsety = allyfrillh * 0.5

--[[	--use this stuff when we get everything laid out properly
	allyfrillh = vsy * 0.059
	allyfrillw = allyfrillh * 4.033
	allyfrilloffset = vsy * 0.24
	allypanelh = vsy * 0.061
	allypanelhoffset = allypanelh * 0.163
	allybarw = allyfrillw * 0.5
	allybarh = allypanelh * 0.129
	allybarhoffset = vsy * 0.026
	allybarwoffset = allyfrillw * 0.32
	allysidepic = vsy * 0.01
]]
end



-------------- Build/orders menu

iconscale = 64				--the size of the buildpics at 1024x768
iconsX = 3				--number of buildpics per row
tooltipheightpercentage = 0 		--if you are using the default tooltip box, use 0.1
xPos = 0				--bar x position
yPos = 0				--bar y position
select  = { x = -100000,   y = 5 }	--the position of the "Selected Units" text
minimapscale = (viewy * iconscale / 768 * (iconsX + 1) + 20) / viewx

textBorder = 0.003
iconBorder = 0
frameBorder = 0
frameAlpha = 0.1
outlinefont = 1
textureAlpha = 1
selectGaps = 0
selectThrough = 1
frontByEnds = 1

function BuildmenuConfig(vsx, vsy)
	_,_,_,minimapY = Spring.GetMiniMapGeometry()

	ratio = vsy * iconscale / 768
	yPos = 0

	iconSizeY = ratio / vsy
	iconSizeX = ratio / vsx

	tooltipoffset = tooltipheightpercentage * vsy

	avaliableY = vsy - minimapY - tooltipoffset - 20

	iconsY = math.floor(avaliableY / ratio)

	xPos = xPos / vsx
	yPos = yPos / vsy

	xSelectPos = select.x / vsx
	ySelectPos = select.y / vsy
end



-------------- Tooltip

function TooltipConfig(vsx, vsy)
	vsx = vsx or viewx
	vsy = vsy or viewy

	mainleft = (vsy * iconscale / 768) * iconsX

	bgheight = vsy * 0.1914
	bgwidth = bgheight * 2.3

	bpx = mainleft + vsy * 0.01
	bpy = vsy * 0.015
	bpwidth = vsy * 78 / 768

	barsx = mainleft + (vsy * 0.057)
	barsy = vsy * 0.06
	barswidth = vsy * 0.08
	barsheight = vsy * 0.005
	barsicon = vsx * 0.013

	namex = mainleft + vsy * 0.16
	namey = bgheight * 0.28
	namesize = resbarfontlarge
	namecolor = {1, 1, 0.25, 1}

	descx = bpx + bpwidth + 1
	descy = bgheight * 0.46
	descwidth = math.floor(mainleft + bgwidth - descx - 5)
	descsize = resbarfontmed
	desccolor = {1, 1, 1, 1}

	resx = mainleft + vsy * 0.235
	resreqy = bgheight * 0.63
	respowery = bgheight * 0.78
	resrcolor = {0.5, 1, 1, 1}
	respcolor = {1, 1, 0.5, 1}
	resposcolor = {0, 1, 0, 1}
	resnegcolor = {1, 0.15, 0.15, 1}
	ressize = descsize
	resiconx = mainleft + bgwidth * 0.32
	resicony = vsy * 0.053
	resiconw = vsy * 0.045
	resiconh = resiconw * 0.7436
end



-------------- Tooltip
function MinimapConfig(vsx, vsy)
	minimapscale = (vsy * iconscale / 768 * iconsX) / vsx		--percentage, max width or height the minimap can be, based on screen width (default is around 0.22 I think)
	posX = 0					--x position (default: left)
	posY = vsy					--y position (default: top)
end


-------------- Command description rewrites

commands = { --while i'm going through all this effort, i may as well clean up the descriptions
	["Stop"] = {
		desc = "Cancel the unit's current actions",
		hotkeys = "S, Shift+S",
	},
	["Attack"] = {
		desc = "Attack a unit or position",
		hotkeys = "A, Shift+A",
	},
	["Wait"] = {
		desc = "Makes a unit wait before executing its commands",
		hotkeys = "W, Shift+W",
	},
	["Fire State"] = {
		desc = "Sets the conditions for a unit to fire upon enemies without an attack order",
		hotkeys = "None",
	},
	["Move State"] = {
		desc = "Sets how far the unit will move to attack enemies",
		hotkeys = "None",
	},
	["Repeat"] = {
		desc = "Sets whether the unit should repeat its command queue",
		hotkeys = "None",
	},
	["Move"] = {
		desc = "Move to a position or set a rally point for factories",
		hotkeys = "M, Shift+M",
	},
	["Patrol"] = {
		desc = "Patrol between two or more waypoints",
		hotkeys = "P, Shift+P",
	},
	["Fight"] = {
		desc = "Take action while moving to a new position",
		hotkeys = "F, Shift+F",
	},
	["Guard"] = {
		desc = "Defend another unit by attacking its attackers or repairing it",
		hotkeys = "G, Shift+G",
	},
	["Area Attack"] = {
		desc = "Attack locations in an area randomly",
		hotkeys = "Alt+A, Alt+Shift+A",
	},
	["Create a new group using the selected units and with the ai selected"] = {
		newname = "Select AI",
		desc = "Create a new group using the selected units with the selected AI",
		hotkeys = "Ctrl+Q",
	},
	["Repair level"] = {
		desc = "Sets the health percentage below which aircraft will attempt to find a repair station",
		hotkeys = "None",
	},
	["Land mode"] = {
		desc = "Sets whether aircraft should land or fly when idle",
		hotkeys = "None",
	},
	["Sets the transport to load a unit or units within an area"] = {
		newname = "Load",
		desc = "Load a unit or units in a selected area",
		hotkeys = "L, Shift+L",
	},
	["Sets the transport to unload units in an area"] = {
		newname = "Unload",
		desc = "Unload units in a selected area",
		hotkeys = "U, Shift+U",
	},
	["Active State"] = {
		desc = "Turns a unit on or off",
		hotkeys = "X, Shift+X",
	},
	["Repair"] = {
		desc = "Repairs another unit",
		hotkeys = "R, Shift+R",
	},
	["Reclaim"] = {
		--newname = "Salvage",
		desc = "Reclaims resources from wreckage or certain map features",
		hotkeys = "E, Shift+E",
	},
	["Restore"] = {
		desc = "Restores an area of the map to its original state",
		hotkeys = "None",
	},
	["Cloak State"] = {
		desc = "Cloaks or uncloaks a unit",
		hotkeys = "K, Shift+K",
	},
	["LX-3 Charge"] = {
		desc = "Plants a timed LX-3 Proton Charge on an enemy unit",
		hotkeys = "",
	},
	["Capture Flag"] = {
		desc = "Attempt to capture a Territorial Marker not in your possession",
		hotkeys = "",
	},
	["Parked status"] = {
		desc = "When parked, it cannot be moved. Moving causes 50% of its power production to be wasted",
		hotkeys = "",
	},
}
commands["Sets the aircraft to attack enemy units within a circle"] = commands["Area Attack"] --i hate lua
commands["Sets the aircraft to attack enemy units within a circle"].newname = "Area Attack"