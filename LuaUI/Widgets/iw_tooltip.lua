function widget:GetInfo()
	return {
		name      = "IW/Tooltip v2",
		desc      = "Custom tooltip",
		author    = "Gnome",
		date      = "October 2008",
		license   = "PD",
		layer     = 0,
		enabled   = true
	}
end

-------------- speedups

local IsGUIHidden = Spring.IsGUIHidden
local GetSelectedUnits = Spring.GetSelectedUnits
local IsUnitSelected = Spring.IsUnitSelected
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitTeam = Spring.GetUnitTeam
local GetTeamColor = Spring.GetTeamColor
local GetUnitHealth = Spring.GetUnitHealth
local GetUnitIsBuilding = Spring.GetUnitIsBuilding
local GetUnitIsTransporting = Spring.GetUnitIsTransporting
local GetUnitRulesParam = Spring.GetUnitRulesParam
local GetUnitShieldState = Spring.GetUnitShieldState
local GetCameraDirection = Spring.GetCameraDirection
local GetUnitResources = Spring.GetUnitResources
local ValidUnitID = Spring.ValidUnitID
local ValidFeatureID = Spring.ValidFeatureID
local GetFeatureDefID = Spring.GetFeatureDefID
local GetFeatureHealth = Spring.GetFeatureHealth
local GetMouseState = Spring.GetMouseState
local TraceScreenRay = Spring.TraceScreenRay
local GetCurrentTooltip = Spring.GetCurrentTooltip
local GetLocalTeamID = Spring.GetLocalTeamID

local glColor = gl.Color
local glTex = gl.Texture
local glTexRect = gl.TexRect
local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix

local fhUseFont = fontHandler.UseFont
local fhGetTextWidth = fontHandler.GetTextWidth
local fhDraw = fontHandler.Draw
local fhDrawCentered = fontHandler.DrawCentered
local fhDrawRight = fontHandler.DrawRight

local streverse = string.reverse
local stlen = string.len
local stfind = string.find
local stsub = string.sub
local stformat = string.format

local floor = math.floor
local insert = table.insert







-------------- some initialization

include("Config/iwui.config.lua")
include("Config/iwui.functions.lua")

local unitDefHumanNames = {}







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
	Spring.SendCommands({"tooltip 0"})
	for id,def in pairs(UnitDefs) do				--mousing over buildpics only gives us the name so a lookup table is necessary
		unitDefHumanNames[def.humanName .. def.energyCost .. def.metalCost .. def.buildTime] = id
	end								--costs are necessary because some imp/reb units have the same names
end

function widget:Shutdown()
	unitDefHumanNames = nil
	Spring.SendCommands({"tooltip 1"})
end







-------------- local string functions

local function GetTooltipData(tooltip, needle, length)
	local start, finish = stfind(tooltip,needle)
	if(start) then
		return stsub(tooltip, start + length, finish)
	else return false end
end

local function SplitUnitNameDesc(tooltip, ignorenl)
	local pos = stfind(tooltip," - ", 1, true)
	local pos2 = stfind(tooltip,":", 1, true)
	local newline = stfind(tooltip,"\n", 1, true)
	if(ignorenl) then newline = 10000 end
	if(pos2) then
		process = stsub(tooltip, 1, pos2) --Build: Sell: Upgrade: etc
		if(process == "Sell:") then
			name = stsub(tooltip, pos2 + 2, newline)
			desc = ''
		else
			name = stsub(tooltip, pos2 + 2, pos - 1)
			desc = stsub(tooltip, pos + 3, newline)
		end
	end
	return process, name, desc
end

local function ParseCmdType(tooltip)
	local pos = stfind(tooltip,":", 1, true)
	local newline = stfind(tooltip,"\n", 1, true)
	local cmd = tooltip
	if(pos) then
		if(newline and newline < pos) then
			cmd = stsub(tooltip, 1, newline - 1)
		else
			cmd = stsub(tooltip, 1, pos - 1)
		end
	elseif(newline) then
		cmd = stsub(tooltip, 1, newline - 1)
	end
	return cmd
end







-------------- local drawing functions

