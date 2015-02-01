
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var env1;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var fspread;
	var fmfreq;

	freq = 70 * 8;
	fmfreq = freq * Duty.kr(1/2/~t, 0, Dseq([
		0,0,0,1,
		7,7,7,17,
	],inf)).midiratio;
	sig1 = SinOsc.ar(fmfreq).range(0,1) * 10;
	sig = LFSaw.ar(sig1 + 1 * freq * [1,1.0001]);
	sig = RLPF.ar(sig, 400 * SinOsc.kr((1..8)/8).range(0.1,4));

	sig1 = sig * SinOsc.ar(freq*2);
	sig = SelectX.ar( SinOsc.kr(1/4 * (1..8)/18).range(0,1), [sig, sig1]);

	sig = sig + FreqShift.ar(sig, [0.01,-1]);
	sig = sig /4;

	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size * 0.2, amp).flop;
	sig;
})
