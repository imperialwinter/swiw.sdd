function widget:GetInfo()
	return {
		name      = "Combat selections v2",
		desc      = "Filters out non-combat units in group selections \nHold alt whilst selecting to select all units regardless",
		author    = "Gnome",
		date      = "June 2008",
		license   = "Public domain",
		layer     = 5,
		enabled   = true  --  loaded by default?
	}
end

local selCache = { }

local GetSelectedUnits = Spring.GetSelectedUnits
local GetModKeyState = Spring.GetModKeyState
local GetUnitDefID = Spring.GetUnitDefID
local SelectUnitArray = Spring.SelectUnitArray
local concat = table.concat
local insert = table.insert

function widget:GameFrame(n)
	if(n % 2 < 1) then --it doesn't need to run tooooo often :P
		local selUnits = GetSelectedUnits()
		local nonCombatUnits = { }
		local combatUnits = { }
		local alt, ctrl, meta, shift = GetModKeyState()
		if(selUnits[1]) then
			local selUnitsConcat = concat(selUnits) --can't compare tables directly
			local selCacheConcat = concat(selCache) --have to compare so you don't have to hold alt continuously
			if(selUnitsConcat ~= selCacheConcat) then	--to keep the mixed selection selected
				for _,uid in ipairs(selUnits) do
					udid = GetUnitDefID(uid)
					ud = UnitDefs[udid]
					if(ud) then
						local trans = Spring.GetUnitTransporter(uid)

						--hold alt to select all, and shift-selecting one unit assumes alt+shift
						if( (shift == true and (#selUnits - #selCache == 1)) or (alt == true) or ((ud.maxWeaponRange > 0) and (not trans)) ) then
							insert(combatUnits,uid)
						else
							insert(nonCombatUnits,uid)
						end
					end
				end
				if(combatUnits[1]) then
					SelectUnitArray(combatUnits,false)
					selCache = combatUnits
				else
					SelectUnitArray(nonCombatUnits,false)
					selCache = nonCombatUnits
				end
			end
		else
			selCache = selUnits
		end
	end
end