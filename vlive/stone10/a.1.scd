
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var env1;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	sig = SinOsc.ar(200 * [1,1.01]);

	sig = sig * Duty.kr(1/~t * Dseq([0.2,0.8],inf), 0, Dseq([
		1,0,1,0,
	],inf));

	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;
	sig;
})
