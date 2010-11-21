function gadget:GetInfo()
	return {
		name      = "Custom Cloak Handler",
		desc      = "Changes how units decloak",
		author    = "Gnome",
		date      = "November 2009",
		license   = "PD",
		layer     = 0,
		enabled   = true
	}
end

local GetAllUnits = Spring.GetAllUnits
local GetUnitTeam = Spring.GetUnitTeam
local GetUnitDefID = Spring.GetUnitDefID
local ValidUnitID = Spring.ValidUnitID
local GetUnitPosition = Spring.GetUnitPosition
local GetUnitsInCylinder = Spring.GetUnitsInCylinder
local GetUnitStates = Spring.GetUnitStates
local SetUnitCloak = Spring.SetUnitCloak
local AreTeamsAllied = Spring.AreTeamsAllied

if (gadgetHandler:IsSyncedCode()) then

local cloakable = {}
local cloakingUnits = {}

function gadget:Initialize()
	--[[raw = include("gamedata/LuaConfigs/aura_defs.lua")
	for name,defs in pairs(raw) do
		local udid = UnitDefNames[name].id or nil
		if(udid) then auras[udid] = defs end
	end]]

	for udid=1,#UnitDefs do
		if(UnitDefs[udid].canCloak == true) then
			cloakable[udid] = true
			--Spring.Echo(UnitDefs[udid].name)
		end
	end

	-- Loops through the units, calling g:UnitFinished() on each of them
	for _,uid in ipairs(GetAllUnits()) do
		local teamID = GetUnitTeam(unitID)
		local unitDefID = GetUnitDefID(unitID)
		gadget:UnitFinished(unitID, unitDefID, teamID)
	end
end

function gadget:UnitFinished(uid, udid, tid)
	if(cloakable[udid]) then
		cloakingUnits[uid] = {udid = udid, tid = tid, cloaked = nil}
	end
end

function gadget:UnitDestroyed(uid, udid, tid, aid, adid, atid)
	if(cloakingUnits[uid]) then
		cloakingUnits[uid] = nil
	end
end

function gadget:GameFrame(n)
	if(n % 15 < 1) then
		for uid,cdat in pairs(cloakingUnits) do
			local states = GetUnitStates(uid)
			local cloaked = states.cloak

			if(cloaked == true) and (cdat.cloaked == false) then
				SetUnitCloak(uid, true, 0)
				cloakingUnits[uid].cloaked = true
			end

			local ux, uy, uz = GetUnitPosition(uid)
			local ud = UnitDefs[cdat.udid]
			local team = cdat.tid
			local decloakDistance = ud.customParams.decloakdistance or 500

			local nearbyUnits = GetUnitsInCylinder(ux,uz,decloakDistance)

			if(nearbyUnits) then
				for _,nid in ipairs(nearbyUnits) do

					if(ValidUnitID(nid) and nid ~= uid) then
						local nteam = GetUnitTeam(nid)
						local areAllied = AreTeamsAllied(team, nteam)
						if(nteam ~= team and areAllied == false) then
							local ndid = GetUnitDefID(nid)
							if(UnitDefs[ndid].canMove == true) then
								SetUnitCloak(uid, false, decloakDistance)
								cloakingUnits[uid].cloaked = false
							end
						end
					end
				end
			end
		end
	end
end

end -- end synced