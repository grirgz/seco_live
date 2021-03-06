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
	\dur, 1/4,
));
Ndef(~name+++\lfo2, { arg fmfreq; SinOsc.kr(fmfreq * [1,0.2], \phase.kr(0)).range(0.100,1.4100).clip(0.1).sum  });
Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	\fmfreq, Pseq([4,2,8,4]*1,inf),
	//\fmfreq, 4,
	\phase, 3.5,
	\fmfreq, 5.400,
	\fmfreq, Pseq([1,2,1,4]*1,inf),
	\dur, 1/2,
));
Ndef(~name+++\lfo3, { arg fmfreq; SinOsc.kr(fmfreq * [1,0.2]).sum.clip(0.5) * \bscale.kr(1) * \base.kr(1000) + \base.kr  });
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\fmfreq, 1 * t,
	\bscale, Pseq([0.91,0.5,0.1,0.1],inf),
	\base, Pseq([2000,200,4000,50]/1,inf),
	\base, Pseq([
		200,1200,1500,1350,
		200,3200,1500,0350,
		700,1200,1500,0350,
		700,200,7500,7350,
	]/1,inf),
	\fmfreq, Pseq([
		1,2,1,4
	]*2,inf),
	\fmfreq, 8 * t,
	\dur, 1/8,
));
Pdef(~name +++ \pre, Pbind(
	\noisefreq, 10.1,
	\delayfactor, 0.8,
	\shift, 230,
	\degree, Pseq([0],inf),
	\oscmix, 0.71,
	\oscfreq, Pseq([100,200,500,1000],inf),
	\oscfreq, Pseq([50,120,150,80],inf),
	\oscfreq, Pseq([
		50,120,150,80,
		50,120,100,80,
		50,170,150,80,
		50,120,120,80,
	],inf),
	\oscfreq, Pseq([50,80],inf),
	\ffreq, Ndef(~name+++\lfo3),
	\freqtab, Pseq([
		//[ Array.geom(8,1.0,1.001) ],
		[ Array.series(8,1.0,1.1) ],

	],inf),
	\ffreqtab, Pseq([
		//[ Array.geom(8,1.0,1.01) ],
		[ Array.series(8,1.0,1.1) ],

	],inf),


	\fbase, 400 + Pseq([1,1.5,1.7,0.5],inf).stutter(4),
	\fbase, Ndef(~name+++\lfo1),
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
	\legato, Pseq([
		4,1,0.5,2,
		4,1,0.5,4,
		3,3,0.5,2,
		1,4,4.5,2,
	],inf),

	\freqfactor, Pseq([1,1.1,0.42,1.3],inf),
	\freqfactor2, Pseq([1,1.1,0.42,1.3],inf),
	\freqfactor2, Ndef(~name+++\lfo2),
	\freqfactor, 4,
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
