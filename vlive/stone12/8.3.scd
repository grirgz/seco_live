BufDef(\march, "vipere/march.flac");
BufDef(\table, "field/table.flac");
(
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,0.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,1.9)).range(0,0.02) + 0.15  });
~buf = BufDef(\table);
~buf = BufDef(\plateau, "field/plateau.wav");
//Ndef(~name+++\lfo1, { Phasor.kr(0, (1/SampleRate.ir).poll *1, 0, 0.81) + 0.1 + LFPulse.kr(8).range(0,0.0001).lag(0.1)});
//Ndef(~name+++\lfo1, { 0.1 + LFPulse.kr(1).range(0,0.0008).lag(0.4)});
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,1.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(1.18).range(0,1.02) + 10.45  });
//Ndef(~name+++\lfo2, { LFSaw.kr(SinOsc.kr(1.12).range(0.01,4.9)).range(0.0001,0.0012)  });
Pdef(~name+++\base, Pbind(
			\dur, (1/8) + Pwhite(0,1/8),
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
				1,0,0,0, 
			],inf).coin.not,

));

Pdef(~name +++ \pre, 
	Ppar([
		Pbind(\isRest, true) <>
		Pseed(100, Pdef(~name+++\base)) <> Pbind(
			\instrument, ~name+++\b,
			\lpfenv1, Pseq([
				[ Env([1,0.1],[0.16], -5) ],
			],inf),
			\lpfenv2, Pseq([
				[ Env([1,0.4],[0.01]) ],
			],inf),
			\lpfenv3, Pseq([
				[ Env([1,0.3],[0.01]) ],
			],inf),
			\levelScale, 0.5,
			\sig2rel, Pseq([
				0.1,0.07, 0.2,0.1
			],inf).stutter(1),
			\sig1rel, 0.22,
			//\sig2rel, 0.1,
			\freq, 100,
			\amp, Pkey(\amp) * 0.5,

		), 

		//Pdef(~name+++\base) <> Pbind(
		Pseed(100, Pdef(~name+++\base)) <> Pbind(
			\instrument, \oscsampler3,
			\pos, 0.014 + Pseq([0,1,0,2],inf).stutter(8)/100,
			\pos, 0.21032882889595 + Pwhite(0,0.01),
			\freq, 18,
			\range, 0.00001,
			\ffreqtab, Pseq([[Array.geom(8,1.8,1.2)]],inf),
			\posenv, Prand([
				Plazy({
					Pseq([
						[ Env([0.00,0.0080+0.000201.rand,0.09181].integrate,[0.07,1.4]) ],
					],1)
				}),
			],inf).stutter(1),
			\legato, 0.2,
			\dur, 1/3,
			\isRest, false,
			\adsr, Pseq([
				Pfuncn({
					[ Env.adsr(0.01+0.2.rand,0.3,0.5,0.1+0.81.rand) ];
				},1),
			],inf),
			\bufnum, ~buf,
			\rq, 0.1,
			//\fshift, Pwrand([0,-400,-300,200],[1.90, 0.1,0.1,0.1].normalizeSum,inf),
			\lpmix, 1,
			\ffreq, 200 + Pwhite(0.0,100),
			\ffreq, 1288.43493629781 * Pseq([1,1.02,Pwhite(1.0,1.1,1)],inf).stutter(40),
			\amp, 109.0 * Pkey(\amp) * 1/2,

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
