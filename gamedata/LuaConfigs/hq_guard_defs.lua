
	-- All times mesured in seconds (32 frames, or 1 slow update)

local config = {
		-- Maximum number of guards
	MAX_GUARDS = 6,
	
		-- How long between succesive guard respawns
	SPAWN_WAIT = 10,
	
		-- How far from the HQ will the guards spawn
	SPAWN_DIST = 200,
	SPAWN_DIST_RAND = 20,
	
		-- How long after the HQ was attacked should units reset
	ATTACK_RESET = 4,
	
		-- The unitname of the guards
	GUARD_NAME = 'imp_i_royalguard',
		-- The unitname of the HQ
	HQ_NAME = 'imp_commander',
	
		-- The positions of the guards, in order of spawn
	posData = {
	[0] = {
		{x=-40,  z=180},     -- Door, left
		{x=40,   z=180},      -- Door, right
		{x=-150, z=-150}, -- Back, Left
		{x=150,  z=-150},  -- Back, Righ
		{x=150,  z=150},    -- Front, Right
		{x=-150, z=150},   -- Front, Left
	},
	
	[1] = {
		{x=180,  z=-40},     -- Door, left
		{x=180,  z=40},      -- Door, right
		{x=-150, z=-150}, -- Back, Left
		{x=150,  z=-150},  -- Back, Righ
		{x=150,  z=150},    -- Front, Right
		{x=-150, z=150},   -- Front, Left
	},
	
	[2] = {
		{x=-40,  z=-180},     -- Door, left
		{x=40,   z=-180},      -- Door, right
		{x=-150, z=-150}, -- Back, Left
		{x=150,  z=-150},  -- Back, Righ
		{x=150,  z=150},    -- Front, Right
		{x=-150, z=150},   -- Front, Left
	},
	
	[3] = {
		{x=-180,  z=-40},     -- Door, left
		{x=-180,  z=40},      -- Door, right
		{x=-150, z=-150}, -- Back, Left
		{x=150,  z=-150},  -- Back, Righ
		{x=150,  z=150},    -- Front, Right
		{x=-150, z=150},   -- Front, Left
	}
	
	}
}

return config