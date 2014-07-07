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
		\amp, 1 * Pkey(\amp),
		//\amp, 1,
		\dur, 2,
		\isRest, false,
		\xfreq, Pseq([
			Pser([8],16),
			Pser([6],8),
			Pser([6 * (2**(3/12))],8),
		],inf),
		\xfreq, 440 * (2**Pseq([
			0,0,1,1
		]/12,inf)).stutter(4)  * (1/8),
		\xffreq, 2,
		\isRest, Pseq([1,1,0,1],inf).coin.not,
		\legato, 0.5,
		\isRest, Pseq([
			0,1,1,0,
			1,1,0,1,
			1,1,1,1,
			1,1,1,1,
		],inf).coin.not,
		\isRest, Pseq([
			1,0.9,1,0.5,
			0,1,1,0.2,
			1,0.2,1,0.5,
			1,1,1,0.2,
		],inf).coin.not,
		\legato, Pseq([
			6,4,9,4,
			6,4,9,4,
			9,9,9,9,
			9,9,9,9,

		],inf)/10 /1.2,
		\legato, 1,
		\isRest, false,
	)
);

Pdef(~name +++ \pre, 
	Ppar([

		Pbind(
			\instrument, \oscsampler,
			\ffreq, Ndef(~name+++\lfo1),
			\freq, Ndef(~name+++\lfo3).bus.asMap,
			\ffreq, Pseq([5000,200,1000],inf).stutter(8),
			\freq, 100 * Pkey(\xfreq),
			\freq, Pseq([100,200,300,1500],inf),
			\range, Pseg(Pseq([0.0001,0.0008,0.1],inf), Pseq([7,1,0],inf)),
			\range, Pseq([0.0001,0.1],inf).stutter(8),
			\bufnum, ~buf,
			\amp, Pkey(\amp) * 0.5,
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
			\degree, 0,
			//\freq, 1 * Pkey(\xfreq),
			\note, Pseq([4,5,8,7],inf).stutter(2),
			\mtranspose, 0,
			\octave, 2,
			\adsr, Pseq([
				[ Env.dadsr(0.02,0.11,0.3,0.4,0.1) ],
			],inf),
			\amp, Pkey(\amp) * 3.5,
		)
		<> Pdef(~name+++\base) 
	])

);
)

// END


Ndef(~name+++\mixer)[50] = nil

(
Ndef(~name+++\mixer)[50] = \filter -> { arg in; 
	var sig;
	var sig2;
	var sig3;
	sig = in;
	//sig = CombL.ar(sig, 0.1,0.1*SinOsc.ar(5).range(0.2,1),1) * 0.1 + sig;

	sig2 = sig;
	sig2 = CombL.ar(sig2, 0.1,1/4/t,1) * 0.1;
	sig2 = (sig2*70).clip2(0.4) * 0.4;
	sig2 = FreqShift.ar(sig2,-5);

	sig3 = sig;
	sig3 = CombL.ar(sig3, 0.1,1/16/t,0) * 1.3;
	//sig3 = sig3 * SinOsc.kr(1/4/t).range(0,1);
	sig3 = DelayL.ar(sig3, 0.1,0.01*SinOsc.kr(50).range(0.1,1));
	sig3 = RLPF.ar(sig3, 700);

	sig = sig3 + sig2 + sig;
	//sig = sig3;
};
)


~set_macro.(\k1, Ndef(~name+++\mixer), \wet50, \unipolar.asSpec)
