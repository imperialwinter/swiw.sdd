function gadget:GetInfo()
	return {
		name      = "Capture radius",
		desc      = "Displays the capture radius around holoflags",
		author    = "Gnome",
		date      = "April 2008",
		license   = "CC by-nc, version 3.0",
		layer     = 0,
		enabled   = false
	}
end

if (gadgetHandler:IsSyncedCode()) then

else

local weaponRange = 1

local GetAllUnits = Spring.GetAllUnits
local IsGUIHidden = Spring.IsGUIHidden
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitPosition = Spring.GetUnitPosition
local GetPositionLosState = Spring.GetPositionLosState
local GetLocalAllyTeamID = Spring.GetLocalAllyTeamID
local GetPlayerInfo = Spring.GetPlayerInfo
local GetLocalPlayerID = Spring.GetLocalPlayerID
local GetUnitTeam = Spring.GetUnitTeam
local GetTeamColor = Spring.GetTeamColor

local glColor = gl.Color
local glDepthTest = gl.DepthTest
local glDrawGroundCircle = gl.DrawGroundCircle

function gadget:Initialize()
	local flagNames, captureNames, weaponID = include("gamedata/LuaConfigs/flag_capture_defs.lua")

	local weaponDef = WeaponDefs[weaponID]
	if weaponDef ~= nil then
		weaponRange = weaponDef.range
	else
		Spring.Echo("Flag range display - Bad weapon '" .. weaponID .. "'")
	end
end

function gadget:DrawWorldPreUnit()
local ui = IsGUIHidden()
if(not ui) then
	local units = GetAllUnits()
	local _,_,spec = GetPlayerInfo(GetLocalPlayerID())
	for i=1,#units do
		local uid = units[i]
		local udid = GetUnitDefID(uid)
		local ud = UnitDefs[udid]

		if ud then
			local unitname = ud.name
			if(ud.name == 'a_p_flag' 
				or ud.name == 'imp_p_flag' or ud.name == 'imp_p_flagecon1' or ud.name == 'imp_p_flagmil1' 
				or ud.name == 'reb_p_flag' or ud.name == 'reb_p_flagecon1' or ud.name == 'reb_p_flagmil1') then

					local x, y, z = GetUnitPosition(uid)
					local los,_,_,radar = GetPositionLosState(x,y,z,GetLocalAllyTeamID())
					if(radar or los or spec) then
						local teamID = GetUnitTeam(uid)
						r,g,b,_ = GetTeamColor(teamID)
						glColor(r,g,b,0.5)
					else
						glColor(1,1,1,0.5)
					end
					if(los and (ud.name == 'imp_p_flagecon1' or ud.name == 'imp_p_flagmil1' 
						or ud.name == 'reb_p_flagecon1' or ud.name == 'reb_p_flagmil1')) then
							--do nothing
					else
							glDepthTest(true)
 							glDrawGroundCircle(x,y,z,weaponRange,32)
							glDepthTest(false)
					end
					glColor(1,1,1,1)
			end
		end
	end
end
end

end