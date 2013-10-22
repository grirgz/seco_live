(
Ndef(~name+++\lfo1, { SinOsc.kr(1).range(100,500)  });
Pdef(~name +++ \pre, Pbind(
	//\freq, Pseq([34,42,37],inf).stutter(4) + Pwhite(1,4),
	\freq, Pwhite(20,40),
	\ffreq, Ndef(~name+++\lfo1),
	//\isRest, Veco(~namex).isrest(16),
	\isRest, false,
	\legato, Pwhite(0.1,0.41),
	\dur, Pwhite(0.5,4),
	\adsr, Pseq([
		[ Env.adsr(0.0101,0.001,0.9,1.4,1,-9) ],
	],inf),
));
)
