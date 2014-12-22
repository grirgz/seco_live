BufDef(\march, "vipere/march.flac");
BufDef(\table, "field/table.flac");
BufDef.mono(\table, "field/table.flac");
BufDef.mono(\march, "vipere/march.flac");
(
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,0.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,1.9)).range(0,0.02) + 0.15  });
~buf = BufDef(\moeten);
~buf = BufDef(\table);
~bufm = BufDef.mono(\table);
//Ndef(~name+++\lfo1, { Phasor.kr(0, (1/SampleRate.ir).poll *1, 0, 0.81) + 0.1 + LFPulse.kr(8).range(0,0.0001).lag(0.1)});
//Ndef(~name+++\lfo1, { 0.1 + LFPulse.kr(1).range(0,0.0008).lag(0.4)});
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,1.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(1.18).range(0,1.02) + 10.45  });
//Ndef(~name+++\lfo2, { LFSaw.kr(SinOsc.kr(1.12).range(0.01,4.9)).range(0.0001,0.0012)  });
Pdef(~name+++\base, 
	Pseq([

	
		Pbind(
			\isRest, Pseq([
				1,0,0,1, 0.61,0,1,0,
				1,0.2,0,0.2, 0,1,0,0,
			],inf).coin.not,
			\isRest, Pseq([
				1,0,0,0, 0.61,0,0,0,
				0,0,0.6,0, 0,0,0,0,
			],inf).coin.not,
			\isRest, Pseq([
				1,0,0,0, 0.61,0,0,0,
				0,0,0.6,0, 0,0,0,0,
				0,0.2,0,0, 0.61,0,0,0,
				0,0,0.6,0, 0,0,0,0,
				0,0,0.5,0, 0.61,0,0,0,
				0,0,0.6,0, 0,0,0,0,
				0,0.2,0,0, 0.61,0,0,0,
				0,0,0.6,0, 0,0,0,0,
			],inf).coin.not,
			\dur, (1/8),
			\amp, Pkey(\amp) * 0.41,
		),
		Pbind(
			\dur, (1/4),
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
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, Pkey(\amp) * 0.41,

		)
	])
);

Pdef(~name +++ \pre, 
	Ppar([
		//Pbind(\isRest, true) <>
		Pseed(100, Pdef(~name+++\base)) <> Pbind(
			\instrument, ~name+++\b,
			\lpfenv1, Pseq([
				[ Env([1,0.1],[0.16], -5) ],
			],inf),
			\lpfenv2, Pseq([
				[ Env([1,0.41],[0.01]) ],
			],inf),
			\lpfenv3, Pseq([
				[ Env([1,0.41],[0.01]) ],
			],inf),
			\levelScale, 0.5,
			\sig2rel, Pseq([
				0.1,0.07, 0.2,0.1
			],inf).stutter(1),
			\sig1rel, 0.010,
			\sig2rel, 0.010,
			//\sig2rel, 0.1,
			\freq, 100,
			\amp, Pkey(\amp) * 0.4,
			//\amp, 0,

		), 

		//Pbind(\isRest, true) <>
		Pseed(100, Pdef(~name+++\base)) <> Pseq([
			Pbind(
				\instrument, ~name+++\gran,
				\pos, [0.15732882889595,0.29] + Pseq([0.1,0.2],inf),
				\pos, 0.51732882889595+ Pseg(Pseq([0,0.001],inf),32),
				\legato, 0.1,
				\adsr, Pseq([
					Pseq([
						[ Env.adsr(0.000001,0.1,0.2,1.4,1,-2) ],
					],1),
					Pseq([
						[ Env.adsr(0.000001,0.1,0.2,0.1,1,-2) ],
					],7),
				],inf),
			\legato, Pseq([
				Prand([
					1,0.3,0.3,0.3, 0.1,0.3,0.3,0.3,
				],1).stutter(1),
			],inf),
				\rate, 148 * Pseq([2,1],inf).midiratio,
				\gdur, 0.103,
				\amp, 17,
				\bufnum, BufDef.mono(\march),
				\bufnum, BufDef.mono(\table),
			
			),
		],1),

		//Pdef(~name+++\base) <> Pbind(
		//Pbind(\isRest, true) <>
		Pseed(100, Pdef(~name+++\base)) <> Pbind(
			\instrument, \oscsampler3,
			\pos, 0.014 + Pseq([0,1,0,2],inf).stutter(8)/100,
			\pos, 0.25732882889595,
			\freq, 11,
			\range, 0.0000001,
			\ffreqtab, Pseq([[Array.geom(8,1.8,1.2)]],inf),
			\posenv, Prand([
				Plazy({
					Pseq([
						Pseq([
							[ Env([0.00,0.00070+0.000021.rand,0.00184181,-0.00181,0.001801].integrate,[0.10,0.6,0.5,1.5]) ],
							//[ Env([0.00,0.0011+0.000201.rand,0.01181].integrate,[0.10,0.5+0.2.rand]) ],
						],1),
						Pser([
							[ Env([0.00,0.00010+0.000021.rand,0.00184181,-0.00181,0.001801].integrate,[0.10,0.6,0.5,1.5]) ],
							[ Env([0.00,0.00020+0.000021.rand,0.00184181,-0.00181,0.001801].integrate,[0.10,0.6,0.5,1.5]) ],
							[ Env([0.00,0.00030+0.000021.rand,0.00184181,-0.00181,0.001801].integrate,[0.10,0.6,0.5,1.5]) ],
							//[ Env([0.00,0.0011+0.000201.rand,0.01181].integrate,[0.10,0.5+0.2.rand]) ],
						],7)
					],1)
				}),
			],inf).stutter(1),
			\legato, Pseq([
				Prand([
					1,
					Pseq([
						0.1
					],7),
				],1).stutter(1),
			]/4,inf),
			\dur, 1/3,
			\adsr, Pseq([
				Prand([
					Pfuncn({
						[ Env.adsr(0.01,0.3,0.5,1.88+0.01) ];
					},1),
//					Pfuncn({
//						[ Env.adsr(0.01,0.3,0.7,0.18+0.01) ];
//					},1),
				],1),
				Pseq([
					Pfuncn({
						[ Env.adsr(0.01,0.3,0.5,0.18+0.01) ];
					},1),
					
				],7),
			],inf),
			\bufnum, ~buf,
			\rq, 0.1,
			\fshift, 100,
			//\fshift, Pwrand([0,-400,-300,200],[1.90, 0.1,0.1,0.1].normalizeSum,inf),
			\lpmix, 1,
			\ffreq, 200 + Pwhite(0.0,100),
			\ffreq, 588.43493629781 + Pwhite(0.0,100),
			\hpmix,1,
			\hpfreq, 100,
			\amp, 709.0 * Pkey(\amp),

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