local function DrawBar(barNum, width, height, max, cur, pct, color, paralyze)
	if(pct) then
		glColor(0, 0, 0, 1)
		glTex('LuaUI/zui/bars/hp.png')
		glTexRect(barsx, barsy + (barNum * barsheight), barsx + barswidth, barsy + barsheight + (barNum * barsheight))
		glTex(false)

		glColor(color)
		glTex('LuaUI/zui/bars/hp.png')
		glTexRect(barsx + 1, barsy + (barNum * barsheight) + 1, barsx + (barswidth * pct) - 1, barsy + barsheight + (barNum * barsheight) - 1)
		glTex(false)

		if(paralyze ~= nil) then
			local parapct = paralyze / max
			if(parapct > pct) then parapct = pct end --amount of hp is more important than stun time
			glColor(0,0.75,1,1)
			glTex('LuaUI/zui/bars/hp.png')
			glTexRect(width * -0.6, (-1 + (2 * barNum)) * height, width * -0.6 + (width * (parapct * 1.6)), (1 + (2 * barNum)) * height)
			glTex(false)
		end
	end
end

local function DrawReqIcon()
	glColor(1, 1, 1, 1)
	glTex("LuaUI/zui/imp/icon_req.png")
	glTexRect(resiconx, resicony, resiconx + resiconw, resicony + resiconh)
	glTex(false)
end

local function DrawPowerIcon()
	glColor(1, 1, 1, 1)
	glTex("LuaUI/zui/imp/icon_power.png")
	glTexRect(resiconx, resicony - resiconh, resiconx + resiconw, resicony)
	glTex(false)
end







-------------- tooltip renderer

local function UnitFeatureTooltip(defs, unitbar)
	unitbar = unitbar or {}

	if(defs.buildpic) then
		glColor(1, 1, 1, 1)
		glTex("unitpics/" .. defs.buildpic)
		glTexRect(bpx, bgheight - bpy - bpwidth, bpx + bpwidth, bgheight - bpy)
		glTex(false)
		glColor(1, 1, 1, 1)
	end

	if(defs.icontype) then
		glColor(defs.r, defs.g, defs.b, 1)
		glTex("bitmaps/radar/" .. defs.icontype .. ".tga")
		glTexRect(barsx - barsicon - 2, barsy + barsheight - (barsicon / 2), barsx - 2, barsy + barsheight + (barsicon / 2))
		glTex(false)
		glColor(1, 1, 1, 1)
	end

	local counter = 0
	for bar, bardata in pairs(unitbar) do
		DrawBar(counter, barswidth, barsheight, bardata.max, bardata.cur, bardata.pct, bardata.color, bardata.paralyze)
		if(bardata.pct ~= nil) then
			counter = counter + 1
		end
	end

	if(defs.maxHP) then
		glColor(unitbar.health.color)
		fhUseFont(fontBaseName .. descsize)
		fhDraw("HP: " .. stformat("%.0f",defs.curHP) .. "/" .. stformat("%.0f",defs.maxHP), barsx - barsicon, bgheight - respowery)
	end
	if(defs.value) then
		glColor(1,1,1,1)
		fhUseFont(fontBaseName .. descsize)
		fhDraw("Value: " .. stformat("%.0f",defs.value), barsx - barsicon, bgheight - respowery - ressize)
	end

	if(defs.reqMake ~= nil and defs.reqUse ~=nil and (defs.reqMake > 0 or defs.reqUse > 0)) then
		DrawReqIcon()

		fhUseFont(fontBaseName .. descsize)
		glColor(resposcolor)
		fhDrawRight("+" .. stformat("%.1f",defs.reqMake), resx, bgheight - resreqy)
		glColor(resnegcolor)
		fhDrawRight("-" .. stformat("%.1f",defs.reqUse), resx, bgheight - resreqy - ressize)
	end
	if(defs.powerMake ~= nil and defs.powerUse ~=nil and (defs.powerMake > 0 or defs.powerUse > 0)) then
		DrawPowerIcon()

		fhUseFont(fontBaseName .. descsize)
		glColor(resposcolor)
		fhDrawRight("+" .. stformat("%.0f",defs.powerMake), resx, bgheight - respowery)
		glColor(resnegcolor)
		fhDrawRight("-" .. stformat("%.0f",defs.powerUse), resx, bgheight - respowery - ressize)
	end

	if(defs.reqCost ~= nil and defs.reqCost > 0) then
		DrawReqIcon()
		fhUseFont(fontBaseName .. descsize)
		glColor(resrcolor)
		fhDrawRight(stformat("%.0f",defs.reqCost), resx, bgheight - resreqy - (ressize + 2) / 2)
	end
	if(defs.powerCost ~= nil and defs.powerCost > 0) then
		DrawPowerIcon()
		fhUseFont(fontBaseName .. descsize)
		glColor(respcolor)
		fhDrawRight(stformat("%.0f",defs.powerCost), resx, bgheight - respowery - (ressize + 2) / 2)
	end

	if(defs.time) then
		fhUseFont(fontBaseName .. descsize)
		glColor(1,1,1,1)
		local bp = defs.builder.bp or 1
		fhDraw("ETA: " .. stformat("%.0f",tonumber(defs.time) / bp) .. " sec", barsx - barsicon, bgheight - respowery)
		glColor(0,1,0,1)
		fhDraw("HP: " .. stformat("%.0f",defs.curHP), barsx - barsicon, bgheight - respowery - ressize)

		if(defs.builder.id ~= nil) then
			local realbuildtime = defs.time / bp
			local reqDrain = defs.reqCost / realbuildtime
			local powerDrain = defs.powerCost / realbuildtime
			local teamID = GetLocalTeamID()

			local curPowerLevel,_,curPowerDec,curPowerInc = Spring.GetTeamResources(teamID, 'energy')
			local curReqLevel,_,curReqDec,curReqInc = Spring.GetTeamResources(teamID, 'metal')

			if(reqDrain + curReqDec > curReqInc) then
				if(defs.reqCost < curReqLevel) then
					glColor(1, 1, 0, 1)
				else
					glColor(resnegcolor)
				end
			else
				glColor(resposcolor)
			end

			fhUseFont(fontBaseName .. descsize)
			fhDraw("(-" .. stformat("%.1f",reqDrain) ..")", resx + resiconw * 0.5, bgheight - resreqy - (ressize + 2) / 2)

			if(powerDrain + curPowerDec > curPowerInc) then
				if(defs.powerCost < curPowerLevel) then
					glColor(1, 1, 0, 1)
				else
					glColor(resnegcolor)
				end
			else
				glColor(resposcolor)
			end

			fhUseFont(fontBaseName .. descsize)
			fhDraw("(-" .. stformat("%.0f",powerDrain) ..")", resx + resiconw * 0.5, bgheight - respowery - (ressize + 2) / 2)
		end
	end

	glColor(namecolor)
	fhUseFont(fontBaseName .. namesize)
	fhDraw(defs.name, namex, bgheight - namey)

	for linenum=1,#defs.desc do
		glColor(desccolor)
		fhUseFont(fontBaseName .. descsize)
		fhDraw(defs.desc[linenum], descx, bgheight - descy - (descsize * (linenum - 1)))
	end
