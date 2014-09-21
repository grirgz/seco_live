Pdef(~name +++ \pre, PmonoArtic(~name+++\b,
	\freq, Pseg(Pseq([700,701],inf),8),
	\freq, Pseq([700,750,760,500],inf).stutter(8) * [1,3/5,4/5],
	\freq, Pseq([
		100,150,100,500,
		100,150,100,200,
		100,150,100,500,
		100,150,120,100,
	],inf).stutter(8*4) * [1,3/5*2,4/5*3] * 4,
	\amp, Pkey(\amp) * 0.4,
	\dur, 1/8,
	\legato, Pseq([
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,1,

		1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,0.8,
	],inf),
	\seq1, Ppatlace([Pseq([1,4],inf),Pseq((1..64)/64*8,inf)],inf).stutter(4),
	\seq1, Ppatlace([Pseq(((1..64)/64*8).reverse,inf),Pseq((1..64)/64*8,inf)],inf).stutter(4),
	\seq1, Pseg(Pseq([100,41],inf),8)/100,
	\seq1, 001,
	\seq2, Pseq([
		0.9,0.58,4,8,
		0.9,0.58,4,8,
		0.9,0.58,4,8,
		0.9,1.58,2,2,
	],inf).stutter(8),
	\seq2, Pseg(Pseq([1,2],inf),8)/10000,
	\seq2, 0,
	\lpf, 1000,
	\amp, Pkey(\amp) * Pseq([
		1,0.5,1,1,0.5,
	],inf).stutter(4),
	\irelease, Pseq([
		1,5,1,1,
		1, 1,1,1,
		1, 1,1, 2,
		6, 1,1,1,
		1, 1,1,
		
	],inf)/10,
	\iadsr, Pfunc({ arg ev;
			[ Env.adsr(0.01,0.1,0.8,ev[\irelease]) ]
	}),
	\igate, Pseq([
		0,0,0,0, 1,0,0,0,
		1,0,0,0, 1,0,0,0,
	],inf),
));
