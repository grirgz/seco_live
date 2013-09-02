
Pdef(~name+++\pre, Pbind(
	\instrument, ~name,
	\freq, Pseq([8,4,2,4,1],inf) * Pwhite(0.9,1.3),
	\detune, 7,
	\minBpfHz, 0.01,
	\maxBpfHz, 1.expexp(1.0,16.0,0.1,76.0),
	\minRq, 0.003,
	\maxRq, Pexprand(0.008,0.128).stutter(3),
	\minCf, Pseq([70,20,30,80,50,60,98],inf).midicps * Pwhite(0.9,1.3),
	//\maxCf, Pkey(\minCf) * Pwhite(1.3,4),
	\maxCf, 51.midicps * [1,1.1,1.5].wchoose([0.87,0.1,0.03]),
	\atk, exprand(0.7,8),
	\rel, 1.5,
	\sus, rrand(0.6,1.0),
	\spread, exprand(1.5,8.0),
	\dur, Pseq([2,1]/2,inf)*Pwhite(0.8,1.3),
))
