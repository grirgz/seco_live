
(
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo3).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo1, { arg fmfreq, base=100; base=base.lag(0.01); SinOsc.kr(fmfreq * [1,0.2]).sum.clip(0.5) * \bscale.kr(1) * base + base  });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\fmfreq, 1 * t,
	\bscale, Pseq([0.91,0.5,0.3],inf),
	\base, Pseq([100,200]*1,inf),
	\base, Pseq([
		100,200, 100,400,
		400,200, 100,400,
	]*1,inf).stutter(2),
	\fmfreq, Pseq([
		1,2,1,4
	]*2,inf),
	\fmfreq, 4 * t,
	\dur, 1/2,
));
Ndef(~name+++\lfo2, { arg fmfreq; SinOsc.kr(fmfreq * [1,0.2], \phase.kr(0)).range(0.100,1.4100).clip(0.1).sum  });
Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	\fmfreq, Pseq([4,2,8,4]*1,inf),
	//\fmfreq, 4,
	\phase, 3.5,
	\fmfreq, 5.400,
	\fmfreq, Pseq([1,2,1,4]*1,inf),
	\dur, 1/4,
));
Ndef(~name+++\lfo3, { arg fmfreq; SinOsc.kr(fmfreq * [1,0.2]).sum.clip(0.9) * \bscale.kr(1).lag(0.1) * \base.kr(1000).lag(0.1) + \base.kr.lag(0.1)  });
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\fmfreq, 1 * t,
	\bscale, Pseq([0.91,0.5,0.1,0.1],inf),
	\bscale, Pseq([0.1],inf).stutter(8),
	\base, Pseq([2000,200,4000,50]/1,inf),
	\base, Pseq([
		
		400, 120, 400, 100,
	]/1,inf),
	\fmfreq, Pseq([
		1,4,1/4,10
	]*2,inf),
	\fmfreq, 1 * t,
	\dur, Pseq([1/9,8/9],inf)/2,
));
Pdef(~name +++ \pre, 
	Pbind(
		//\oscfreq, Pseq([50,80],inf),

	) <>
	
	
	Pbind(
	\noisefreq, 10.1,
	\delayfactor, 0.8,
	\shift, -730,
	\degree, Pseq([0],inf),
	\oscmix, Pseq([0,1,0.1,0.2],inf).stutter(2),
	\oscmix, Pseq([1.00],inf).stutter(2),
	\oscfreq, Pseq([50,40,50,60],inf).stutter(2),
	\oscfreq, Pseq([100,200,50,50],inf),
	\oscfreq, 100.86318974343,
	\ffreq, 132.08387924661,
	\ffreq, Ndef(~name+++\lfo3),
	\freqtab, Pseq([
		//[ Array.geom(8,1.0,1.001) ],
		//[ Array.series(8,1.0,1.1) ],
		//[ Array.series(8,0.4,1.01) ],
		[ Array.series(8,0.4,1.03) ],

	],inf),
	\ffreqtab, Pseq([
		//[ Array.geom(8,1.0,1.01) ],
		//[ Array.series(8,1.0,1.1) ],
		//[ Array.series(8,1.0,0.74) ],
		[ Array.series(8,1.0,0.04) ],
		//[ Array.series(8,1.7,1.7) ],

	],inf),


	\fbase, Pseq([4,8],inf).stutter(4),
	\fbase, 400 * Pseq([1,1.5,1.7,0.5],inf).stutter(4),
	//\fbase, Ndef(~name+++\lfo1),
	\fbase, Pseq([54,410],inf),
	\fbase2, 1,

	\fscale, Pseq([1.8,1.7,0.6],inf),
	\fscale, 5.4794723369003,
	\fscale2, Pseq([4.8,1,1.7,0.6],inf),
	\fscale2, 0.45462954695324,

	//\decay, 2.8,
	\decay2, 0.2,
	\dur, 1/1,
	\adsr, Pseq([
		[ Env.adsr(0.001,0.1,0.8,0.1) ],
		[ Env.adsr(0.001,0.1,0.8,0.1) ],
		[ Env.adsr(0.001,0.1,0.8,0.4) ],
		[ Env.adsr(0.001,0.4,0.8,0.2) ],
	],inf),
	\legato, 1,
	\legato, Pseq([
		4,1,0.5,2,
		4,1,0.5,4,
		3,3,0.5,2,
		1,4,4.5,2,
	],inf),
	\legato, Pseq([
		04,
	],inf)/10,

	\freqfactor, Pseq([1,1.1,0.42,1.3],inf),
	\freqfactor2, Pseq([1,1.1,0.42,1.3],inf),
	\freqfactor2, Ndef(~name+++\lfo2),
	\freqfactor2, 1,
	\freqfactor, 1,

	\isRest, Pseq([
		1,1,1,1, 1,1,1,1,
	],inf).coin.not,
));
)
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
