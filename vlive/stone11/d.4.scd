(

Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	
	var freq = Ndef.ar(~name+++\freq, 16);
	freq = 150 * [1,1.2,1.3,1.5] *.t [0,4,7].midiratio;
	freq = freq.flatten;
	freq = freq * (1 + SinOsc.ar(freq) * Ndef.ar(~name+++\lfo1));
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar( SinOsc.kr(1/8).range(0,2), [sig1, sig2, sig3]);
	//sig = RLPF.ar(sig, 700,0.1);
	//sig = sig + FreqShift.ar(sig, (1..16) *10 * SinOsc.kr((1..16)/16).range(-4,1));

	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
);

// END

Ndef(~name+++\freq).clear
Ndef(~name+++\freq).fadeTime = 1;
Ndef(~name+++\freq).quant = 1;
Ndef(~name+++\lfo1).quant = 1;
Ndef(~name+++\lfo1).fadeTime = 1;
