-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--
--local auras = {
--	reb_commander = {
--		range = 300,		--range of the aura (applies to all effects)
--		transport = true,	--only applies to units being transported by this unit (you should also set range to 0 if this is true)
--		buildpower = {
--			rate = 2,	--buildspeed multiplier
--			mask = {"infantry","factories"},
--					--A mask will only apply this effect to these categories of units
--					--To apply to all (applicable) units, use the keyword "all"
--					--All masks work this way. The values are the same as those in the "Category" tag in the unit's fbi
--					--(you may need to add the new keywords. Remember there's a max of 32 categories)
--					--Do not use any caps
--		},
--		hp = {
--			rate = 2,	--armor multiplier
--			mask = {"all"},
--		},
--		heal = {
--			rate = 0.1,	--heals the unit by maxHP * rate per second. The per second is non-negotiable
--			mask = {"infantry"},
--		},
--		weapons = {
--			reloadtime = 0.5,	--reloadtime multiplier
--			range = 2,		--Range multiplier. This also increases the projectile speed so lasers don't fade out.
--						--Missiles and artillery may have problems with excessive range increases
--			mask = {"infantry","droid"},
--		},
--	},
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


local auras = {
	imp_d_pillbox = {
		range = 0,
		transport = true,
		weapons = {
--			reloadtime = 0.9,
			range = 1.1,
			mask = {"all"},
		},
	},
	imp_p_flagmil1 = {
		range = 0,
		transport = true,
		weapons = {
--			reloadtime = 0.9,
			range = 1.1,
			mask = {"all"},
		},
	},
	reb_com_builder1 = {
		range = 200,
		transport = false,
		buildpower = {
			rate = 1.25,
			mask = {"all"},
		},
	},
	reb_com_armor1 = {
		range = 350,
		transport = false,
		weapons = {
			reloadtime = 0.75,
			mask = {"infantry", "droid", "tank", "walker", "defense"},
		},
		hp = {
			rate = 1.2,
			mask = {"infantry", "droid", "tank", "walker", "defense"},
		},
	},
	reb_a_transport = {
		range = 0,
		transport = true,
		heal = {
			rate = 0.05,
			mask = {"iontargetable"},
		},
	},
	imp_a_laatc = {
		range = 0,
		transport = true,
		heal = {
			rate = 0.05,
			mask = {"iontargetable"},
		},
	},
}

return auras