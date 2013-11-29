(
~buf = BufDef(\march);
~buf = BufDef(\moeten);
~buf = BufDef(\donkey);
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo3).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo1, { arg freq=1, fmin=50, fmax=5000; LFTri.kr(freq * t).range(fmin,fmax).lag(0.051)});
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([4,1,16,1,32,8,1,1],inf),
	\freq, 4,
	\freq, Pseq([
		4,1,16,1,
		1,1,1,1,
	],inf),
	\fmax, 4100,
	\fmax, Pseq([
		4000,4000,400,4000,
		4000,4000,400,4000,
		4000,4000,400,4000,
		4000,4000,7400,4000,

	],inf),
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
	\fmin, Pseq([
		500,200,100,100,
		1000, 1000, 1000, 1000,

	],inf),
	\dur, 1/4,
));
Ndef(~name+++\lfo3, { arg freq=1000, flag=0.1; freq.lag(flag)});
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\freq, Pseq([
		1000, 40, 1000, 1000,
		10, 4, 10, 10,
		1000, 40, 1000, 1000,
		10, 4, 10, 10,

		1000, 4000, 1000, 1000,
		1,1,1,1,
		1,1,1,1,
		1,1,1,1,

		1000, 40, 1000, 1000,
		10, 4, 10, 10,
		1,1,1,1,
		1,1,1,1,

		1000, 40, 1000, 1000,
		10, 4, 10, 10,
		1,1,1,1,
		1,1,1,1,
	],inf),
	\freq, Pseq([
		700, 0.1, 0.700, 0.1,
		1,1,1,1,

		300,100,1,1,
		400,100,1,1,

		1000, 0.1, 0.1000, 0.1,
		1,1,1,1,

		1000, 0.1, 0.1000, 0.1,
		1,1,1,1,
	],inf),
	\flag, Pseq([
		1, 0, 0.0, 0,
		0, 0, 0.0, 0,
		0, 0, 0.0, 0,
		1, 0, 0.0, 0,
	],inf),
	\flag, Pseq([
		1.0, 1.0, 0.0, 1.0,
	],inf),
	\dur, 1/8,
));
Ndef(~name+++\lfo2, { arg freq=1000, flag=0.1; freq.lag(flag)});
Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	\freq, Pseq([
		-200,100,
	],inf).stutter(8),
	\flag, Pseq([
		1, 0, 0.0, 0,
		0, 0, 0.0, 0,
		0, 0, 0.0, 0,
		1, 0, 0.0, 0,
	],inf),
	\flag, Pseq([
		1.0, 1.0, 0.0, 1.0,
	],inf),
	\dur, 1/8,
));
Pdef(~name +++ \pre, 
	Pbind(
		\bufnum, ~buf,
		\range, Pseg(Pseq([
			0.00001,
			0.00002,

			0.00001,
			0.00003,

			0.00001,
			0.00002,

			0.00001,
			0.00007,
		],inf), 2),
		\posenv, Pseq([
			[ Env([0.001,0.102,0.004].integrate.postln,[0.4,0.4]) ],
			[ Env([0.101,0.002,0.104].integrate.postln,[0.1,1.4]) ],
			[ Env([0.301,0.002,0.104].integrate.postln,[0.1,1.4]) ],
			[ Env([0.041,0.102,0.004].integrate.postln,[0.4,0.4]) ],

			[ Env([0.101,0.102,0.004].integrate.postln,[0.4,0.4]) ],
			[ Env([0.201,0.102,0.004].integrate.postln,[0.4,1.4]) ],
			[ Env([0.101,0.002,0.104].integrate.postln,[0.4,0.4]) ],
			[ Env([0.141,0.102,0.004].integrate.postln,[0.4,0.4]) ],
		],inf),
		\blendenv, Pseg(Pseq([
			0,0.5,0,1,
			0,0.1,0,1,

		],inf), 2),
		\posenv, [
			Env([0.001,0.102,0.304].integrate.postln,[1.1,1.04]),
		],
		\posenv, Pfunc { arg ev;
			var env;

			 env = blend(
				 Env([0.041,0.192,0.014].integrate.postln,[0.7,1.04]),
				 Env([0.004,0.012,0.014].integrate.postln,[0.8,0.4]),
				 ev[\blendenv]
			 );
			 [ env ];
		},
		//\ffreq, Ndef(~name+++\lfo1),
		\freqshift, Ndef(~name+++\lfo2).bus.asMap,
	) <>
	Sdef(~name, \mypreset).pdef <> Pbind(
		\freq, Ndef(~name+++\lfo3).bus.asMap,
		\range, Pseg(Pseq([0.0001,0.0008,0.1],inf), Pseq([7,1,0],inf)),
		\range, 0.00001,
		\range, Pseg(Pseq([
			0.00101,
			0.00202,

			0.00101,
			0.00002,
		],inf), 2),
		\range, Pseg(Pseq([
			0.00001,
			0.00202,

			0.00101,
			0.00002,
		],inf), 2),
		\lpmix, Pseq([
			1,1,1,0,
			1,1,1,0,
			0,0,0,0,
			1,0,0,0,

		],inf),
		\lpmix, Pseg(Pseq([
			1,1,1,0,
			1,1,1,0,
			0,0,0,0,
			1,0,0,0,

		],inf),2),
		\blendenv, Pseg(Pseq([
			0,0.01,0,0.1,
			0,0.01,0,0.1,
			0,0.01,0,0.1,
			0,0.1,0,1,

		],inf), 2),
		\posenv, [
			Env([0.001,0.102,0.304].integrate.postln,[1.1,1.04]),
		],
		\posenv, Pfunc { arg ev;
			var env;

			 env = blend(
				 Env([0.141,0.092,0.014].integrate.postln,[2.0,1.04]),
				 Env([0.004,0.012,0.014].integrate.postln,[0.8,0.4]),
				 ev[\blendenv]
			 );
			 [ env ];
		},
	\legato, 1.0,
	\dur, 1/2,
	\amp, 4 * Pkey(\amp),
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
