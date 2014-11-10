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

));

Pdef(~name +++ \pre, 
	Ppar([
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
			\sig1rel, 0.12,
			\sig2rel, 0.1,
			//\sig2rel, 0.1,
			\freq, 100,
			\amp, Pkey(\amp) * 1.5,
			//\amp, 0,

		), 

		//Pdef(~name+++\base) <> Pbind(
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
						[ Env([0.00,0.0010+0.000021.rand,0.01181].integrate,[0.10,1.6]) ],
						//[ Env([0.00,0.0011+0.000201.rand,0.01181].integrate,[0.10,0.5+0.2.rand]) ],
					],1)
				}),
			],inf).stutter(16),
			\legato, Pseq([
				Prand([
					1,2,3,4,
				],1),
			]/4,inf),
			\dur, 1/3,
			\isRest, false,
			\adsr, Pseq([
				Prand([
					Pfuncn({
						[ Env.adsr(0.01,0.3,0.5,0.08+0.01) ];
					},1),
					Pfuncn({
						[ Env.adsr(0.01,0.3,0.7,0.18+0.01) ];
					},1),
				],1),
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
);

Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	
	sig = Greyhole.ar(sig, 
		\delay.kr(1/4/~t),\damp.kr(0.6),\size.kr(1.1), \diff.kr(0.407) , \feedback.kr(0.79), \modDepth.kr(0.01), \modFreq.kr(8)
	);
	sig = sig/4 + in;

	sig;
});

// END
(
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	
	sig = CombL.ar(sig, 4/~t, 1/16*[1,0.9,0.8]/~t,1/~t);
	sig = CombL.ar(sig, 4/~t, 1/16*[1/4,1,0.7,0.9,0.82]*1/~t,1/~t);
	sig = (sig*10).tanh;
	sig = RLPF.ar(sig,SinOsc.kr(1).range(50,17001));
	sig = sig / 18;
	sig = Splay.ar(sig, 0.4 * SinOsc.kr(1).range(0,1), 1, 0);
	sig = sig + in;

	sig;
});
);

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
