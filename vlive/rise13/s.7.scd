Pdef(~name +++ \pre, Pbind(
	\note, Pseq([
		0,0, 1,1,
		0,0, 4,3,
		0,0, 3,3,
		0,4, 4,3,

		0,0, 6,5,
		0,0, 4,3,
		0,0, 3,3,
		0,4, 4,3,

	],inf).stutter(2),
	\freqfac_saw, Pseq([
		2,5,5,5,
		7,2,5,5,
	],inf),
	//\scale, Scale.minor,
	\ctranspose, -4,
	\octave, 3,
	\dur, 1/2,
	//\amp, 4,
	\amp, Pkey(\amp) * 2,
	\isRest, Pseq([1,0,0,0],inf).coin.not,
	\isRest, Pseq([
		1,0,0,0,
		1,1,1,0,
		1,0,0,0,
		1,0,1,0,
		1,0,0,0,
		1,0,0,0,
		1,0,0,0,
		1,1,1,0,
		1,0,0,0,
		1,0,1,0,
	],inf).coin.not,
	\isRest, Pseq([
		1,0.51,1,1,
		1,0.95,1,0.51,
		1,1,1,0.95,
		0.951,1,1,1,
	],inf).coin.not,
	\legato, Pseq([
		1,0,2,0,
		2,0,1,0,
		1/5,1/5,0,1/5,
		0.8,0.8,0.8,0.8,

		1,00.9,1,0,
		1/5,1/5,0,1/5,
		1,0,2,0,
		0.8,1.8,0.0,0.8,
		
	],inf),
	\isRest, Pfunc({ arg ev;
		if(ev[\legato] == 0) {
			true
		} {
			false
		}
	}),
));
