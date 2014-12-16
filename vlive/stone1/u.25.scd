Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
(
Pdef(~name +++ \pre, Pbind(
	\freq, Pwhite(100,800.0).stutter(14) ,
	\freq, 100 * Prand(Scale.minor.ratios, inf) * Prand([4,2,3,1],inf).stutter(4),
	\freq, Pkey(\freq).stutter(4)* [0,4,7].midiratio,
	\mfreq, Ndef(~name+++\lfo1, { SinOsc.kr(1).range(50,100)*4  }),
	\freq, 4 * Pseq([
		0,0,
	],inf).midiratio.stutter(4) * [0,3,7].midiratio * 4,
	\freq, Pkey(\freq).trace(prefix: "Patfreq:"),
	\legato, 0.51,
	\legato, Pseq([
		Pseq([
			0.5
		],3),
		2
	],inf).stutter(4),
	\fspread, Pseq([1,0.1],inf),
	\dur, Pwhite(0.3,1/16),
	\dur, 1/1,
	//\time, Ptime().trace(prefix:"Pattime:"),
	\isRest, Pseq([
		Pseq([
			1
		],4),
		//Pseq([
		//	Pwhite(0,0.5,1)
		//],12),
		
	],inf).stutter(4).coin.not,
));

Ndef(~name+++\fx).put(10, \filter -> { arg in, amp=0.1;
	var sig = in;
	var mix;
	var lfo1;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	mix = \mix.kr(0);
	sig = CombL.ar(sig, 4/~t, SinOsc.kr(1).range(0.8,1.2)*1/4/~t,4/~t) + sig;
	sig = CombL.ar(sig, 4/~t, SinOsc.kr(1/14).range(0.8,1.2)*1/4/~t,4/~t) + sig;
	sig = BPF.ar(sig, 1400 * SinOsc.kr(1).range(0,1),0.1)/2 + in;
	sig1 = RLPF.ar(sig, \lpf.kr(100)*LFNoise1.kr(2).range(0.4,4.0), \rq.kr(0.5));
	sig = SelectX.ar(mix.lag(0.5), [sig, sig1]);
	
	sig;
});

Ndef(~name+++\fx).put(11, \set -> Pbind(
	\mix, Pseq([
		Pseq([
			1,1,0,1
		],1),
		Pseq([
			0
		],12),
	],inf).stutter(4).trace(prefix:"setmix:"),
	//\time, Ptime().trace(prefix:"settime:"),
	\dur, 1,
));
)

// END

Scale.minor.ratios
