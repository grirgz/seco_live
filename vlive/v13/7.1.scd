(
Ndef(~name+++\lfo1, { arg freq; SinOsc.kr(freq*t).range(50,400)  });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([4,2,8,4],inf),
	\dur, 1,
));
Pdef(~name +++ \pre, Pbind(
	\degree, Pseq([0,1,-2,2]+8,inf),
	\degree, 0,
	\scale, Scale.minor,
	\octave, 4,
	\freq, Pseq([700,600,500]/2,inf)* [1,0.98],
	\freq, Ndef(~name+++\lfo1).bus.asMap,
	\ffreq, 700,
	//\ffreq, Ndef(~name+++\lfo1),
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.2) ],
		[ Env.adsr(0.01,0.1,0.8,0.42) ],
	],inf),
	\ffenv, Pseq([
		[Env([0,1,0]*16000, [0.4,3])],
		[Env([0,1,0]*9000, [0.1,0.3])],
	],inf),
	\fenv, Pseq([
		[ Env([0,1,0], [0.31,0.1], [9,9]) ],
		[ Env([0,1,0], [0.1,0.1], [9,9]) ],
	],inf),
	//\isRest, Veco(~name).isrest,
	\offset, 0.0001,
	\offset, Pseg(Pseq([0.001,0.015],inf), 8),
	\legato, Pseq([4.0,1,1,1],inf),
	\dur, 1/8,
));
)
