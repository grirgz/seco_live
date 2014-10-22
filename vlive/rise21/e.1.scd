(
Pdef(~name +++ \pre, Pmono(~name,
	\freq, 70 * Pseq(( [0,1]+(2*12) ).midiratio,inf).stutter(16),
	\fmrange, Pseq([0.5,1,1.5],inf),
	\fmfreq, Pseq([0.5,1,2,4],inf),
	\dur, 1/4,
	\igate, Pseq([
		1,0,1,0,
		0,0,0,0,
		1,0,1,1,
		0,1,1,0,

		1,0,1,0,
		0,0,0,0,
		1,0,1,0,
		1,0,1,1,
	],inf),
	\iadsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.4) ],
	],inf),
	\lpf, Pkey(\freq) * Pseq([2,1,4,8],inf).stutter(8),
	\hpf, Pkey(\freq) / 2,

	\amp, Pkey(\amp) * 2,
	\isRest, false,
));
)


