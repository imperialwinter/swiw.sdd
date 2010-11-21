--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file: fake_mexes.lua
--  brief: Lets units which dont usually extract, extract
--  author: Maelstrom / TheFatController
--
--  Copyright (C) 2008.
--  Licensed under the terms of the Creative Commons Attribution-Noncommercial 3.0 Unported
--  The idea for this script was borrowed from jK's mobMex script.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--    Note:
--  Fake mex definitions are defined in 'gamedata/LuaConfigs/mex_defs.lua'
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name      = "Fake Mex",
		desc      = "Makes units that cant extract, extract",
		author    = "Maelstrom / TheFatController",
		date      = "02 August 2008",
		license   = "CC by-nc, version 3.0",
		layer     = -5,
		enabled   = true  --  loaded by default?
	}
end


if (not gadgetHandler:IsSyncedCode()) then
  return
end

-- Speed ups
local CreateUnit          = Spring.CreateUnit
local DestroyUnit         = Spring.DestroyUnit
local GetGaiaTeamID       = Spring.GetGaiaTeamID
local GetUnitBasePosition = Spring.GetUnitBasePosition
local GetUnitResources    = Spring.GetUnitResources
local GetUnitBuildFacing  = Spring.GetUnitBuildFacing
local SetUnitHealth       = Spring.SetUnitHealth
local SetUnitMaxHealth    = Spring.SetUnitMaxHealth
local SetUnitNeutral      = Spring.SetUnitNeutral
local SetUnitNoDraw       = Spring.SetUnitNoDraw
local SetUnitNoMinimap    = Spring.SetUnitNoMinimap
local SetUnitNoSelect     = Spring.SetUnitNoSelect
local SetUnitResourcing   = Spring.SetUnitResourcing
	
local mexDefs = {}
local watchList = {}
local idleList = {}
local spawnList = {}
local deathList = {}
local gaiaID
	
function gadget:Initialize()
  local rawMexDefs = include("gamedata/LuaConfigs/mex_defs.lua")
  for unitname, mexDef in pairs(rawMexDefs) do
    local unitDefID = UnitDefNames[unitname].id
    local mexDefID = UnitDefNames[mexDef.name].id
    if unitDefID then
      if mexDefID then
        mexDefs[unitDefID] = mexDef.name
      else
        Spring.Echo("Fake Mexes - Bad mex name in def file: " .. mexDef.name)
      end
    else
      Spring.Echo("Fake Mexes - Bad unit name in def file: " .. unitname)
    end
  end
end
	
	
function gadget:GameFrame(n)
  for uid,def in pairs(deathList) do
    if watchList[uid] then
      DestroyUnit(watchList[uid], false, true)
      watchList[uid] = nil
    end
    if idleList[uid] then
      DestroyUnit(idleList[uid], false, true)
      idleList[uid] = nil
    end
    deathList[uid] = nil
  end

  for unitID,mex in pairs(watchList) do
    local metal,_,_,drain = GetUnitResources(mex.unitID)
    Spring.AddTeamResource(gaiaID,"e",10000)
    if (mex.lastM ~= metal) then
      mex.counter = 0
      mex.lastM = metal
      SetUnitResourcing(unitID, { cmm = (metal*2), cue = (drain*2)})
    else
      mex.counter = (mex.counter + 1)
      if (mex.counter > 180) then
        watchList[unitID] = nil
        idleList[unitID] = mex.unitID
        SetUnitResourcing(mex.unitID, {ume = (drain*2)})
      end
    end
  end

  for i,defs in pairs(spawnList) do
    local fakeMex = CreateUnit(defs.name,defs.x,defs.y,defs.z,defs.heading,gaiaID)
    SetUnitNoSelect(fakeMex,true)
    SetUnitNeutral(fakeMex,true)
    SetUnitNoMinimap(fakeMex,true)
    SetUnitNoDraw(fakeMex,true)
    SetUnitMaxHealth(fakeMex,1000000)
    SetUnitHealth(fakeMex,1000000)
    watchList[defs.parent] = { unitID = fakeMex, counter=0, lastM = 0 }
    spawnList[i] = nil
  end
end
	
function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
    deathList[unitID] = unitID
end

function gadget:UnitFinished(unitID, unitDefID, teamID)
  if mexDefs[unitDefID] then
    gaiaID = GetGaiaTeamID()
    local x, y, z = GetUnitBasePosition(unitID)
    local heading = GetUnitBuildFacing(unitID)
    table.insert(spawnList, {name=mexDefs[unitDefID], x=x, y=y, z=z, heading = heading, parent=unitID})
  end
end