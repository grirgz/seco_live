(
~buf = BufDef(\march);
~buf = BufDef(\ukraine);
~buf = BufDef(\moeten);
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo3).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo1, { arg freq=1, fmin=50, fmax=5000; LFTri.kr(freq * t).round(0.4).range(fmin,fmax)});
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([4,1,16,1,32,8,1,1],inf),
	\freq, 1/4,
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
	],inf) + 1000,
	\dur, 1,
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
	\freq, Pseq([
		10,40,10,10,
		100,10,10,10,
		10,40,10,10,
		1000, 1000,910,1000,
	],inf),
	\flag, Pseq([
		1.0, 1.0, 0.0, 1.0,
	],inf),
	\flag, 1,
	\dur, 1/1,
));

Ndef(~name+++\lfo2, { arg freq=20, flag=0.1; freq.lag(flag)});
Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	\freq, Pseq([0.1,0],inf),
	\lag, 2,
	\dur, 2,
));
Pdef(~name +++ \pre, 
	Pbind(
		\freq, Ndef(~name+++\lfo3).bus.asMap,
		\freq, Pseq([5000,200,1000],inf).stutter(8),
		\pos, 0.13,
		\freq, 100,
		\ffreq, 500,
		\ffreq, 5000,
		\finepos, Ndef(~name+++\lfo2),
		\freq, Pwhite(500,5000).stutter(8),
		\ffreq, Ndef(~name+++\lfo1),
		\rq, 0.3,
		\lpmix, 1,
		\freq, 10,
		\ffreqtab, Pseq([
			[ Array.series(8,0.2,0.051) ]
		],inf),

		\ffreq, Pwhite(500,5000),
		\ffreq, 7000,
		\range, Pseg(Pseq([0.0001,0.0008,0.001],inf), Pseq([7,1,0],inf)),
		\range, Pseq([0.0001,0.001,0.00001,0.000001],inf).stutter(4),
		\bufnum, ~buf,
		\dur, 1/4,
		\adsr, Pseq([
			~penv.( 
				Env.adsr(
					Pseg(Pseq([0.07,0.134,0.5,0.034],inf),7),
					0.1,0.8,
					Pseg(Pseq([0.7,0.034,0.5,0.034],inf),4)
				)
			),
		],inf),
		\amp, 18 * Pkey(\amp),
	) <>
	Sdef(~name, \mypreset).pdef <> Pbind(
		\legato, Plazy({
			Pseq([0.2+0.7.rand],16)
		}).loop,
		\legato, 0.5,
		\legato, Pseg(Pseq([0.1,2,0.5,0.1],inf), 8),
	\dur, 1/8,
	\isRest, Pseq([1,0.3,0.5,0.2],inf).coin.not,
	\isRest, Pseq([
		Pser([1],8),
		1,0,0,0, 0,0,0,0,
		1,0,0,0, 0,0,0,0,
		Pser([1],8),
		Pser([1],8),
		1,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\isRest, Pseq([
		0,0.0,1.0,0.0,
		0,0.1,0.5,0.0,
	],inf).coin.not,
	\dur, PdurStutter(Prand([1,16,8,4,2],inf),1),
	\dur, 1/4,
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

Pdef.all.do { arg x; x.postln; }

Pdef('1.0.mypreset').source.asCompileString
Pdef('1.0.mypreset').play
//Ndef(~name+++\lfo1, { 0.1 + LFPulse.kr(1).range(0,0.0008).lag(0.4)});
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,1.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(1.18).range(0,1.02) + 10.45  });
//Ndef(~name+++\lfo2, { LFSaw.kr(SinOsc.kr(1.12).range(0.01,4.9)).range(0.0001,0.0012)  });
(
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,0.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,1.9)).range(0,0.02) + 0.15  });
~buf = BufDef(\march);
~buf = BufDef(\moeten);
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo3).quant = Pdef.defaultQuant;
//Ndef(~name+++\lfo1, { Phasor.kr(0, (1/SampleRate.ir).poll *1, 0, 0.81) + 0.1 + LFPulse.kr(8).range(0,0.0001).lag(0.1)});
Ndef(~name+++\lfo1, { arg freq=1; LFPulse.kr(freq * t).range(50,7500).lag(0.051)});
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([1,1,16,1,1,8,1,1],inf),
	\dur, 1/2,
));
Ndef(~name+++\lfo3, { arg freq=20; freq.lag(0.101)});
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\freq, Pseq([2,2,16,1]*10,inf),
	\dur, 1/2,
));
Pdef(~name +++ \pre, 
	Pbind(
		\ffreq, Ndef(~name+++\lfo1),
		\freq, Ndef(~name+++\lfo3).bus.asMap,

	) <>
	
	Sdef(~name, \mypreset).pdef <> Pbind(
	\freq, 100,
	\pos, Pseq([0.0,0.01,0.02,0.03],inf),
	\pos, Pseg(Pseq([0,0.1],inf),32)+0.5,
	\pos, 0.412,
	\posenv, Pseq([
		//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
		[ Env([0.001,0.002,0.004].integrate.postln,[0.01,0.1]) ],
		[ Env([0.001,0.003,0.004].integrate.postln,[0.01,0.1]) ],
		[ Env([0.001,0.0013,0.004].integrate.postln,[0.01,0.1]) ],
	],inf),
	\fshift, 0,
	\fshift, Pseq([0,48,-40],inf),
	\fshift, -148,
	\lpmix, 0.11,
	\rq, 0.4,
	\posenv, Pseq([
		//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
		[ Env([0.004,0.0009,0.0071].integrate.postln,[0.02,0.4]) ],
	],inf),
	//\pos, Ndef(~name+++\lfo1),
	//\pos, Pseq([0,0.1,0.5],inf) + Pwhite(0,0.01),
	//\finepos, Ndef(~name+++\lfo1),
	//\range, Pseg(Pseq([0.001,0.21],inf),8),
	//\range, Ndef(~name+++\lfo2),
	\range, 0.0001,
	\ffreq, Pseq([100,300,200,200],inf),
	\ffreq, Pseq([60,70,100,120],inf),
	\ffreq, Pseq([1000,3000,200,2000],inf),
	\bufnum, ~buf,
	\ffreqtab, Pn(Plazy({
		[{ 2.rand } ! 8]
	})),
	\ffreqtab, Pseq([
		[[2.3,3.2,0.1,0.1, 0.2,0.8,1.2,1.5]],
	],inf),
	\ffreqtab, Pseq([[Array.series(8,0.5,0.1).postln]],inf),
	\ffreqtab, Pseq([[Array.geom(8,0.1,1.2).postln]],inf),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.3,0.5,0.21) ],
	],inf),
	\legato, 16.0,
	\amp, 1 * Pkey(\amp),
));
)
