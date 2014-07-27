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
		\pos, Pseg(Pseq([0,0.03],inf),8),
		//\pitch_stretch, Ndef(~name+++\lfo1),
		\pitch_stretch, Pseq([1,2,0.5,0.25],inf),
		\pitch_stretch, Pseg(Pseq([0,0.3],inf),8)+0.5,
		\time_stretch, Pseq([0],inf),
		//\pos, ~midi.(\k1, nil, ControlSpec(0,0.1,'lin',0,0)).vpattern + 0.3,
		\legato, Pseq([1,0.8],inf),
	) <>
	
	Sdef(~name, \mypreset).pbind <> 
	Pbind(
		\time_stretch, 0,
		\freq, 100,
	)
)

// END

Sdef(~name, \mypreset).pbind.asStream.next(Event.default);
