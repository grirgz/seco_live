
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var ffreq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	freq = 50 * [1,1.00002];
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = LFPulse.ar(freq * ( SinOsc.ar(freq) * 10 + 1 ));
	sig = SelectX.ar( Duty.kr(1/4/~t, 0, Dseq([
		1,0,0,0, 1,0,4,0,
		3,0,0,0, 1,0,4,0,
	],inf))/4*2, [sig1, sig2,sig3]);

	ffreq = 100 * Duty.kr(1/4/~t, 0, Dseq([
		1,1,1,1,
		1,1,1,1,
		1,2,4,4,
		1,1,1,1,
		1,1,1,1,
		4,2,4,4,
		1,1,1,1,
		1,1,1,1,
		4,2,2,2,
		1,1,1,1,
		1,1,1,1,
		2,2,4,2,
	],inf))/1;
	lfo1 = SinOsc.kr(1/7).range(1,1.2);
	sig = RLPF.ar(sig, ffreq * [1,2,3,4,5,6,7,8], 0.1) * ( (10..3)**(lfo1) )/10 * SinOsc.kr((1..8)/8+0.1).range(1/2,1);
	sig = sig / 2;
	sig = sig * Duty.kr(1/4/~t, 0, Dseq([
		1,1,1,1, 0,1,1,1,
		1,0,1,1, 0,1,1,1,
	],inf));
	//sig = RLPF.ar(sig, 400 * Duty.kr(1/~t, 0, Dseq([
	//	1,4,2,1/2,
	//],inf)), 0.1);
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
