Pdef(~name +++ \pre, Pbind(
	\isRest, Veco(~namex).isrest(16),
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\shift, Pseq([
		100,0,50,100,-200,
		200,0,50,100,-200,
	],inf),
	\shift, Pseq([
		100,0,
	],inf),
	\legato, Pseq([
		0.1,3,0.7,1,
		0.1,2.3,0.7,1,
		0.5,2
	],inf),
	\legato, Pseq([
		0.1*2.5, 0.1
	],inf) * 8,
	\sustain, 0.1,
	\freqfactor, Pseq([
		1.1,0.92,
		1.2,0.99,
		1.051,0.90,
		1.15,0.94,
	],inf),
	\dur, Pkey(\dur) * ~swing1,
));

// END

Ndef(~name+++\mixer).set(\xfade, 0.5)
Ndef(~name+++\mixer).set(\xfade, 0)
Ndef(~name+++\mixer).set(\xfade, 1)
