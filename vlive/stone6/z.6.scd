
Pdef(~name+++\pre, Pbind(
	\instrument, ~name+++\b,
	\pos, 0.75732882889595,
	\pos, 0.25732882889595,
	\legato, 3,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,2.1) ],
	],inf),
	\rate, Pseq([210/4,220/4],inf).stutter(32),
	\gdur, 0.3,
	\dur, 1,
	\amp, 17,
	\bufnum, BufDef.mono(\march),
	\bufnum, BufDef.mono(\table),
));
