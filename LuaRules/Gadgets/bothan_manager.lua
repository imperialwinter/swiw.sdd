--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file: bothan_manager.lua
--  brief: Manages the bothans stealing metal thing
--  author: Maelstrom
--
--  Copyright (C) 2007.
--  Licensed under the terms of the Creative Commons Attribution-Noncommercial 3.0 Unported
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--    Note:
--  Upgrade definitions are defined in 'gamedata/LuaConfigs/upgrade_defs.lua'
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name      = "Bothan Manager",
		desc      = "Makes bothans steal metal from enemy mex's",
		author    = "Maelstrom",
		date      = "4th October 2007",
		license   = "CC by-nc, version 3.0",
		layer     = -5,
		enabled   = true  --  loaded by default?
	}
end

	-- Speed ups
local GetUnitAllyTeam = Spring.GetUnitAllyTeam
local GetUnitPosition = Spring.GetUnitPosition
local GetGaiaTeamID = Spring.GetGaiaTeamID
local GetUnitsInCylinder = Spring.GetUnitsInCylinder
local GetUnitResources = Spring.GetUnitResources
local GetUnitDefID = Spring.GetUnitDefID
local AddUnitResource = Spring.AddUnitResource
local UseUnitResource = Spring.UseUnitResource
local ValidUnitID = Spring.ValidUnitID
local GetLocalAllyTeamID = Spring.GetLocalAllyTeamID

	-- Constants
local UPDATE_BOTHAN = "UpdateBothan"
local KILL_BOTHAN = "KillBothan"

local LINE_COLOUR = {0.0, 1.0, 1.0, 0.75}

if (gadgetHandler:IsSyncedCode()) then


	local BOTHAN_DEF_ID
	local WEAPON_ID
	local STEAL_RANGE
	local STEAL_RATIO
	local bothans = { }
	local stolenFrom = { }

	function gadget:Initialize()
		BOTHAN_DEF_ID = UnitDefNames["reb_i_bothan"].id
		WEAPON_ID = 1
		STEAL_RANGE = WeaponDefs[UnitDefs[BOTHAN_DEF_ID].weapons[WEAPON_ID].weaponDef].range
		STEAL_RATIO = 1 -- UnitDefs[BOTHAN_DEF_ID].customParams.stealRatio
		bothans = { }
	end

	function gadget:UnitFinished(unitID, unitDefID, teamID)
		if unitDefID == BOTHAN_DEF_ID then
			bothans[unitID] = { }
			local bothan = bothans[unitID]

			bothan.id = unitID
			bothan.allyTeamID = GetUnitAllyTeam(unitID)

			bothan.x, _, bothan.z = GetUnitPosition(unitID)

			bothan.checked = false
			bothan.needChecking = true

			bothan.mexID = -1
			bothan.mexDefID = -1
			bothan.gotMex = false
		end
	end

	local function SendBothanToUnsynced(bothan, kill)
		if kill == true then
			SendToUnsynced(KILL_BOTHAN, bothan.id)
		else
			SendToUnsynced(UPDATE_BOTHAN, bothan.id, bothan.allyTeamID, bothan.mexID, bothan.x, bothan.y, bothan.z)
		end
	end

	function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
		for bothanID, bothan in pairs(bothans) do
			if bothanID == unitID then
				SendToUnsynced("MexStealStop", bothan.mexID)
				SendBothanToUnsynced(bothan, true)
				bothans[unitID] = nil
				return

			elseif bothan.mexID == unitID then
				bothan.mexID = -1
				bothan.mexDefID = -1
				bothan.gotMex = false
				bothan.checked = false
				bothan.needChecking = true
				return
			end
		end
	end

	function gadget:GameFrame(n)
		local gaiaTeamID = GetGaiaTeamID()

			-- Loop through all our bothans
		for bothanID,bothan in pairs(bothans) do

				-- Get the bothans position
			local px, py, pz = GetUnitPosition(bothanID)

				-- If the bothan is stationary
			if (bothan.x == px) and (bothan.z == pz) then
				if bothan.checked == false then
					bothan.needChecking = true
				end

				-- The bothan is moving
			else

					-- If we still have a mex on this bothan
				if bothan.mexID ~= -1 then
					stolenFrom[bothan.mexID] = nil
					SendToUnsynced("MexStealStop", bothan.mexID)
					bothan.mexID = -1
					bothan.mexDefID = -1
					bothan.gotMex = false
					SendBothanToUnsynced(bothan, false)
				end

				bothan.checked = false
				bothan.needChecking = false
			end

			bothan.x = px
			bothan.z = pz
			bothan.y = py

				-- If we need to check for a mex, cause we dont have one.
			if bothan.needChecking then
				bothan.gotMex = false
				bothan.mexID = -1

					-- Get the units around the bothan
				local units = GetUnitsInCylinder(bothan.x, bothan.z, STEAL_RANGE)

					-- it will always be 1 or greater, cause of the bothan
				if #units > 1 then
					local make
					local use
					local metal
					local maxMetal = 0
					bothan.mexID = -1
					bothan.mexDefID = -1

						-- Finds the extractor extracting the most near the bothan
					for _,unitID in ipairs(units) do

							-- We will always find the bothan, so skip it
						if unitID ~= bothanID then

							if stolenFrom[unitID] ~= true then
								unitTeamID = GetUnitAllyTeam(unitID)

									-- If its an enemy mex (and not on gaia)
								if unitTeamID ~= bothan.allyTeamID then
									if unitTeamID ~= gaiaTeamID then

											-- Check that its not a bothan as well, stealing from a bothan is stupid :P
										if bothans[unitID] == nil then

												-- Calculate metal use/make
											make, use = GetUnitResources(unitID)
											if make ~= nil then
												if use ~= nil then
													metal = make - use
												else
													metal = make
												end

													-- If its making more metal than the last one...
												if metal > maxMetal then

														-- Set this one to be the best
													bothan.mexID = unitID
													bothan.mexDefID = GetUnitDefID(unitID)
													maxMetal = metal
												end
											end
										end
									end
								end
							end
						end
					end

						-- If we found a mex to steal from
					if bothan.mexID ~= -1 then
						bothan.gotMex = true
						stolenFrom[bothan.mexID] = true

							-- Update the unsynced side
						SendToUnsynced("MexSteal", bothan.mexID)
					end
				end

				SendBothanToUnsynced(bothan, false)

				bothan.checked = true
				bothan.needChecking = false
			end

				-- If the bothan has a mex, resource!
			if bothan.gotMex then
				local make = GetUnitResources(bothan.mexID)
				AddUnitResource(bothanID, "m", STEAL_RATIO * make / 32)
				UseUnitResource(bothan.mexID, "m", STEAL_RATIO * make / 32)
			end
		end
	end


