
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lim;
	var oscmix;
	freq = Ndef.ar(~name+++\freq);
	//freq = 500/4 * 4.midiratio;
	freq = freq * [1/2,1,1/4] *.x [0,4,7,15].midiratio;

	oscmix = Ndef.ar(~name+++\oscmix);

	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar( oscmix * 2, [sig1, sig2, sig3]);
	sig1 = RLPF.ar(sig, 500 * SinOsc.kr(1/4 * (1..8)/8).range(1/4,2),0.1);
	sig2 = RHPF.ar(sig, 2500 * SinOsc.kr(1/4 * (1..8)/8).range(1/4,2),0.1);
	sig = SelectX.ar( oscmix.lag(0.1), [sig1, sig2]);
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
