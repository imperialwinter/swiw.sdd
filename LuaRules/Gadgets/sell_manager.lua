--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file: sell_manager.lua
--  brief: Sells units
--  author: Maelstrom
--
--  Copyright (C) 2007.
--  Licensed under the terms of the Creative Commons Attribution-Noncommercial 3.0 Unported
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--    Note:
--  Sell definitions are defined in 'gamedata/LuaConfigs/sell_defs.lua'
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name      = "Sell Units",
		desc      = "Sells units",
		author    = "Maelstrom",
		date      = "10th December 2007",
		license   = "CC by-nc, version 3.0",
		layer     = -5,
		enabled   = true  --  loaded by default?
	}
end

	-- Constants

local CMD_SELL = 31139
local ADD_BAR = "AddBar"
local SET_BAR = "SetBar"
local REMOVE_BAR = "RemoveBar"

if (gadgetHandler:IsSyncedCode()) then
	
	
	
	local sellDefs = { }
	local sellUnits = { }
	
	
	
	local function checkSellDefs(rawSellDefs)
		
		sellDefs = { }
		
		for unitDefName, sellDef in pairs(rawSellDefs) do
			
			local udSrc = UnitDefNames[unitDefName]
			local udID = udSrc.id
			sellDefs[udID] = { }
			
			sellDef.name = unitDefName
			sellDef.id = udID
			sellDef.ud = udSrc
			
			if sellDef.time <= 0 then
				sellDef.increment = 1
			else
				sellDef.increment = (1 / (32 * sellDef.time))
			end
			
			sellDef.resTable = { }
			
			if (sellDef.metal ~= nil) then
				sellDef.resTable.m = sellDef.metal
			else
				sellDef.resTable.m = udSrc.metalCost * sellDef.returnMult
			end
			
			if (sellDef.energy ~= nil) then
				sellDef.resTable.e = sellDef.energy
			else
				sellDef.resTable.e = udSrc.energyCost * sellDef.returnMult
			end
			
			sellDefs[udID] = sellDef
			
		end
		
	end
	
	
	
	function gadget:Initialize()
		
		sellDefs = { }
		local rawSellDefs = include("gamedata/LuaConfigs/sell_defs.lua")
		checkSellDefs(rawSellDefs)
		
		gadgetHandler:RegisterCMDID(CMD_SELL)
		
			-- Loops through the units, calling g:UnitFinished() on each of them
		for _, unitID in ipairs(Spring.GetAllUnits()) do
			local teamID = Spring.GetUnitTeam(unitID)
			local unitDefID = GetUnitDefID(unitID)
			gadget:UnitFinished(unitID, unitDefID, teamID)
		end
		
	end
	
	
	
	local function GetSellToolTip(unitID, sellDef)
		local ud = sellDef.ud
		local tt = ''
		tt =       'Sell: ' .. ud.humanName .. '\n'
		tt = tt .. 'Energy cost ' .. sellDef.resTable.e .. '\n'
		tt = tt .. 'Metal cost ' .. sellDef.resTable.m .. '\n'
		tt = tt .. 'Build time ' .. sellDef.time .. '\n'
		
		return tt
	end
	
	
	
	function gadget:UnitCreated(unitID, unitDefID, teamID)
		
		local sellCmdDesc = {
			id      = CMD_SELL,
			type    = CMDTYPE.ICON,
			name    = 'Sell',
			cursor  = 'Sell',  -- add with LuaUI?
			action  = 'sell',
		}
		
		if sellDefs[unitDefID] then
			
			local sellDef = sellDefs[unitDefID]

			if sellDef.buttonname then
				sellCmdDesc.name = sellDef.buttonname
			else
				sellCmdDesc.name = "Sell"
			end

			if sellDef.buildpic then
				sellCmdDesc.texture = "&.1x.1&unitpics/" .. sellDef.buildpic .. "&bitmaps/icons/frame.png"
			end

			if sellDef.notext == true then
				sellCmdDesc.onlyTexture = true
			else
				sellCmdDesc.onlyTexture = false
			end

			sellCmdDesc.tooltip = GetSellToolTip(unitID, sellDef)
			Spring.InsertUnitCmdDesc(unitID, sellCmdDesc)
			
		end
		
	end
	
	
	
	local function StartSell(unitID, unitDefID)
		
		if (not sellDefs[unitDefID]) then
			return false
		end
		
		-- paralyze the unit
		Spring.SetUnitHealth(unitID, { paralyze = 1.0e9 })    -- turns mexes and mm off
	
		sellUnits[unitID] = {
			def = sellDefs[unitDefID],
			progress = 0.0,
			increment = sellDefs[unitDefID].increment
		}
		
		if sellUnits[unitID].def.onStart ~= nil then
			sellUnits[unitID].def.onStart(unitID)
		end
	end
	
	
	
	local function FinishSell(unitID, sellData)
		sellUnits[unitID] = nil
		
		local health, maxHealth = Spring.GetUnitHealth(unitID)
		local mult = health / maxHealth
		
		Spring.AddTeamResource(Spring.GetUnitTeam(unitID), "m", sellData.def.resTable.m * mult)
		Spring.AddTeamResource(Spring.GetUnitTeam(unitID), "e", sellData.def.resTable.e * mult)
		Spring.DestroyUnit(unitID, false, true) -- selfd = false, reclaim = true
	end
	
	
	
	local function StepSell(unitID, sellData)
		
		sellData.progress = sellData.progress + sellData.increment

		Spring.SetUnitRulesParam(unitID, "upgradeProgress", sellData.progress)
		
		if (sellData.progress >= 1.0) then
			FinishSell(unitID, sellData)
			return false -- remove from the list, all done
		end
		
		return true
		
	end
	
	
	
	local function StopSell(unitID)
		if sellUnits[unitID] then
			
			if sellUnits[unitID].def.onStop ~= nil then
				sellUnits[unitID].def.onStop(unitID)
			end
			
			Spring.SetUnitHealth(unitID, { paralyze = -1 })
			
			sellUnits[unitID] = nil

			Spring.SetUnitRulesParam(unitID, "upgradeProgress", 0)
		end
	end
	
	
	
	function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
		
		if sellUnits[unitID] then
			
			if cmdID == CMD.STOP then
				StopSell(unitID, sellUnits[unitID])
				return true
			end
			
			return false
			
		else
			
			if (cmdID == CMD_SELL) then
				StartSell(unitID, unitDefID)
			end
			
			return true  -- command was used
			
		end
		
	end
	
	
	
	function gadget:CommandFallback(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
		
		if (cmdID ~= CMD_SELL) then
			return false  -- command was not used
		end
		
		StartSell(unitID, unitDefID)
		
		return true, true  -- command was used, remove it
		
	end
	
	
	
	function gadget:GameFrame(n)
		
		if (next(sellUnits) == nil) then
			return  -- no upgradinging units
		end
		
		local killUnits = {}
		for unitID, sellData in pairs(sellUnits) do
			if (not StepSell(unitID, sellData)) then
				killUnits[unitID] = true
			end
		end
		
		for unitID in pairs(killUnits) do
			sellUnits[unitID] = nil
		end
		
	end
	
	
	
	function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
		StopSell(unitID)
	end
end

