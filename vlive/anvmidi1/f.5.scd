BufDef(\march, "vipere/march.flac");
(
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,0.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,1.9)).range(0,0.02) + 0.15  });
~buf = BufDef(\march);
~buf = BufDef(\moeten);
BufDef(\moto, "vipere/moto.flac");
~buf = BufDef(\moto);
//Ndef(~name+++\lfo1, { Phasor.kr(0, (1/SampleRate.ir).poll *1, 0, 0.81) + 0.1 + LFPulse.kr(8).range(0,0.0001).lag(0.1)});
//Ndef(~name+++\lfo1, { 0.1 + LFPulse.kr(1).range(0,0.0008).lag(0.4)});
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,1.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(1.18).range(0,1.02) + 10.45  });
//Ndef(~name+++\lfo2, { LFSaw.kr(SinOsc.kr(1.12).range(0.01,4.9)).range(0.0001,0.0012)  });
Pdef(~name+++\prebase, Pbind(
	\dur, 1,
	\legato,4,
	\freq, 100,
	\timeScale, 8,
	\amp, Pseq([1,0],inf) * Pkey(\amp)
));

Pdef(~name +++ \pre,
	Ppar([
		Pbind(
			\freq, 50,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0.0,0,0, 1,0,0,0,
			],inf).coin.not,
			\posenv, Pseq([
				//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
				[ Env([0.00,0.001,0.0071].integrate.postln,[0.04,0.21]) ],
				[ Env([0.00,0.011,0.0071].integrate.postln,[0.04,0.21]) ],
			],inf).stutter(16),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.3,0.5,0.05) ],
			],inf),
			\range, 0.00001,

		) <> Pdef(~name+++\prebase),
		Pbind(
			\freq, 60,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0.0,0,0, 1,0,0,0,
			],inf).coin.not,
			\posenv, Pseq([
				//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
				[ Env([0.00,0.003,0.0071].integrate.postln,[0.04,0.21]) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.3,0.5,0.05) ],
			],inf),
			\range, 0.00001,

		) <> Pdef(~name+++\prebase),
		Pbind(
			\freq, 60,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0.0,0,0, 0,0,0,0,
			],inf).coin.not,
			\posenv, Pseq([
				//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
				[ Env([0.00,0.003,0.0171].integrate.postln,[0.04,0.21]) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.3,0.5,0.05) ],
			],inf),
			\range, 0.00001,

		) <> Pdef(~name+++\prebase),

	])
);
);

// END

Pdef(~name +++ \pre, 
	Pbind(
		\freq, 100,
		\isRest, Pseq([
			0,0,0,0, 0,0,0,0,
			0.5,0.0,0,0, 1,0,0,0,
		],inf).coin.not,
		\posenv, Pseq([
			//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
			[ Env([0.001,0.111,0.0071].integrate.postln,[0.02,0.01]) ],
			[ Env([0.001,0.111,0.0071].integrate.postln,[0.02,0.01]) ],
		],inf),
		\adsr, Pseq([
			[ Env.adsr(0.01,0.3,0.5,0.01) ],
			[ Env.adsr(0.01,0.3,0.5,0.11) ],
		],inf),
		\range, 0.0001,

	) <>
	
	Pbind(
	\freq, 100,
	\pos, Pseq([0.0,0.01,0.02,0.03],inf),
	\pos, Pseg(Pseq([0,0.1],inf),32)+0.5,
	\pos, 0.112,
	\posenv, Pseq([
		//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
		[ Env([0.001,0.002,0.004].integrate.postln,[0.01,0.1]) ],
		[ Env([0.001,0.003,0.004].integrate.postln,[0.01,0.1]) ],
		[ Env([0.001,0.0013,0.004].integrate.postln,[0.01,0.1]) ],
	],inf),
	\fshift, Pseq([0,48,-40],inf),
	\fshift, 0,
	\fshift, 48,
	\lpmix, 0.99,
	\rq, 0.4,
	\posenv, Pseq([
		//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
		[ Env([0.001,0.011,0.0071].integrate.postln,[0.2,0.4]) ],
	],inf),
	//\pos, Ndef(~name+++\lfo1),
	//\pos, Pseq([0,0.1,0.5],inf) + Pwhite(0,0.01),
	//\finepos, Ndef(~name+++\lfo1),
	//\range, Pseg(Pseq([0.001,0.21],inf),8),
	//\range, Ndef(~name+++\lfo2),
	\range, 0.0001,
	\ffreq, Pseq([100,300,200,200],inf),
	\ffreq, Pseq([1000,3000,200,2000],inf),
	\ffreq, Pseq([60,70,100,120],inf),
	\ffreq, 1980,
	\bufnum, ~buf,
	\ffreqtab, Pn(Plazy({
		[{ 2.rand } ! 8]
	})),
	\ffreqtab, Pseq([
		[[2.3,3.2,0.1,0.1, 0.2,0.8,1.2,1.5]],
	],inf),
	\ffreqtab, Pseq([[Array.geom(8,0.1,1.2).postln]],inf),
	\ffreqtab, Pseq([[Array.series(8,0.1,0.1).postln]],inf),
	\legato, 0.5,
	\amp, 1 * Pkey(\amp),
));
)
