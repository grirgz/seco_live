
// xTAGS: perc, echo, metallic, pdef, klank
~size = 8;
Pdef(~name +++ \pre, Pbind(
	\freq, 700,
	\isRest, false,
	\sustain, 0.01,
	\freqs, Pseq([
		Pfunc({
			[ { 520.rand + 50 } ! ~size ]
		}),
	],inf).trace,
	\amps, Pseq([
		Pfunc({
			[ { 0.1.rand + 0.1 } ! ~size ]
		}),
	],inf),
	\decays, Pseq([
		Pfunc({
			[ { 0.1.rand + 0.1 } ! ~size ]/100
		}),
	],inf),
	\imprate, Pwhite(0.4,8),
	\adsr, Pseq([
		Pfunc({
			[ Env.adsr(0.0001,0.1,0.8,2.1.rand+9.5,1,-8) ]
		}),
	],inf),
	\dur, 1.1,
));
