--[[

Syntax is like this:
local sellDefs = {
	unitname = <sellDef>,
	unitname = <sellDef>,
	...
	unitname = <sellDef>
}
<sellDef>
	{
			returnMult = ###,    -- return the units cost, multiplied by this number
				-- OR --
			metal  = ###,        -- metal returned upon sale.
			energy = ###,        -- energy returned upon sale.
			
			time   = ###,        -- seconds taken to sell. Optional, defaults to 0
		}


  Note: All unitnames are case sensitive!
]]--


local sellDefs = {
	imp_b_airplant = {
		returnMult = 0.6,
		time = 10,
		buttonname = 'Relinquish',
		notext = true,
		buildpic = 'upgrades/imp_sell.png',
	}, imp_b_barracks = {
		returnMult = 0.6,
		time = 10,
		buttonname = 'Relinquish',
		notext = true,
		buildpic = 'upgrades/imp_sell.png',
	}, imp_b_droidplant = {
		returnMult = 0.6,
		time = 10,
		buttonname = 'Relinquish',
		notext = true,
		buildpic = 'upgrades/imp_sell.png',
	}, imp_b_vehicleplant = {
		returnMult = 0.6,
		time = 10,
		buttonname = 'Relinquish',
		notext = true,
		buildpic = 'upgrades/imp_sell.png',
	}, imp_d_antiair = {
		returnMult = 0.6,
		time = 10,
		buttonname = 'Relinquish',
		notext = true,
		buildpic = 'upgrades/imp_sell.png',
	}, imp_d_ioncannon = {
		returnMult = 0.6,
		time = 10,
		buttonname = 'Relinquish',
		notext = true,
		buildpic = 'upgrades/imp_sell.png',
	}, imp_p_estore = {
		returnMult = 0.6,
		time = 10,
		buttonname = 'Relinquish',
		notext = true,
		buildpic = 'upgrades/imp_sell.png',
	}, imp_p_fusion = {
		returnMult = 0.6,
		time = 10,
		buttonname = 'Relinquish',
		notext = true,
		buildpic = 'upgrades/imp_sell.png',
	}, imp_p_solar = {
		returnMult = 0.6,
		time = 10,
		buttonname = 'Relinquish',
		notext = true,
		buildpic = 'upgrades/imp_sell.png',
	}, imp_p_tibanna = {
		returnMult = 0.6,
		time = 10,
		buttonname = 'Relinquish',
		notext = true,
		buildpic = 'upgrades/imp_sell.png',
	}, reb_b_airplant = {
		returnMult = 0.8,
		time = 10,
		buttonname = 'Recycle',
		notext = true,
		buildpic = 'upgrades/reb_sell.png',
	}, reb_b_barracks = {
		returnMult = 0.8,
		time = 10,
		buttonname = 'Recycle',
		notext = true,
		buildpic = 'upgrades/reb_sell.png',
	}, reb_b_repulsorliftplant = {
		returnMult = 0.8,
		time = 10,
		buttonname = 'Recycle',
		notext = true,
		buildpic = 'upgrades/reb_sell.png',
	}, reb_d_antiair = {
		returnMult = 0.8,
		time = 10,
		buttonname = 'Recycle',
		notext = true,
		buildpic = 'upgrades/reb_sell.png',
	}, reb_d_golan = {
		returnMult = 0.8,
		time = 10,
		buttonname = 'Recycle',
		notext = true,
		buildpic = 'upgrades/reb_sell.png',
	}, reb_p_estore = {
		returnMult = 0.8,
		time = 10,
		buttonname = 'Recycle',
		notext = true,
		buildpic = 'upgrades/reb_sell.png',
	}, reb_p_fusion = {
		returnMult = 0.8,
		time = 10,
		buttonname = 'Recycle',
		notext = true,
		buildpic = 'upgrades/reb_sell.png',
	}, reb_p_tibanna = {
		returnMult = 0.8,
		time = 10,
		buttonname = 'Recycle',
		notext = true,
		buildpic = 'upgrades/reb_sell.png',
	}, reb_p_varenergy = {
		returnMult = 0.8,
		time = 10,
		buttonname = 'Recycle',
		notext = true,
		buildpic = 'upgrades/reb_sell.png',
	}, reb_sp_spotter = {
		returnMult = 0.8,
		time = 10,
		buttonname = 'Recycle',
		notext = true,
		buildpic = 'upgrades/reb_sell.png',
	},
}


-------------------------------------------------
-- Dont touch below here
-------------------------------------------------

return sellDefs