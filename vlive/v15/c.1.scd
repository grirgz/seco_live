
//Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
(
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo1, { arg freq=20, flag=0.1; freq.lag(flag)});
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([
		8000,100, 3000,2000,
		10000, 1000,500,2000,
	],inf),
	\flag, Pseq([
		0,0,1,0,
		1.0, 1.0, 0.0, 1.0,
	],inf),
	\dur, 1/4,
));

Ndef(~name+++\lfo3).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo3, { arg freq=20, flag=0.1; freq.lag(flag)});
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\freq, Pseq([
		1000, 1000, 1000, 1000,
		Pseq([1,2,1,1]*200),
		1000, 10, 1, 1000,
		Pseq([0.5,0.5,0.1,0.1,]*400),
		10, 10, 1, 1000,
		Pseq([0.01, 0.01, 0.01, 0.01]*5000),
		Pseq([1,2,1,1,]*140),
		Pseq([0.4, 0.4, 0.4, 0.4]*500),
	],inf),
	\flag, Pseq([
		1.0, 1.0, 0.0, 1.0,
	],inf),
	\dur, 1/8,
));

Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\ffreq, Pseq([
		1000, 1000, 1000, 1000,
		1,2,1,1,
		1000, 10, 1, 1000,
		0.5,0.5,0.1,0.1,
		10, 10, 1, 1000,
		0.01, 0.01, 0.01, 0.01,
		1,2,1,1,
		0.4, 0.4, 0.4, 0.4,
	],inf),
	\ffreq, Ndef(~name+++\lfo1).bus.asMap,
	\freq, Ndef(~name+++\lfo3).bus.asMap,
	//\freq, 500,
));
)
