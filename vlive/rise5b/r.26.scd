Ndef(~name+++\lfo1).quant = 2;
Pdef(~name +++ \pre, 
	Pbind(
		\fratioc, Pwhite(0.1,1),

	) <>

	Sdef(~name, \mypreset).pbind <>
	
	Pbind(
	\isRest, Veco(~namex).isrest(32),
	\fratio, Pseq([1.5,2.3,2.7,2.1,1.8],inf).stutter(8),
	\fratio, 2,
	//\release, Pseq([0.1,0.7, 0.5,0.1, 1.1]/2,1),
	//\release, Pn(0.21,1),
	\modamp, Ndef(~name+++\lfo1),
	\rq, 0.9,
));
Ndef(~name+++\lfo1, { SinOsc.ar(2*t).range(0.2,1) });


// END

Sdef(~name, \mypreset).edit
