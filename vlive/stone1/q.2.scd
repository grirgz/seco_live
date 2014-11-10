
~size = 8;
Pdef(~name +++ \pre, Pbind(
	\freq, 700,
	\dec, 0.2 + Pwhite(0.0,0.7),
	\sustain, 0.91,
	\freqs, Pseq([
		Pfunc({
			[ { 7520.rand + 50 } ! ~size ]
		}),
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
	\imprate, Pwhite(0.4,8),
	\adsr, Pseq([
		Pfunc({
			[ Env.adsr(0.0001,0.1,0.8,0.4,1,-8) ]
		}),
	],inf),
	\isRest, Pseq([
		0,1,
	],inf).coin.not,
	\dur, 2,
));
