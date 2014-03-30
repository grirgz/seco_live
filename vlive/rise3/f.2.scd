//Ndef(~name+++\lfo1, { SinOsc.kr(0.01).range(0.05,1)  });
(
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo3).quant = Pdef.defaultQuant;


Ndef(~name+++\lfo2, { arg val=1, flag=0.1; val.lag(flag) });
Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	\val, Pseq([0.1,0.2,0.01,0.02],inf),
	\flag, 0.1,
	\dur, 1/2,
));

Ndef(~name+++\lfo3, { arg val=0.1, flag=0.1; val.lag(flag) });
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\val, Pseq([
		0.1,0.12,
		0.2,0.2,
		0.5,0.5,
	],inf)/30 + Pwhite(0,0.6),
	\val, Pwhite(0,0.6),
	//\val, Pseg(Pseq([0.1,0.2],inf),8),
	\dur, 1,
	\flag, Pkey(\dur),
));

Ndef(~name+++\lfo1, { arg val=0.1, flag=0.1; val.lag(flag) });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\val, Pseq([
		0.1,0.12,
		0.2,0.2,
		0.5,0.5,
	],inf)/30 + Pwhite(0,0.6),
	\val, Pseq([
		Pwhite(2,3.6,1),
		Pwhite(0,2.6,1),
	],inf),
	//\val, Pseg(Pseq([0.1,0.2],inf),8),
	\dur, 1,
	\flag, 0.061,
));

Pdef(~name+++\mod, Pbind());

Pdef(~name +++ \pre, 
	Pbind(

		\mbufnum, BufDef.mono(\ukraine),
		\dur, 1/8 + Pwhite(0,1/8),
		\pitch_stretch, Pseg(Pwhite(1,5.0), 2),
		\pitch_stretch, Pbrown(0.1,5.0),
		\legato, 1.5,
		\time_stretch, Plprand(0.01,0.1),
		\finepos, Ndef(~name+++\lfo3),
		\isRest, Veco(~namex).isrest(32),
		\isRest, Plazy({
			var list;
				list = List[
					0.5,
					0.5,
					0.2,
					0.7,
					0.5,
					0.5,
					0.1,
					0.7,
				].coin;
				Pseq(list, 4);
		}).loop,
		//\pitch_stretch, 1.0,
		//\pitch_stretch, Pseq([
		//	1.0,2,0.8,0.7,
		//	2.0,1,0.8,0.4,
		//],inf).stutter(4),
		//\pitch_stretch, Pseg(Pseq([0.1,4],inf),16),
		//\pos, ~midi.(\k1, nil, ControlSpec(0,0.1,'lin',0,0)).vpattern + 0.3,
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
