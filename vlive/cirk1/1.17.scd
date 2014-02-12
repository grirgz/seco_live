Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([50,50,60,40],inf).stutter(8) + [0,Pseq([1,0.5,2,1],inf).stutter(2)],
	\isRest, Veco(~namex).isrest(32),

	//\freq, Pseq([50,60],inf) + 0,
	\legato, 2.4,
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.004) ],
	],inf),
	\dur, Pseq([1/8],inf);
));
Pdef(~name+++\pre).quant=4;

(
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([
		4,4,4,8,
		4,4,4,8,
		8,8,4,4,
		8,8,4,4,

		4,6,4,8,
		4,6,4,8,
		8,8,4,4,
		8,8,4,4,
	],inf) * Pfunc({ ~num_beats }),
	\choose, Pseq([
		0,0,0,0,
		0,0,1,1,
		0,1,1,0,
		1,0,0,0,
	],inf),
	\base, Pseq([
		1000,1500,5000,2000,
		2000,2500,5000,7000,
	],inf).stutter(1),
	\time, Pseq([1,1,1,2],inf).stutter(4),
	\dur, 1/2,
));
Ndef(~name+++\fx).put(1, \set -> Pbind(
	//\freq, Pseq([
	//	4,4,4,8,
	//	0,0,0,0,
	//	8,8,4,4,
	//	0,0,0,0,
	//],inf),
	\choose, Pseq([
		0,2,0,2,
		0,2,0,0,
		0,1,0,2,
		0,0,1,1,
	],inf).stutter(2),
	\time, 2,
	//\base, Pseq([5000,5000,5000,2000],inf),
	//\time, Pseq([1,1,1,2],inf).stutter(4),
	\dur, 1/2,
));
);

// END

Ndef(~name+++\fx).play;
