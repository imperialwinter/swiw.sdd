function widget:GetInfo()
	return {
		name      = "IW/Resource Bar v3",
		desc      = "Replaces default resource bar with SW:IW version",
		author    = "Gnome",
		date      = "October 2008", -- last update March 1 2009
		license   = "PD",
		layer     = -5,
		enabled   = true  --  loaded by default?
	}
end

-------------- speedups

local IsGUIHidden = Spring.IsGUIHidden
local GetTeamResources = Spring.GetTeamResources
local MakeFont = Spring.MakeFont
local GetLocalTeamID = Spring.GetLocalTeamID
local GetTeamInfo = Spring.GetTeamInfo
local GetTeamList = Spring.GetTeamList

local insert = table.insert
local floor = math.floor
local min = math.min
local max = math.max

local fhUseFont = fontHandler.UseFont
local fhDraw = fontHandler.Draw
local fhDrawRight = fontHandler.DrawRight
local stformat = string.format
local stsub = string.sub

local glColor = gl.Color
local glTexture = gl.Texture
local glTexRect = gl.TexRect







-------------- some initialization

include("Config/iwui.config.lua")
local vsx, vsy = widgetHandler:GetViewSizes()
local shareResource = nil
local numAllies = 0
local allyExpand = true
local allyExpandHover = false







-------------- initialization/setup functions

function widget:ViewResize(viewSizeX, viewSizeY)
	vsx = viewSizeX
	vsy = viewSizeY

	ResbarConfig(vsx,vsy)
	MakeFont(fontVirtualName,{ inData = VFS.LoadFile(fontRealName), height = resbarfontlarge, minChar = 0, maxChar = 255, outlineMode = 0, outlineRadius = 0, outlineWeight = 0})
	MakeFont(fontVirtualName,{ inData = VFS.LoadFile(fontRealName), height = resbarfontmed, minChar = 0, maxChar = 255, outlineMode = 0, outlineRadius = 0, outlineWeight = 0})
	MakeFont(fontVirtualName,{ inData = VFS.LoadFile(fontRealName), height = resbarfontsm, minChar = 0, maxChar = 255, outlineMode = 0, outlineRadius = 0, outlineWeight = 0})
end

function widget:Initialize()
	vsx, vsy = widgetHandler:GetViewSizes()
	widget:ViewResize(vsx, vsy)
	Spring.SendCommands({"resbar 0"})
end

function widget:Shutdown()
	Spring.SendCommands({"resbar 1"})
end







-------------- local functions

local function BigNumbers(value, energy)
	if(value >= 1000000) then
		value = stsub(floor(value),0,-7) .. "mil"
	elseif(value >= 10000) then
		value = stsub(floor(value),0,-4) .. "k"
	elseif(energy == true) then
		value = stformat("%.0f",value) --decimal values are unimportant on energy's scale
	else
		value = stformat("%.1f",value)
	end
	return value
end

local function UpdateResourceValues(teamID)
	local curPowerLevel,curPowerStore,curPowerDec,curPowerInc,_,curPowerShare,_,_ = GetTeamResources(teamID, 'energy')
	local curReqLevel,curReqStore,curReqDec,curReqInc,_,curReqShare,_,_ = GetTeamResources(teamID, 'metal')

	curPowerLevel = floor(curPowerLevel)
	curReqLevel = floor(curReqLevel)

	local curPowerNet = curPowerInc - curPowerDec
	local curReqNet = curReqInc - curReqDec

	local curPowerPct = curPowerLevel / curPowerStore
	local curReqPct = curReqLevel / curReqStore

	local curPowerSharePct = curPowerShare / curPowerStore

	--Spring.Echo(curReqShare..' '..curReqSharePct)

	curPowerStore = BigNumbers(curPowerStore,true)
	curPowerLevel = BigNumbers(curPowerLevel,true)
	local curPowerIncDisplay = BigNumbers(curPowerInc,true)
	local curPowerDecDisplay = BigNumbers(curPowerDec,true)

	curReqStore = BigNumbers(curReqStore,true)
	curReqLevel = BigNumbers(curReqLevel,true)
	local curReqIncDisplay = BigNumbers(curReqInc,false)
	local curReqDecDisplay = BigNumbers(curReqDec,false)

	local res = {
		power = {
			level = curPowerLevel,
			store = curPowerStore,
			net = curPowerNet,
			inc = curPowerInc,
			dec = curPowerDec,
			incDisplay = curPowerIncDisplay,
			decDisplay = curPowerDecDisplay,
			pctStored = curPowerPct,
			pctShare = curPowerShare,
		},
		req = {
			level = curReqLevel,
			store = curReqStore,
			net = curReqNet,
			inc = curReqInc,
			dec = curReqDec,
			incDisplay = curReqIncDisplay,
			decDisplay = curReqDecDisplay,
			pctStored = curReqPct,
			pctShare = curReqShare,
		},
	}

	return res
