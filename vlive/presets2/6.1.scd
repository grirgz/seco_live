Pdef(~name+++\pre, Pbind(
	//\freq, Pseq([100,200,400,200],inf) + Pseq([0,350,240,50],inf).stutter(4),
	\degree, Pseq([
		0,2,3,0, 2,4,6,2,
		Pseq([0,2,3,0, 2,4,6,2]+3),
	],inf),
	\scale, Scale.minor,
	\dur, 1/8,
	\legato, 0.5,
	\isRest, false,
	\isRest, ~restbyfreq.([
		1,2,3,4,
		1,2,3,4,
	]),
	\isRest, ~restbyfreq.([
		1,1,1,1,
		2,2,2,2,
		4,2,4,8,
		1,2,1,2,
	]),
	\isRest, ~restbyfreq.([
		1,2,4,2,
		4,8,8.4,8,
		1,2,4,2,
		4,8,8.4,8,
	]),
	\isRest, ~restbyfreq.([
		1,1,4,4,
		2,2,3,3,
		1,1,4,4,
		2,2,3,3,
	]),
));

// END

~restbyfreq.([1,2,0,0]).asStream.nextN(16)
