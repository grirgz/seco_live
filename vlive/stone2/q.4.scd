Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\dur, 1/16,
	\isRest, Veco(~namex).isrest(16),
	\fmix, 0.01,
	\fratio3, Pseq([1,2,4,9, 12,1,15,1],inf).stutter(8),
	\timeScale, 1/2,
	\pan, Pseq([
		Pwrand([
			-1,0,1,

		], [0.1,1,0.1])/2 + 0.5
	],inf),
	\elpf, 17000,
	\ehpf, 50,
	//\amp, Pkey(\amp) * Pseq([
	//	1,0.3,0.8,0.6,

	//],inf).stutter(1),
	\isRest, Pseq([
		1,
	],inf).coin.not,
	\dur, PdurStutter(Pseq([8,2,16,1],inf), 1),
	\isRest, Pstep(Pseq([0.5,0,1,0.1],inf),2).coin.not,
	\dur, Pstep(Pwhite(1/16,0.5),4),
	\timeScale, Pseg(Pwhite(1/8,1),4),
	\fmix, Pseg(Pwhite(0.0,1),4),
));
