
(
Ndef(~name+++\lfo1, { SinOsc.kr(1/5).range(150,4100)  });
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Pdef(~name +++ \pre, Pbind(
	\degree, Pseq([0],inf) + Pseq([
		[0,2,4],
	],inf),
	\mtranspose, Pstep(Pseq([0,2],inf),2),
	\lpf, Ndef(~name+++\lfo1),
	\amp, Pkey(\amp) * 1/18,
	\isRest, Pseq([
		0,0,0,0, 1,0,1,0,
		0,0,1,0, 1,0,1,0,
	],inf).coin.not,
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
	\dur, 1/8,
));
)
