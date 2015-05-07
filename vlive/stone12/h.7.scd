
(

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
		\kick1, \hat1, \hat2, \hat1, 
		\tom1, \hat1, \hat2, \hat1, 
		\kick1, \hat1, \kick1, \hat1, 
		\tom1, \hat1, \hat2, \hat1, 
		\kick1, \hat1, \hat1, \kick1, 
		\tom1, \hat1, \kick2, \hat1, 
		\kick1, \kick1, \hat1, \hat1, 
		\tom1, \hat1, \hat2, \hat1, 
	],inf),
	\speed, Pseq([
		1,1,1,1,
		1,1,1,0.8,
	],inf)/1,
	\bufnum, BufDef(\amen),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,1.0,0.03) ],
	],inf),
	\envmix, 1,
	\pos, Pfunc({ arg ev;
		~amen_slices[ev[\beat]][0] / ev[\bufnum].duration;
	}),
	\pos, Pseq([0.2,0.1]/1,inf) + Pseq([0.1,0.2,0.1,0.3],inf).stutter(8),
	\isRest, false,
	\isRest, Pseq([
		1
	],inf).coin.not,
	\dur, 1/8,
	\reprate, Pseq([
		Prand((1..4),1),1,
		Prand((1..4),1),1,
		1,Prand((1..4),1),
		1,Prand((1..4),1),
		1,1,Prand((1..4),1),1,
		1,1,Prand((1..4),1),1,
	],inf) / Pkey(\dur) * ~t,
	\reprate, Pseq([
		1,1, 1,1, 1,1, 4,4,
	],inf) / Pkey(\dur) * ~t,
	\sustain, Pfunc({ arg ev;
		~amen_slices[ev[\beat]][1]+(1/~t/2*ev[\reprate]);
		ev[\dur]/~t;
		//1/4;
	}),
	\sustain, Pseq([0.1],inf),
	\freq, 100,
));
)

// END

BufDef(\amen).duration
~t
