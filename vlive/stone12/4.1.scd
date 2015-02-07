Pdef(~name +++ \pre, Pbind(
	\instrument, ~name+++\b,
	\prob, Pseq([
		0,0.5,0.2,0.7,
	],inf),
	\amp, Pkey(\amp) * 0.5,
	\isRest, Pfunc({ arg ev;
		ev.isRest || ev.prob.coin;
	
	}),
	\isRest, Veco(~namex).isrest(32),
	\isRest, Pseq([
		1,0,0,0, 1,0,0,0,
		1,0,0,0, 1,0,0,0,
		1,0,0,0, 1,0,0,0,
		Prand([
			Pseq([
				1,0,1,0, 1,0,1,0,
			],1),
			Pseq([
				1,1,1,1, 1,0,1,0,
			],1),
			Pseq([
				1,0,1,0, 1,1,1,1,
			],1),
			Pseq([
				1,0,0,0, 1,0,0,0,
			],1),
			Pseq([
				0,0,1,0, 0,0,1,0,
			],1),
		],1),

	],inf).coin.not,
	\isRest, Pseq([
		0,0,0,0, 0,0,0,0,
		0,1,1,1, 1,1,1,1,
		0,0,0,0, 0,0,0,0,
		0,1,1,1, 0,0,1,1,
	],inf).coin.not,
	\degree, Pseq([0],inf),
	\shift, Pseq([100,0,50,100,-200],inf).stutter(4),
	\legato, Pseq([0.1,3,0.7,1,0.5,2],inf),
	\freqfactor, Pseq([1,1.1,0.42],inf),
	\freqfactor, [
		Ndef(~name+++\lfo1, { SinOsc.ar(0.1).range(0.2,2) }),
		0.5,
	],
	\freqfactor, Pseq([
		4,4,2,4,
		3,3,3,3,
	],inf).stutter(8),
	\shift, Pseq([
		//Pwhite(-700,700)
		100
	],inf).stutter(1),
	\hpfreq, 40,
	\attack, 0.002,
	\decay, 1/16 + Pwhite(0.0,0.01),
	\legato, Pseq([
		Pseq([
			8,7,6,5,4,3,2,1,
		],1)/4,
		Pseq([
			8,7,6,5,4,3,2,1,
		].mirror,1)/4,
		Plazy({
			Pseq([
				8,7,6,5,4,3,2,1,
			].scramble,1)/4
		}),

		//Pser([0.1,0.2],16),
	],inf).stutter(2) / 2,
));
