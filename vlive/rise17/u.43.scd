BufDef(\march, "vipere/march.flac");
(
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,0.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,1.9)).range(0,0.02) + 0.15  });
~buf = BufDef(\march);
~buf = BufDef(\moeten);
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo3).quant = Pdef.defaultQuant;

Ndef(~name+++\lfo2, { arg freq=20; freq.lag(0.401) * SinOsc.kr(1/16*t).range(0.5,1.0)});
Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	\freq, Pseq([
		0.00003,
		0.00013,
		0.0001,
		0.001,
	],inf),
	\dur, 1,
));
Ndef(~name+++\lfo3, { arg freq=20; freq.lag(0.401).round(0.1) * SinOsc.kr(1/16*t).range(0.5,1.0).round(0.1)});
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\freq, Pseq([
		2,2,2,2,
		2,4,4,6,
		2,2,2,2,
		2,4,4,6,
	]/6,inf),
	\dur, 1,
));
Ndef(~name+++\lfo1, { arg freq=20; freq.lag(0.401).round(0.1) * SinOsc.kr(1/16*t).range(0.5,1.5).round(0.1)});
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([
		Pseq([
			2,8,2,2,
			4,4,16,1,
			
			Pseq([
				16,16,1,1,
			],2),
		],1),
		Pseq([
			2,8,2,2,
			4,4,16,1,

			4,8,4,2,
			4,2,16,2,
		],1),
		Pseq([
			2,8,2,2,
			4,4,16,1,

			Prand([
				Pseq([
					10,
				],8),
				
				Pseq([
					4,4,4,4,
					4,4,16,4,
				],1),
			],1),
		],1),
	]*250,inf),
	\dur, 1/4,
));
//Ndef(~name+++\lfo1, { 0.1 + LFPulse.kr(1).range(0,0.0008).lag(0.4)});
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,1.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(1.18).range(0,1.02) + 10.45  });
//Ndef(~name+++\lfo2, { LFSaw.kr(SinOsc.kr(1.12).range(0.01,4.9)).range(0.0001,0.0012)  });
Pdef(~name +++ \pre, 
	Pmono(\oscsampler3,
		\finepos, Pseq([0,0,0.0000,0.00004],inf) + Pseq([0,0.1,0.20,0.25],inf).stutter(8),
		\finepos, Pseq([0,0,0.0000,0.00000],inf),
		\fineposlag, 0.7,
		\pos, 0.4,
		//\freq, Ndef(~name+++\lfo3).bus.asMap,
		\freq, 60 * Pseq([
			[0,3,8],
			[0,3-12,8],
			[0,3,7],
			[0,3,8-12],
		],inf).midiratio.stutter(2) * 4,
		\isRest, false,
	\bufnum, ~buf,
	\ffreqtab, Pseq([
		[Array.geom(8,1.1,1.11).postln]
	],inf),
	\range, 0.005,
	\range, Ndef(~name+++\lfo2),
	\lpmix, Ndef(~name+++\lfo3),
	\rq, 0.01,
	\hpmix, 0,
	\distmix, 1,
	\distamp, 4,
	\distpreamp, 440,
	\posenv, Pseq([
		[ Env([0.00,0.000014,0.0].integrate.postln,[0.42,8.4]) ],
	],inf),
	\dur, 1,

	
	) <>
	Pbind(
		\ffreq, 5800,
		\ffreq, Ndef(~name+++\lfo1),

	)
	
)
);

// END

Sdef(~name, \mypreset).rebuild
Sdef(~namex, \mypreset).edit
Sdef(~namex, \mypreset).rebuild(true)
a = IdentityDictionary.new; a.putPairs( Sdef(~namex, \mypreset).specs ); a[\fshift]
Sdef(~namex, \mypreset).get(0,0)
Sdef(~name, \mypreset).active_subindex
Sdef(~name, \mypreset).all[0][0] = nil
~score_storage.all['1'][\mypreset] = nil

Pdef.all.do { arg x; x.postln; }

Pdef('1.0.mypreset').source.asCompileString
Pdef('1.0.mypreset').play
