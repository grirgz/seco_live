
Ndef(~name+++\lfo3, { arg freq=20; freq.lag(0.101)});
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\freq, Pseq([
		Pseq([800,50],8),
		Pseq([200,50,20,100],4),
		Pseq([800,20],8),
		Pseq([800,200,800,100],4),
	],inf),
	\dur, PdurStutter(Pseq([
		1,1,1,1,
		1,1,1,4,
		2,1,2,1,
		4,1,1,4,
	],inf),1/2),
));
