--[[

Syntax is like this:

local holoUnits = {
	
	textures = {
		<Texture Information>
	},
	
	holoDefID = {
		<Holo Def IDs>
	}
}

<Texture Information>
	textures = {
			-- Have one texClass for each different animation type
		texClass = {
			
				-- How big the icon is
			iconsize = 60,
				-- Shift the icon this far upwards
			yshift   = 30,
			
				-- Each animation frame will last for this many game frames
			frameLength = 5,
			
			normal = {
				<texture list>
			},
			steal = {
				<texture list>
			},
			
	},
	texClass2 = {
		...
	}

<texture list>
				"images/frame1.jpg",
				"images/frame2.jpg",
				"images/frame3.jpg",
				"images/frame4.jpg",
				"images/frame5.jpg",
				"images/frame6.jpg",

<Holo Def IDs>
	holoDefID = {
		["unitname"] = texClass,
		["unitname2"] = texClass2,
	}

]]--

	-- Images used
local holobase = 'bitmaps/holograms/'
local neutbase = holobase .. "neutral/"
local impbase = holobase .. "imp/impholo_"
local rebbase = holobase .. "reb/rebholo_"

local holoUnits = {
	
	textures = {
		a_p_flag = {
			iconsize = 60,
			xshift   = 0,
			yshift   = 30,
			zshift   = 0,
			frameLength = 5,
			
			normal = {
				neutbase .. '01.tga',
				neutbase .. '02.tga',
				neutbase .. '03.tga',
				neutbase .. '04.tga',
				neutbase .. '05.tga',
				neutbase .. '06.tga',
				neutbase .. '07.tga',
				neutbase .. '08.tga',
				neutbase .. '09.tga',
				neutbase .. '10.tga',
				neutbase .. '11.tga',
				neutbase .. '12.tga',
				neutbase .. '13.tga',
			},
			steal = {
				neutbase .. 'glitch_01.tga',
				neutbase .. 'glitch_02.tga',
			},
		},
		imp_p_flag = {
			iconsize = 60,
			xshift   = 0,
			yshift   = 30,
			zshift   = 0,
			frameLength = 5,
			
			normal = {
				impbase .. '01.tga',
				impbase .. '02.tga',
				impbase .. '03.tga',
				impbase .. '04.tga',
				impbase .. '05.tga',
				impbase .. '06.tga',
				impbase .. '07.tga',
				impbase .. '08.tga',
				impbase .. '09.tga',
				impbase .. '10.tga',
				impbase .. '11.tga',
				impbase .. '12.tga',
			},
			steal = {
				impbase .. 'glitch_01.tga',
				impbase .. 'glitch_02.tga',
			},
		},
		imp_p_flagecon1 = {
			iconsize = 40,
			xshift   = 15,
			yshift   = 60,
			zshift   = 0,
			frameLength = 5,
			
			normal = {
				impbase .. '01.tga',
				impbase .. '02.tga',
				impbase .. '03.tga',
				impbase .. '04.tga',
				impbase .. '05.tga',
				impbase .. '06.tga',
				impbase .. '07.tga',
				impbase .. '08.tga',
				impbase .. '09.tga',
				impbase .. '10.tga',
				impbase .. '11.tga',
				impbase .. '12.tga',
			},
			steal = {
				impbase .. 'glitch_01.tga',
				impbase .. 'glitch_02.tga',
			},
		},
		imp_p_flagmil1 = {
			iconsize = 40,
			xshift   = 0,
			yshift   = 60,
			zshift   = 0,
			frameLength = 5,
			
			normal = {
				impbase .. '01.tga',
				impbase .. '02.tga',
				impbase .. '03.tga',
				impbase .. '04.tga',
				impbase .. '05.tga',
				impbase .. '06.tga',
				impbase .. '07.tga',
				impbase .. '08.tga',
				impbase .. '09.tga',
				impbase .. '10.tga',
				impbase .. '11.tga',
				impbase .. '12.tga',
			},
			steal = {
				impbase .. 'glitch_01.tga',
				impbase .. 'glitch_02.tga',
			},
		},
		reb_p_flag = {
			iconsize = 60,
			xshift   = 0,
			yshift   = 30,
			zshift   = 0,
			frameLength = 5,
			
			normal = {
				rebbase .. '01.tga',
				rebbase .. '02.tga',
				rebbase .. '03.tga',
				rebbase .. '04.tga',
				rebbase .. '05.tga',
				rebbase .. '06.tga',
				rebbase .. '07.tga',
				rebbase .. '08.tga',
				rebbase .. '09.tga',
				rebbase .. '10.tga',
				rebbase .. '11.tga',
				rebbase .. '12.tga',
			},
			steal = {
				rebbase .. 'glitch_01.tga',
				rebbase .. 'glitch_02.tga',
			}
		},
		reb_p_flagecon1 = {
			iconsize = 40,
			xshift   = 3,
			yshift   = 50,
			zshift   = -5,
			frameLength = 5,
			
			normal = {
				rebbase .. '01.tga',
				rebbase .. '02.tga',
				rebbase .. '03.tga',
				rebbase .. '04.tga',
				rebbase .. '05.tga',
				rebbase .. '06.tga',
				rebbase .. '07.tga',
				rebbase .. '08.tga',
				rebbase .. '09.tga',
				rebbase .. '10.tga',
				rebbase .. '11.tga',
				rebbase .. '12.tga',
			},
			steal = {
				rebbase .. 'glitch_01.tga',
				rebbase .. 'glitch_02.tga',
			}
		},
		reb_p_flagmil1 = {
			iconsize = 40,
			xshift   = 0,
			yshift   = 80,
			zshift   = 0,
			frameLength = 5,
			
			normal = {
				rebbase .. '01.tga',
				rebbase .. '02.tga',
				rebbase .. '03.tga',
				rebbase .. '04.tga',
				rebbase .. '05.tga',
				rebbase .. '06.tga',
				rebbase .. '07.tga',
				rebbase .. '08.tga',
				rebbase .. '09.tga',
				rebbase .. '10.tga',
				rebbase .. '11.tga',
				rebbase .. '12.tga',
			},
			steal = {
				rebbase .. 'glitch_01.tga',
				rebbase .. 'glitch_02.tga',
			}
		},
	},
	
		-- Which units use which holograms
	holoDefID = {
		[UnitDefNames["a_p_flag"].id] = 'a_p_flag',
		[UnitDefNames["imp_p_flag"].id] = 'imp_p_flag',
		[UnitDefNames["imp_p_flagecon1"].id] = 'imp_p_flagecon1',
		[UnitDefNames["imp_p_flagmil1"].id] = 'imp_p_flagmil1',
		[UnitDefNames["reb_p_flag"].id] = 'reb_p_flag',
		[UnitDefNames["reb_p_flagecon1"].id] = 'reb_p_flagecon1',
		[UnitDefNames["reb_p_flagmil1"].id] = 'reb_p_flagmil1',
	}
}

return holoUnits