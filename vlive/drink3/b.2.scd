Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\legato, Pwhite(0.2,2.5),
	\dur, 1/4,
	\rfreqtab, Plazy({
		Pseq([
			//[230,71,73,220].scramble,
			//[130,171,73,220].scramble,
			//[140,81,73,220].scramble,
			//[130,131,133,120,120,120,120,120].scramble * (0.2+1.8.rand),
			[[83,84,87,90,120,122,124,130].scramble * 2],
			[[83,84,87,90,120,122,124,130].scramble * 1.3],
			[[83,84,87,90,120,122,124,130].scramble * 2],
			[[83,84,87,90,120,122,124,130].scramble * 1.45],
			[[83,84,87,90,120,122,124,130].scramble * 2],
			[[83,84,87,90,120,122,124,130].scramble * 1.1],
		])
	}).loop,
	\rringtab, Pseq([
		[[2.01,1.1,2.1,3.1, 1,1,1,1].scramble/5]
	],inf),
	\amp, Pkey(\amp) * 1,
	\adsr, Pseq([
		[ Env.adsr(0.101,0.1,0.8,0.2) ],
	],inf),
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
		1,0,0,0, 0,0,0,0,
		1,0,1,0, 1,0,0,0,
		1,0,0,0, 0,0,0,0,
		1,0,0,1, 1,0,1,0,
		1,0,1,0, 1,0,0,0,
	],inf).coin.not,
	\isRest, Pseq([
		0,0,0,0, 1,0,0,0,
		0,0,0,0, 0.71,0,1,0,
		0,0,0.41, 1,0,0.41,0,
		0,0,0,0, 0.2,0,0.7,0,
		0.5,0,0,0, 0.2,0,0,0,
	],inf).coin.not,
));
