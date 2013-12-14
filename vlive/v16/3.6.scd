Pdef(~name +++ \pre, Pbind(
	\instrument, ~name+++\2,
	\degree, Pseq([0],inf),
	\isRest, Pseq([
		Veco(~namex).isrest(32, 1),
	],inf),
	\shift, 050+Pwhite(1,5),
	\shift, Pseq([100,0,50,100,-200],inf),
	\legato, Pseq([0.1,0.4]+0.7,inf),
	\legato, Pseq([0.1,3,0.7,1,0.5,2]/2,inf),
	\legato, 0.1,
	\lpfreq, Pseq([12000,5000,8000],inf),
	\delayfactor, Pseq([1,2,4,0.2,4],inf),
	\noisefreq, 80,
	\release, Pseq([0.12,0.03,0.1,0.091,0.13],inf).stutter(1),
	\adsr, Pn(Plazy({ arg ev;
		Pseq([
			[ Env.adsr(0.0001,0.001,0.8,ev[\release]) ],
		],1)

	})),
	\freqfactor, Pseq([1,1.1,0.42],inf),
	\freqfactor, 1,
));
