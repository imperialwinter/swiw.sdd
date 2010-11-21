function widget:GetInfo()
	return {
		name = "Capture Command rightclick",
		desc = "Enables rightclicking on flag positions to capture them",
		author = "KDR_11k (David Becker)",
		date = "2008-10-04",
		license = "Public Domain",
		layer = 25,
		enabled = true
	}
end

local flagnames, capturernames, capweapon=VFS.Include("gamedata/LuaConfigs/flag_capture_defs.lua")
local capDist=WeaponDefs[capweapon].range
local flags={}
local capturers={}

local GetCOBGlobalVar=Spring.GetCOBGlobalVar
local clickDist=60
local CMD_CAPTURE_FLAG=35981
--local flags={
--	[UnitDefNames.a_p_flag.id]=true,
--	[UnitDefNames.imp_p_flag.id]=true,
--	[UnitDefNames.reb_p_flag.id]=true,
--}

local sqrt=math.sqrt
local GetUnitDefID=Spring.GetUnitDefID
local GetUnitAllyTeam=Spring.GetUnitAllyTeam
local GetLocalAllyTeamID=Spring.GetLocalAllyTeamID
local GetMouseState=Spring.GetMouseState
local TraceScreenRay=Spring.TraceScreenRay

function widget:DefaultCommand()
	local mx,my = GetMouseState()
	local s,t = TraceScreenRay(mx,my)
	local selected=Spring.GetSelectedUnits()
	local found=false
	for i=1,#selected do --make sure we actually have a capturer selected
		if capturers[GetUnitDefID(selected[i])] then
			found=true
			break
		end
	end
	if not found then
		return false
	end
	if s == "ground" then --React to positions on the ground near flags
		local tx=t[1]
		local tz=t[3]
		for i = 1,GetCOBGlobalVar(0) do
			local x,z=GetCOBGlobalVar(i,true) --unpacked
			if sqrt((tx-x)*(tx-x) + (tz-z)*(tz-z)) < clickDist then
				return CMD_CAPTURE_FLAG
			end
		end
	elseif s == "unit" then --React to direct rightclicks (duh)
		if flags[GetUnitDefID(t)] and GetUnitAllyTeam(t) ~= GetLocalAllyTeamID() then
			return CMD_CAPTURE_FLAG
		end
	end
	return false
end

local GetUnitsInCylinder = Spring.GetUnitsInCylinder
local GetCommandQueue = Spring.GetCommandQueue
local GetUnitPosition = Spring.GetUnitPosition
local GetUnitDefID = Spring.GetUnitDefID
local GiveOrderToUnit = Spring.GiveOrderToUnit
local GetUnitVectors = Spring.GetUnitVectors

function widget:UnitFromFactory(unitID, unitDefID, unitTeam, factID, factDefID, userOrders)
	-- Scouts coming out of the imperial base with no orders should capture nearby flags
	if UnitDefs[factDefID].isCommander and (not userOrders) and capturers[unitDefID] and (#GetCommandQueue(factID) == 0) then
		local vec = GetUnitVectors(factID)
		local x,_,z = GetUnitPosition(unitID)
		x = x + (vec[1]*125)
		z = z + (vec[3]*125)
		for dist = 75,300,75 do
			local nearUnits = GetUnitsInCylinder(x,z,dist)
			for _,flagID in ipairs(nearUnits) do
				if flags[GetUnitDefID(flagID)] and (GetUnitAllyTeam(flagID) ~= GetLocalAllyTeamID()) then
					GiveOrderToUnit(unitID, CMD_CAPTURE_FLAG, {GetUnitPosition(flagID)}, {"shift"})
					return
				end
			end
		end
	end
end

function widget:Initialize()
	for _,un in pairs(flagnames) do
		flags[UnitDefNames[un].id]=true
	end
	for un,_ in pairs(capturernames) do
		capturers[UnitDefNames[un].id]=true
	end
end

