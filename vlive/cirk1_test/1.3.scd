Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([50,60,40],inf) + [0,1],

	//\freq, Pseq([50,60],inf) + 0,
	\legato, 1,
	\dur, Pseq([1/4,1/8,1/8]*8,inf);
));
Pdef(~name+++\pre).quant=4;

(
Ndef(~name+++\lfo1).quant=4;
Ndef(~name+++\fx).map(\ffreq, Ndef(~name+++\lfo1));
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
	//\choose, Pseq([
	//	0,0,0,0,
	//	1,1,1,1,
	//	0,0,0,0,
	//	1,1,1,1,
	//],inf),
	\base, Pseq([1000,1500,5000,2000],inf).stutter(4) + Pseq([0,-500,0,500],inf),
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
		0,0,0,0,
		0,0,0,1,
	],inf).stutter(4),
	\time, 2,
	//\base, Pseq([5000,5000,5000,2000],inf),
	//\time, Pseq([1,1,1,2],inf).stutter(4),
	\dur, 1/2,
));
);

// END

Ndef(~name+++\fx).play;
