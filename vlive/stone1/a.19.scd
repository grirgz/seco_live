(
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo3).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo1, { arg fmfreq, flag; SinOsc.kr(fmfreq * [1,0.2]).sum.clip(0.5) * \bscale.kr(1) * \base.kr(1000,flag) + \base.kr.lag(flag)  });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\fmfreq, 1 * t,
	\bscale, Pseq([
		0.91,0.1,0,0,
		0,0,0,0,
	],inf),
	\flag, 0.7,
	\base, Pseq([
		7000,10,10,10,
		20,20,20,20,
		7000,40,4000,10,
		700,90,90,90,
	]*2,inf),
	//\base, 40,
	\fmfreq, Pseq([
		1,2,1,4
	],inf),
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
Ndef(~name+++\lfo3, { arg fmfreq; (SinOsc.kr(fmfreq * [1,0.2]).sum.clip(0.5) * \bscale.kr(1) * \base.kr(1000,0.2) + \base.kr).clip(10,18000)  });
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\fmfreq, 1 * t,
	\bscale, Pseq([0.91,0.5,0.1,0.1],inf),
	\base, Pseq([7000,4000,7000,50]/1,inf),
	\base, Pseq([
		400,400,400,400,
		400,200,700,800,
		1400,400,1400,400,
		2400,4200,2700,800,

		Prand([
			Pseq([
				400,400,400,400,
			],1),
			Pseq([
				400,200,700,800,
			],1),
			Pseq([
				1400,400,1400,400,
			],1),
			Pseq([
				2400,4200,2700,800,
			],1),
		],4),
	],inf),
	\base, 100,
	\fmfreq, Pseq([
		1,2,1,4
	]*1,inf),
	\fmfreq, 8 * t,
	\dur, 1/4,
));
Pdef(~name +++ \pre, Pbind(
	\noisefreq, 110.1,
	\delayfactor, 4.8,
	\shift, 100,
	\degree, Pseq([0],inf),
	\oscmix, 0.91,
	\oscfreq, Pseq([100,200,500,1000],inf),
	\oscfreq, Pseq([
		50,50,50,100,
		50,50,50,100,
		50,50,50,100,
		150,50,50,100,
	],inf),
	\oscfreq, Pseq([
		50,50,50,100,
		50,50,50,100,
		50,50,50,100,
		150,50,50,100,
	],inf) * Pseq([0,2,3,-1],inf).midiratio.stutter(32),
	\ffreq, 50*8,
	\ffreq, Ndef(~name+++\lfo3),
	\freqtab, Pseq([
		//[ Array.geom(8,1.0,1.001) ],
		[ Array.series(8,1.0,1.00001) ],

	],inf),
	\ffreqtab, Pseq([
		//[ Array.geom(8,1.0,1.01) ],
		[ Array.series(8,2.4,1-0.1001) ],

	],inf),


	\fbase, 700 + Pseq([1,1.5,1.0,0.5],inf).stutter(4),
	\fbase, Pseq([170,1],inf),
	\fbase, Ndef(~name+++\lfo1),
	\fbase2, 10,

	\fscale, Pseq([1.8,1.7,0.6],inf),
	\fscale, 1,
	\fscale2, Pseq([4.8,1,1.7,0.6],inf),
	\fscale2, 0.4,

	//\decay, 2.8,
	\decay2, 7.1,
	\dur, 1/8,
	\adsr, Pseq([
		[ Env.adsr(0.001,0.1,0.8,0.1) ],
	],inf),
	\legato, Pseq([4,1,0.5,2],inf),

	\freqfactor, Pseq([1,1.1,0.42,1.3],inf),
	\freqfactor2, Pseq([1,1.1,0.42,1.3],inf),
	\freqfactor2, Ndef(~name+++\lfo2),
	\freqfactor, 0.4,
	\freqfactor2, 0.1,
	\isRest, Pseq([
		Pseq([
			1,0,1,1, 1,0,1,0,
			1,0,0,0, 0,0,1,0,
		],1),
		Pseq([
			1,0.3,1,1, 1,0.3,1,0.3,
			1,0.3,0.3,0.3, 0.3,0.3,1,0.3,
		],1),
		Pseq([
			1,1,1,0, 0,1,1,0,
			1,0,0,0, 1,1,0,0,
		],1),
		Pseq([
			1,0,0,0, 1,0,0,0,
			1,1,1,1, 0,0,1,1,
		],1),
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
