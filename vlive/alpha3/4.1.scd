
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = 300;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = Duty.kr(1/~t, 0, Dseq([
		0,2,0,7,
	],inf)).midiratio * freq;
	freq = freq * [0,3,7].midiratio;
	sig = SinOsc.ar(freq);
	sig1 = FreqShift.ar(sig, [1,2,3] * SinOsc.kr(1/8*~t).range(0,100) ) + sig;
	sig = SelectX.ar(
		Duty.kr(1/8/~t, 0, Dseq([
			1,0,0,0,
			0,1,0,0,
		],inf)).lag(0.1)
		, [sig, sig1]);
	sig1 = sig * LFSaw.ar(freq);
	sig = SelectX.ar( Duty.kr(1/4/~t, 0, Dseq([
		0,1,0,0,
		1,0,1,1,
		1,1,1,1,
	],inf)).lag(0.1), [sig, sig1]);
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})

// END


