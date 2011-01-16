local LAND_1 = {speed=29,frames=32}
local LAND_2 = {speed=23,frames=65}
local LAND_3 = {speed=20,frames=85}
local LAND_4 = {speed=17,frames=111}
local LAND_5 = {speed=19,frames=95}

local dropshipTypes={
	sentinel = {
		unitname = "imp_sh_sentinel",
		landFunc = "LandStraight",
		startFunc = "TakeoffVert",
		approachTime = 10,
	},
	freighter = {
		unitname = "imp_sh_freighter",
		landFunc = "LandStraight",
		startFunc = "TakeoffVert",
		approachTime = 10,
	},
	theta = {
		unitname = "imp_sh_theta",
		landFunc = "LandStraight",
		startFunc = "TakeoffVert",
		approachTime = 10,
	},
}

local dropshipUnits = {
	imp_p_solar = {
		dropship = "sentinel",
		approachTime = 6,
		landceg = "impact_dust",
		speed = LAND_4.speed,
		frames = LAND_4.frames,
	},
	imp_p_estore = {
		dropship = "freighter",
		approachTime = 7,
		landceg = "impact_dust_med",
		speed = LAND_5.speed,
		frames = LAND_5.frames,
	},
	imp_b_barracks = {
		dropship = "theta",
		approachTime = 8,
		landceg = "impact_dust_med",
		speed = LAND_3.speed,
		frames = LAND_3.frames,
	},
}

for shipname, defs in pairs(dropshipUnits) do
	if UnitDefNames[shipname] then
		dropshipUnits[shipname].id = UnitDefNames[shipname].id
		if not dropshipUnits[shipname].landDefs then
			dropshipUnits[shipname].speed = LAND_3.speed
			dropshipUnits[shipname].frames = LAND_3.frames
		end
	else
		dropshipUnits[shipname] = nil
		Spring.Echo("Invalid Dropship unit removed - " .. shipname)
	end
end

return dropshipTypes, dropshipUnits