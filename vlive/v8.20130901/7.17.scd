Pdef(~name +++ \pre, Pbind(
	\freq, (Pseq([
		0,1,5,1,
		0,1,4,1,
		0,2,4,1,
		0,2,3,4,

		0,2,5,1,
		0,1,4,7,
		0,7,4,1,
		0,2,0,4,
	],inf)*8 + 45).midicps - Pwhite(0,10,inf),
	\fmrange, 8.50,
	\freqtab, [ Array.geom(0.4,6.42,8) ] + Pwhite(0,1.0,inf),
	\fmtab, [ Array.geom(0.01,8.12,8) ],
	\cartab, [ Array.geom(0.1,7.02,8) ] + Pwhite(0,10.0,inf),
	\sustain, Pseq([0.1,0.7,0.4,0.1,0.2],inf),

	\octave, 3,
));
