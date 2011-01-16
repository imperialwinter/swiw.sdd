--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file: hq_guard_manager.lua
--  brief: Manages the Royal Guards around the Imperial HQ
--  author: Maelstrom
--
--  Copyright (C) 2007.
--  Licensed under the terms of the Creative Commons Attribution-Noncommercial 3.0 Unported
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--    Note:
--  Guard information is defined in 'gamedata/LuaConfigs/hq_guard_defs.lua'
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name      = "HQ Royal Guard Manager",
		desc      = "Manages the Royal Guards around the Imperial HQ",
		author    = "Maelstrom/TheFatController",
		date      = "31st July 2007",
		license   = "CC by-nc, version 3.0",
		layer     = -5,
		enabled   = true  --  loaded by default?
	}
end

	-- Constants
local MAX_GUARDS = 0
local SPAWN_WAIT = 0
local SPAWN_DIST = 0
local SPAWN_DIST_RAND = 0
local ATTACK_RESET = 0
local GUARD_NAME = ''
local HQ_NAME = ''
local GUARD_SPEED = 0

	-- Speed Up
local GetTeamUnits     = Spring.GetTeamUnits
local GetUnitDefID     = Spring.GetUnitDefID

if (gadgetHandler:IsSyncedCode()) then
	
	local HQ_DEF_ID = 0
	local HQ_GUARD_ID = 0
	
	
		-- Variables
	--[[
	
		HQ array structure:
	HQ[unitID] = {
		x = 0, y = 0, z = 0,
		teamID = 0,
		guards = { },
		lastSpawn = 0
	}
	
	]]--
	
	local HQ = { }
	local guardList = { }
	
	local function AddHQ(unitID, teamID)
			-- Set up the HQ array, and fill it with data
		HQ[unitID] = { }
		HQ[unitID].x, HQ[unitID].y, HQ[unitID].z = Spring.GetUnitBasePosition(unitID)
		HQ[unitID].teamID = teamID
		HQ[unitID].guards = { }
		HQ[unitID].numGuards = 0
		HQ[unitID].lastSpawn = 0
		HQ[unitID].lastAttack = ATTACK_RESET
		HQ[unitID].lastShuffle = Spring.GetGameFrame()
		HQ[unitID].posData = posData[Spring.GetUnitBuildFacing(unitID)]
	end
	
	local function RemoveHQ(unitID)
		HQ[unitID] = nil
	end
	
	local function TakeCover(HQ)
		HQ.lastSpawn = 0
		HQ.lastAttack = 0
	end
	
	local function SendToPositions(HQ)
		local guardID
		for i = 1, MAX_GUARDS do
			guardID = HQ.guards[i]
			if guardID ~= nil then
				local moveX = HQ.x + HQ.posData[i].x
				local moveZ = HQ.z + HQ.posData[i].z
				local moveY = Spring.GetGroundHeight(moveX,moveZ)
				Spring.GiveOrderToUnit(guardID, CMD.MOVE, {moveX, moveY, moveZ}, 0)
				Spring.GiveOrderToUnit(guardID, CMD.SET_WANTED_MAX_SPEED, {[1] = GUARD_SPEED}, 16)
			end
		end
	end
	
	function gadget:GameFrame(n)
			-- Run every slowupdate
		if ((n+1)%32)<1 then
				-- Loops through the HQ table
			for HQID, HQData in pairs(HQ) do
				
				if HQData.lastAttack ~= ATTACK_RESET then
					HQData.lastAttack = HQData.lastAttack + 1
					if HQData.lastAttack == ATTACK_RESET then
						SendToPositions(HQData)
					end
				else
						-- This HQ is missing a guard
					if HQData.numGuards < MAX_GUARDS then
						
							-- Increments last spawn
						HQData.lastSpawn = HQData.lastSpawn + 1
						
							-- If sufficient time has past to spawn a new unit
						if HQData.lastSpawn > SPAWN_WAIT then
							
								-- Spawns a new unit, and adds it to the guards table
							
							local dir = math.random() * 2 * math.pi
							local dist = math.random(SPAWN_DIST - SPAWN_DIST_RAND, SPAWN_DIST + SPAWN_DIST_RAND)
							
							local spawnX = HQData.x + math.floor(math.cos(dir) * dist)
							local spawnZ = HQData.z + math.floor(math.sin(dir) * dist)
							local spawnY = Spring.GetGroundHeight(spawnX,spawnZ)
							local newUnit = Spring.CreateUnit(GUARD_NAME, spawnX, spawnY, spawnZ, 0, HQData.teamID)
							Spring.SetUnitNoSelect(newUnit, true)
							guardList[newUnit] = true
							
							for i = 1, MAX_GUARDS do
								if HQData.guards[i] == nil then
									HQData.guards[i] = newUnit
									break
								end
							end
							
							SendToPositions(HQData)
							
							HQData.numGuards = HQData.numGuards + 1
							HQData.lastSpawn = 0
						end
					end
				end
				if ((n - HQData.lastShuffle) > 1400) then
					if (HQData.numGuards == 6) then
						local tempGuard = HQData.guards[HQData.numGuards]
						HQData.guards[HQData.numGuards] = nil
						table.insert(HQData.guards,1,tempGuard)
						HQData.lastShuffle = n
						SendToPositions(HQData)
					else
						HQData.lastShuffle = n
						SendToPositions(HQData)
					end
				end
			end
		end
	end
	
	
		-- Detects when a guard or HQ dies
	function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
		
			-- If it was a HQ that died
		if (HQ[unitID] ~= nil) or (unitDefID == GUARD_DEF_ID) then
			guardList[unitID] = nil
				-- Loops through the HQ's
			for HQID, HQData in pairs(HQ) do
					-- If ID's match, remove it from the function
				if HQID == unitID then
					
					for i = 1, MAX_GUARDS do
						if HQData.guards[i] ~= nil then
							Spring.SetUnitNoSelect(HQData.guards[i], false)
						end
					end
					
					RemoveHQ(unitID)
				else
						--they didnt match, loop through to check the guards
					for i = 1, MAX_GUARDS do
						if HQData.guards[i] == unitID then
							HQData.guards[i] = nil
							HQData.lastSpawn = 0
							HQData.numGuards = HQData.numGuards - 1
						end
					end
				end
			end
		end
	end
	
	
		-- Tells the guards to take cover if they or their HQ is attacked
	function gadget:UnitDamaged(unitID, unitDefID, unitTeam, _, _, _, _, _)
		if (HQ[unitID] ~= nil) then
			for HQID, HQData in pairs(HQ) do
				if (HQID == unitID) then
					TakeCover(HQData)
				end
			end
		elseif (unitDefID == GUARD_DEF_ID)  then
			for _, HQData in pairs(HQ) do
				for i = 1, MAX_GUARDS do
					if HQData.guards[i] == unitID then
						TakeCover(HQData)
					end
				end
			end
		end
	end
	
	
	
	function HQ_GUARD_IDUpdate(IDs)
		RemoveHQ(IDs.newID)
		AddHQ(IDs.newID, Spring.GetUnitTeam(IDs.newID))
		HQ[IDs.newID].guards = HQ[IDs.oldID].guards
		HQ[IDs.newID].numGuards = HQ[IDs.oldID].numGuards
		HQ[IDs.newID].lastSpawn = HQ[IDs.oldID].lastSpawn
		HQ[IDs.newID].lastAttack = HQ[IDs.oldID].lastAttack
		RemoveHQ(IDs.oldID)
		return "foo" .. IDs.oldID
	end
	
	function gadget:Initialize()
		
			-- Initialises some stuff
		
		local config = include('gamedata/LuaConfigs/HQ_guard_defs.lua')
		MAX_GUARDS = config.MAX_GUARDS
		SPAWN_WAIT = config.SPAWN_WAIT
		SPAWN_DIST = config.SPAWN_DIST
		SPAWN_DIST_RAND = config.SPAWN_DIST_RAND
		ATTACK_RESET = config.ATTACK_RESET
		GUARD_NAME = config.GUARD_NAME
		HQ_NAME = config.HQ_NAME
		
		posData = config.posData
		
		--math.randomseed( os.time() )
		GG.gHQIDUpdate = HQIDUpdate
		HQ_DEF_ID = UnitDefNames[HQ_NAME].id
		GUARD_DEF_ID = UnitDefNames[GUARD_NAME].id
		GUARD_SPEED = UnitDefs[GUARD_DEF_ID].speed/30
		
		gadgetHandler:RegisterGlobal('HQ_GUARD_IDUpdate', HQ_GUARD_IDUpdate)
		
			-- Loops through the units, calling g:UnitCreated() on each of them
		for _, unitID in ipairs(Spring.GetAllUnits()) do
			local teamID = Spring.GetUnitTeam(unitID)
			local unitDefID = GetUnitDefID(unitID)
			gadget:UnitCreated(unitID, unitDefID, teamID)
		end
	end
	
		-- Adds a HQ to the HQ table, if a HQ has been created
	function gadget:UnitFinished(unitID, unitDefID, teamID)
		if unitDefID == HQ_DEF_ID then
			if HQ[unitID] == nil then
				AddHQ(unitID, teamID)
			end
		end
	end
	
	function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions, cmdTag, synced)
		if guardList[unitID] and (not synced) then
			return false
		end
		return true
	end

end
