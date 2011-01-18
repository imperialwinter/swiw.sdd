-- Author: Tobi Vollebregt
-- License: GNU General Public License v2

-- Misc config
FLAG_RADIUS = 160 --from SWIW antiflag weapon
SQUAD_SIZE = 10

-- unit names must be lowercase!

-- Pick one out of three buildorders at random.
do
	local r = math.random()
	if (r < 0.333333) then
		--Spring.Echo("C.R.A.I.G.: Taking buildorder variant A")
		include("LuaRules/Configs/craig/swiw/buildorder.1.lua")
	elseif (r < 0.666667) then
		--Spring.Echo("C.R.A.I.G.: Taking buildorder variant B")
		include("LuaRules/Configs/craig/swiw/buildorder.2.lua")
	else
		--Spring.Echo("C.R.A.I.G.: Taking buildorder variant C")
		include("LuaRules/Configs/craig/swiw/buildorder.3.lua")
	end
end

-- This lists all the units (of all sides) that are considered "base builders"
gadget.baseBuilders = UnitSet{
	"imp_c_condroid",
	"imp_c_protocon",
	"reb_commander",
	"reb_c_condroid",
	"reb_i_bothan",
}

-- This lists all the units that should be considers flags.
gadget.flags = UnitSet{
	"a_p_flag",
	"imp_p_flag",
	"imp_p_flagmil1",
	"imp_p_flagecon1",
	"reb_p_flag",
	"reb_p_flagmil1",
	"reb_p_flagecon1",
}

-- This lists all the units (of all sides) that may be used to cap flags.
gadget.flagCappers = UnitSet{
	"imp_i_scouttrooper",
	"imp_i_reptrooper",
	"imp_i_stormtrooper",
	"imp_i_flametrooper",
	"imp_i_rockettrooper",
	"reb_i_trooper",
	"reb_i_combat",
	"reb_i_mrb",
	"reb_i_wookiee",
}

-- Number of units per side used to cap flags.
gadget.reservedFlagCappers = {
	["galactic empire"] = 10,
	["rebel alliance"] = 10
}

-- commit: 7b17e5e6741b7ce8e2299e550b4373f84411980f
