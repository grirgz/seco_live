
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var env1;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var fspread;
	var fmfreq;

	freq = 70 * 12;
	fmfreq = freq * Duty.kr(3/~t, 0, Dseq([
		0,0,0,1,
		7,7,7,17,
	],inf)).midiratio;
	sig1 = SinOsc.ar(fmfreq).range(0,1) * 1;
	sig = SinOsc.ar(sig1 + 1 * freq * [1,1.0001]);
	sig = RLPF.ar(sig, 400 * SinOsc.kr((1..8)/8).range(0.1,4));

	sig1 = sig * SinOsc.ar(freq);
	sig = SelectX.ar( SinOsc.kr(1/4 * (1..8)/18).range(0,1), [sig, sig1]);

	sig = sig + FreqShift.ar(sig, [0.01,-1]);
	sig = sig /4;
	sig1 = TDuty.kr(1/~t, 0, Dseq([
		1,0,0,0,
	],inf));
	sig2 = Duty.kr(1/~t, 0, Dseq([
		1,0,0,0,
		Drand([
			Dseq([
				Dwhite(0.1,1),0,0,0,
			],1),
			Dseq([
				Dwhite(0.1,1),0,0,5,
			],1),
			Dseq([
				0,Dwhite(0.1,1),0,0,
			],1),
		],1),
	],inf));
	sig = sig * EnvGen.kr(Env.adsr(0.001,0.4,0.8,0.1), Trig1.kr(sig1, sig2), doneAction:0);

	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size * 0.2, amp).flop;
	sig;
})
