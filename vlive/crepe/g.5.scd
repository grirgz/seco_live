Pdef(~name +++ \pre, Pbind(
	\note, Pseq([
		[0,4,10],
		[0,5,9],
		[0,5,8],
		[0,4,7],
	],inf).stutter(32),
	\octave, 5,
	//* Pseq([1/3,2/3,1]*440,inf).stutter(6),
	\dur, 1/4,
	\sigmix, Pseg(Pseq([0.2,0.8,Pwhite(0.0,8,1),Pwhite(0.0,8,1)],inf),16),
	\detune, Pseq([1,0,5,-8],inf).stutter(8) * 2,
	\legato, 0.3,
	\amp, Pseq([1,0.5,0.7,0.3],inf).stutter(1) * Pkey(\amp) * Pseq([1,0.8,1,0.8,1,0.4],inf).stutter(8) * 0.1,
));
