
(
// TAGS: pdef, amen, drumloop

Pdef(~name +++ \pre, Pbind(
	\instrument, \stereosampler_stutter,
	\freq, Pseq([1],inf),
	\igate, Pseq([
		1,1,1,1,
	],inf)/2,
	\beat, Pseq([
		//\hat1,
		//\kick1,\hat1,
		//\tom1, \hat1,
		\kick1,
	],inf),
	\beat, Pseq([
		\kick1,\hat1, \tom1, \hat1,
		\kick2,\hat1, \tom1, \hat1,
	],inf),
	\speed, Pseq([
		Prand([
			1,
			1,
			1,
			1,
			1,
			Pwhite(1/2,2,1),
		],1),
	],inf),
	\bufnum, BufDef(\amen),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,1.0,0.01) ],
	],inf),
	\envmix, 1,
	\pos, Pfunc({ arg ev;
		~amen_slices[ev[\beat]][0] / ev[\bufnum].duration;
	}),
	\isRest, false,
	\dur, 1/4,
	\reprate, Pseq([
		//2,1, 4,1,
		Prand((1..4),8),
		1,4,1,4,
		4,1,1,4,

	],inf) / Pkey(\dur) * ~t,
	\reprate, Pseq([
		Prand((1..4),1),1,
		Prand((1..4),1),1,
		1,Prand((1..4),1),
		1,Prand((1..4),1),
		1,1,Prand((1..4),1),1,
		1,1,Prand((1..4),1),1,
	],inf) / Pkey(\dur) * ~t,
	\sustain, Pfunc({ arg ev;
		~amen_slices[ev[\beat]][1]+(1/~t/2*ev[\reprate]);
		ev[\dur]/~t;
		//1/4;
	}),
	\freq, 100,
));
)

// END

BufDef(\amen).duration
~t
