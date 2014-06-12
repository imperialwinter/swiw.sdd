--[[

Syntax is like this:
local upgradeDefs = {
	unitname = <upgrades>,
	unitname = <upgrades>,
	...
	unitname = <upgrades>
}
<upgrades>
	{
		<upgrade option 1>, -- first upgrade option
		<upgrade option 2>, -- second upgrade option
		...
		<upgrade option n>  -- nth upgrade option
	}

<upgrade options>
		{
			into  = 'unitname', -- what it upgrades into, case sensitive
			mcost = ###,        -- metal cost of upgrading. Optional, defaults to 0
			ecost = ###,        -- energy cost of upgrading. Optional, defaults to 0
			time  = ###,        -- seconds taken to upgrade. Optional, defaults to 0
			
				-- runs a function upon defined event. Optional, defaults to nothing
				-- run when a unit finishes upgrading
			onUpgrade = function(oldUnitID, newUnitID, upgradeUnit) <statments> end,
				-- run when a unit starts upgrading, or stops stalling
			onStart   = function(oldUnitID, newUnitID, upgradeUnit) <statments> end,
				-- run when the Stop command is sent if upgrading
			onStop    = function(oldUnitID, newUnitID, upgradeUnit) <statments> end,
				-- run when a unit starts stalling (ie. no resources)
			onStall   = function(oldUnitID, newUnitID, upgradeUnit) <statments> end,
		}



  Note: All unitnames are case sensitive!
]]--

	-- If the unit is a HQ, put this in the definition
	--[[
			onUpgrade = function(oldUnitID, newUnitID, _)
				HQGuardTransfer(oldUnitID, newUnitID)
			end
	]]--
	-- If the unit also has E-WEBs guarding it, put this below HQGuardTransfer
	-- HQEWEBTransfer(oldUnitID, newUnitID)

	
local function HQGuardTransfer(oldID, newID)
	if Script.LuaRules.HQ_GUARD_IDUpdate ~= nil then
		Script.LuaRules.HQ_GUARD_IDUpdate({oldID = oldID, newID = newID})
	end
end
local function HQEWEBTransfer(oldID, newID)
	if Script.LuaRules.HQ_EWEB_IDUpdate ~= nil then
		Script.LuaRules.HQ_EWEB_IDUpdate({oldID = oldID, newID = newID})
	end
end


