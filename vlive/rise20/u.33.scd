
Ndef(~name+++\fx).put(0, { arg amp=0.051;
	var sig;

	var freq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	freq = 70 * 4 * Duty.kr(8/~t, 0, Dseq([
		[0,3,7,11].midiratio,
		[0,3,7-12,10].midiratio,
		[0,3,7-12,7].midiratio,
		[0,3,6,10].midiratio,
	],inf));
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar( ({LFNoise1.kr(1/12).range(0.0,1.0)}!freq.size)*2, [sig1, sig2, sig3]);

	sig = 4.collect { arg x;
		sig.wrap2(SinOsc.kr(1/(x+9)).range(0.4,1))
	};
	sig = sig.flatten;
	sig.postln;
	sig = sig.collect { arg isig, x;
		isig = FreqShift.ar(isig, LFNoise1.kr(1/13).range(0.0,10.0));
		isig;
	};
	sig = sig.collect { arg isig, x;
		isig = RLPF.ar(isig, 9120 * LFNoise1.kr(1/12).range(0.5,1.2));
		isig;
	};
	sig = sig / 12;
	
	amp = amp * \gain.kr(1);


	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));

	sig = sig * EnvGen.kr(Env([0,1/2,16,0],[0.01,4/~t,0.01]), TDuty.kr(2/~t, 0, Dseq([
		0,0,0,0,
		1,0,0,0,
		0,0,0,0,
		0,0,1,0,
		Drand([
			Dseq([
				0,0,0,0,
				1,0,0,0,
			],1),
			Dseq([
				1,0,0,0,
				0,0,0,0,
				0,0,0,0,
			],1),
			Dseq([
				0,0,0,0,
				0,0,1,0,
			],1),
		],1),
	],inf)));
	sig;
})
