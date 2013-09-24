Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([200,700],inf),
	\dur, 1/2,
	\sustain, 0.4,
	//\legato, 1,
));
Ndef(~name+++\fx, Ndef(~name+++\fx_i).source);
