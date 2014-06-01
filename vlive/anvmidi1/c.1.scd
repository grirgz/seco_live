~buf = BufDef(\moeten);
~buf = BufDef(\march);
~buf = BufDef(\ukraine);
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo3).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo1, { arg freq=1, fmin=50, fmax=5000; LFTri.kr(freq * t).round(0.4).range(fmin,fmax)});
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([4,1,16,1,32,8,1,1],inf),
	\freq, 1/8,
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
	],inf)+100,
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
	\freq, Pseq([
		1000, 1000,910,1000,
		1000, 1000,910,1000,
		1000, 0950,910,1000,
		1100, 1000,990,0900,
	],inf),
	\flag, Pseq([
		1.0, 1.0, 0.0, 1.0,
	],inf),
	\flag, 2,
	\dur, 2/1,
));

(

Pdef(~name +++ \pre, 

		Pbind(
			\instrument, \oscsampler,
			\ffreq, Pseq([5000,200,1000],inf).stutter(8),
			\range, Pseg(Pseq([0.0001,0.0008,0.1],inf), Pseq([7,1,0],inf)),
			\range, Pseq([
				Pser([0.0001],7),
				Pser([0.01],1),
			] ,inf).stutter(1),
			\bufnum, ~buf,
			//\freq, ~envNdefq.()500,
			\freq, Ndef(~name+++\lfo3).bus.asMap,
			\lpmix, 1,
			\ffreq, 1000,
			\ffreq, Ndef(~name+++\lfo1),
			\amp, Pkey(\amp) * 6,
			\dur, 8,

			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
		)

);
)
