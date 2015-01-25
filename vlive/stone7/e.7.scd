(
// TAGS: pdef, bass, richtimbre, pmono
Pdef(~name +++ \pre, Pmono(~name,
	\freq, 400/4 * Pseq([
		Pseq([
			0,5
		],1),
		Pseq([
			0,4
		],1),
	].midiratio,inf).stutter(4),
	\fmrange, Pseq([0.5,8],inf),
	\fmfreq, Pseq([1,2],inf),
	\dur, 1/2,
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


