Pdef(~name +++ \pre, PmonoArtic(~name+++\b,

	\freq, Pseg(Pseq([100,101],inf),8),
	\dur, 1/8,
	\sfreq, Pseq([
		1700,2700,4578,125,
		100,200,478,125,
		100,200,478,7125,
	],inf).stutter(2),
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
	\igate, Pseq([
		1,0,0,0, 1,0,0,0,
		1,1,1,1, 1,1,1,1,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		
		1,1,1,1, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		1,1,1,1, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
	],inf),
	\seq1, 8,
	\seq2, Pseq([
		0.9,0.58,4,8,
		0.9,0.58,4,8,
		0.9,0.58,4,8,
		0.9,1.58,2,2,
	],inf).stutter(2),
	\igate, Pseq([
		//1,0,1,0, 1,0,1,0,
		1,0,0,1, 1,0,1,0,
		0,0,0,0, 1,0,0,0,
		1,0,0,0, 0,0,0,0,
		0,0,1,1, 0,0,0,0,

		1,0,0,1, 1,0,1,0,
		0,0,0,0, 1,0,0,0,
		0,0,0,0, 1,0,0,0,
		1,0,1,0, 0,0,0,0,
	],inf),
));