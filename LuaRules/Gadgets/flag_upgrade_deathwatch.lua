function gadget:GetInfo()
	return {
		name      = "Flag upgrade death watch",
		desc      = "Spawns an appropriate flag when an upgraded flag is killed",
		author    = "Gnome",
		date      = "November 2008",
		license   = "PD",
		layer     = 0,
		enabled   = true
	}
end

if (gadgetHandler:IsSyncedCode()) then

local upgrades = {
	imp_p_flagecon1 = "imp_p_flag",
	imp_p_flagmil1 = "imp_p_flag",
	reb_p_flagecon1 = "reb_p_flag",
	reb_p_flagmil1 = "reb_p_flag",
}

local toSpawn = {}

function gadget:UnitDestroyed(uid, udid, tid, aid, adid, atid)
	local name = UnitDefs[udid].name
	if(upgrades[name]) then
		local x,y,z = Spring.GetUnitBasePosition(uid)
		toSpawn[uid] = { x = x, y = y, z = z, team = tid, uid = uid, flag = upgrades[name] }
	end
end

function gadget:GameFrame(n)
	for i,defs in pairs(toSpawn) do
		local flagID = Spring.CreateUnit(defs.flag, defs.x, 0, defs.z, 0, defs.team)
		Spring.SetUnitNeutral(flagID,true)
		Spring.SetUnitBlocking(flagID,true)

		local flag
		for _,f in ipairs(_G.flags) do 
			if f.unitID == defs.uid then flag = f end
		end

		if flag ~= nil then
			flag.unitID = flagID
			flag.name = defs.flag
		end

		toSpawn[i] = nil
	end
end

end