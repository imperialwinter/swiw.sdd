local options={
	{
		key="deathmode",
		name="Game end mode",
		desc="What it takes to eliminate a team",
		type="list",
		def="com",
		items={
			{key="killall", name="Annihilate", desc="Every enemy unit must be destroyed"},
			{key="com", name="Command death", desc="When a team has no Garrisons/M-C-Vs left, it loses"},
		}
	},
	{
		key    = 'craig_difficulty',
		name   = 'C.R.A.I.G. difficulty level',
		desc   = 'Sets the difficulty level of the C.R.A.I.G. bot.',
		type   = 'list',
		def    = '3',
		items = {
			{
				key = '1',
				name = 'Easy',
				desc = 'No resource cheating.'
			},
			{
				key = '2',
				name = 'Medium',
				desc = 'Little bit of resource cheating.'
			},
			{
				key = '3',
				name = 'Hard',
				desc = 'Infinite resources.'
			},
		}
	},
}
return options
