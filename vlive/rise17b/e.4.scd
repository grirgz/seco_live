Pdefn(~name+++\freq,
	(60 * Pseq([
			Prand([0,3,7,9],8),
			Prand([0,3,6,-10],8),
		],inf).midiratio * 16) * Prand([Pn(1/4,4),Pn(1/2,4),Pn(1/4,4),Pseq([1,1/4,1/4,1/4],1)],inf),
		\freq, ~f
);
Pdef(~name +++ \pre, Pbind(
	//\freq, 100,
	\instrument, ~name+++\b,
	\amp, Pkey(\amp) * 2,
	\degree, Pseq([
		Prand([0,1,4,0]),
		Prand([0,1,4,0])+8,
	],inf) + Ptuple([0,Pseq([3,5],inf)]),
	\freqx, ~frozzer.(Pdefn(~name+++\freq), Pseq([
		0,0.41,0,0,
		1,1,1,1,
	],inf).coin.not),
	\lpffac, Ndef(~name+++\lfo1, { CuspN.ar(1/7).range(0.50,4)  }),
	\adsr, Prand([
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
		[ Env.adsr(0.001,0.1,0.8,1.1) ],
		[ Env.adsr(0.1,0.1,0.8,0.001) ],
		[ Env.adsr(1.1,0.1,0.8,0.1) ],
	],inf).stutter(4),
	//\lag, Ptuple([0,
	//	Prand([
	//		1/~t,
	//		1/2/~t,
	//		1/4/~t,
	//		0,
	//	])
	//],inf),
	//\scale, [1,2.5,7.3,5,7],
	\scale, Scale.minor,
	\octave, 4,
	\dur, 1/4,
	\legato, Pseq([
		4,2,1,1,
	],inf),
	\isRest, false,
));
