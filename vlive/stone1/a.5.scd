(
Ndef(~name+++\lfo1, { arg fmfreq; var sig = SinOsc.kr(fmfreq * [1,0.2]).sum.clip(0.5) * \bscale.kr(1) * \base.kr(1000) + \base.kr; sig.lag(0.1)  });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\fmfreq, 1 * t,
	\bscale, Pseq([0.91,0.5],inf),
	\base, Pseq([
		10,200, 10,20,
		100,200,10,10,
		100,200,10,10,
		100,2000,10,10,

		10,200, 10,20,
		100,200,10,10,
		100,200,10,10,
		Prand([100,2000,10,10],4),

		10,200, 10,20,
		100,200,10,10,
		Prand([100,2000,10,10],4),
		100,20,10,10,

		10,200, 10,20,
		100,200,10,10,
		100,200,10,10,
		Prand([100,2000,10,10],4),
	]*2,inf),
	\fmfreq, Pseq([
		1,2,1,4
	]*2,inf),
	\fmfreq, 4 * t,
	\dur, 1/4,
));
Ndef(~name+++\lfo2, { arg fmfreq; SinOsc.kr(fmfreq * [1,0.2], \phase.kr(0)).range(0.100,1.4100).clip(0.1).sum  });
Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	\fmfreq, Pseq([4,2,8,4]*1,inf),
	\fmfreq, Pseq([1,2,1,4]*1,inf),
	\phase, 3.5,
	\fmfreq, 5.400,
	\dur, 1/2,
));
Ndef(~name+++\lfo3, { arg fmfreq; (SinOsc.kr(fmfreq * [1,0.2]).sum.clip(0.5) * \bscale.kr(1) * \base.kr(1000) + \base.kr).clip(10,18000)  });
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\fmfreq, 1 * t,
	\bscale, Pseq([0.91,0.5,0.1,0.1],inf),
	\base, Pseq([2000,200,4000,50]/1,inf),
	\base, 2000,
	\fmfreq, Pseq([
		1,2,1,4
	]*2,inf),
	\fmfreq, 8 * t,
	\dur, 1/1,
));
Pdef(~name +++ \pre, Pbind(
	\noisefreq, 10.1,
	\delayfactor, 0.8,
	\shift, 0,
	\degree, Pseq([0],inf),
	\oscmix, 0.51,
	\oscfreq, Pseq([100,200,500,1000],inf),
	\oscfreq, Pseq([
		40,50,55,52,
		40,50,55,52,
		40,50,55,52,
		40,50,55,52,
		40,50,55,52,
	],inf),
	\ffreq, Ndef(~name+++\lfo3),
	\ffreq, 50*8,
	\freqtab, Pseq([
		//[ Array.geom(8,1.0,1.001) ],
		Pser([
			[ Array.series(8,1.0,1.20001) ],
			[ Array.series(8,1.0,1.10001) ],
		],4),
		Pser([
			[ Array.series(8,1.0,1.00001) ],
			[ Array.series(8,1.0,1.10001) ],
		],32),
		Pser([
			[ Array.series(8,1.0,1.00001) ],
			[ Array.series(8,1.0,1.00001) ],
			[ Array.series(8,1.0,1.00001) ],
			[ Array.series(8,1.0,1.10001) ],
		],32-8),
		Pser([
			[ Array.series(8,1.0/2,2.00001) ],
			[ Array.series(8,1.0/2,2.00001) ],
			[ Array.series(8,1.0,1.00001) ],
			[ Array.series(8,1.0,1.00001) ],
		],4),

	],inf),
	\ffreqtab, Pseq([
		//[ Array.geom(8,1.0,1.01) ],
		[ Array.series(8,1.0,1.4001) ],
		[ Array.series(8,1.0,1-0.0001) ],
		[ Array.series(8,1.0,1-0.0001) ],
		[ Array.series(8,1.0,1-0.0001) ],

		[ Array.series(8,0.4,1.7001) ],
		[ Array.series(8,1.0,1-0.0001) ],
		[ Array.series(8,1.0,1-0.01) ],
		[ Array.series(8,1.0,1-0.0001) ],

	],inf),


	\fbase, 700 + Pseq([1,1.5,1.0,0.5],inf).stutter(4),
	\fbase, Pseq([170,1,1,1],inf),
	\fbase, Ndef(~name+++\lfo1),
	\fbase2, Pseq([100],inf),

	\fscale, Pseq([1.8,1.7,0.6],inf),
	\fscale2, Pseq([4.8,1,1.7,0.6],inf),
	\fscale, 4,
	\fscale2, 1.4,

	//\decay, 2.8,
	\decay2, 0.8,
	\dur, 1/8,
	\adsr, Pseq([
		[ Env.adsr(0.001,0.1,0.8,0.1) ],
	],inf),
	\legato, Pseq([
		1,1,0.5,2,
		1,1,4.5,2,
		1,2,0.5,4,
		2,1,4.5,2,

		1,1,0.5,2,
		1,1,4.5,2,
		1,2,0.5,4,
		2,1,4.5,2,

		4,2,2.5,4,
		2,1,4.5,2,
		4,1,0.5,2,
		1,1,4.5,2,
	],inf),

	\freqfactor, 1/7,
	\freqfactor2, 1/7,
	\freqfactor, Pseq([1,1.1,0.42,1.3],inf),
	\freqfactor2, Pseq([1,1.1,0.42,1.3],inf),
	\freqfactor2, Ndef(~name+++\lfo2),
	\isRest, Pseq([
		1,0,1,0,
		0,0,0,0,
		1,0,1,0,
		0,1,1,0,

		1,0,1,0,
		0,1,0,1,
		1,0,1,0,
		1,0,1,1,
	],inf).coin.not,
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