end

local function Button(x, y, x1, y1, x2, y2)
	x1 = x1 or 0
	x2 = x2 or 0
	y1 = y1 or 0
	y2 = y2 or 0
	if(x > x1 and x < x2 and y > y1 and y < y2) then
		return true
	end
	return false
end

local function ReqShareAmount(x)
	x1 = (vsx * 0.5) - resbarbarxmax
	y1 = vsy - (vsy * 0.015)
	x2 = (vsx * 0.5) - resbarbarxmin
	y2 = vsy - vsy * 0.005

	local share = (x - x1) / (x2 - x1)
	share = max(share, 0)
	share = min(share, 1)

	return share
end

local function EnergyShareAmount(x)
	x1 = (vsx * 0.5) + resbarbarxmin
	y1 = vsy - (vsy * 0.015)
	x2 = (vsx * 0.5) + resbarbarxmax
	y2 = vsy - vsy * 0.005

	local share = 1 - (x - x1) / (x2 - x1)
	share = max(share, 0)
	share = min(share, 1)

	return share
end

function widget:MousePress(x, y, button)

	x1 = vsx - allyexpandoffsetx - allyexpandbuttonw
	y1 = vsy - allyexpandoffsety - allyexpandbuttonh
	x2 = vsx - allyexpandoffsetx
	y2 = vsy - allyexpandoffsety
	local click = Button(x, y, x1, y1, x2, y2)
	if(click and numAllies > 1) then
		allyExpand = not allyExpand
		return true
	end

	x1 = (vsx * 0.5) - resbarbarxmax
	y1 = vsy - (vsy * 0.015)
	x2 = (vsx * 0.5) - resbarbarxmin
	y2 = vsy - vsy * 0.005

	shareResource = nil

	local click = Button(x, y, x1, y1, x2, y2)
	if(click) then
		shareResource = "metal"
		return true
	end

	x1 = (vsx * 0.5) + resbarbarxmin
	y1 = vsy - (vsy * 0.015)
	x2 = (vsx * 0.5) + resbarbarxmax
	y2 = vsy - vsy * 0.005

	click = Button(x, y, x1, y1, x2, y2)
	if(click) then
		shareResource = "energy"
		return true
	end

	return false
end

function widget:MouseRelease(x, y, button)
	if(shareResource) then
		if(shareResource == "metal") then
			Spring.SetShareLevel("metal", ReqShareAmount(x))
			shareResource = nil
			return true
		elseif(shareResource == "energy") then
			Spring.SetShareLevel("energy", EnergyShareAmount(x))
			shareResource = nil
			return true
		end
		shareResource = nil
	end
	return false
end

function widget:IsAbove(x, y)
	x1 = vsx - allyexpandoffsetx - allyexpandbuttonw
	y1 = vsy - allyexpandoffsety - allyexpandbuttonh
	x2 = vsx - allyexpandoffsetx
	y2 = vsy - allyexpandoffsety
	hover = Button(x, y, x1, y1, x2, y2)
	if(hover and numAllies > 1) then
		return true
	end

	x1 = (vsx * 0.5) - resbarbarxmax
	y1 = vsy - (vsy * 0.05)
	x2 = (vsx * 0.5) + (resbarbarxmax)
	y2 = vsy

	hover = Button(x, y, x1, y1, x2, y2)
	if(hover) then
		return true
	end
	return false
end

