
(
Pdef(~name+++\pre, Pbind(
	\freq, Pseq([
		60,60,60,80,

	],inf).stutter(8) * 4 * Pseq([1,2,3,4],inf),
	\octave, 6,
	\oscmix, 0,
	\freqmix, Ndef(~name+++\lfo4, { SinOsc.kr(1/4).range(0,3)  }),
	\det, Ndef(~name+++\lfo3, { SinOsc.kr(1).range(50,10000)  }),
	\lpfspread, 0.9,
	\lpf, Ndef(~name+++\lfo1, { SinOsc.kr(0.4).range(500,5000)  }),
	\lpfspread, Ndef(~name+++\lfo2, { SinOsc.kr(0.6).unipolar  }),
	\amp, Pkey(\amp) ,
	\legato, Pseq([1,2],inf).stutter(8)/4,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
	],inf),
	\isRest, Pseq([
		1,1,1,0,
		0,0,1,0,
	],inf).coin.not,
	\dur, 1/4,
));
);

// END
