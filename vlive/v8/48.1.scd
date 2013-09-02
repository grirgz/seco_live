
Pdef(~name+++\pre, Pbind(
	\instrument, ~name,
	\freq, Pseq([8,4,2,4],inf) * Pwhite(0.9,1.3),
	\detune, 7,
	\minBpfHz, 0.01,
	\maxBpfHz, Pwhite(0.1,76),
	\minRq, 0.003,
	\maxRq, exprand(0.008,0.8),
	\minCf, Pseq([70,20,30,80,50,60,98],inf).midicps * Pwhite(0.9,1.3),
	\maxCf, Pkey(\minCf) * Pwhite(1.3,4),
	\atk, exprand(0.7,8),
	\rel, 1.5,
	\sus, rrand(2.6,3.0),
	\spread, exprand(1.5,8.0),
	\dur, Pseq([2,1],inf)*Pwhite(0.9,1.3),
))
