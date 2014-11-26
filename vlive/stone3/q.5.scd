
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var nfreq;
	freq = \freq.kr(100);
	nfreq = \nfreq.kr(200);
	freq = freq * ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1);
	sig = PinkNoise.ar * SinOsc.ar(freq,add:1);
	sig = LFNoise1.ar(freq);
	sig = LFNoise1.ar(nfreq) * LFSaw.ar(freq);
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
~set_macro.(\k5, Ndef(~name+++\fx), \fspread, ControlSpec(0.00001,1,\exp,0,0.00001));
