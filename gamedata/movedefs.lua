local moveDefs = {
	{						--infantry
		name = 'INFANTRY1x1',
		footprintX = 1,
		maxWaterDepth = 15,
		maxSlope = 35,
		crushStrength = 0,
	},
	{						--small walkers/large droids
		name = 'WALKER2x2',
		footprintX = 2,
		maxWaterDepth = 25,
		maxSlope = 24,
		crushStrength = 10,
	},
	{						--small all terrain (crab droid)
		name = 'WALKER2x2AT',
		footprintX = 2,
		maxWaterDepth = 25,
		maxSlope = 60,
		crushStrength = 10,
	},
	{						--tanks
		name = 'TANK3x3',
		footprintX = 3,
		maxWaterDepth = 30,
		maxSlope = 25,
		crushStrength = 45,
	},
	{						--amphib tanks
		name = 'TANK3x3AMPHIB',
		footprintX = 3,
		maxSlope = 25,
		maxWaterDepth = 255,
		crushStrength = 30,
	},
	{						--small hovers
		name = 'HOVER2x2',
		footprintX = 2,
		maxSlope = 50,
		crushStrength = 1,
	},
	{						--large hovers
		name = 'HOVER3x3',
		footprintX = 2,
		maxSlope = 40,
		crushStrength = 20,
	},
	{						--large hovers with poor slope tolerance
		name = 'HOVER3x3LOWSLOPE',
		footprintX = 3,
		maxSlope = 25,
		crushStrength = 30,
	},
}

return moveDefs