else


	local glColor = gl.Color
	local glVertex = gl.Vertex
	local glBeginEnd = gl.BeginEnd
	local glDepthTest = gl.DepthTest
	local glLineStipple = gl.LineStipple
	local glLineWidth = gl.LineWidth
	local GL_LINES = GL.LINES

	local bothans = { }

	function gadget:Initialize()
		gadgetHandler:AddSyncAction(UPDATE_BOTHAN, UpdateBothan)
		gadgetHandler:AddSyncAction(KILL_BOTHAN, KillBothan)
	end

	function UpdateBothan(command, bothanID, allyTeamID, mexID, x, y, z)
		if bothans[bothanID] == nil then
			bothans[bothanID] = { }
		end

		local bothan = bothans[bothanID]

		bothan.id = bothanID
		bothan.allyTeamID = allyTeamID
		bothan.mexID = mexID

		bothan.x = x
		bothan.y = y
		bothan.z = z
	end

	function KillBothan(command, bothanID)
		bothans[bothanID] = nil
	end

	local function DrawLine(bX, bY, bZ, mX, mY, mZ)
		glColor(LINE_COLOUR)
		glVertex(mX, mY, mZ)
		glColor(LINE_COLOUR)
		glVertex(bX, bY, bZ)
	end

	local function DrawStealLine(bothan)
		if bothan.mexID ~= -1 and ValidUnitID(bothan.mexID) then
			local mexX, mexY, mexZ = GetUnitPosition(bothan.mexID)
			glBeginEnd(GL_LINES, DrawLine, bothan.x, bothan.y, bothan.z, mexX, mexY, mexZ)
		end
	end

	function gadget:DrawWorldPreUnit()
		local myAllyTeam = GetLocalAllyTeamID()

		glDepthTest(false)
		glLineStipple("default")
		glLineWidth(2)

		for bothanID, bothan in pairs(bothans) do
			if bothan.allyTeamID == myAllyTeam then
				DrawStealLine(bothan)
			end
		end
	end

end

