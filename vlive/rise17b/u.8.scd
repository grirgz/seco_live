BufDef(\march, "vipere/march.flac");
(
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,0.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,1.9)).range(0,0.02) + 0.15  });
~buf = BufDef(\moeten);
~buf = BufDef(\crepe);
~buf = BufDef(\march);
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo3).quant = Pdef.defaultQuant;
//Ndef(~name+++\lfo1, { Phasor.kr(0, (1/SampleRate.ir).poll *1, 0, 0.81) + 0.1 + LFPulse.kr(8).range(0,0.0001).lag(0.1)});
Ndef(~name+++\lfo1, { arg freq=1; SinOsc.kr(freq * t).range(50,7500).lag(0.051)});
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([1,1,16,1,1,8,1,1],inf),
	\dur, 1/1,
));
Ndef(~name+++\lfo3, { arg freq=20; freq.lag(0.401).round(0.1) * SinOsc.kr(1/16*t).range(0.5,1.5).round(0.1)});
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\freq, Pseq([
		2,2,2,2,
		2,4,4,6,
		2,2,2,2,
		2,4,4,6,
	]*250,inf),
	\dur, 1,
));
//Ndef(~name+++\lfo1, { 0.1 + LFPulse.kr(1).range(0,0.0008).lag(0.4)});
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,1.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(1.18).range(0,1.02) + 10.45  });
//Ndef(~name+++\lfo2, { LFSaw.kr(SinOsc.kr(1.12).range(0.01,4.9)).range(0.0001,0.0012)  });
Pdef(~name +++ \pre, 
	Pmono(\oscsampler3,
		\finepos, Pseq([0,0,0.0004,0.01004],inf) + Pseq([0.1,0.091],inf).stutter(4),
		\fineposlag, 0.1,
		\pos, 0.46816816816817,
		\amp, Pkey(\amp) * 4 * Pseq([0,0.2,0.3,0.5,0.7,0.9,Pseq([1],inf)],inf),
		//\freq, Ndef(~name+++\lfo3).bus.asMap,
		\freq, 60 * Pseq([
			
			Prand([
				Pseq([
					Pseq([0,0,0,5, [0,5],0,5,[0,7]]),
					Pseq([0,0,3,0, 7,0,7,8]),
				],1),
				Pseq([
					Pseq([0,0,0,5, 0,0,5,7]),
					Pseq([0,3,0,3, 3,0,7,8]),
				],1),
				Pseq([
					Pseq([3,3,3,5, 5,[0,5],5,[0,7]]),
					Pseq([0,0,3,0, 0,0,7,8]),
				],1),
				Pseq([
					
					Pseq([3,0,3,5, 5,[0,5],5,[0,7]]),
					Pseq([0,0,3,0, 0,0,7,8]),
				],1),
			],1),
		],inf).midiratio.stutter(1) * 4,
		\isRest, false,
	\bufnum, ~buf,
	\ffreqtab, Pseq([[Array.geom(8,1.0,1.01).postln]],inf),
	\range, 0.00001,
	\posenv, Pseq([
		[ Env([0.00,0.000,0.00].integrate.postln,[4.42,8.4]) ],
	],inf),
	\dur, 1,

	
	) <>
	Pbind(
		\ffreq, 5800,
		\ffreq, Ndef(~name+++\lfo1),

	)
	
)
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

Pdef.all.do { arg x; x.postln; }

Pdef('1.0.mypreset').source.asCompileString
Pdef('1.0.mypreset').play
