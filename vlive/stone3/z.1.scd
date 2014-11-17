(
Pdef(~name +++ \pre, Pmono(~name,
	\freq, 60.midicps / 4 * Pseq([0,7].midiratio,inf).stutter(8),
	\fmrange, Pseq([0.5,1,1.5],inf),
	\fmfreq, Pseq([0.5,1,2,4],inf),
	\dur, 1/1,
	\igate, Pseq([
		1,1,1,1,
		0,0,0,0,
	],inf),
	\lpf, Pkey(\freq) * Pseq([2,1,4,8],inf).stutter(2),
	\hpf, Pkey(\freq) / 2,
	\isRest, false,
));
)


