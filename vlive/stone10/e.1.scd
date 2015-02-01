
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var env1;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var fspread;

	freq = 400* Duty.kr(8/~t, 0, Dseq([
		[0,3,7],
		[0,3,6],
	],inf)).midiratio;
	sig = SinOsc.ar(freq * [1,1.0001]);

	sig = sig + FreqShift.ar(sig, [0.01,-1000]);

	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;
	sig;
})
