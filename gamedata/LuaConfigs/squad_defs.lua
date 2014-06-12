--[[

Syntax:

local squadDefs = {
	["squad_spawner"] = {
		"squad_member_1",
		"squad_member_2",
		"squad_member_3",
		...
		"squad_member_n",
	},
	... -- more squad spawners
}

where:

  squad_spawner is the unitname of the unit that spawns the
squad upon completion. This unit can be build from a factory, 
builder, spawned by Lua, anything. When it is created, it will
spawn the units specified in its squad_member array

  squad_member_n is the unit name of one of unit to spawn in
the squad. There can be as many squad_members as needed. All 
members of the squad will receive the orders assigned to the 
spawner unit. Thus, whole squads can be ordered around from
in a factory, like a normal unit would be.

]]--

local squadDefs = {
	["imp_is_scout"] = {
		"imp_sc_speederbike",
		"imp_sc_speederbike",
		"imp_i_scouttrooper",
		"imp_i_scouttrooper",
	},
	["imp_is_assault"] = {
		"imp_i_stormtrooper",
		"imp_i_stormtrooper",
		"imp_i_stormtrooper",
		"imp_i_stormtrooper",
		"imp_i_stormtrooper",
		"imp_i_reptrooper",
		"imp_i_reptrooper",
		"imp_i_reptrooper",
	},
	["imp_is_heavy"] = {
		"imp_i_reptrooper",
		"imp_i_reptrooper",
		"imp_i_flametrooper",
		"imp_i_flametrooper",
		"imp_i_flametrooper",
		"imp_i_flametrooper",
	},
	["imp_is_antiair"] = {
		"imp_i_rockettrooper",
		"imp_i_rockettrooper",
		"imp_i_rockettrooper",
		"imp_i_rockettrooper",
		"imp_i_rockettrooper",
		"imp_i_stormtrooper",
	},
	["imp_is_defense"] = {
		"imp_i_reptrooper",
		"imp_i_eweb",
		"imp_i_eweb",
		"imp_i_reptrooper",
	},
	["reb_is_commando"] = {
		"reb_i_veterantrooper",
		"reb_i_veterantrooper",
		"reb_i_veterantrooper",
		"reb_i_veterantrooper",
	},
 	["imp_is_b1"] = {
 		"imp_i_battledroid",
 		"imp_i_battledroid",
 		"imp_i_battledroid",
 		"imp_i_battledroid",
 		"imp_i_battledroid",
 		"imp_i_battledroid",
 	},
}

-------------------------------------------------
-- Dont touch below here
-------------------------------------------------

local squadDefIDs = { }

for i, squad in pairs(squadDefs) do
	unitDef = UnitDefNames[i]
	if unitDef ~= nil then
		squadDefIDs[unitDef.id] = squad
	else
		Spring.Echo("  Bad unitName! " .. i)
	end
end

for i, squad in pairs(squadDefIDs) do
	squadDefs[i] = squad
end

return squadDefs