(
Ndef(~name+++\lfo_hooo, { Latch.kr(~hooo_lfo2, Impulse.kr(1/4*~t)) * 100 });
Pdef(~name +++ \pre, Pmono(~name+++\trig,
	\freq, 400/5 * Pseq([0,1,-1,0].midiratio,inf).stutter(16),
	\freq, ~hooo_lfo2.asMap,
	\freq, Ndef(~name+++\lfo_hooo),
	\freqx, 100,
	\fmrange, Pseq([0.0,5,9],inf),
	\fmfreq, Pseq([0.5,1],inf).stutter(8),
	\dur, 1/8,
	\igate, Pseq([
		1,0,0,0, 1,0,1,0,
		1,0,1,0, 0,1,0,0,
	],inf),
	\isustain, Pseq([
		4.1,0.5, 0.11,0.5, 4.1,0.5, 0.11,0.5,
		0.7,0.5, 4.11,0.5, 1.1,0.5, 1.11,0.5,
	],inf) * 1/8,
	\iadsr, Pseq([
		Pfunc({ arg ev;
			[ Env.adsr(0.01,0.1,0.8,0.2) ]
		}),
	],inf),
	\lpf, Pkey(\freqx) * Pseq([2,1],inf).stutter(2),
	\lpf, Pkey(\freqx) * Pseq([2,4],inf).stutter(8),
	\hpf, Pkey(\freqx) / 4,
	\isRest, false,
));
)

// END

~hooo_lfo2
