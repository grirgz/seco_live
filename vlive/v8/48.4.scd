
Pdef(~name+++\pre, Pbind(
	\instrument, ~name,
	\freq, Pseq([1,2,4,2,1],inf) * Pwhite(1,4)/4,
	\detune, 0,
	\minBpfHz, 0.1,
	\maxBpfHz, Pseq([7,2,13,2],inf).expexp(1.0,16.0,0.1,076.0),
	\minRq, 0.003,
	\maxRq, Pseq([
		Pexprand(0.008,0.028,4).stutter(2),
		Pexprand(0.008,0.228,1).stutter(1),
	],inf),
	//\minCf, Pseq([65,75,50,55,58,60,78],inf).midicps * Pwhite(0.9,3.3),
	\minCf, Pseq([90,94,80,150],inf) * Pexprand(1.0,4.3).stutter(3),
	\minCf, Pseq([490,94,80,150],inf) * Pexprand(1.0,1.3),
	\maxCf, Pkey(\minCf) * Pwhite(1.3,1.5),
	\atk, Pexprand(0.007,8),
	\rel, Pwhite(0.5,3.5),
	\sus, Pwhite(0.2,4.0),
	\spread, Pexprand(1.5,8.0),
	\dur, Pseq([2,1],inf)*Pwhite(0.8,2.3),
	\dur, Pseq([1],inf),
))
