
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
		\kick1,\hat1, \snare1, \hat1,
		\tom1,\hat1, \snare1, \hat1,
		\kick2,\hat1, \snare1, \hat1,
		\tom1,\hat1, \snare1, \hat1,
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
	\dur, 1/2,
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
	\legato, 0.5,
	\sustain, Pfunc({ arg ev;
		var totdur, slicedur, beatdur, res;
		totdur = ev[\dur]/~t;
		beatdur = ~amen_slices[ev[\beat]][1];
		slicedur = totdur/ev[\reprate];
		res = slicedur * ev[\reprate];
		~amen_slices[ev[\beat]][1]+(1/~t/2*ev[\reprate]);
		ev[\dur]/~t * min(ev[\reprate] *  ev[\legato], 1 );
		ev[\reprate]*ev[\dur]/~t/4
		//1/4;
	}),
	\freq, 100,
));
)

// END

BufDef(\amen).duration
~t
