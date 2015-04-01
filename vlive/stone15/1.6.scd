
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = 60;
	var trig = Impulse.kr(1/4 * ~t);
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = LFSaw.ar(freq);

	sig = RLPF.ar(sig, 60 * EnvGen.kr(Env([1,1.2,1],[0.001,0.8]), trig); , 0.01);
	env1 = EnvGen.kr(Env([1,2,1],[0.01,0.8]), TDuty.kr(1/4/~t, 0, Dseq([
		1,0,0,1, 0,0,1,0,
		1,0,1,0, 0,0,1,0,
	],inf)));
	sig = sig * env1;
	sig = sig.tanh;
	sig = RLPF.ar(sig, 60*1 * [16,1,2,4,8] / env1);
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, \pan.kr(0));
	sig;
})
