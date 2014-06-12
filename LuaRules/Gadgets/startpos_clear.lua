--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file: startpos_clear.lua
--  brief: Removes any features around the IMP Commanders start positions, sets flags at entrance to no blocking
--  author: Maelstrom
--
--  Copyright (C) 2007.
--  Licensed under the terms of the Creative Commons Attribution-Noncommercial 3.0 Unported
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name      = "Startpos Clearer",
		desc      = "Blows shit up around the IMP Commander",
		author    = "Maelstrom/TheFatController",
		date      = "30th September 2007",
		license   = "CC by-nc, version 3.0",
		layer     = -5,
		enabled   = true  --  loaded by default?
	}
end

local COMMANDER_ID = UnitDefNames['imp_commander'].id

if (gadgetHandler:IsSyncedCode()) then

	local GetUnitPosition = Spring.GetUnitPosition
	local GetUnitsInCylinder = Spring.GetUnitsInCylinder
	local GetUnitVectors = Spring.GetUnitVectors
	local GetUnitDefID = Spring.GetUnitDefID
	local sqrt = math.sqrt

	local isFlag = {
		[UnitDefNames['a_p_flag'].id] = true,
		[UnitDefNames['imp_p_flag'].id] = true,
		[UnitDefNames['imp_p_flagecon1'].id] = true,
		[UnitDefNames['imp_p_flagmil1'].id] = true,
		[UnitDefNames['reb_p_flag'].id] = true,
		[UnitDefNames['reb_p_flagecon1'].id] = true,
		[UnitDefNames['reb_p_flagmil1'].id] = true,
	}
	
	local isImpCommander = {
		[UnitDefNames['imp_commander'].id] = true,
		[UnitDefNames['imp_com_res1'].id] = true,
		[UnitDefNames['imp_com_mil1'].id] = true,
	}
	
	function gadget:GameFrame(n)
		if(n == 1) then
			local units = Spring.GetAllUnits()
			for _,uid in ipairs(units) do
				udid = Spring.GetUnitDefID(uid)
				if(udid == COMMANDER_ID) then

					local ud = UnitDefs[COMMANDER_ID]

					local px, py, pz = GetUnitPosition(uid)

					local xmin = px - (ud.xsize * 8) / 2
					local xmax = px + (ud.xsize * 8) / 2
					local zmin = pz - (ud.zsize * 8) / 2
					local zmax = pz + (ud.zsize * 8) / 2

					local features = Spring.GetFeaturesInRectangle(xmin, zmin, xmax, zmax)
					for k,v in pairs(features) do
						Spring.DestroyFeature(v)
					end
				end
			end
			gadgetHandler:RemoveCallIn("GameFrame")
		end
	end
		
	function gadget:UnitFinished(unitID, unitDefID, unitTeam)
		if isFlag[unitDefID] then
			local x,_,z = GetUnitPosition(unitID)
			local nearUnits = GetUnitsInCylinder(x,z,150)
			for _,nearID in ipairs(nearUnits) do
				if isImpCommander[GetUnitDefID(nearID)] then
					local x2,_,z2 = GetUnitPosition(nearID)
					local vec = GetUnitVectors(nearID)
					x2 = x2 + (vec[1]*80)
					z2 = z2 + (vec[3]*80)
					if sqrt((x-x2)*(x-x2) + (z-z2)*(z-z2)) < 110 then
						Spring.SetUnitBlocking(unitID, false)
						return
					end					
				end
			end
		end
	end

end
