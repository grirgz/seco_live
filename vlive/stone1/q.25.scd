
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;

~size = 8;
Pdef(~name +++ \pre, Pbind(
	\freq, 700,
	\dec, 0.2 + Pwhite(0.0,0.7),
	\dec, 0.1,
	\sustain, 2.91,
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
	\imprate, Ndef(~name+++\lfo1, { LFSaw.kr(1/2*~t).range(0.1,20.1)  }),
	\adsr, Pseq([
		Pfunc({
			[ Env.adsr(0.0001,0.1,0.8,0.4,1,-8) ]
		}),
	],inf),
	\isRest, Pseq([
		1, 1,
	],inf).coin.not,
	\dur, 4,
));