end

local function RawTooltip(tooltip)
	glColor(desccolor)
	fhUseFont(fontBaseName .. descsize)
	for linenum=1,#tooltip do
		fhDraw(tooltip[linenum], descx, bgheight - descy - (descsize * (linenum - 1)))
	end
end

local function CmdTooltip(defs)
	glColor(namecolor)
	fhUseFont(fontBaseName .. namesize)
	fhDraw(defs.name, namex, bgheight - namey)

	glColor(desccolor)
	fhUseFont(fontBaseName .. descsize)
	for linenum=1,#defs.desc do
		fhDraw(defs.desc[linenum], descx, bgheight - descy - (descsize * (linenum - 1)))
	end

	if(defs.hotkeys) then
		fhDraw("Hotkeys: " .. defs.hotkeys, descx, bgheight - respowery - ressize)
	end
end

local function HandleTooltip(ids, isFeature)
	local name = nil
	local desc = {}
	defs = {}
	ids = ids or {}

	local unitbar = {
		health = {},
		build = {},
		upgrade = {},
		transport = {},
		shield = {},
	}

	if(#ids > 1) then			--handle a group of selected ids
		defs.curHP = 0
		defs.maxHP = 0
		defs.reqMake = 0
		defs.reqUse = 0
		defs.powerMake = 0
		defs.powerUse = 0
		defs.value = 0
		for i=1,#ids do
			local uid = ids[i]
			if(ValidUnitID(uid) == true) then
				local udid = GetUnitDefID(uid)
				local ud = UnitDefs[udid]
				local ucurHP,umaxHP = GetUnitHealth(uid)
				local ureqMake, ureqUse, upowerMake, upowerUse = GetUnitResources(uid)

				defs.curHP = defs.curHP + ucurHP
				defs.maxHP = defs.maxHP + umaxHP
				defs.value = defs.value + ud.metalCost

				defs.reqMake = defs.reqMake + ureqMake
				defs.reqUse = defs.reqUse + ureqUse
				defs.powerMake = defs.powerMake + upowerMake
				defs.powerUse = defs.powerUse + upowerUse

				defs.name = #ids .. " units selected"
				defs.desc = {}
				defs.icontype = nil
				if(myFaction == "rebel alliance") then
					defs.buildpic = rebBuildpic
				else
					defs.buildpic = impBuildpic
				end
			end
		end
	elseif(isFeature == true) then		--handle a feature
		local fid = ids[1]
		if(ValidFeatureID(fid) == true) then
			local fdid = GetFeatureDefID(fid)
			local fd = FeatureDefs[fdid]

			defs.curHP,defs.maxHP,defs.paradmg = GetFeatureHealth(fid)
			defs.reqCost = fd.metal
			defs.powerCost = fd.energy
			defs.name = fd.tooltip
			defs.desc = {}
		end
	else					--handle a single unit or a unit being moused over
		local uid = ids[1]
		if(ValidUnitID(uid) == true) then
			local udid = GetUnitDefID(uid)
			local ud = UnitDefs[udid]
			local teamID = GetUnitTeam(uid)

			defs.r,defs.g,defs.b = GetTeamColor(teamID)

			if(ud) then
				local unitbuildid = GetUnitIsBuilding(uid)
				local upgradeProgress = GetUnitRulesParam(uid, "upgradeProgress")
				local transportingids = GetUnitIsTransporting(uid)
				defs.curHP,defs.maxHP,defs.paradmg = GetUnitHealth(uid)
				defs.reqMake, defs.reqUse, defs.powerMake, defs.powerUse = GetUnitResources(uid)

				defs.name = ud.humanName
				defs.desc = WordWrap(ud.tooltip, descsize, descwidth)
				defs.buildpic = ud.buildpicname
				defs.icontype = ud.iconType
				defs.value = ud.metalCost

				if(ud.shieldWeaponDef) then
					local shieldwdid = ud.shieldWeaponDef
					local wd = WeaponDefs[shieldwdid]
					local sMaxPow = wd.shieldPower
					local _,sCurPow = GetUnitShieldState(uid)
					if(sCurPow) then
						unitbar.shield = {
							max = sMaxPow,
							cur = sCurPow,
							pct = sCurPow / sMaxPow,
							color = {2 * (1 - (sCurPow / sMaxPow)), (1 - (sCurPow / sMaxPow)), 2 * (sCurPow / sMaxPow), 0.8},
						}
					end
				end

				if(unitbuildid) then
					local curbHP,maxbHP,_,_,unitbuildprog = GetUnitHealth(unitbuildid)
					unitbar.build = {
						cur = curbHP,
						max = maxbHP,
						pct = curbHP / maxbHP,
						color = {1 - unitbuildprog, 1 + unitbuildprog, 0, 0.8},
					}
				end

				if(upgradeProgress ~= nil and upgradeProgress > 0) then
					unitbar.upgrade = {
						cur = 1,
						max = 100,
						pct = upgradeProgress,
						color = {1 - upgradeProgress, 1 + upgradeProgress, 0, 0.8},
					}
				end

				if(transportingids ~= nil) then
					maxtransmass = ud.transportMass
					currentmass = 0
					for i=1,#transportingids do
						transuid = transportingids[i]
						transudid = GetUnitDefID(transuid)
						currentmass = currentmass + UnitDefs[transudid].mass
					end
					if(currentmass > 0) then
						unitbar.transport = {
							max = maxtransmass,
							cur = currentmass,
							pct = currentmass / maxtransmass,
							color = {1, 1, 1, 0.8},
						}
					end
				end
			else			--unit is only visible on radar or something
				defs.name = "Enemy unit"
				defs.desc = ""
			end
		end
	end

	if(defs.maxHP) then
		unitbar.health = {
			cur = defs.curHP,
			max = defs.maxHP,
			pct = defs.curHP / defs.maxHP,
			paralyze = defs.paradmg,
			color = {2 * (1 - (defs.curHP / defs.maxHP)), 2.0 * (defs.curHP / defs.maxHP), 0, 0.8},
		}
	end

	defs.builder = { id = nil }

	UnitFeatureTooltip(defs, unitbar)
end





-------------- drawscreen

function widget:DrawScreen()
	local ui = IsGUIHidden()
	if(not ui) then
		glPushMatrix()

		glColor(1, 1, 1, 1)
		glTex("LuaUI/zui/imp/tooltip/bg_main.png")
		glTexRect(mainleft, 0, mainleft + bgwidth, bgheight)
		glTex(false)

		local renderNameBG = true
		local mx, my = GetMouseState()
		local type, id = TraceScreenRay(mx, my)
		local tooltip = GetCurrentTooltip()

--shitfest

		if(tooltip) then
			local cmdType = ParseCmdType(tooltip)
			local units = GetSelectedUnits()
			if(cmdType == "Resource" or cmdType == "UI") then
				local process, name, desc = SplitUnitNameDesc(tooltip, true)
				defs = {
					name = name,
					desc = WordWrap(string.gsub(desc,"\n"," "), descsize, descwidth),
					hotkeys = nil,
				}
				CmdTooltip(defs)
			elseif(cmdType == "Build" or cmdType == "Sell" or cmdType == "Upgrade" or cmdType == "Downgrade") then
				local process, name, desc = SplitUnitNameDesc(tooltip)
				local powerCost = tonumber(GetTooltipData(tooltip, "Energy cost %d*", 12))
				local reqCost = tonumber(GetTooltipData(tooltip, "Metal cost %d*", 11))
				local buildTime = GetTooltipData(tooltip, "Build time %d*", 11)
				if(stfind(tooltip, "Build:")) then
					armor = GetTooltipData(tooltip, "Health %d*", 7)
				else
					armor = 0
				end

				if(unitDefHumanNames[name .. powerCost .. reqCost .. buildTime]) then
					unitdefid = unitDefHumanNames[name .. powerCost .. reqCost .. buildTime]
				else
					unitdefid = UnitDefNames["imp_p_flag"].id
				end

				local builderdefs = {
					id = nil,
					defid = nil,
					bp = nil,
				}

				if(cmdType == "Build" and #units == 1) then
					builderdefs.id = units[1]
					builderdefs.defid = GetUnitDefID(builderdefs.id)
					bd = UnitDefs[builderdefs.defid]
					buildspeed = GetUnitRulesParam(builderdefs.id, "aurabuildspeed")
					if(not buildspeed or buildspeed == 0) then buildspeed = bd.buildSpeed end
					builderdefs.bp = buildspeed --need GetUnitBuildSpeed
				elseif(cmdType == "Upgrade" or cmdType == "Downgrade") then
					builderdefs.id = 1	--anything not nil here, doesn't matter
					builderdefs.bp = 1	--workertime equiv
				end
					

				local defs = {
					powerCost = powerCost,
					reqCost = reqCost,
					name = process .. " " .. name,
					desc = WordWrap(desc, descsize, descwidth),
					curHP = armor or 0,
					time = buildTime,
					buildpic = UnitDefs[unitdefid].buildpicname,
					builder = builderdefs,
				}
				UnitFeatureTooltip(defs)
			elseif(commands[cmdType]) then
				local command = commands[cmdType]
				cmddefs = {
					name = command.newname or cmdType,
					desc = WordWrap(command.desc, descsize, descwidth),
					hotkeys = command.hotkeys,
				}
				CmdTooltip(cmddefs)
			
--end shitfest

			elseif(type == 'unit') then
				HandleTooltip({id})
			elseif(type == 'feature') then
				HandleTooltip({id}, true)
			else
				if(#units > 0) then
					HandleTooltip(units)
				else
					renderNameBG = false
					RawTooltip(nl2table(tooltip, descsize, descwidth))
				end
			end

			if(renderNameBG == true) then
				glColor(1, 1, 1, 1)
				glTex("LuaUI/zui/imp/tooltip/name.png")
				glTexRect(mainleft, 0, mainleft + bgwidth, bgheight)
				glTex(false)
			end
		end

		glPopMatrix()
		glColor(1,1,1,1)
	end
end