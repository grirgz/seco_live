//Ndef(~name+++\lfo1, { SinOsc.kr(0.01).range(0.05,1)  });
BufDef.mono(\clap, "field/clap.flac");
(
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo3).quant = Pdef.defaultQuant;

Ndef(~name+++\lfo1, { arg val=1, flag=0.1; val.lag(flag) });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\val, Pseq([
		0.81, 1.3,
		0.81, 0.9,
		0.81, 0.7,
		0.61, 1.5,

	],inf),
	\flag, 0.7,
	\dur, 1,
));

Ndef(~name+++\lfo2, { arg val=1, flag=0.1; val.lag(flag) });
Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	\val, Pseq([
		4.2,1.1,
		4.2,0.4,
		4.2,1.1,
		1.2,1.0,
	],inf),
	\flag, 0.1,
	\dur, 1/2,
));

Ndef(~name+++\lfo3, { arg val=(4.1/100), flag=0.1; val.lag(flag) });
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\val, Pseq([
		4.1,8.1002,
	],inf)/100,
	\flag, 0.1,
	\dur, 1/4,
));

Pdef(~name +++ \pre, 
	Pbind(

		\mbufnum, BufDef.mono(\oeuf),
		\dur, 1/4,
		\pitch_stretch, Ndef(~name+++\lfo1),
		\time_stretch, Ndef(~name+++\lfo2),
		\finepos, Ndef(~name+++\lfo3),
		\pos, 0.07,
		//\pitch_stretch, 1.0,
		//\pitch_stretch, Pseq([
		//	1.0,2,0.8,0.7,
		//	2.0,1,0.8,0.4,
		//],inf).stutter(4),
		//\pitch_stretch, Pseg(Pseq([0.1,4],inf),16),
		//\pos, ~midi.(\k1, nil, ControlSpec(0,0.1,'lin',0,0)).vpattern + 0.3,
		\legato, 1.0,
		\legato, Pseq([
			1,0.2,0.8,0.6,
			1,1.2,0.8,0.6,
			1,0.2,0.8,1.0,
			0.1,1.2,0.8,1.6,
		],inf),
		\legato, Pseq([
			4,0.1,0.8,0.1
		],inf),
		\isRest, Pseq([
			1,1,1,1,
			1,0,0,0,
		],inf).coin.not,
		\amp, Pkey(\amp) * 1/4,
		\ffreq, 1000,
	) <>
	
	Sdef(~name, \mypreset).pbind <> 
	Pbind(
		\time_stretch, 0,
		\freq, 100,
		\pos, Pseq([0.1,0.12,0.3,0.2],inf) + Pwhite(0,0.01),
		\pos, Pseq([
			0.3,0.21,
			0.4,0.31,
		],inf) + Pwhite(0,0.007),
		\pos, 0.3,
	)
)

)

// END

Sdef(~name, \mypreset).pbind.asStream.next(Event.default);
