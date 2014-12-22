
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1;
	
	env1 = EnvGen.kr(Env([1,0.02,4],[1.0,1.8]), 1);
	sig1 = SinOsc.ar(100 * env1 * [1,1.23,1.24896,1.12547]);
	sig = SinOsc.ar(50, sig1);
	sig = sig * LFNoise1.kr(1/2).range(0.0,1.0);
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
