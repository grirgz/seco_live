
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = 60;
	var trig = Impulse.kr(1/4 * ~t);
	sig = LFSaw.ar(freq * (1+ ( (1..8)/8 * 0.002 ) + ( LFNoise1.kr(1/2 * (1..8)/8).range(0.0,1.0) ) ));

	sig = RLPF.ar(sig, 60 * EnvGen.kr(Env([1,1.2,1],[0.001,0.8]), trig); , 0.01);
	sig = (sig * LFNoise1.kr(1/2).range(4.8,5.0)).tanh;
	sig = sig * 3;
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, \pan.kr(0));
	sig;
})
