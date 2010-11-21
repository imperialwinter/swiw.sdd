-- Author: Tobi Vollebregt
-- License: GNU General Public License v2

-- Misc config
FLAG_RADIUS = 160 --from SWIW antiflag weapon
SQUAD_SIZE = 10

-- unit names must be lowercase!

-- Pick one out of three buildorders at random.
if (not gadgetHandler:IsSyncedCode()) then
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
else
	gadget.unitBuildOrder = {}
	gadget.baseBuildOrder = {}
end

-- This lists all the units (of all sides) that are considered "base builders"
gadget.baseBuilders = {
	"imp_c_condroid",
	"imp_c_protocon",
	"reb_commander",
	"reb_c_condroid",
	"reb_i_bothan",
}

-- This lists all the units that should be considers flags.
gadget.flags = {
	"a_p_flag",
	"imp_p_flag",
	"imp_p_flagmil1",
	"imp_p_flagecon1",
	"reb_p_flag",
	"reb_p_flagmil1",
	"reb_p_flagecon1",
}

-- This lists all the units (of all sides) that may be used to cap flags.
gadget.flagCappers = {
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

-- Currently I'm only configuring the the unitLimits per difficulty level,
-- it's easy however to use a similar structure for the buildorders above.

-- Do not limit units spawned through LUA! (infantry that is build in platoons,
-- deployed supply trucks, deployed guns, etc.)

if (gadget.difficulty == "easy") then

	-- On easy, limit both engineers and buildings until I've made an economy
	-- manager that can tell the AI whether it has sufficient income to build
	-- (and sustain) a particular building (factory).
	-- (AI doesn't use resource cheat in easy)
	gadget.unitLimits = {
		-- engineers
		imp_c_protocon       = 1,
		imp_c_condroid	   = 1,
		reb_c_condroid	   = 1,
		reb_c_condroid	   = 1,
		reb_i_bothan	   = 2,
		-- buildings
		imp_b_barracks       = 3,
		imp_b_droidplant     = 5,
		imp_b_vehicleplant   = 1,
		imp_b_airplant       = 1,

	}

elseif (gadget.difficulty == "medium") then

	-- On medium, limit engineers (much) more then on hard.
	gadget.unitLimits = {
		imp_c_protocon       = 1,
		imp_c_condroid	   = 1,
		reb_c_condroid	   = 1,
		reb_i_bothan	   = 2,
		-- buildings
		imp_b_barracks       = 4,
		imp_b_droidplant     = 5,
		imp_b_vehicleplant   = 1,
		imp_b_airplant       = 1,
	}

else

	-- On hard, limit only engineers (because they tend to get stuck if the
	-- total group of engineers and construction vehicles is too big.)
	gadget.unitLimits = {
		reb_c_condroid	   = 2,
		reb_i_bothan	   = 3,
		imp_c_protocon       = 2,
		imp_c_condroid	   = 2,
	}
end
