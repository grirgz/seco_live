(
Pdef(~name +++ \pre, Pmono(~name+++\trig,
	\freq, 400/5 * Pseq([0,1,-1,0].midiratio,inf).stutter(16),
	\fmrange, Pseq([0.5,1,1.5,4, 5,9],inf),
	\fmfreq, Pseq([0.5,1,2, 4,7,8,9],inf),
	\dur, 1/8,
	\igate, Pseq([
		1,1,0,0, 1,0,1,0,
		1,1,0,1, 1,1,1,0,
	],inf),
	\isustain, Pseq([
		0.1,0.5, 0.11,0.5,
		0.1,2.5, 2.11,0.5,
		0.1,0.5, 0.11,0.5,
		0.7,0.5, 0.11,2.5,
	],inf) * 1/8,
	\iadsr, Pseq([
		Pfunc({ arg ev;
			[ Env.adsr(0.01,0.1,0.8,0.2) ]
		}),
	],inf),
	\lpf, Pkey(\freq) * Pseq([2,1,4,8],inf).stutter(2),
	\lpf, Pkey(\freq) * Pseq([2,4,7,8, 9,1,4,8],inf).stutter(2),
	\hpf, Pkey(\freq) / 4,
	\isRest, false,
));
)


