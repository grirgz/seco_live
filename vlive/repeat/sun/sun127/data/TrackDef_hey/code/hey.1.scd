
(
~currentTrack.initPdef(
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.021,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
			\out, Pfunc({ ~currentTrack.parentTrack.childAt(3).mixer.inBus }),
			\sideout, Pfunc({ ~currentTrack.parentTrack.childAt(0).mixer.inBus }),
		),
)
)

// END

~currentTrack.parentTrack.childAt(3).mixer.inBus
~currentTrack.parentTrack.childAt(3).mixer

Pdef(~name).isPlaying
Pdef(~name).clear
