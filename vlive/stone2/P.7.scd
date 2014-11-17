
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	
	var freq;
	var ffreq;
	freq = 400 * Duty.kr(2/~t, 0, Dseq([
		0,1,3,2,
	],inf)).midiratio * Duty.kr(1/2/~t, 0, Dseq([
		[0,3,7,9],
		[9,-2,3,7],
	],inf)).midiratio.lag(0.1) * 2;
	sig1 = SinOsc.ar(freq * SinOsc.kr(1/7).range(0.99,1) *.t [1,1.24563,1.29456,1.545147]);
	sig2 = LFSaw.ar(freq * 1.0012541);
	sig2 = RLPF.ar(sig2, LFNoise1.kr(1/2).range(100,17000), 0.5);
	sig = SinOsc.ar(70 * SinOsc.kr(1/17).range(1,1.01) * [1.32,1.4523], sig1 * LFNoise1.ar(1/14 * LFNoise1.ar(1/8).exprange(1.0,119)).range(0.5,4));
	sig = sig + sig2;
	sig = SelectX.ar( LFNoise1.kr(1/2).range(0.0,1.0) * (sig.size-1), sig.flop);
	sig.postln;
	sig = sig *(  {LFNoise1.kr(1/2).range(0.0,1.0)}!sig.size );
	ffreq = {LFNoise1.kr(1/22)}!sig.size;
	sig = LPF.ar(sig, ffreq.range(8200,17000) );
	sig = HPF.ar(sig, ffreq.range(182,770));
	sig = sig / 2;
	amp = amp * Duty.kr(4/~t, 0, Dseq([
		0,0, 1,1,
	],inf));
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
