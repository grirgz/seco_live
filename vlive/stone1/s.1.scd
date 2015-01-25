
// TAGS: perc, pdef, klank
~size = 8;
Pdef(~name +++ \pre, Pbind(
	\freq, 700,
	\dec, 1.2 + Pwhite(0.0,0.7),
	\freqs, Pseq([
		Pseq([
			Pfunc({
				[ { 720.rand + 750 } ! ~size ]
			}).stutter(8),
		],16),
		Pseq([
			Pfunc({
				[ { 17520.rand + 7050 } ! ~size ]
			}),
		],16),
	],inf).trace,
	\amps, Pseq([
		Pfunc({
			[ { 0.1.rand + 0.1 } ! ~size ]
		}),
	],inf),
	\decays, Pseq([
		Pfunc({
			[ { 0.1.rand + 0.1 } ! ~size ]
		}),
	],inf),
	\imprate, Pwhite(0.1,8),
	\imprate, Prand((1..8),inf).stutter(2) * 2,
	\adsr, Pseq([
		Pfunc({
			[ Env.adsr(0.0001,0.1,0.8,0.1,1,-8) ]
		}),
	],inf),
	\legato, 1,
	\isRest, Pseq([
		1,0,0,0, 1,1,1,0,
		1,0,0,0, 0,0,0,0,
		1,0,1,1, 0,0,0,0,
		0,0,0,0, 0,1,0,0,
	],inf).coin.not,
	\dur, 1/2,
));
