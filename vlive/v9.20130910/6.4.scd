
(
Pdef(~name +++ \pre, Pbind(
	\cutoff, Place([100,500,[2000,7000]],inf),
	//\cutoff, Pwhite(100,800.0),
	\freq, Pwhite(100,800.0).stutter(15),
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
		[ Env.adsr(0.001,0.1,0.8,0.1) ],
		[ Env.adsr(0.1,0.1,0.8,0.001) ],
	],inf),
	\dur, Pwhite(0.05,0.1),
	\isRest, Veco(~namex).isrest(16),
	\legato, 1.5,
	\pwidth, Ndef(~name+++\lfo3),
	//\rq, Ndef(~name+++\lfo1, { PulseCount.kr(Dust.kr(1),Dust.kr(1))*0.1 }),
	\rq, 0.3,
));

);

