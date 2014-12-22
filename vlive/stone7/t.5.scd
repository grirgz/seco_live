
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	
	sig1 = SinOsc.ar(400 *2* ([0,13]).midiratio *.t [2.001,1,1.001,2]);
	sig = SinOsc.ar(400/2 * [1,1+ SinOsc.kr(1/42).range(0,0.001)], sig1 * SinOsc.kr(1/42).range(0,1));
	sig = sig * LFNoise1.kr(1/2).range(0.0,1.0);
	sig = sig * SinOsc.kr(4*~t).range(0.0,1.0);
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
