
Pdef(~name +++ \pre, Pbind(
	\degree, Prand([0,2,4],inf),
	\octave, Prand([3,4,5,2,6,4],inf),
	\scale, Scale.minor,
	\ctranspose, Pstep(Pseq([0,4,2,5],inf),8),
	\ffreq, Prand([200,600],inf) * Pwhite(0.2,5.2),
	\ffreq, Prand([80,150,90,80, 200,600,1200,1000],inf),
	\legato, Prand([4.5,2,1.9,2.5],inf),
	\adsr, [Env.adsr(0.3,0.1,0.8,0.5)],
	\blende, Pseg(Pseq([0,1],inf),16),
	\adsr, Pfunc { arg ev;
		[Env.adsr(0.03,0.1,0.8,0.05)].blend(
			[Env.adsr(0.3,0.1,0.8,0.5)],
			ev[\blende]
		)
	},
	\adsr, [Env.adsr(0.03,0.1,0.8,0.05)],
	\isRest, ~isrest.(Pseq([
		Pseq([1,0,0,0, 0,0,0,0],4),
		Pseq([1,0,0,0, 1,0,0,0],4),
		Pseq([1,0,0,0, 1,0,1,0],4),
		Pseq([1,0,0,0, 1,1,1,0],4),
		Pseq([1,0,1,0, 1,1,1,0],8),
	],inf)),
	\legato, 1.2,
	\dur, Prand([0.5,0.7,0.8,0.9]/10,inf),
	\dur, Pseq([0.01,0.02,0.03,0.05]+0.1,inf),
	\dur, Pwhite(0.05,0.2),
	\out, BusDef(~name+++\fx),
	\dur, 1/8,
));
