BufDef(\march, "vipere/march.flac");
BufDef(\table, "field/table.flac");
(
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,0.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,1.9)).range(0,0.02) + 0.15  });
~buf = BufDef(\moeten);
~buf = BufDef(\table);
//Ndef(~name+++\lfo1, { Phasor.kr(0, (1/SampleRate.ir).poll *1, 0, 0.81) + 0.1 + LFPulse.kr(8).range(0,0.0001).lag(0.1)});
//Ndef(~name+++\lfo1, { 0.1 + LFPulse.kr(1).range(0,0.0008).lag(0.4)});
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,1.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(1.18).range(0,1.02) + 10.45  });
//Ndef(~name+++\lfo2, { LFSaw.kr(SinOsc.kr(1.12).range(0.01,4.9)).range(0.0001,0.0012)  });
Pdef(~name+++\base, Pbind(
			\dur, (1/8),
			//\lag, 0.03,
			\isRest, Pseq([
				Prand([
					Pseq([
						0,0,0,0,
						1,0,0,0,
						0,0,0,0,
						0,0,0,0,
					],1),
					Pseq([
						0,0,0.1,0,
						1,0,0,0,
						0,0,0,0,
						0,0,0,0,
					],1),
				],1),
			],inf).coin.not,
			\isRest, Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				1,0,0,0,
			],inf).coin.not,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\amp, Pkey(\amp) * 3

));

Pdef(~name +++ \pre, 
	Ppar([
		Pseed(100, Pdef(~name+++\base)) <> Pbind(
			\instrument, ~name+++\b,
			\lpfenv1, Pseq([
				[ Env([1,0.1],[0.16], -5) ],
			],inf),
			\lpfenv2, Pseq([
				[ Env([1,0.4],[0.01], -5) ],
			],inf),
			\lpfenv3, Pseq([
				[ Env([1,0.2],[0.01], -4) ],
			],inf),
			\levelScale, 0.5,
			\sig2rel, Pseq([
				0.1,0.07, 0.2,0.1
			],inf).stutter(1) + 0.1,
			\sig1rel, 0.2,
			//\sig2rel, 0.1,
			\freq, 100,
			\amp, Pkey(\amp) * 0.07,
			//\amp, 0,

		), 

		//Pdef(~name+++\base) <> Pbind(
		Pdef(~name+++\base) <> Pbind(
			\instrument, \oscsampler3,
			\pos, 0.014 + Pseq([0,1,0,2],inf).stutter(8)/100,
			\pos, 0.53332882889595 + Pwhite(0.0,0.001),
			\freq, 418,
			\range, 0.0000001,
			\ffreqtab, Plazy({
				Pseq([[Array.geom(8,0.2,1.4123+0.01.rand).postln]],1)
			}).loop,
			\posenv, Prand([
				//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
				//[ Env([0.00,0.0189,0.401].integrate.postln,[0.01,0.1]) ],
				[ Env([0.00,0.00071,0.01081].integrate.postln,[0.07,2.4]) ],
			],inf).stutter(1),
			\legato, 0.2,
			\dur, 1/3,
			\isRest, false,
			\adsr, Pseq([
				Pfuncn({
					[ Env.adsr(0.01,0.3,0.5,0.4+0.01) ];
				},1),
			],inf),
			\bufnum, ~buf,
			\rq, 0.1,
			//\fshift, Pwrand([0,-400,-300,200],[1.90, 0.1,0.1,0.1].normalizeSum,inf),
			\lpmix, 1,
			\ffreq, 200 + Pwhite(0.0,100),
			\ffreq, 988.43493629781,
			\amp, 109.0 * Pkey(\amp),

		) 	
	])
);
)

// END

Pdef(~name +++ \pre, Pbind(
	\instrument, ~name+++\b,
	\lpfenv, Pseq([
		//[ 
		//	Env([1,0.2],[0.1]),
		//	Env([1,0.2]/2,[0.01]),
		//	Env([1,0.4],[0.01]),
		//],
		[ 
			Env([1,0.1],[0.1]),
			Env([1,0.1],[0.01]),
			Env([0.21,0.7],[0.01]),
		],
	],inf),
	\levelScale, 0.5,
	\sig2rel, Pseq([
		0.1,0.07, 0.2,0.1
	],inf).stutter(1),
	\sig1rel, 0.22,
	//\sig2rel, 0.1,
	\freq, 100,
	\amp, Pkey(\amp) * 0.5,
	\isRest, Pseq([
		0,0,0,0, 1,0.31,0,0,
	],inf).coin.not,
));
