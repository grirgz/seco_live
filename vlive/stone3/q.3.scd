
// TAGS: ndef, drone, noise, rain, harsh, simple
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var nfreq;
	freq = \freq.kr(100);
	nfreq = \nfreq.kr(200);
	sig = PinkNoise.ar * SinOsc.ar(freq,add:1);
	sig = LFNoise1.ar(freq);
	sig = LFNoise1.ar(nfreq) * LFSaw.ar(freq*[1,2.1,4],add:[0,0.5,1]);
	//sig = HPF.ar(sig, 800);
	sig = sig / 3;
	sig = Limiter.ar(sig);
	
	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)}!sig.size * \panmax.kr(1) + \pan.kr(0), amp).flop;
	sig;
});

// END

~set_macro.(\k1, Ndef(~name+++\fx), \freq, \freq.asSpec);
~set_macro.(\k2, Ndef(~name+++\fx), \nfreq, \freq.asSpec);
~set_macro.(\k3, Ndef(~name+++\fx), \panmax, \unipolar.asSpec);
~set_macro.(\k4, Ndef(~name+++\fx), \pan, \bipolar.asSpec);
