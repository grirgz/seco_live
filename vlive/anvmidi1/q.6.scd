~buf = BufDef(\moeten);
~buf = BufDef(\march);
~buf = BufDef(\ukraine);
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo3).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo1, { arg freq=1, fmin=50, fmax=5000; LFTri.kr(freq * t).round(0.4).range(fmin,fmax)});
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([4,1,16,1,32,8,1,1],inf),
	\freq, 1/4,
	\fmax, 7000,
	\fmin, 50,
	\fmin, Pseq([
		50, 50, 50, 50, 
		50, 50, 50, 50, 
		50, 50, 50, 50, 
		50, 50, 50, 50, 

		50, 50, 50, 50, 
		750, 50, 50, 50, 
		50, 50, 50, 50, 
		5000, 50, 50, 50, 
	],inf) + 1000,
	\dur, 1,
));
Ndef(~name+++\lfo3, { arg freq=20, flag=0.1; freq.lag(flag)});
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\freq, Pseq([
		16,2,16,1,
		16,2,16,1,
		14,16,16,16,
		14,16,16,16,
	]*10,inf),
	\freq, 1000,
	\freq, Pseq([
		1000, 1000, 1000, 1000,
		1,2,1,1,
	],inf),
	\freq, Pseq([
		100, 100, 100, 100,
		1,2,1,1,
	],inf),
	\flag, Pseq([
		0.0, 0.0, 0.0, 0.0,
		1.0, 1.0, 1.0, 1.0,
		0.4, 1.0, 0.4, 1.0,
		1.0, 1.0, 1.0, 1.0,
	],inf),
	\freq, Pseq([
		1,2,1,1,
		0.5,0.5,0.1,0.1,
		0.01, 0.01, 0.01, 0.01,
		0.4, 0.4, 0.4, 0.4,
	]*10,inf),
	\freq, Pseq([
		1000, 1000, 1000, 1000,
		1,2,1,1,
		1000, 10, 1, 1000,
		0.5,0.5,0.1,0.1,
		10, 10, 1, 1000,
		0.01, 0.01, 0.01, 0.01,
		1,2,1,1,
		0.4, 0.4, 0.4, 0.4,
	],inf),
	\freq, Pseq([
		10,40,10,10,
		100,10,10,10,
		10,40,10,10,
		1000, 1000,910,1000,
	],inf),
	\flag, Pseq([
		1.0, 1.0, 0.0, 1.0,
	],inf),
	\flag, 1,
	\dur, 1/1,
));

(
Pdef(~name +++ \base,

	Pbind(
		//\amp, 1 * Pkey(\amp),
		\amp, 1,
		\dur, 1/2,
		\isRest, false,
		\xfreq, Pseq([
			Pser([8],16),
			Pser([6],8),
			Pser([8],16-8),
		],inf),
		\xfreq, Pseq([
			Pser([8,4.5],8).stutter(16),
		],inf),
		\xfreq, Pseq([
			Pser([8],16),
			Pser([5.5],16),
			Pser([6.6],16),
			Pser([4.1],16),
		],inf),

		\xffreq, 2,
		\isRest, Pseq([
			//1,0,1,0,
			1,1,1,1, 1,1,1,1,
			1,1,1,1, 1,1,1,1,

			Pser([
				1,0,1,0, 1,0.5,1,0, 
				1,0,1,0, 1,1,0,0, 
			],16)
		],inf).coin.not,
	)
);

Pdef(~name +++ \pre, 
	Ppar([

		Pbind(
			\instrument, \oscsampler,
			\ffreq, Ndef(~name+++\lfo1),
			\freq, Ndef(~name+++\lfo3).bus.asMap,
			\ffreq, Pseq([5000,200,1000],inf).stutter(8),
			\freq, 1000 * Pkey(\xfreq),
			\range, Pseg(Pseq([0.0001,0.0008,0.1],inf), Pseq([7,1,0],inf)),
			\range, Pseq([0.0001,0.1],inf).stutter(8),
			\bufnum, ~buf,
			\amp, Pkey(\amp) * 4,
		)
		<> Pdef(~name+++\base) 
		,

		//////////////////

		Pbind(
			\instrument, ~name,
			\ffreq, Pseq([50,100,80,200],inf).stutter(8) * Pseq([0.5,1,1.5]*8,inf),
			\ffreq, 7000,
			\ffreq, Pseq([5000,6000,500,600],inf).stutter(8),
			\ffreq, Pseq([100,200,100,250],inf).stutter(1),
			\legato, 0.9,
			\degree, 0,
			\freq, 10 * Pkey(\xfreq),
			\mtranspose, 0,
			\octave, 4,
			\adsr, Pseq([
				[ Env.dadsr(0.02,0.11,0.3,0.4,0.1) ],
			],inf),
		)
		<> Pdef(~name+++\base) 
	])

);
)
