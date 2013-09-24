Pdef(~name +++ \pre, Pbind(
	\noisefreq, 10.1,
	\delayfactor, 0.8,
	\shift, -230,
	\degree, Pseq([0],inf),
	\freq2, 1480,


	\fbase, 2000 + Pseq([1,1.5,1.7,0.5],inf).stutter(4),
	\fbase2, 1500,

	\fscale, Pseq([1.8,1.7,0.6],inf),
	\fscale2, 3.4,

	\decay, 0.2,
	\decay2, 0.1,

	\freqfactor, Pseq([1,1.1,0.42,1.3],inf),
	\freqfactor2, Pseq([1,1.1,0.42,1.3],inf),
	\freqfactor, 1,
));
