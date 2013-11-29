(
~buf = BufDef.mono(\march);
~buf = BufDef.mono(\moeten);
~buf = BufDef.mono(\soda);
~buf = BufDef.mono(\donkey);
Ndef(~name+++\lfo3, { arg val=0.1, flag=0.1; val.lag(flag)});
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\val, Pseq([
		Pser([
			0.1,0.2,
		],16),
		Pser([
			0.2,0.22,
		],16),
		Pser([
			0.22,0.32,
		],16),
	],inf).stutter(1) + 0.1,
	\flag, 0.001,
	\dur, 1/8,
));
Ndef(~name+++\lfo1, { arg val=0.1, flag=0.1; val.lag(flag)});
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\val, Pseq([
		Pser([0.09],10+16),
		Pser([0.07,0.5],06),
	],inf).stutter(1) + 0,
	\flag, 1.1,
	\dur, 1/4,
));
Ndef(~name+++\lfo2, { arg val=0.1, flag=0.1; val.lag(flag)});
Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	\val, Pseq([
		0.01,2.42,
		0.01,1.42,

		4.11,0.42,
		3.01,1.42,

		1.01,2.42,
		0.01,1.42,

		0.11,0.42,
		3.11,1.42,


	],inf).stutter(1),
	\val1, Pseq([
		0.01,2.42,
		0.01,1.42,

		0.11,0.42,
		3.01,1.42,

		1.01,2.42,
		0.01,1.42,

		0.11,0.42,
		3.11,1.42,


		0.11,2.42,
		0.01,1.42,

		4.11,0.42,
		3.01,1.42,

		1.04,2.42,
		0.01,1.42,

		0.12,0.42,
		3.11,1.42,

	],inf).stutter(1),
	\val2, Pseq([
		1.01,0.12,
		0.01,1.12,

		0.11,0.42,
		1.01,4.42,

		1.01,2.42,
		0.01,1.42,

		0.11,0.42,
		3.11,1.42,


		0.01,1.12,
		0.01,1.12,

		0.21,0.42,
		2.01,4.42,

		1.01,2.42,
		0.01,1.42,

		0.11,0.42,
		3.11,1.42,
	],inf).stutter(1),
	\val3, Pseq([
		1.01,0.12,
		0.01,1.12,

		0.11,0.42,
		1.01,4.42,

		1.01,2.42,
		0.01,1.42,

		0.11,0.42,
		3.11,1.42,
	],inf).stutter(1),
	\val4, Pseq([

		0.01,1.12,
		0.01,1.12,

		0.21,0.42,
		2.01,4.42,

		1.01,2.42,
		0.01,1.42,

		0.11,0.42,
		3.11,1.42,
	],inf).stutter(1),
	\val, Pseq([
		Pkey(\val1),
		Pkey(\val2),
	],inf),
	\val, Prout { arg ev;
		var seq = Pseq([1,1,1,3,1,1,1,4],inf).stutter(16).asStream;
		inf.do { arg va;
			var num = seq.next;
			ev = ev[(\val++num).asSymbol].debug("kjk").yield;
		};
	},
	\flag, Pseq([
		0.1,1.0,0.1,0.1,
	],inf),
	\dur, 1/8,
));
Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;
Pdef(~name +++ \pre, 
	Pbind(
		\mbufnum, ~buf,
		\amp, 4 * Pkey(\amp),
		\pitch_stretch, Ndef(~name+++\lfo2),
		\time_stretch, Ndef(~name+++\lfo1),
	) <>
	Sdef(~name, \mypreset).pdef <> 
	Pbind(
		\pos, Ndef(~name+++\lfo3),
		//\ffreq, Ndef(~name+++\lfo1),
		//\freq, Ndef(~name+++\lfo3).bus.asMap,
		//\range, Pseg(Pseq([0.0001,0.0008,0.1],inf), Pseq([7,1,0],inf)),
	\legato, 0.8,
	\dur, 1/2,
));
)

// END

Sdef(~name, \mypreset).rebuild
Sdef(~namex, \mypreset).edit
Sdef(~namex, \mypreset).rebuild(true)
a = IdentityDictionary.new; a.putPairs( Sdef(~namex, \mypreset).specs ); a[\fshift]
Sdef(~namex, \mypreset).get(0,0)
Sdef(~name, \mypreset).active_subindex
Sdef(~name, \mypreset).all[0][0] = nil
~score_storage.all['1'][\mypreset] = nil

Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo3).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo1, { arg freq=1, fmin=50, fmax=5000; LFPulse.kr(freq * t).range(fmin,fmax).lag(0.051)});
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([4,1,16,1,32,8,1,1],inf),
	\freq, 1,
	\fmax, 7000,
	\fmin, 50,
	\fmin, Pseq([
		50, 50, 50, 50, 
		50, 50, 50, 50, 
		50, 50, 50, 50, 
		50, 50, 50, 50, 

		50, 50, 50, 50, 
		750, 50, 50, 50, 
		50, 50, 50, 50, 
		5000, 50, 50, 50, 
	],inf),
	\dur, 1/4,
));
Ndef(~name+++\lfo3, { arg freq=20, flag=0.1; freq.lag(flag)});
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\freq, Pseq([
		16,2,16,1,
		16,2,16,1,
		14,16,16,16,
		14,16,16,16,
	]*10,inf),
	\freq, 1000,
	\freq, Pseq([
		1000, 1000, 1000, 1000,
		1,2,1,1,
	],inf),
	\freq, Pseq([
		100, 100, 100, 100,
		1,2,1,1,
	],inf),
	\flag, Pseq([
		0.0, 0.0, 0.0, 0.0,
		1.0, 1.0, 1.0, 1.0,
		0.4, 1.0, 0.4, 1.0,
		1.0, 1.0, 1.0, 1.0,
	],inf),
	\freq, Pseq([
		1,2,1,1,
		0.5,0.5,0.1,0.1,
		0.01, 0.01, 0.01, 0.01,
		0.4, 0.4, 0.4, 0.4,
	]*10,inf),
	\freq, Pseq([
		1000, 1000, 1000, 1000,
		1,2,1,1,
		1000, 10, 1, 1000,
		0.5,0.5,0.1,0.1,
		10, 10, 1, 1000,
		0.01, 0.01, 0.01, 0.01,
		1,2,1,1,
		0.4, 0.4, 0.4, 0.4,
	],inf),
	\flag, Pseq([
		1.0, 1.0, 0.0, 1.0,
	],inf),
	\dur, 1/8,
));