function widget:GetTooltip(x, y)
	--(vsx * 0.5) - (resbarw * 0.5), vsy - (vsy * 0.05), (vsx * 0.5) + (resbarw * 0.5), vsy


	x1 = vsx - allyexpandoffsetx - allyexpandbuttonw
	y1 = vsy - allyexpandoffsety - allyexpandbuttonh
	x2 = vsx - allyexpandoffsetx
	y2 = vsy - allyexpandoffsety
	hover = Button(x, y, x1, y1, x2, y2)
	if(hover and numAllies > 1) then
		allyExpandHover = true
		local tooltip = "UI: Ally Bar Display - Toggles whether allied resource "
				.."\nbars are shown."
		return tooltip
	end


	x1 = (vsx * 0.5) - resbarbarxmax
	y1 = vsy - (vsy * 0.05)
	x2 = vsx * 0.48
	y2 = vsy

	local hover = Button(x, y, x1, y1, x2, y2)
	if(hover) then
		local tooltip = "Resource: Requisition - Acquired by capturing territory markers with your men. "
				.."\nIncome is shown in green, expenditures in red. "
				.."\nClick on the bar to set the level at which excess Requisition will be shared to allies. "
		return tooltip
	end

	x1 = (vsx * 0.52)
	y1 = vsy - (vsy * 0.05)
	x2 = (vsx * 0.5) + (resbarbarxmax)
	y2 = vsy

	hover = Button(x, y, x1, y1, x2, y2)
	if(hover) then
		local tooltip = "Resource: Power - Produced by field generators. "
				.."\nIncome is shown in green, expenditures in red. "
				.."\nClick on the bar to set the level at which excess Power will be shared to allies. "
		return tooltip
	end


	allyExpandHover = false
	return false
end







-------------- ally bar renderer

local function DrawAllyBars(allyTeamID, number)
--NOTE: Commented out positioning in this function is the proper layout when we get everything positioned like we want it. Don't remove it.
	number = number - 1
	local offset = allyfrilloffset - (allypanelh * number) + 3

	glColor(1,1,1,1)
	glTexture('LuaUI/zui/imp/resbar/ally/panel.png')
--	glTexRect(0, allyfrilloffset + allyfrillh + (allypanelh * number) - allypanelhoffset / 2, allyfrillw, allyfrilloffset + allyfrillh + (allypanelh * number) + allypanelh + allypanelhoffset)
	glTexRect(vsx, offset, vsx - allyfrillw, offset - allypanelh * 1.3)
--	glTexRect(vsx, allyfrilloffset - (allypanelh * number) + allypanelhoffset / 2, vsx - allyfrillw, allyfrilloffset - (allypanelh * number) - allypanelh - allypanelhoffset)
	glTexture(false)

	local res = UpdateResourceValues(allyTeamID)
	local _,name,_,_,faction,ping = Spring.GetTeamInfo(allyTeamID)
	name,_,_,_,_,_,_,_,_ = Spring.GetPlayerInfo(name)
	local r,g,b = Spring.GetTeamColor(allyTeamID)
	local sidepic = "LuaUI/zui/sidepics/"

	if(faction == "rebel alliance") then sidepic = sidepic .. "rebel.png"
	else sidepic = sidepic .. "empire.png" end

	local pingpic = "LuaUI/zui/both/connection/"

	if(ping < 51) then pingpic = pingpic .. "6.png"
	elseif(ping > 50 and ping < 101) then pingpic = pingpic .. "5.png"
	elseif(ping > 100 and ping < 151) then pingpic = pingpic .. "4.png"
	elseif(ping > 150 and ping < 201) then pingpic = pingpic .. "3.png"
	elseif(ping > 200 and ping < 251) then pingpic = pingpic .. "2.png"
	else pingpic = pingpic .. "1.png" end

	glColor(1,1,1,1)
	glTexture(pingpic)
	glTexRect(vsx - allyfrillw + allysidepic * 1.5,
			offset - allysidepic * 5.5,
			vsx - allyfrillw + allysidepic * 4,
			offset - allysidepic * 4)


	glColor(r,g,b,1)

	glTexture(sidepic) -- - allypanelhoffset * 2.5
	glTexRect(vsx - allyfrillw + allysidepic * 4,
			offset - allysidepic * 3.5,
			vsx - allyfrillw + allysidepic * 1.5,
			offset - allysidepic)

