local Sounds = {
	SoundItems = {
		-- Base content sound items
		IncomingChat = {
		--- always play on the front speaker(s)
		file = "sounds/beep4.wav",
		in3d = "false",
		},
		MultiSelect = {
		--- always play on the front speaker(s)
		file = "sounds/button9.wav",
		in3d = "false",
		},
		MapPoint = {
		--- respect where the point was set, but don't attenuate in distance
		--- also, when moving the camera, don't pitch it
		file = "sounds/beep6.wav",
		rolloff = 0,
		dopplerscale = 0,
		},
		default = {
			gainmod = 0.35,
			pitchmod = 0.05,
			pitch = 1.0,
			in3d = true,
		},
		-- SWIW sound items	
	},
}

return Sounds
