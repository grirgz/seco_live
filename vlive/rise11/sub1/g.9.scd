
(
Ndef(~name+++\fx, {
	var sig;
	var sig1,sig2,sig3,sig4,sig5;
	var control = Ndef.ar(Veco('q').uname+++\mixer);
	var freq, hasfreq;
	sig = WhiteNoise.ar(1);
	#freq, hasfreq = Tartini.kr(control).flop;
	//hasfreq.poll;
	freq.poll;
	freq = SelectX.kr(hasfreq, [freq, freq.lag(1)]);
	sig = LFSaw.ar(freq.lag(0.1)*2);
	sig = RLPF.ar(sig, freq*4*LFPulse.kr(1/2*~t).range(0.5,1), 0.3);
	sig = sig * 0.01;
	sig.postln;
	//sig = control;


	sig;
});
);