--[[	glTexRect((allyfrillw * 0.417) / 2 - allysidepic * 2,
			allyfrilloffset + allyfrillh + (allypanelh * number) + allypanelh - allysidepic * 3,
			(allyfrillw * 0.417) / 2,
			allyfrilloffset + allyfrillh + (allypanelh * number) + allypanelh - allysidepic * 2 + allysidepic)
]]
	glTexture(false)

	fhUseFont(fontBaseName .. resbarfontmed)
	fhDraw(name, vsx - allyfrillw + allysidepic * 4, offset - allysidepic * 2)
	--fhDraw(name, (allyfrillw * 0.417) / 2, allyfrilloffset + allyfrillh + (allypanelh * number) + allypanelh - allypanelhoffset * 2.5)

	if(res.req.inc > res.req.dec) then
		glColor(0,1,0,1)
	else
		glColor(1,0,0,1)
	end

	if(res.req.net > 0) then res.req.net = "+" .. stformat("%.1f",res.req.net)
	else res.req.net = stformat("%.1f",res.req.net) end
		
	fhUseFont(fontBaseName .. resbarfontsm)
	fhDrawRight(res.req.net, vsx - allyfrillw + allysidepic * 8, offset - allysidepic * 3.5)
	--fhDrawRight(res.req.net, allyfrillw * 0.417, (allyfrilloffset + allyfrillh + (allypanelh * number) - allypanelhoffset / 2) + allypanelhoffset * 2.5)

	glTexture('LuaUI/zui/both/resbar/outline.png')
	glTexRect(vsx - allyfrillw + allysidepic * 8.5,
			offset - allysidepic * 2.5,
			vsx - allyfrillw + allysidepic * 8.5 + allybarw,
			offset - allysidepic * 3.5)
--[[	glTexRect(allyfrillw * 0.39 + allypanelhoffset,
			allyfrilloffset + allyfrillh + (allypanelh * number) - allypanelhoffset / 2 + allybarhoffset,
			allyfrillw * 0.39 + allypanelhoffset + allybarw,
			allyfrilloffset + allyfrillh + (allypanelh * number) - allypanelhoffset / 2 + allybarhoffset + allybarh)
]]
	glTexture(false)

	glTexture('LuaUI/zui/both/resbar/resbar.png')
	glTexRect(vsx - allyfrillw + allysidepic * 8.5,
			offset - allysidepic * 2.5,
			vsx - allyfrillw + allysidepic * 8.5 + allybarw * res.req.pctStored,
			offset - allysidepic * 3.5)
--[[	glTexRect(allyfrillw * 0.39 + allypanelhoffset,
			allyfrilloffset + allyfrillh + (allypanelh * number) - allypanelhoffset / 2 + allybarhoffset,
			allyfrillw * 0.39 + allypanelhoffset + allybarw * res.req.pctStored,
			allyfrilloffset + allyfrillh + (allypanelh * number) - allypanelhoffset / 2 + allybarhoffset + allybarh)
]]
	glTexture(false)





	if(res.power.inc > res.power.dec) then
		glColor(0,1,0,1)
	else
		glColor(1,0,0,1)
	end

	if(res.power.net > 0) then res.power.net = "+" .. stformat("%.0f",res.power.net)
	else res.power.net = stformat("%.0f",res.power.net) end
		
	fhUseFont(fontBaseName .. resbarfontsm)
	fhDrawRight(res.power.net, vsx - allyfrillw + allysidepic * 8, offset - allysidepic * 5)
	--fhDrawRight(res.power.net, allyfrillw - allypanelhoffset * 1.2, (allyfrilloffset + allyfrillh + (allypanelh * number) - allypanelhoffset / 2) + allypanelhoffset * 1.25)

	glTexture('LuaUI/zui/both/resbar/outline.png')
	glTexRect(vsx - allyfrillw + allysidepic * 8.5,
			offset - allysidepic * 4,
			vsx - allyfrillw + allysidepic * 8.5 + allybarw,
			offset - allysidepic * 5)
--[[	glTexRect(allybarwoffset,
			allyfrilloffset + allyfrillh + (allypanelh * number) - allypanelhoffset / 2 + allybarhoffset / 2,
			allybarwoffset + allybarw,
			allyfrilloffset + allyfrillh + (allypanelh * number) - allypanelhoffset / 2 + allybarhoffset / 2 + allybarh)
]]
	glTexture(false)

	glTexture('LuaUI/zui/both/resbar/resbar.png')
	glTexRect(vsx - allyfrillw + allysidepic * 8.5,
			offset - allysidepic * 4,
			vsx - allyfrillw + allysidepic * 8.5 + allybarw * res.req.pctStored,
			offset - allysidepic * 5)
