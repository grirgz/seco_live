(
Pdef(~name +++ \pre, Pmono(~name,
	\freq, 400/4 * Pseq([
		Pser([
			0,0,8,2,
		],8),
		Pser([
			0,0,8,8,
			7,7,7,1,
		],8),
		Pser([
			0,0,7,1,
		],8),
		Pser([
			0,0,7,8,
			0,0,7,1,
		],8),
	].midiratio,inf).stutter(2),
	\fmrange, Pseq([0.5,1/8,1],inf),
	\fmfreq, Pseq([1,2,16,1/8,1/4],inf),
	\dur, 1/4,
	\lag, Ppatlace([0, Pseg(Pseq([0,1,0,0.5],inf),8)*0.1],inf),
	\igate, Pseq([
		1,1,1,1,
		1,0,1,1,

		1,1,0,1,
		1,1,1,1,
	],inf),
	\lpf, Pkey(\freq) * Pseq([2,1],inf).stutter(2),
	\hpf, Pkey(\freq) / 2,
	\isRest, false,
));
)


