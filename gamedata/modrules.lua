local modrules = {
	reclaim = {
		multiReclaim = false,		-- boolean - allow only 1 or >1 unit to simultaneously reclaim a feature/corpse
		unitMethod = 1,			-- int, 1
		unitEnergyCostFactor = 0,	-- float, 0
		unitEfficiency = 1,		-- float, 1
		featureEnergyCostFactor = 0,	-- float, 0
		allowEnemies = true,		-- bool, true
		allowAllies = true,		-- bool, true
		reclaimMethod = 0,		-- 0 is gradual reclaim (ie a small % is reclaimed every tick)
						-- 1 is current behaviour - ie one large hit of resources at the end of the reclim period
						-- >1 is chunky behaviour - reclaim happens in n equal sized chunks
	},
	repair = {
		energyCostFactor = 0.75,	-- how much of the original cost it requires to repair something.
	},
	resurrect = {
		energyCostFactor = 0.5,		-- default: 0.5
	},
	capture = {
		energyCostFactor = 0,		-- default: 0
	},
	transportability = {
		transportGround = true,	-- defaults to true	--Can [x] units be transported?
		transportHover = true,	-- defaults to false
		transportShip = false,	-- defaults to false
		transportAir = true,	-- defaults to false
	},
	flankingbonus = {
		defaultMode=0,		-- defaults to 1
	},				-- 0: no flanking bonus
					-- 1: global coords, mobile
					-- 2: unit coords, mobile
					-- 3: unit coords, locked

	experience = {
		experienceMult = 1.0,	-- defaults to 1.0

		-- these are all used in the following form:
		--   value = defValue * (1 + (scale * (exp / (exp + 1))))

		powerScale = 1.0,	-- float, 1.0
		healthScale = 0.7,	-- float, 0.7
		reloadScale = 0.4,	-- float, 0.4
	},
	fireatdead = {
		fireAtKilled = false,
		fireAtCrashing = false,
	},
	construction = {
		constructionDecay = true,	-- bool, true
		constructionDecayTime = 8,	-- float, 6.66
		constructionDecaySpeed = 1,	-- float, 0.03
	},
	sensors = {
		los = {
			losMipLevel = 4,	-- int, 1, must be -1 < n < 7
			losMul = 1,		-- float, 1
			airMipLevel = 2,	-- int, 2, must be -1 < n < 31
			airLosMul = 1,		-- float, 1
		},
		requireSonarUnderWater = true,	-- bool, true
	},
	nanospray = {
		allow_team_colours = false,
	},
}

return modrules