(
Ndef(~name+++\lfo1, { arg freq; SinOsc.kr(freq*t).range(7100,500)  });
Ndef(~name+++\lfo2, { arg freq; SinOsc.kr(freq*t,pi).range(0,1)  });
Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	\freq, Pseq([1,4,8]/8,inf),
	\dur, 1,
));
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([4,1,4,8]/8,inf),
	\dur, 1,
));
Pdef(~name +++ \pre, Pbind(
	//\freq, Pseq([34,42,37],inf).stutter(4) + Pwhite(1,4),
	//\freq, Pwhite(20,40),
	\ffreq, Ndef(~name+++\lfo1),
	\degree, Pseq([
		0,2,4,4, 0,0,-2,1,
		0,0,1,1, 0,0,-2,1,
	],inf).stutter(4),
	\octave, [3,4],
	\isRest, false,
	\oscmix, Ndef(~name+++\lfo2),
	\isRest, Veco(~namex).isrest(32),
	\legato, Pwhite(0.1,0.41),
	\dur, Pwhite(0.5,4),
	\amp, Pkey(\amp) * [1,0.1],
	\dur, 1/8,
	\adsr, Pseq([
		[ Env.adsr(0.0101,0.221,0.1,0.4,1,-9) ],
		[ Env.adsr(0.0101,0.221,0.1,0.9,1,-9) ],
	],inf),
));
)
