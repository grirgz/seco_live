
// xTAGS: electric, lead, pdef
(
Ndef(~name+++\lfo1, { arg fmfreq; SinOsc.kr(fmfreq * [1,0.2]).sum.clip(0.5) * \bscale.kr(1) * \base.kr(1000) + \base.kr  });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\fmfreq, 1 * t,
	\bscale, Pseq([0.91,0.5],inf),
	\base, Pseq([1000,700,5400],inf),
	\fmfreq, 4 * t,
	\fmfreq, Pseq([
		1,2,1,4
	]*2,inf),
	\dur, 1/4,
));
Ndef(~name+++\lfo2, { arg fmfreq; SinOsc.kr(fmfreq * [1,0.2], \phase.kr(0)).range(0.100,1.4100).clip(0.1).sum  });
Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	\fmfreq, Pseq([4,2,8,4]*1,inf),
	\fmfreq, Pseq([1,2,1,4]*1,inf),
	\phase, 3.5,
	\fmfreq, 1/45.400,
	\dur, 1/8,
));
Ndef(~name+++\lfo3, { arg fmfreq; (SinOsc.kr(fmfreq * [1,0.2]).sum.clip(0.5) * \bscale.kr(1) * \base.kr(1000) + \base.kr).clip(10,18000)  });
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\fmfreq, 1 * t,
	\bscale, Pseq([
		4.91,4.5,4.1,4.1,
		0.91,0.5,0.1,0.1,
		4.91,0.5,0.1,0.1,
		0.91,0.5,0.1,0.1,
		4.91,0.5,0.1,0.1,
	],inf),
	\base, Pseq([2000,200,4000,50]/1,inf),
	\base, 200,
	\fmfreq, Pseq([
		1,2,1,4
	]*2,inf),
	\fmfreq, 2 * t,
	\dur, 1/8,
));
Pdef(~name +++ \pre, Pbind(
	\noisefreq, 10.1,
	\delayfactor, 0.8,
	\shift, 0,

	\degree, Pseq([0],inf),
	\oscmix, 0.51,
	\oscfreq, Pseq([100,200,500,1000],inf),
	\oscfreq, Pseq([
		50,50,50,100,
		50,50,50,100,
		50,50,50,100,
		150,50,50,100,
	],inf),
	\ffreq, 50*8,
	\ffreq, Ndef(~name+++\lfo3),
	\freqtab, Pseq([
		//[ Array.geom(8,1.0,1.001) ],
		[ Array.series(8,1.0,1.00001) ],

	],inf),
	\ffreqtab, Pseq([
		//[ Array.geom(8,1.0,1.01) ],
		[ Array.series(8,1.0,1-0.0001) ],

	],inf),


	\fbase, 700 + Pseq([1,1.5,1.0,0.5],inf).stutter(4),
	\fbase, Ndef(~name+++\lfo1),
	\fbase, Pseq([170,1,1,1,1],inf),
	\fbase2, 40,

	\fscale, Pseq([1.8,1.7,0.6],inf),
	\fscale2, Pseq([4.8,1,1.7,0.6],inf),
	\fscale, 1,
	\fscale2, 3.4,

	//\decay, 2.8,
	\decay2, 0.8,
	\dur, 1/8,
	\adsr, Pseq([
		[ Env.adsr(0.001,0.1,0.8,0.1) ],
	],inf),
	\legato, Pseq([4,1,0.5,2],inf),

	\freqfactor, Pseq([1,1.1,0.42,1.3],inf),
	\freqfactor2, Ndef(~name+++\lfo2),
	\freqfactor2, Pseq([1,1.1,0.42,1.3],inf),
	\freqfactor, 0.7,
	\freqfactor2, 7,
));
);

// END

Ndef(~name+++\lfo1, { arg fmfreq; SinOsc.kr(fmfreq).range(400,4800)+500  });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\fmfreq, 1,
	\fmfreq, Pseq([
		1,2,1,4
	]*2,inf),
	\fmfreq, 0.10,
	\dur, 1/2,
));