--[[	glTexRect(allybarwoffset,
			allyfrilloffset + allyfrillh + (allypanelh * number) - allypanelhoffset / 2 + allybarhoffset / 2,
			allybarwoffset + allybarw * res.power.pctStored,
			allyfrilloffset + allyfrillh + (allypanelh * number) - allypanelhoffset / 2 + allybarhoffset / 2 + allybarh)
]]
	glTexture(false)
end







-------------- assemble and draw the data

local function DrawShareMarker(type, pct)
	local shareOffset = (resbarbarxmax - resbarbarxmin) * pct
	local shareWidth = vsy * 0.0039

	if(type == "metal") then
		gl.Rect((vsx * 0.5) - resbarbarxmax + shareOffset - shareWidth, vsy - (vsy * 0.015), (vsx * 0.5) - resbarbarxmax + shareOffset + shareWidth, vsy - vsy * 0.005)
		return true
	elseif(type == "energy") then
		gl.Rect((vsx * 0.5) + resbarbarxmax - shareOffset - shareWidth, vsy - (vsy * 0.015), (vsx * 0.5) + resbarbarxmax - shareOffset + shareWidth, vsy - vsy * 0.005)
		return true
	end
end

function widget:DrawScreen()
	local ui = IsGUIHidden()
	if(not ui) then
		glColor(1,1,1,1)
		glTexture('LuaUI/zui/imp/resbar/bg.png')
		glTexRect((vsx * 0.5) - (resbarw * 0.5), vsy - (vsy * 0.05), (vsx * 0.5) + (resbarw * 0.5), vsy)
		glTexture(false)

		-- Teams can change, so we need to update out team ID incase this happens
		local myTeam = GetLocalTeamID()

		local _,_,_,_,_,allyTeam = GetTeamInfo(myTeam)
		local allies = GetTeamList(allyTeam)

		local alliesNotMyself = { }

		if(#allies > 1) then
			numAllies = #allies
			glColor(1,1,1,1)
			glTexture('LuaUI/zui/imp/resbar/ally/frill.png')
			glTexRect(vsx, allyfrilloffset + allyfrillh, vsx - allyfrillw, allyfrilloffset)
			--glTexRect(0, allyfrilloffset, allyfrillw, allyfrilloffset + allyfrillh)
			glTexture(false)

			local minmax = "minimize"
			local alpha = 0.75
			if(allyExpand) then minmax = "minimize" else minmax = "maximize" end
			if(allyExpandHover) then alpha = 1 end

			glColor(1,1,1,alpha)
			glTexture('LuaUI/zui/imp/resbar/ally/' .. minmax .. '.png')
			glTexRect(vsx - allyexpandoffsetx, vsy - allyexpandoffsety - allyexpandbuttonh, vsx - allyexpandoffsetx - allyexpandbuttonw, vsy - allyexpandoffsety)
			glTexture(false)

			if(allyExpand) then
				for i=1,#allies do
					if(allies[i] ~= myTeam) then
						insert(alliesNotMyself,allies[i])
					end
				end
			end
		end
		if(alliesNotMyself) then
			for i=1,#alliesNotMyself do
				allyTeamID = alliesNotMyself[i]
				DrawAllyBars(allyTeamID,i)
			end
		end

		local res = UpdateResourceValues(myTeam)


		glColor(0,1,0,1)
		fhUseFont(fontBaseName .. resbarfontmed)
		fhDraw("+" .. res.power.incDisplay, (vsx * 0.5) + resbarbarxmin - resbarincoffset, vsy - resbarfontlarge - resbarfontmed)
		fhDrawRight("+" .. res.req.incDisplay, (vsx * 0.5) - resbarbarxmin + resbarincoffset, vsy - resbarfontlarge - resbarfontmed)

		glColor(1,0,0,1)
		fhDrawRight("-" .. res.power.decDisplay, (vsx * 0.5) + resbarbarxmin, vsy - resbarfontlarge - resbarfontmed)
		fhDraw("-" .. res.req.decDisplay, (vsx * 0.5) - resbarbarxmin, vsy - resbarfontlarge - resbarfontmed)





		if(res.req.inc > res.req.dec) then
			glColor(0,1,0,1)
		else
			glColor(1,0,0,1)
		end

		if(res.req.net > 0) then res.req.net = "+" .. stformat("%.1f",res.req.net)
		else res.req.net = stformat("%.1f",res.req.net) end

		fhUseFont(fontBaseName .. resbarfontlarge)
		fhDraw(res.req.net, (vsx * 0.5) - resbarbarxmin + resbarbarxoffset, vsy - resbarfontmed)
		
		fhUseFont(fontBaseName .. resbarfontmed)
		fhDrawRight(res.req.level, (vsx * 0.5) - resbarbarxmin - resbarbarh, vsy - resbarh * 0.6)
		fhDraw(res.req.store, (vsx * 0.5) - resbaruseoffset, vsy - resbarh * 0.6)

		glTexture('LuaUI/zui/both/resbar/resbar.png')
		glTexRect((vsx * 0.5) - resbarbarxmax + resbarbarxoffset, vsy - (vsy * 0.015), (vsx * 0.5) - resbarbarxmax + ((resbarbarxmax - resbarbarxmin) * res.req.pctStored), vsy - vsy * 0.005)
		glTexture(false)
		glTexture('LuaUI/zui/both/resbar/outline.png')
		glTexRect((vsx * 0.5) - resbarbarxmax, vsy - (vsy * 0.015), (vsx * 0.5) - resbarbarxmin, vsy - vsy * 0.005)
		glTexture(false)





		if(res.power.inc > res.power.dec) then
			glColor(0,1,0,1)
		else
			glColor(1,0,0,1)
		end

		if(res.power.net > 0) then res.power.net = "+" .. stformat("%.0f",res.power.net)
		else res.power.net = stformat("%.0f",res.power.net) end

		fhUseFont(fontBaseName .. resbarfontlarge)
		fhDrawRight(res.power.net, (vsx * 0.5) + resbarbarxmin - resbarbarxoffset, vsy - resbarfontmed)

		fhUseFont(fontBaseName .. resbarfontmed)
		fhDraw(res.power.level, (vsx * 0.5) + resbarbarxmin + resbarbarh, vsy - resbarh * 0.6)
		fhDrawRight(res.power.store, (vsx * 0.5) + resbaruseoffset, vsy - resbarh * 0.6)

		glTexture('LuaUI/zui/both/resbar/resbar.png')
		glTexRect((vsx * 0.5) + resbarbarxmax - resbarbarxoffset, vsy - (vsy * 0.015), (vsx * 0.5) + resbarbarxmax - ((resbarbarxmax - resbarbarxmin) * res.power.pctStored), vsy - vsy * 0.005)
		glTexture(false)
		glTexture('LuaUI/zui/both/resbar/outline.png')
		glTexRect((vsx * 0.5) + resbarbarxmax, vsy - (vsy * 0.015), (vsx * 0.5) + resbarbarxmin, vsy - vsy * 0.005)
		glTexture(false)

		glColor(1,1,1,1)

		glTexture('LuaUI/zui/both/resbar/border.png')
		glTexRect((vsx * 0.5) - resbarbarxmax - resbarbarh, vsy - (vsy * 0.015), (vsx * 0.5) - resbarbarxmin, vsy - vsy * 0.005)
		glTexture(false)
		glTexture('LuaUI/zui/both/resbar/border.png')
		glTexRect((vsx * 0.5) + resbarbarxmax + resbarbarh, vsy - (vsy * 0.015), (vsx * 0.5) + resbarbarxmin, vsy - vsy * 0.005)
		glTexture(false)


		glColor(1,1,1,0.75)

		DrawShareMarker("metal", res.req.pctShare)
		DrawShareMarker("energy", res.power.pctShare)


		glColor(1,1,1,1)

		if(shareResource) then
			local mx, my = Spring.GetMouseState()
			if(shareResource == "metal") then
				local shareAmount = stformat("%.0f", ReqShareAmount(mx) * 100)
				local text = "Set allied Requisition sharing minimum to " .. shareAmount .. "%"
				fhUseFont(fontBaseName .. resbarfontlarge)
				fhDraw(text, mx - 20, my - 20)

				DrawShareMarker("metal", shareAmount / 100)

			elseif(shareResource == "energy") then
				local shareAmount = stformat("%.0f", EnergyShareAmount(mx) * 100)
				local text = "Set allied Power sharing minimum to " .. shareAmount .. "%"
				fhUseFont(fontBaseName .. resbarfontlarge)
				fhDraw(text, mx - 20, my - 20)

				DrawShareMarker("energy", shareAmount / 100)
			end
		end
	end
end