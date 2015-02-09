
(
Ndef(~name+++\lfo1, { EnvGen.kr(Env([1,2,4]/4,[0.01,2.8]), \ttrig.tr(1)); });
Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\bufnum, BufDef(\march),
	\bufnum, BufDef(\scream),
	\pos, 0,
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\dur, 1,
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,1.01) ],
	],inf),
	\legato, 2,
	\speed, Pseq([0.1],inf).stutter(4),
	\fspeed, Pseq([
		1,1,1,1, 1,1,1,1,
	],inf).stutter(2)*1/8,
	\speedlag, Pseq([
		0,0,4,0,
	],inf),
	\speedlagfmamp, 0.31,
	\speedlagfm, 0.31,
	\aspeed, Pfunc({ arg ev;
		if(ev[\isRest].not) {
			Ndef(~name+++\lfo1).set(\ttrig, 1);
			Ndef(~name+++\lfo1);
		} {
			Ndef(~name+++\lfo1);
		};
	}),
));


)
