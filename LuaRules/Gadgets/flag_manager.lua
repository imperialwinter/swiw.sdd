--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file: flag_manager.lua
--  brief: Manages the building and dying of teritory flags
--  author: Maelstrom / TheFatController
--
--  Copyright (C) 2008.
--  Licensed under the terms of the Creative Commons Attribution-Noncommercial 3.0 Unported
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--    Note:
--  Capture definitions are defined in 'gamedata/LuaConfigs/flag_capture_defs.lua'
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name      = "Flag Manager",
		desc      = "Manages flag building and dying",
		author    = "Maelstrom/TheFatController", -- modified by aegis
		date      = "02 August 2008",
		license   = "CC by-nc, version 3.0",
		layer     = -5,
		enabled   = true  --  loaded by default?
	}
end

-- Constants
local UPDATE_FLAG = "UpdateFlag"
local RESET_FLAG = "ResetFlag"
local LINE_COLOUR = {1.0, 0.25, 0.0, 0.75}
local LINE_COLOUR_REPAIR = {0.0, 0.75, 0.0, 0.75}

if (gadgetHandler:IsSyncedCode()) then

	local IMPERIAL = UnitDefNames['imp_commander'].id
	local REBEL = UnitDefNames['reb_commander'].id

	local GetUnitsInCylinder = Spring.GetUnitsInCylinder
	local CallCOBScript = Spring.CallCOBScript
	local GetUnitTransporter = Spring.GetUnitTransporter
	local SetUnitHealth = Spring.SetUnitHealth
	local GetUnitHealth = Spring.GetUnitHealth
	local GetUnitTeam = Spring.GetUnitTeam
	local GetUnitAllyTeam = Spring.GetUnitAllyTeam
	local GetTeamInfo = Spring.GetTeamInfo
	local GetUnitBasePosition = Spring.GetUnitBasePosition
	local SetUnitAlwaysVisible = Spring.SetUnitAlwaysVisible
	local DestroyUnit = Spring.DestroyUnit
	local CreateUnit = Spring.CreateUnit
	local GetGaiaTeamID = Spring.GetGaiaTeamID
	local SetUnitNeutral = Spring.SetUnitNeutral
	local GetUnitSeparation = Spring.GetUnitSeparation
	local ValidUnitID = Spring.ValidUnitID

	local weapon = {}
	local flagDefs = {}
	local captureDefs = {} 
	local captureList = {} -- list of alive units that can capture
	local cappingUnits = {} -- units that are currently capping (so they can only cap one at a time)
	local teamFactions = {}
	local weaponRange = 0
	local weaponDamage = 0
	local reloadTimeout = 0
	local badFlagNames = { upgrade = true, --right now i can't figure out why upgrade names won't set, so an upgrade is fine too
				imp_p_flagmil1 = true, imp_p_flagecon1 = true, reb_p_flagmil1 = true, reb_p_flagecon1 = true }

	function gadget:Initialize()
		local flags = { }
		_G.flags = flags

		local flagNames, captureUnits, weaponID = include("gamedata/LuaConfigs/flag_capture_defs.lua")

		for _, flagName in pairs(flagNames) do
			local def = UnitDefNames[flagName]
			if def ~= nil then
				flagDefs[def.id] = true
			else
				Spring.Echo("Flag Manager - Bad flag '" .. flagName .. "'")
			end
		end

		for captureName, multiplier in pairs(captureUnits) do
			local def = UnitDefNames[captureName]
			if def ~= nil then
				captureDefs[def.id] = multiplier
			else
				Spring.Echo("Flag Manager - Bad capture unit '" .. captureName .. "'")
			end
		end

		local weaponDef = WeaponDefs[weaponID]
		if weaponDef ~= nil then
			weaponRange = weaponDef.range
			weaponDamage = weaponDef.damages[0]
			reloadTimeout = weaponDef.reload * 32 -- measured in seconds, 32 frames per second
		else
			Spring.Echo("Flag Manager - Bad weapon '" .. weaponID .. "'")
		end

		local teamList = Spring.GetTeamList()

		for _,teamID in pairs(teamList) do
			local _,_,_,_,faction = GetTeamInfo(teamID)
			if (faction == "galactic empire") then
				teamFactions[teamID] = IMPERIAL
			else
				teamFactions[teamID] = REBEL
			end
		end
	end


	-- Checks around a flag for capture units
	function gadget:GameFrame(n)
		if(n % 32 < 1) then
			for uid, flagid in pairs(cappingUnits) do
				local sep = GetUnitSeparation(uid, flagid, true) or 10000
				if(ValidUnitID(flagid) == false or sep > weaponRange) then
					cappingUnits[uid] = nil
				end
			end
		end

		-- Loop through all our flagss
		for flagID,flag in ipairs(_G.flags) do

			-- Only run unit update every 32 frames
			if(n % 32 < 1) then
				SendToUnsynced(RESET_FLAG, flagID, flag.unitID)

				local unitList = { }
				local unitRepairList = { }
				local totalMultiplier = 0
                                
				if not badFlagNames[flag.name] then

						-- Get the units around the flag
					local units = GetUnitsInCylinder(flag.x, flag.z, weaponRange)

						-- it will always be 1 or greater, cause of the flag
					if (#units > 1) then

							-- Loop through all the units we found
						for _,unitID in ipairs(units) do
							
							-- if unit can capture and is not allied with the flags team amd not being transported
							if captureList[unitID] and (not cappingUnits[unitID] or cappingUnits[unitID] == flag.unitID) and (not GetUnitTransporter(unitID)) then
								
								if (captureList[unitID].allyID ~= flag.allyID) then
								
									-- Check if it is able to capture right now (ie it isnt shooting)
									local _, canCapture = CallCOBScript(unitID, "CanCapture", 1, 1)
									if (canCapture ~= 0) then
										-- It can capture, so add it to the list
										table.insert(unitList,unitID)
										cappingUnits[unitID] = flag.unitID
										-- and update the total captue multiplier

										totalMultiplier = totalMultiplier + captureDefs[captureList[unitID].unitDefID]
										SendToUnsynced(UPDATE_FLAG, flagID, unitID)
									end

								else -- repair the flag
									local _, canCapture = CallCOBScript(unitID, "CanCapture", 1, 1)
									if (canCapture ~= 0) then
										-- It can capture, so add it to the list
										table.insert(unitRepairList,unitID)

										-- and update the total capture multiplier

										totalMultiplier = totalMultiplier + captureDefs[captureList[unitID].unitDefID]
										SendToUnsynced(UPDATE_FLAG, flagID, unitID)
									end
								end
							end
						end
					end

					flag.unitList = unitList
					flag.multiplier = totalMultiplier
					flag.unitRepairList = unitRepairList

				end
			end

					-- Damage the unit and send it off to unsynced
			if #flag.unitList > 0 then
				local damage = weaponDamage * flag.multiplier
				local health = GetUnitHealth(flag.unitID)
				if (health ~= nil) then
					if (health - damage) > 1 then
						SetUnitHealth(flag.unitID, health - damage)
					else
						local captureTeamID = GetUnitTeam(flag.unitList[1])

						DestroyUnit(flag.unitID, false, true, flag.unitID)

						if (flag.name == "imp_p_flag") or (flag.name == "reb_p_flag") then
							flag.unitID = CreateUnit("a_p_flag", flag.x, 0, flag.z, 0, GetGaiaTeamID())
							SetUnitNeutral(flag.unitID,true)
							flag.allyID = -1
							flag.name = "a_p_flag"
						elseif (teamFactions[captureTeamID] == IMPERIAL) then
							flag.unitID = CreateUnit("imp_p_flag", flag.x, 0, flag.z, 0, captureTeamID)
							SetUnitNeutral(flag.unitID,true)
							flag.allyID = GetUnitAllyTeam(flag.unitID)
							flag.name = "imp_p_flag"
						else
							flag.unitID = CreateUnit("reb_p_flag", flag.x, 0, flag.z, 0, captureTeamID)
							SetUnitNeutral(flag.unitID,true)
							flag.allyID = GetUnitAllyTeam(flag.unitID)
							flag.name = "reb_p_flag"
						end

						flag.unitList = {}
					end
				end
			end

			if #flag.unitRepairList > 0 then
				local repair = weaponDamage * flag.multiplier
				local health, maxHealth = GetUnitHealth(flag.unitID)
				if health and (health < maxHealth) then
				    local newHealth = math.min((health + repair), maxHealth)
					if newHealth > 1 then
						SetUnitHealth(flag.unitID, newHealth)
					end
				end
			end
		end
	end

	function gadget:UnitFinished(unitID, unitDefID, unitTeam)
		if captureDefs[unitDefID] then
			captureList[unitID] = {unitID = unitID, unitDefID = unitDefID, allyID = GetUnitAllyTeam(unitID)}
		end
		if unitDefID == IMPERIAL then
			teamFactions[unitTeam] = IMPERIAL
		elseif unitDefID == REBEL then
			teamFactions[unitTeam] = REBEL
		end
	end

	function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
		if captureDefs[unitDefID] then
			captureList[unitID] = nil
		end	
	end

	function gadget:AllowUnitTransfer(unitID, unitDefID, oldTeam, newTeam, capture)
		if captureList[unitID] then
			local _,_,_,_,_,newAllyID = GetTeamInfo(newTeam)
			captureList[unitID].allyID = newAllyID
		end
		return true
	end


else

	local IsUnitVisible = Spring.IsUnitVisible
	local GetUnitPosition = Spring.GetUnitPosition
	local GetUnitHealth = Spring.GetUnitHealth
	local GetUnitAllyTeam = Spring.GetUnitAllyTeam
	local GetLocalAllyTeamID = Spring.GetLocalAllyTeamID
	local GetLocalTeamID = Spring.GetLocalTeamID
	local glColor = gl.Color
	local glVertex = gl.Vertex
	local glBeginEnd = gl.BeginEnd
	local glDepthTest = gl.DepthTest
	local glLineStipple = gl.LineStipple
	local glLineWidth = gl.LineWidth
	local GL_LINES = GL.LINES

	local flags = { }
	local captureList = ""


	function gadget:Initialize()
		gadgetHandler:AddSyncAction(UPDATE_FLAG, UpdateFlag)
		gadgetHandler:AddSyncAction(RESET_FLAG, ResetFlag)

		local _,captureUnits,_ = include("gamedata/LuaConfigs/flag_capture_defs.lua")

		for captureName, multiplier in pairs(captureUnits) do
			local def = UnitDefNames[captureName]
			if def ~= nil then
				captureList = captureList .. captureName .. "," .. multiplier .. "\n" 
			else
				Spring.Echo("Flag Manager - Bad capture unit '" .. captureName .. "'")
			end
		end
	end

	function gadget:AICallIn(str)
		return captureList
	end


	function ResetFlag(command, flagID, flagUnitID)
		flags[flagID] = {unitID = flagUnitID}
	end


		-- Adds a capture units to a flags list
	function UpdateFlag(command, flagID, captureID)
		table.insert(flags[flagID], captureID)
	end


		-- Draws a line between two points
	local function DrawLine(bX, bY, bZ, mX, mY, mZ)
		if bX == nil or mX == nil then
			return
		end
		glColor(LINE_COLOUR)
		glVertex(bX, bY, bZ)
		glColor(LINE_COLOUR)
		glVertex(mX, mY, mZ)
	end

	local function DrawRepairLine(bX, bY, bZ, mX, mY, mZ)
		if bX == nil or mX == nil then
			return
		end
		glColor(LINE_COLOUR_REPAIR)
		glVertex(mX, mY, mZ)
		glColor(LINE_COLOUR_REPAIR)
		glVertex(bX, bY, bZ)
	end

		-- Draw the lines between the flag and capture units
	local function DrawCaptureLines(unitID, captureUnits)

		local flaghp,flagmaxhp,_,_,_ = GetUnitHealth(unitID)
		if(flaghp ~= flagmaxhp) then
			for _, captureID in ipairs(captureUnits) do
				local flagVisible = IsUnitVisible(unitID)
				local capperVisible = IsUnitVisible(captureID)
				if flagVisible or capperVisible then
					local flagteam = GetUnitAllyTeam(unitID)
					local capteam = GetUnitAllyTeam(captureID)
					local captureX, captureY, captureZ = GetUnitPosition(captureID)
					local flagX, flagY, flagZ = GetUnitPosition(unitID)
					if(flagteam == capteam) then
						glBeginEnd(GL_LINES, DrawRepairLine, flagX, flagY, flagZ, captureX, captureY, captureZ)
					else
						glBeginEnd(GL_LINES, DrawLine, flagX, flagY, flagZ, captureX, captureY, captureZ)
					end
				end
			end
		end

	end


	function gadget:DrawWorldPreUnit()
		
		local myAllyTeam = GetLocalAllyTeamID()
		local myTeam = GetLocalTeamID()

		glDepthTest(false)
		glLineStipple("default")
		glLineWidth(2)

			-- Loop through the flags and draw them
		CallAsTeam(myTeam, function()
			for _, flag in pairs(flags) do
				DrawCaptureLines(flag.unitID, flag)
			end
		end)

	end

end

