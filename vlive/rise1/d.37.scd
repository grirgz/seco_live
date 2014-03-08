Pbindef('gmod', 
	\pitch_stretch, 2,
	\bla, Pfunc({
		arg ev;
		ev.postln;
		1
	})

)
// END


Pdef('gmod', Pbind(
	\pitch_stretch, Pkey(\pitch_stretch)*1.1,
))
