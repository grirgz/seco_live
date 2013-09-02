Pdef(~name +++ \pre, Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\shift, Pseq([100,0,50,100,-200],inf),
	\shift, Ndef(~name+++\lfo1, { SinOsc.kr(2).range(-100,700) }),
	\legato, Pseq([0.1,2,0.1,3,0.2],inf),
	\freqfactor, Pseq([2,0.1,0.42],inf),
	\freqfactor2, Pseq([1,0.1,0.42]/15,inf),
	\delayfactor, Pseq([1,1.1,0.42]*2,inf),
));
