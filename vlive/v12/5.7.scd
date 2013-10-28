(
Ndef(~name+++\lfo1, { arg fmfreq; SinOsc.kr(fmfreq) * \bscale.kr(1) * \base.kr(1000) + \base.kr  });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\fmfreq, 1 * t,
	\bscale, Pseq([0.91,0.5],inf),
	\base, Pseq([1000,2000],inf),
	\fmfreq, Pseq([
		1,2,1,4
	]*2,inf),
	\fmfreq, 4 * t,
	\dur, 1/4,
));
Ndef(~name+++\lfo2, { arg fmfreq; SinOsc.kr(fmfreq).range(0.100,1.4100)  });
Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	\fmfreq, Pseq([4,2,8,4]*1,inf),
	\fmfreq, Pseq([1,2,1,4]*1,inf),
	\fmfreq, 1,
	\dur, 1/2,
));
Pdef(~name +++ \pre, 
	Pbind(
		\fbase, Pkey(\fbase) + Pseq([1,1.5,1.7,0.5],inf).stutter(4),
		\legato, Pseq([1.4,0.1,0.5,2],inf),
		\fbase, Ndef(~name+++\lfo1),
		\freqfactor2, Ndef(~name+++\lfo2),

	) <>
	Sdef(~namex, \mypreset).pbind <>
	Pbind(
		\noisefreq, 10.1,
		\delayfactor, 0.8,
		\shift, 230,
		\degree, Pseq([0],inf),


		\fbase2, 450,

		\fscale, Pseq([1.8,1.7,0.6],inf),
		\fscale2, 3.4,
		\fscale2, Pseq([4.8,1,1.7,0.6],inf),

		//\decay, 2.8,
		\decay2, 0.8,
		\dur, 1/8,
		\adsr, Pseq([
			[ Env.adsr(0.001,0.1,0.8,0.1) ],
		],inf),

		\freqfactor, Pseq([1,1.1,0.42,1.3],inf),
		\freqfactor2, Pseq([1,1.1,0.42,1.3],inf),
		\freqfactor, 1,
));
);

// END


Sdef(~namex, \mypreset).edit
