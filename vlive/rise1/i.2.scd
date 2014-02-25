Ndef(~name+++\lfo1, { SinOsc.kr(0.01).range(0.95,1)  });

Pdef(~name +++ \pre, 
	Pbind(

		\mbufnum, BufDef.mono(\ukraine),
		\dur, 1/8,
		\pos, Pseq([0.1,0.12,0.3,0.2],inf) + Pwhite(0,0.01),
		\pos, Pseq([
			0.3,0.21,
			0.4,0.31,
		],inf) + Pwhite(0,0.007),
		//\pitch_stretch, Ndef(~name+++\lfo1),
		\time_stretch, 0.102,
		\pitch_stretch, Pseq([1,0.8,2],inf) * [1,0.8] * 0.2,
		//\pos, ~midi.(\k1, nil, ControlSpec(0,0.1,'lin',0,0)).vpattern + 0.3,
		\legato, 0.2,
	) <>
	
	Sdef(~name, \mypreset).pbind <> 
	Pbind(
		\time_stretch, 0,
		\freq, 100,
	)
)

// END

Sdef(~name, \mypreset).pbind.asStream.next(Event.default);
