
Pdef(~name +++ \pre, Pbind(
	\framepos,19096, 
	\speed, 0.21,
	\adsr, Pseq([
		[ Env.adsr(0.01,0,1,0.01) ],
	],inf),
	\dur, 2,
	\isRest, Pseq([
		1,0, 
	],inf).coin.not,
	\sustain, 09021 / s.sampleRate  / Pkey(\speed) * ~t,
	\bufnum, BufDef(\amen),
	\freq, 100,
));

// END

~select_sample_position.(BufDef(\amen).path);
