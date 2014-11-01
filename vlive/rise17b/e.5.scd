Pdef(~name +++ \pre, 
	Pseq([
			Pbind(
			//\freq, 100,
			\instrument, ~name+++\b,
			\degree, Pseq([
				Prand([0,1,4,0]),
				Prand([0,1,4,0])+8,
			],inf) + Ptuple([0,Pseq([3,5],inf)]),
			\freq, (60 * Pseq([
				Prand([
					0,3,[0,4,7]
				],4) + Pseq([
					0,12
				]).stutter(4),
				Prand([
					7,10,[7,10]
				],4) + Pseq([
					0,12
				]).stutter(4),
				Prand([
					5,9,7
				],4) + Pseq([
					0,12
				]).stutter(4),
			],1).midiratio * 16) * Prand([1,1/2,1/4,1],inf).stutter(1),
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
			\dur, 2,
			\legato, 3.5,
			\isRest, false,
		),
		Pbind(
			//\freq, 100,
			\instrument, ~name+++\b,
			\degree, Pseq([
				Prand([0,1,4,0]),
				Prand([0,1,4,0])+8,
			],inf) + Ptuple([0,Pseq([3,5],inf)]),
			\freq, (60 * Pseq([
				[0,3,4,7,10]
			],8).midiratio * 16) * Prand([1/2],inf).stutter(1),
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
			\dur, 1/2,
			\legato, 3.5,
			\isRest, false,
		),

	])
);
	
