function gadget:GetInfo()
	return {
		name      = "Corpse spawner",
		desc      = "Spawns arbitrary corpses identified in the unit's cob",
		author    = "Maelstrom",
		date      = "2007", --converted to luarules October 2008
		license   = "PD",
		layer     = 5,
		enabled   = true  -- loaded by default?
	}
end

if (gadgetHandler:IsSyncedCode()) then

local FeatureDefNames = {}
local features = {}
local toSpawn = {}

for id,featureDef in pairs(FeatureDefs) do
	FeatureDefNames[featureDef.name] = featureDef
end

function gadget:Initialize()
	features = include("gamedata/LuaConfigs/corpse_defs.lua")
	gadgetHandler:RegisterGlobal("SpawnFeature", SpawnFeature)
	gadgetHandler:RegisterGlobal("MakeMeNoCollide", MakeMeNoCollide)
end

function SpawnFeature(uid, udid, tid, featureNum, headingOffset, corpseType)
	if(features[featureNum] ~= nil) then
		featureName = features[featureNum]
		local px, py, pz = Spring.GetUnitBasePosition(uid)
		local heading = Spring.GetUnitHeading(uid)
		table.insert(toSpawn, {name=featureName, x=px, y=py, z=pz, heading=heading, offset=headingOffset, team=tid})
	end
end

function MakeMeNoCollide(uid, udid, tid, doit)
	if(doit ~= nil) then
		Spring.SetUnitCollisionVolumeData(uid, 1, 1, 1, 0, -100000, 0, 0, 0, 0)
	end
end

function gadget:GameFrame(n)
	if(#toSpawn > 0) then
		for k,feature in ipairs(toSpawn) do
			Spring.CreateFeature(feature.name, feature.x, feature.y, feature.z, feature.heading + feature.offset, feature.team)
			toSpawn[k] = nil
		end
	end
end

end