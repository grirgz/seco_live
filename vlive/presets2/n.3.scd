//Ndef(~name+++\lfo1, { SinOsc.kr(0.01).range(0.05,1)  });
(
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo3).quant = Pdef.defaultQuant;

Ndef(~name+++\lfo1, { arg val=1, flag=0.1; val.lag(flag) });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\val, 0.92,
	\val, Pseq([
		Pseq([1,0.50],6),
		Pseq([2,0.70],1),
		Pseq([4,0.30],1),
	],inf),
	\flag, 0.1,
	\dur, Pseq([
		Pser([1/2],4),
	],inf),
));

Ndef(~name+++\lfo2, { arg val=1, flag=0.1; val.lag(flag) });
Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	\val, Pseq([0.1,0.2,0.01,0.02],inf),
	\val, 0,
	\flag, 0.1,
	\dur, 1/2,
));

Ndef(~name+++\lfo3, { arg val=1, flag=0.1; val.lag(flag) });
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\val, Pseq([
		0.1,0.2,
		0.2,0.3,
		0.2,0.3,
		0.2,0.3,
	],inf)/10,
	\val, 0,
	\flag, 0.1,
	\dur, 1/4,
));

Pdef(~name +++ \pre, 
	Pbind(

		\mbufnum, BufDef.mono(\metal),
		\dur, 1/2,
		\pitch_stretch, Ndef(~name+++\lfo1),
		\time_stretch, Ndef(~name+++\lfo2),
		\finepos, Ndef(~name+++\lfo3),
		//\pitch_stretch, 1.0,
		//\pitch_stretch, Pseq([
		//	1.0,2,0.8,0.7,
		//	2.0,1,0.8,0.4,
		//],inf).stutter(4),
		//\pitch_stretch, Pseg(Pseq([0.1,4],inf),16),
		//\pos, ~midi.(\k1, nil, ControlSpec(0,0.1,'lin',0,0)).vpattern + 0.3,
		\legato, 1.0,
		\amp, Pkey(\amp) * 2,
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

Ndef(~name+++\lfo1, { arg val=1, flag=0.1; val.lag(flag) });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\val, Pseq([
		1,0.1,1.2,0.2,
		1,1,1.2,1.5,
		Pseq([0.2,0.3,0.2,0.3]*4),
	],inf),
	\flag, 0.1,
	\dur, Pseq([
		Pser([1/2],4),
		Pser([1/4],8),
	],inf),
));
