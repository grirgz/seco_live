BufDef(\march, "vipere/march.flac");
(
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,0.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,1.9)).range(0,0.02) + 0.15  });
~buf = BufDef(\march);
~buf = BufDef(\moeten);
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo3).quant = Pdef.defaultQuant;
//Ndef(~name+++\lfo1, { Phasor.kr(0, (1/SampleRate.ir).poll *1, 0, 0.81) + 0.1 + LFPulse.kr(8).range(0,0.0001).lag(0.1)});
Ndef(~name+++\lfo1, { arg freq=1; SinOsc.kr(freq * t).range(6050,7500).lag(0.051)});
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([4,2,6,8],inf),
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
	Pbind(
		\finepos, Pseq([0,0,0.0000,0.000],inf) + Pseq([0,0],inf).stutter(16),
		\fineposlag, 4.4,
		\pos, 0.7,
		\range, 0.0000,
		\framerange, 50,
		\amp, Pkey(\amp) * 2,
		//\freq, Ndef(~name+++\lfo3).bus.asMap,
		\freq, 440 * Pseq([
			Pseq([0,1],16),
		],inf).midiratio.stutter(1) / 2,
		//\freq, 80,
		\isRest, false,
	\bufnum, ~buf,
	\ffreqtab, Pseq([[Array.geom(8,1.0,1.01).postln]],inf),
	\posenv, Pseq([
		[ Env([0.00,0.0010,0.0000].integrate.postln,[0.42,8.4]) ],
		[ Env([0.00,0.0010,0.1100].integrate.postln,[0.42,8.4]) ],
	],inf),
	\isRest, Pseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,

		1,0,0,0, 1,0,0,0,
		1,0,0,0, 1,1,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\dur, 1/8,
	\legato, Pseq([
		4,1,1,1, 4,1,1,1,
		1,3,1,1, 1,3,1,1,
		2,1,2,1, 4,1,1,1,
		1,3,1,1, 1,3,1,1,
		2,1,1,1, 4,1,1,1,
		1,3,1,1, 1,3,1,1,
		4,1,2,1, 4,1,1,1,
		1,3,1,1, 1,3,1,1,
	],inf),
	\lpmix, 1,
	\hpmix, 1,
	\ffreq, 4400,
	
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
