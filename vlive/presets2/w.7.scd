
Pdef(~name +++ \pre, 
	Pbind(

		\mbufnum, BufDef.mono(\ukraine),
		\dur, 1/4,
		\pos, Pseq([0.1,0.12,0.3,0.2],inf) + Pwhite(0,0.01),
		\pos, Pseq([0.3,0.21],inf) + Pwhite(0,0.011),
		//\pos, ~midi.(\k1, nil, ControlSpec(0,0.1,'lin',0,0)).vpattern + 0.3,
		\legato, 0.5,
		\amp, Pkey(\amp) * 0.5,
		\isRest, Veco(~namex).isrest(16),
	) <>
	
	Sdef(~name, \mypreset).pbind <> 
	Pbind(
		\time_stretch, 0,
		\freq, 100,
	)
)

// END

Sdef(~name, \mypreset).pbind.asStream.next(Event.default);
