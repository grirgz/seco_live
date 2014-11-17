
(
Ndef(~name+++\lfo1, { SinOsc.kr(1/5).range(150,4100)  });
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Pdef(~name +++ \pre, Pbind(
	\degree, Pseq([0],inf) + Pseq([
		[0,2,4],
	],inf),
	\mtranspose, Pstep(Pseq([0,2],inf),2),
	\legato, Pseq([
		0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.4, 0.1,
		0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 2.4, 0.1,

		0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.4, 0.1,
		0.1, 0.1, 2.1, 0.1, 0.1, 0.1, 0.4, 0.1,
	],inf) + Pseq([
		Pfunc({
			[0.2,0,0.05].scramble
		})
	],inf),
	\lpf, Ndef(~name+++\lfo1),
	\amp, Pkey(\amp) * 1/18,
	\isRest, Pseq([
		0,1,0.81,0.3, 0.91,0.81,0.91,0,
		0,1,1,0, 1,1,1,0,

		0,1,1,0.7, 1,1,1,0,
		1,0,1,0, 1,1,1,0,

		0,1,1,0, 1,0.71,1,0,
		0,1,1,1, 1,1,1,0,

		0,1,1,0, 1,1,1,0,
		0,1,1,0, 1,1,1,1,
	],inf).coin.not,
	\dur, 1/8,
));
)
