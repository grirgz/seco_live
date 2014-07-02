Pdef(~name +++ \pre, Pbind(
	\freq, 400 * (2**([0/12,2/12,5/12])),
	\freq, Pseq([
		(2**([0/12,2/12,5/12])),
		(2**([0/12,3/12,6/12])),
	],inf).stutter(8) * Pseq([400, [400,200], [400,100,800], [100,200,400]],inf).stutter(8),
	\sawtab, Plazy({ arg ev;
		Pseq([
			[ { 10.rand} ! 8 + ev[\freq]];
		])
	}).loop,
	\sigmix, Pseg(Pseq([0.2,0.8,Pwhite(0.0,8,1),Pwhite(0.0,8,1)],inf),16),
	\detune, Pseq([1,0,5,-8],inf).stutter(8) * 2,
	\legato, 0.3,
	\amp, Pseq([1,0.5,0.7,0.3],inf).stutter(1) * Pkey(\amp) * Pseq([1,0.8,1,0.8,1,0.4],inf).stutter(8) * 0.1,
));
