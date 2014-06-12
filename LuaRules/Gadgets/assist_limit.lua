function gadget:GetInfo()
	return {
		name = "No Assist",
		desc = "Disables assist",
		author = "KDR_11k (David Becker)",
		date = "2008-11-13",
		license = "Public Domain",
		layer = 1,
		enabled = true
	}
end

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local cons={}
local canBuild={}
local toBeKicked={}

local function KickBuilder(u,bd)
	toBeKicked[u]=bd
end

local function CheckBuilder(u)
	if cons[u] then
		if Spring.GetUnitIsBuilding(cons[u]) == u then
			return cons[u]
		else
			cons[u]=nil
			return false
		end
	else
		return false
	end
end

function gadget:AllowUnitBuildStep(bu, bteam, u, ud, part)
	if part > 0 then --otherwise it's a reclaim or a keepalive or whatever
		local bud = Spring.GetUnitDefID(bu)
		if canBuild[bud][ud] then
			if (CheckBuilder(u) or bu) == bu then
				cons[u]=bu
				return true
			else
				KickBuilder(bu,ud)
				return false
			end
		else
			KickBuilder(bu,ud)
			return false
		end
	end
	return true
end

function gadget:AllowCommand(u,ud,team,cmd,param,opt)
	if cmd == CMD.REPAIR and (CheckBuilder(param[1]) or u) ~= u then
		return false
	end
	return true
end

function gadget:UnitDestroyed(u, ud, team)
	cons[u]=nil
end

function gadget:UnitFinished(u,ud,team)
	cons[u]=nil
end

function gadget:Initialize()
	for ud,d in pairs(UnitDefs) do
		local c={}
		for _,bud in pairs(d.buildOptions) do
			c[bud]=true
		end
		canBuild[ud]=c
	end
end

function gadget:GameFrame(f)
	for u,bd in pairs(toBeKicked) do
		Spring.GiveOrderToUnit(u,CMD.REMOVE,{-bd,CMD.REPAIR},{"alt"})
		toBeKicked[u]=nil
	end
end

else

--UNSYNCED

return false

end
