
Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\pos, Pseq([
		Prand([
			Pseq([
				1,5,2,4,
				Pseq([7],4),
				1,5,2,4,
				Pseq([6],4),
				Pseq([
					1,5,2,4,
				],1).stutter(2),
				Pseq([1],4),
				Pseq([8],4),
			],1),
			Pseq([
				4,1,1,4, 1,1,4,1,
				2,1,2,1/4, 1,1,4,8,
			],4),
		],1),
	]/10,inf),
	\bufnum, BufDef(\scream),
	\speed, Pseq([1]/4,inf).stutter(4),
	\fspeed, Ndef(~name+++\lfo1, { SinOsc.kr(1/8*~t).range(0,6) }),
	\fspeed, Pseq([
		2,2,16,16,
		4,2,16,16,
		Prand([
			Pseq([
				8,8,1,1,
				2,2,8,16,
			]),
			Pseq([
				2,2,1,16,
				4,2,16,16,
			]),
			Pseq([
				2,2,8,8,
				8,1,8,16,
				2,2,8,8,
				8,4,2,1,
			],1),
			Pseq([
				2,2,16,16,
				4,2,16,16,
				2,2,16,16,
				3,2,16,16,
			],1),
		],4),
	],inf).stutter(2),
	\aspeed, Pseq([
		8,0,2,-4,
		0,0,6,-4,
		8,0,2,-4,
		0,0,-4,0,
	]/4,inf),
	\aspeed, Pseq([
		1,1,1,1,
	]/4,inf),
));

