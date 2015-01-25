
Pdef(~name+++\pre, Pbind(
	\pos, 0.75732882889595,
	\pos, 0.25732882889595,
	\legato, Pseq([
		1,1,1,1, 1,1,1,1,
		Pseq([
			4,4,4,4, 2,4,4,1,
		]*1,1),

	],inf),
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
	],inf),
	\rate, Pseq([210/4,220/4],inf).stutter(32),
	\gdur, 0.3,
	\dur, 1/2,
	\amp, 17,
	\bufnum, BufDef.mono(\march),
	\bufnum, BufDef.mono(\table),
));
