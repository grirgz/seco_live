(
	Ndef(~name+++\lfo1, { arg freq=2; SinOsc.kr(freq*t).range(50,3100)  });
	Ndef(~name+++\lfo1).put(1, \set -> Pbind(
		\freq, Pseq([1,4,8,4,8],inf),
		\dur, Pseq([4,2],inf),
	));
	Ndef(~name+++\lfo1).quant = 4;
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([
		//[400,100],
		[400,100]+300,
		[100,200]+200,
	],inf),
	\freq, Pwhite(0,1100.0).stutter(16),
	\freq, Pseq([50,60,50,80]*1.2,inf).stutter(8),
	\dur, Prand([1/2,1/4],inf),
	\dur, 1/4,
	\isRest, false,
	\amp, Pkey(\amp) * 4,
	\isRest, Pseq([1,0.5,1,0.5],inf).coin.not,
	\ffreq, Ndef(~name+++\lfo1),
	\legato, 1,
	\isRest, Pseq([
		1,0.8,1,0.8,
		0,0,0.1,0.1,
	],inf).coin.not,
));
)
