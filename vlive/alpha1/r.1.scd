
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = \freq.kr(201);
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var trig;

	trig = Impulse.kr(1 * ~t);
	trig = TDuty.kr(1/2/~t, 0, Dseq([
		1,0,0,0,
		1,1,0,0,
	],inf));

	env1 = EnvGen.kr(Env([0,0,12],[0,2]), trig)+0.2;
	env2 = EnvGen.kr(Env([1,1,0],[0,2]), trig)+0.2;

	sig = SinOsc.ar(freq * [1/2,1,2.0001] * ( 1 + ( SinOsc.ar(10 * LFNoise1.kr(1/22).range(0.0,10.0)) * env1 )));
	sig1 = LFSaw.ar(freq * ( 1 + ( SinOsc.ar(100) * 1 )));
	sig1 = RLPF.ar(sig1, SinOsc.ar(4).range(100,400) * env1);
	sig = sig + sig1;
	sig = sig.fold( env2 ) + (sig/2);
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
