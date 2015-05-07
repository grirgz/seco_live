
(
// xTAGS: pdef, amen, drumloop

Pdef(\amendrum, Pbind(
	\instrument, \stereosampler_stutter_filter,
	\bufnum, BufDef(\amen),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,1.0,0.01) ],
	],inf),
	\envmix, 1,
	\pos, Pfunc({ arg ev;
		~amen_slices[ev[\beat]][0] / ev[\bufnum].duration;
	}),
	\lpmix, 0,
	\hpmix, 0,
	//\isRest, false,
	\dur, 1/8,
	\reprate, Pkey(\repbeat) / Pkey(\dur) * ~t,
	\sustain, Pfunc({ arg ev;
		~amen_slices[ev[\beat]][1]+(1/~t/2*ev[\reprate]);
		ev[\dur]/~t;
		//1/4;
	}),
));

~pa1 = [
	[
		1,0,0,1, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
	],
	[
		0,0,0,0, 0,0,0,1,
		1,1,1,0, 0,0,1,0,
	],
	[
		0,0,0,0, 1,0,0,0,
		0,0,0,0, 1,0,0,0,
	],
	[
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,1,0,0,
	],
	[
		0,1,1,0, 0,1,1,1,
		1,0,1,0, 1,1,0,1,
	],
];

~pa2 = [
	[
		1,0,0,1, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
	],
	[
		0,0,0,0, 0,0,0,1,
		1,0,1,0, 1,0,1,0,
	],
	[
		0,0,0,0, 1,0,1,0,
		0,1,0,0, 1,0,0,0,
	],
	[
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 1,1,1,1,
	],
	[
		0,1,1,0, 0,1,0,1,
		1,0,1,0, 1,1,1,1,
	],
];


~score1 = ~pa2.size.collect ({ arg x;
	[
		Pseq([
			Pseq(~pa1[x]),
			Pseq(~pa1[x]),
			Pseq(~pa1[x]),
			Pseq(~pa2[x]),
		]);
	]
}).debug("score1");


Pdef(~name +++ \pre, 
	Ppar([
		Pdef(\amendrum) <>
		Pbind(
			\repbeat, Pseq([1,2,1,1],inf),
			\speed, 1,
			\beat, \kick1,
			\isRest, Plazy({ Pseq(~score1[0]) }).loop.coin.not,
		),

		Pbind(
			\lpmix, Pseq([0,1,1,0],inf),
			\lpf, 180,
		) <>
		Pdef(\amendrum) <>
		Pbind(
			\repbeat, 1,
			\speed, 1,
			\beat, \kick2,
			\isRest, Plazy({ Pseq(~score1[1]) }).loop.coin.not,
		),
		Pdef(\amendrum) <>
		Pbind(
			\repbeat, 1,
			\speed, Pseq([0,1,2,0,1/2, 0],inf).stutter(8)/2 + ( 1/2 ),
			\beat, \snare1,
			\isRest, Plazy({ Pseq(~score1[2]) }).loop.coin.not,
			\adv, Pkey(\isRest).not,
			\repbeat, Pgate(Pseq([
				2,1,1,1
			],inf), inf, \adv),
		),
		Pdef(\amendrum) <>
		Pbind(
			\repbeat, 1,
			\speed, 1,
			\beat, \tom1,
			\isRest, Plazy({ Pseq(~score1[3]) }).loop.coin.not,
		),
		Pdef(\amendrum) <>
		Pbind(
			\repbeat, 1,
			\speed, 1,
			\beat, \hat1,
			\isRest, Plazy({ Pseq(~score1[4]) }).loop.coin.not,
		),
	])

);


Pdef(~name +++ \prex, Pbind(
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