local upgradeDefs = {
	imp_p_flag = {
		{
			into = 'imp_p_flagmil1',
			mcost = 650,
			ecost = 2000,
			time = 80,
			buttonname = 'Upg: Mil',
			name = 'Upgrade: Fortify',
			desc = 'Fortifies strategic point with a bunker which produces 1.5X more requisition',
			notext = true,
			buildpic = 'imp_p_flagmil1.png',
		},
		{
			into = 'imp_p_flagecon1',
			mcost = 170,
			ecost = 2325,
			time = 26,
			buttonname = 'Upg: Econ',
			name = 'Upgrade: Economic',
			desc = 'Upgrades area with a weapons cache which produces 3X more requisition for an energy upkeep',
			notext = true,
			buildpic = 'imp_p_flagecon1.png',
		}
	},
	reb_p_flag = {
		{
			into = 'reb_p_flagmil1',
			mcost = 450,
			ecost = 1500,
			time = 65,
			buttonname = 'Upg: Mil',
			name = 'Upgrade: Fortify',
			desc = 'Fortifies area with a tunnel entrance which builds infantry, and earns 1.5X more requisition',
			notext = true,
			buildpic = 'reb_p_flagmil1.png',
		},
		{
			into = 'reb_p_flagecon1',
			mcost = 150,
			ecost = 2100,
			time = 24,
			buttonname = 'Upg: Econ',
			name = 'Upgrade: Economic',
			desc = 'Upgrades area with a tibanna fuel dump which produces 3X more requisition for an energy upkeep',
			notext = true,
			buildpic = 'reb_p_flagecon1.png',
		}
	},



	reb_commander = {
		{
			into = 'reb_com_armor1',
			mcost = 600,
			ecost = 1800,
			time = 54,
			buttonname = 'Upg: Mil',
			name = 'Upgrade: Militaristic',
			desc = 'Increases armor, can command troops around it',
			notext = true,
			buildpic = 'upgrades/reb_com_armor1.png',
		},
		{
			into = 'reb_com_builder1',
			mcost = 240,
			ecost = 1500,
			time = 65,
			buttonname = 'Upg: Comm',
			name = 'Upgrade: Command',
			desc = 'Increases build power, build options, can command nearby factories',
			notext = true,
			buildpic = 'upgrades/reb_com_builder1.png',
		}
	},
	reb_com_armor1 = {
		{
			into = 'reb_commander',
			mcost = 0,
			ecost = 0,
			time = 10,
			buttonname = 'Degrade',
			name = 'Downgrade',
			desc = 'Removes the armor upgrade',
			notext = true,
			buildpic = 'upgrades/reb_com_degrade.png',
		}
	},
	reb_com_builder1 = {
		{
			into = 'reb_commander',
			mcost = 0,
			ecost = 0,
			time = 10,
			buttonname = 'Degrade',
			name = 'Downgrade',
			desc = 'Removes the comms upgrade',
			notext = true,
			buildpic = 'upgrades/reb_com_degrade.png',
		}
	},


	imp_d_eweb = {
		{
			into = 'imp_i_eweb',
			mcost = 0,
			ecost = 0,
			time = 0,
			buttonname = '',
			name = '',
			desc = '',
			notext = true,
		}
	},
	
	
	imp_commander = {
		{
			into = 'imp_com_mil1',
			mcost = 700,
			ecost = 4500,
			time = 84,
			buttonname = 'Upg: Def',
			name = 'Upgrade: Defense',
			desc = 'Fortifies Garrison with walls, anti-air, and buildable E-Webs',
			notext = true,
			buildpic = 'upgrades/imp_com_mil.png',
			onUpgrade = function(oldUnitID, newUnitID, _)
				HQGuardTransfer(oldUnitID, newUnitID)
			end
		},
		{
			into = 'imp_com_res1',
			mcost = 750,
			ecost = 5000,
			time = 75,
			buttonname = 'Upg: Comm',
			name = 'Upgrade: Command',
			desc = 'Adds new Stormtrooper build options, resource generation, and sensors',
			notext = true,
			buildpic = 'upgrades/imp_com_econ.png',
			onUpgrade = function(oldUnitID, newUnitID, _)
				HQGuardTransfer(oldUnitID, newUnitID)
			end
		}
	},
	imp_com_mil1 = {
		{
			into = 'imp_commander',
			mcost = 0,
			ecost = 0,
			time = 10,
			buttonname = 'Degrade',
			name = 'Downgrade',
			desc = 'Removes defense enhancements',
			notext = true,
			buildpic = 'upgrades/imp_com_degrade.png',
			onUpgrade = function(oldUnitID, newUnitID, _)
				HQGuardTransfer(oldUnitID, newUnitID)
			end
		}
	},
	imp_com_res1 = {
		{
			into = 'imp_commander',
			mcost = 0,
			ecost = 0,
			time = 10,
			buttonname = 'Degrade',
			name = 'Downgrade',
			desc = 'Removes command enhancements',
			notext = true,
			buildpic = 'upgrades/imp_com_degrade.png',
			onUpgrade = function(oldUnitID, newUnitID, _)
				HQGuardTransfer(oldUnitID, newUnitID)
			end
		}
	},


}


-------------------------------------------------
-- Dont touch below here
-------------------------------------------------

for _, upgrades in pairs(upgradeDefs) do
	for _, upgrade in ipairs(upgrades) do
		if (upgrade.mcost == nil) then upgrade.mcost = 0 end
		if (upgrade.ecost == nil) then upgrade.ecost = 0 end
		if (upgrade.time == nil)  then upgrade.time  = 0 end
	end
end

return upgradeDefs