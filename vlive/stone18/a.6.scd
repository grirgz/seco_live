
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = 40.midicps;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = Duty.kr(1/~t, 0, Dseq([
		40,52,40,55,
	],inf)).midicps;
	freq = freq * [1,2];
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr( freq) * LFNoise1.kr(1/8*~t).exprange(0.1,100) ))); 
	sig = sig * [2,1];

	sig1 = Duty.kr(1/4/~t, 0, Dseq([
		4,2,4,8,
	],inf)) * ~t;

	sig2 =  1-Duty.kr(1/8/~t, 0, Dseq([
		1,1,1,1, 1,1,1,1,
		1,0,0,0, 0,0,0,0,
		1,1,1,1, 1,1,1,1,
		1,0,0,0, 1,1,1,0,

		1,1,1,1, 1,1,1,1,
		1,1,1,1, 0,1,1,1,
		0,0,0,0, 0,0,0,0,
		1,1,1,1, 1,1,1,1,

	],inf));
	sig3 = LFSaw.ar(40.midicps * [1,1.00001] * ( 1 + ( SinOsc.kr( 
		//LFNoise1.kr(1/2).range(40.0,1000.0)
		Duty.kr(8/~t, 0, Dseq([
			Dwhite(140,7000)
		],inf)).lag(1/~t)
	) * Duty.kr(4/~t, 0, Dseq([
			Dwhite(0.1,10),
			Dwhite(0.1,10),
			Dwhite(0.1,10),
			Dwhite(0.1,100)
		],inf)).lag(1/~t)
	)));
	sig4 = sig3.tanh;
	sig4 = HPF.ar(sig4, 7000 * LFPulse.kr(1/3*~t).range(1,1/3));
	sig3 = LPF.ar(sig3, 2000);
	sig3 = sig3 + ( sig4 * Duty.kr(1/16/~t, 0, Dseq([
		1,0,1,0,
		1,1,0,0,
		1,0,1,0,
		1,1,0,1,
	],inf)) );
	//sig4 = SelectX.ar(sig2, [sig3, DC.ar(1)]);
	sig = SelectX.ar(sig2, [sig3, sig + sig4]);
	//sig = sig * (sig4);
	//sig = RLPF.ar(sig, 1000);
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
