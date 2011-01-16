--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    game_spawn.lua
--  brief:   spawns start unit and sets storage levels
--  author:  Tobi Vollebregt
--
--  Copyright (C) 2010.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name      = "Spawn",
		desc      = "spawns start units",
		author    = "Tobi Vollebregt/TheFatController",
		date      = "January, 2010",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = true  --  loaded by default?
	}
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- synced only
if (not gadgetHandler:IsSyncedCode()) then
	return false
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local modOptions = Spring.GetModOptions()
local GetUnitPosition = Spring.GetUnitPosition

local coopMode = tonumber(Spring.GetModOptions().mo_coop) or 0

local IMPERIAL_HQ = UnitDefNames['imp_commander'].id
local startShips = {}

local function GetStartUnit(teamID)
	-- get the team startup info
	local side = select(5, Spring.GetTeamInfo(teamID))
	local startUnit
	if (side == "") then
		-- startscript didn't specify a side for this team
		local sidedata = Spring.GetSideData()
		if (sidedata and #sidedata > 0) then
			startUnit = sidedata[1 + teamID % #sidedata].startUnit
		end
	else
		startUnit = Spring.GetSideData(side)
	end
	return startUnit
end

local function SpawnStartUnit(teamID)
	local startUnit = GetStartUnit(teamID)
	if (startUnit and startUnit ~= "") then
		Spring.SetTeamResource(teamID, "ms", 20)
		Spring.SetTeamResource(teamID, "es", 20)
		-- spawn the specified start unit
		local x,y,z = Spring.GetTeamStartPosition(teamID)
		-- snap to 16x16 grid
		x, z = 16*math.floor((x+8)/16), 16*math.floor((z+8)/16)
		y = Spring.GetGroundHeight(x, z)
		-- facing toward map center
		local facing=math.abs(Game.mapSizeX/2 - x) > math.abs(Game.mapSizeZ/2 - z)
			and ((x>Game.mapSizeX/2) and "west" or "east")
			or ((z>Game.mapSizeZ/2) and "north" or "south")
		local commanderID = Spring.CreateUnit(startUnit, x, y, z, facing, teamID)
		-- set the *team's* lineage root
		Spring.SetUnitLineage(commanderID, teamID, true)
	
		-- set start resources, either from mod options or custom team keys
		local teamOptions = select(7, Spring.GetTeamInfo(teamID))
		local m = modOptions.startmetal or 1000
		local e = modOptions.startenergy or 1000

		if (m and tonumber(m) ~= 0) then
			Spring.SetUnitResourcing(commanderID, "m", 0)
			Spring.SetTeamResource(teamID, "m", 0)
			Spring.AddTeamResource(teamID, "m", tonumber(m))
		end
		
		if (e and tonumber(e) ~= 0) then
			Spring.SetUnitResourcing(commanderID, "e", 0)
			Spring.SetTeamResource(teamID, "e", 0)
			Spring.AddTeamResource(teamID, "e", tonumber(e))
		end
		
		return commanderID, facing
	end
end

function gadget:Initialize()
	local gaiaTeamID = Spring.GetGaiaTeamID()
	local teams = Spring.GetTeamList()
	for i = 1,#teams do
		local teamID = teams[i]
		if (teamID ~= gaiaTeamID) then
			Spring.SetTeamResource(teamID, "ms", 20)
			Spring.SetTeamResource(teamID, "es", 20)
		end
	end
end

function gadget:AllowCommand(u,ud,team,cmd,param,opt)
	if startShips[u] then
		return false
	end
	return true
end

function gadget:GameStart()
	local excludeTeams = {}

	if (coopMode == 1) then

		for _, teamID in ipairs(Spring.GetTeamList()) do
			local playerCount = 0
			for _, playerID in ipairs(Spring.GetPlayerList(teamID)) do
				if not select(3,Spring.GetPlayerInfo(playerID)) then
					playerCount = playerCount + 1
				end
			end
			if (playerCount > 1) then excludeTeams[teamID] = true end
		end
	
	end
	-- spawn start units
	local gaiaTeamID = Spring.GetGaiaTeamID()
	local teams = Spring.GetTeamList()
	for i = 1,#teams do
		local teamID = teams[i]
		-- don't spawn a start unit for the Gaia team
		if (teamID ~= gaiaTeamID) and (not excludeTeams[teamID]) then
			local commanderID, facing = SpawnStartUnit(teamID)
			if (Spring.GetUnitDefID(commanderID) == IMPERIAL_HQ) then
				local x,y,z = GetUnitPosition(commanderID)
				local dropUnit = Spring.CreateUnit("imp_sh_theta",x,y,z,facing,teamID)
				Spring.SetUnitNeutral(dropUnit,true)
				Spring.SetUnitNoSelect(dropUnit,true)
				Spring.MoveCtrl.Enable(dropUnit,true)
				local vx = (math.random() - 0.5)
				local vz = (math.random() - 0.5)
				Spring.MoveCtrl.SetVelocity(dropUnit,vx,2,vz)
				startShips[dropUnit] = {x=vx,y=2,z=vz}
			end
		end
	end
end

function gadget:GameFrame(n)
	for unitID,defs in pairs(startShips) do	
		startShips[unitID].y = startShips[unitID].y * 1.015
		Spring.MoveCtrl.SetVelocity(unitID,defs.x,defs.y,defs.z)
		local _,Y = GetUnitPosition(unitID)
		if Y > 15000 then
		  startShips[unitID] = nil
		  Spring.DestroyUnit(unitID,false,true)
		end
	end
end

