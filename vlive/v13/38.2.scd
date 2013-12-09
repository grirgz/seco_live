Pdef(~name +++ \pre, Pbind(
	//\freq, 100,
	//\note, Pseq([[0,7],[1,8],[-1,5]]-2,inf),
	//\note, Pseq([0,1,2,3,4],inf)
	//\octave, Pstep(Pseq([3,4],inf),Pseq([5,0.75],inf)),
	\octave, 3,
	\degree, Pseq([
		0,2,4,4, 0,0,-2,1,
		0,0,1,1, 0,0,-2,1,
	],inf).stutter(4),
	\degree, Pseq([
		0,0,0,0,
		0,0,1b,1, 

		0,0,0,0,
		0,0,1b,1, 

		0,1,0,0,
		0,0,1b,1, 

		0,0,0,0,
		0,0,2,1, 
	],inf).stutter(4),
	//\freq, 
	\scale, Scale.minor,
	\minfreq, 50,
	\isRest, Veco(~namex).isrest(16),
	\decaytime, 1.0,
	\adsr, Pseq([
		[Env.adsr(0.02,0.1,0.8,0.4,curve:0.5)],
		[Env.adsr(0.02,0.1,0.8,0.4,curve:0.5)],
		[Env.adsr(0.02,0.1,0.8,0.4,curve:0.5)],
		[Env.adsr(0.03,0.1,0.8,0.1,curve:0.5)],
		[Env.adsr(0.03,0.1,0.8,0.1,curve:0.5)],
		[Env.adsr(0.03,0.1,0.8,0.1,curve:0.5)],
	],inf),
	\adsr, Pseq([
		//[Env.adsr(0.02,0.1,0.8,0.4,curve:0.5)],
		[Env.adsr(0.02,0.1,0.8,0.04,curve:0.5)],
	],inf),
	\legato, 0.9,
	\ffreq, [500,610,820,140],
	//\ffreq, 500,
	//\ffreqtab, [[0.8,1,1.1,1.2, 2,4,5,6, 8,10].scramble.postln],
	\ffreqtab, Pfunc{ [[ 0.1, 0.2, 0.3, 0.5,  1,2,3,8, 10, 12  ].scramble] + rrand(0.01,1.0); },
	//\ffreqtab, [ 6, 4, 5, 10, 1, 1.2, 0.8, 1.1, 2, 8  ], // also nice
	//\ffreqtab, [[ 6, 4, 5, 10, 1, 1.2, 0.8, 0.4, 2, 8  ]],
	\dur, Pseq([3,1,1, 0.25,0.25,0.25],inf),
	\dur, 1/8,
));
