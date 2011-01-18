-- Author: Tobi Vollebregt
-- License: GNU General Public License v2

-- Currently I'm only configuring the the unitLimits per difficulty level,
-- it's easy however to use a similar structure for the buildorders above.

-- Do not limit units spawned through LUA! (infantry that is build in platoons,
-- deployed supply trucks, deployed guns, etc.)

if (gadget.difficulty == "easy") then

	-- On easy, limit both engineers and buildings until I've made an economy
	-- manager that can tell the AI whether it has sufficient income to build
	-- (and sustain) a particular building (factory).
	-- (AI doesn't use resource cheat in easy)
	gadget.unitLimits = UnitBag{
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
	gadget.unitLimits = UnitBag{
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
	gadget.unitLimits = UnitBag{
		reb_c_condroid	   = 2,
		reb_i_bothan	   = 3,
		imp_c_protocon       = 2,
		imp_c_condroid	   = 2,
	}
end

-- commit: 7b17e5e6741b7ce8e2299e550b4373f84411980f
