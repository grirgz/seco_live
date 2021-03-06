(
Ndef(~name+++\lfo1, { arg freq; SinOsc.kr(freq).range(80,200) });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([
		8,4,16,32,
		8,4,16,1,
	],inf).stutter(4),
	\dur, 1/4,
));
Ndef(~name+++\lfo2, { arg fmax; SinOsc.kr(1/8).range(15,fmax.lag(0.1)) });
Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	\fmax, Pseq([
		1000,4000,8000,3100,
		5000,4000,8000,3100,
		1000,4000,8000,3100,
		10000,4000,8000,3100,
	],inf),
	\dur, 1/4,
));
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([50,60,70,60],inf).stutter(8),
	\freq, Ndef(~name+++\lfo1).bus.asMap,
	\ffreq, 4700,
	\ffreq, Pseq([100,200,4000,4700],inf),
	\ffreq, Ndef(~name+++\lfo2),
	\legato, Pseq([1,1,0.1,0.1,0.5],inf).stutter(8),
	\legato, 1,
	\adsr, Pseq([
		[Env.adsr(0.01,0.1,0.8,0.401)]
	],inf),
));
)
