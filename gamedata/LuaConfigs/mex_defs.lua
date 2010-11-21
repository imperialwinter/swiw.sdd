--[[

Syntax is like this:

local features = {
	parentUnitname = {
		name = "fakeMexUnitname",
	},
	parent2 = {
		name = "anotherFakeMex",
	},
}

Where:
	parentUnitname:
		Is the unitname of the unit that needs the fake mex attached to it.
	fakeMexUnitname
		Is the unitname of the unit the metal extraction data is taken from.

For example:
local features = {
	unit_bunker = {
		name = "unit_bunker_mex",
	},
}

	This will force all instances of unit_bunker to have the extraction
details of unit_bunker_mex, as if unit_bunker was actually extracting.

]]--




local features = {
	imp_p_flagmil1 = {
		name = "imp_pf_flagadv1",
	},
	reb_p_flagmil1 = {
		name = "reb_pf_flagadv",
	}
}

return features