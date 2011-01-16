if (Spring.GetModOptions) then
	local modOptions = Spring.GetModOptions()

	local commander = {
	 ["imp_commander"] = true,
	 ["imp_com_mil1"] = true,
	 ["imp_com_res1"] = true,
	 ["reb_commander"] = true,
	 ["reb_com_armor1"] = true,
	 ["reb_com_builder1"] = true,
	}

	for name, ud in pairs(UnitDefs) do  
		if (commander[ud.unitname]) then
			ud.energyStorage = modOptions.startenergy or 1000
			ud.metalStorage = modOptions.startmetal or 1000
		end
	end
	
end
