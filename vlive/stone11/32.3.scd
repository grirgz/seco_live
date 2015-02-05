
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lim;
	freq = Ndef.ar(~roger+++\freq);
	freq = freq * [1/2,1,1/4];

	sig1 = SinOsc.ar(freq * SinOsc.kr(1/4).range(1.01,1)) * Duty.kr(1/4/~t, 0, Dseq([
		Drand([
			Dseq([
				1,0,7,0,
			],1),
			Dseq([
				10,4,0,0,
			],1),
			Dseq([
				1,0,0,7,
			],1),
			Dseq([
				10,4,0,40,
			],1),
		],1),
	],inf));
	sig = LFSaw.ar(freq * ( 1+sig1 ));

	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
