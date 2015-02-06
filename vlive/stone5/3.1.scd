
(
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo2, { SinOsc.kr(1).range(0.4,1.0)  });
Ndef(~name+++\lfo3).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo3, { SinOsc.kr(1/4).range(0.004,0.1)  });


);

(
~size = 8;
~pat = 
	Pbind(
		\freq, 700,
		\dec, 0.2 + Pwhite(0.0,0.7),
		\dec, 0.01,
		\freqscale, 2.3,
		\sustain, 0.11,
		\freqs, Pseq([
			Pfin(1,Pfunc({
				[ { 150.0.rand + 200 } ! ~size ]
			})),
			Pfin(1,Pfunc({
				[ { 750.0.rand + 100 } ! ~size ]
			})),
		],inf).trace,
		\amps, Pseq([
			Pfunc({
				[ { 0.1.rand + 0.1 } ! ~size ]
			}),
		],inf),
		\decays, Pseq([
			Pfunc({
				[ { 0.101.rand + 0.001 } ! ~size ]
			}),
		],inf),
		\imprate, Pwhite(0.4,8),
		\imprate, Pseries(1,4.41, 16).loop,
		\imprate, Ndef(~name+++\lfo1, { LFSaw.kr(1/2*~t).range(0.1,70.1)  }),
		\imprate, 1,
		\adsr, Pseq([
			Pfunc({
				[ Env.adsr(0.0001,0.1,0.8,0.4,1,-8) ]
			}),
		],inf),
		\isRest, 
			Pseq([
				1, 0,
			],inf).coin.not,
		\dur, 1/4,
	);

Pdef(~name +++ \pre, 
	Ppar(
		[
			~pat,
			Pbind(
				\imprate, 5,
				\isRest, Pseq([
					1,
				],inf).coin.not,
			) <> ~pat,
			Pbind(
				\imprate, 10,
				\isRest, Pseq([
					0,0,0,1,
				],inf).coin.not,
			) <> ~pat,
		]
	)
);
)
