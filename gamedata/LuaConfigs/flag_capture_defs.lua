--[[

Syntax like this:

flagNames and captureNames are just arrays of unit names.
  - flagNames is a list of the flags that are be capturable
  - captureNames is a list of units that can capture said flags

weaponID is the ID of the weapon that range/damage is taken from.
Untill I can work out a way to extract a weaponID from a weaponName,
going through the antiflag unit will have to do.

--]]

local flagNames    = {
	"a_p_flag",
	"imp_p_flag",
	"reb_p_flag",
}
local captureUnits = {
	imp_i_flametrooper = 1,
	imp_i_reptrooper = 1,
	imp_i_scouttrooper = 1,
	imp_i_stormtrooper = 1,
	imp_i_rockettrooper = 1,
	imp_i_eweb = 1,
	reb_commander = 5,
	reb_com_armor1 = 5,
	reb_com_builder1 = 5,
	reb_i_trooper = 1,
	reb_i_combat = 1,
	reb_i_wookiee = 1,
	reb_i_rockettrooper = 1,
	reb_i_mrb = 1,
}
local weaponID = UnitDefNames["antiflag"].weapons[1].weaponDef

return flagNames, captureUnits, weaponID;
