(
// pos
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo1, { arg val=0.4, vlag=0.1; val.lag(vlag) });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\vlag, Pseq([
		Pser([0.01]*1,6),
	],inf),
	\vlag, 0.01,
	\val, 0.5,
	\val, Pseq([
		Pser([0.5,0.04],2),
		Pser([0.05,0.74],2),
	],inf),
	\val, Pseq([
		Pseq([1,0.6,0.2,0.2],2),
		Pseq([1,0.6,0.2,0.2].rotate(2),2),
	],inf) / 3,
	\val, Pseq([
		0.7,0.701,
	],inf)-0.3,
	\val, Pwhite(0.0,0.101)+0.2,
	\vlag, 4,
	\dur, 4,
));

// pitch_stretch
Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo2, { arg val=1, vlag=0.1; val.lag(vlag) });
Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	\vlag, 1/4,
	\vlag, 0.01,
	\val, 0.1,
	\val, Pseq([
		Pser([0.01],6),
		Pser([0.21,0.23],2),

		Pser([0.01],6),
		Pser([0.51,0.23],2),

		Pser([0.01],6),
		Pser([0.51,0.23],2),

		Pser([0.01],2),
		Pser([0.01],2),
		Pser([0.17],2),
		Pser([0.21,0.23],2),
	],inf),
	\dur, 1/2,
));

// time_stretch
Ndef(~name+++\lfo3).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo3, { arg val=1, vlag=0.1; val.lag(vlag) });
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\val, Pseq([
		Pser([0.01,0.02],6*2),
		Pser([0.01,0.13],2*2),
	],inf).stutter(2),
	\vlag, 0.01,
	\val, 0.01,
	\val, Pseq([
		Pser([0.01,0.02],6*2),
		Pser([0.41,0.13],2*2),
	],inf).stutter(2),
	\dur, 1/8,
));

Pdef(~name +++ \pre, 
	Pbind(

		\mbufnum, BufDef.mono(\ukraine),
		\dur, 1/8,
		\pos, Pseq([0.1,0.12,0.3,0.2],inf) + Pwhite(0,0.01),
		\pos, Pseq([
			0.3,0.21,
			0.4,0.31,
		],inf).stutter(4) + Pwhite(0,0.007),
		\pos, Pseg(Pseq([0,0.03]+0.1,inf),8),
		//\time_stretch, Pseq([0],inf),
		//\pitch_stretch, Pseq([1,2,0.5,0.25],inf),
		//\pitch_stretch, Pseg(Pseq([0,0.3],inf),8)+0.5,
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.01) ],
		],inf),
		\pitch_stretch, Pseq([
			[1.8,0.55,0.37]
		],inf).stutter(1),
		\time_stretch, Pseg(Pseq([0,0.01,0],inf),1),
		\pos, Ndef(~name+++\lfo1),
		\amp, 0.2 * Pkey(\amp),
		//\pitch_stretch, Ndef(~name+++\lfo2),
		//\time_stretch, Ndef(~name+++\lfo3),
		//\pos, ~midi.(\k1, nil, ControlSpec(0,0.1,'lin',0,0)).vpattern + 0.3,
		\legato, Pseq([4,0.8],inf),
		\legato, Pseq([1.4],inf),
	) <>
	
	Sdef(~name, \mypreset).pbind <> 
	Pbind(
		\isRest, Veco(~namex).isrest(16),
		\time_stretch, 0,
		\freq, 100,
	)
)
)

// END

Sdef(~name, \mypreset).pbind.asStream.next(Event.default);

Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo1, { arg val=1, vlag=0.1; val.lag(vlag) });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\val, Pseq([
		Pser([0.1,0.5],4),
		Pser([1.1,1.5],2),
		Pser([4.1,0.1],2),
	],inf),
	\vlag, Pseq([
		Pser([0.1,0.1]*1,6),
		Pser([0.5,0.1]*0.1,2),
	],inf),
	\dur, 1,
));

Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo2, { arg val=1, vlag=0.1; val.lag(vlag) });
Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	\val, Pseq([
		Pser([0.01,0.52],6),
		Pser([0.01,0.13],2),
	],inf),
	\vlag, 1/4,
	\dur, 1/4,
));

Ndef(~name+++\lfo3).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo3, { arg val=1, vlag=0.1; val.lag(vlag) });
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\val, Pseq([
		Pser([0.01,0.02],6*2),
		Pser([0.01,0.13],2*2),
	],inf).stutter(2),
	\vlag, 0.01,
	\dur, 1/8,
));
