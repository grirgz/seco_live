
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var ffreq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	freq = 80 * [1,1.00002,2,1/2];
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		13,0,0,0,
	],inf)).midiratio.lag( Duty.kr(1/2/~t, 0, Dseq([
		1,1,0,0, 1,1,0,0,
		0,1,1/2,0, 1,1,1,0,
	],inf)) );

	sig = SinOsc.ar(freq);
	sig = (sig* (1..8) * SinOsc.kr((1..8)/15).range(1,4)).tanh/2;
	sig = sig + DelayC.ar(sig, 1/40,1/freq*(1..8) * SinOsc.kr(1/4).range(1.1,1));
	sig = RLPF.ar(sig, ( freq * (1..8) * SinOsc.kr(1/12 * (1..8)/8).range(10,1) ).clip(50,18000));
	//sig = RLPF.ar(sig, freq*1.1);
	//sig = RLPF.ar(sig, freq*1.01);
	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size * 0.4, amp).mean;
	sig;
})
