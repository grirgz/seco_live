Pdef(~name +++ \pre, PmonoArtic(~name,
	//\freq, Pseq([,80,60,120],inf),
	\degree, Pseq([
		0,0, 7,7,
		0,7,-3,2,
		0,0, 7,7,
		0,7,-3,2,
	],inf),
	\isRestz, Veco(~namex).isrest(16),
	\isRestz, Pseq([
		1,1,1,0, 1,0,1,1,
		1,1,0,1, 1,0,1,1,
	],inf).coin.not,
	\isRestz, Pseq([
		1,1,1,0, 1,0,1,1,
		1,1,0,1, 1,1,0,1,
	],inf).coin.not,
	\isRest, false,
	\octave, 6,
	\legato, 1,
	\iamp, Pfunc({ arg ev;
		//ev[\isRestz].debug("isrest");
		if(ev[\isRestz]) {
			ev[\legato] = 0.9;
			0
		} {
			1
		}
	}),
	//\iamp, Pseq([1,0,1,0],inf),
	\dur, 1/8,
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.01) ],
	],inf),
));
