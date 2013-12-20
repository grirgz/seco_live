Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([50,52],inf).stutter(8),
	\freq, 60,
	\freq, Pseq([
		50, 54, 51, 50,
		52, 52, 52, 52,
	]+10,inf).stutter(8) ,
	\oscmix, Ndef(~name+++\lfo1, { SinOsc.kr(2).range(0,1) }),
	\adsr, Pseq([
		[ Env.adsr(0.001,0.1,0.8,0.44, 1, 0) ],
		[ Env.adsr(0.001,0.1,0.8,0.44, 1, 0) ],
	],inf).stutter(32),
	\env, Pseq([
		[Env([00.1, 0.4201,0.0001],[0.07,1.4])],
		[Env([01.0, 0.4201,0.0001],[0.07,1.4])],
	],inf).stutter(4),
	\env1, Pseq([
		[Env([00.1, 0.4201,0.0001],[0.07,1.4])],
		[Env([00.1, 0.4201,0.0001],[0.07,1.4])],
		[Env([01.0, 0.4201,0.0001],[0.07,1.4])],
	],inf).stutter(4),
	\dur, 1/8,
	\legato, Pseq([1],inf),
	\legato, 0.1,
));
