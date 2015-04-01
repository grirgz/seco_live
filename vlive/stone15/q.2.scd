
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = 60 *8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var trig1;
	var trig2;
	var seq1;

	trig1 = Impulse.kr(1/4*~t);
	trig2 = TDuty.kr(1/4/~t, 0, Dseq([
		0,0,1,0,
	],inf));
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), trig1);
	env2 = EnvGen.kr(Env([0,1,0],[0.01,1.8]), trig1);
	seq1 = Duty.kr(1/8/~t, 0, Dseq([
		4,8,8,16,
		8,8,8,8,
	],inf));
	sig = SinOsc.ar(freq * SinOsc.kr(seq1*~t * env1).range(1,2 * SinOsc.kr(1/8*~t).range(1,1.1))); 
	sig1 = SinOsc.ar(freq * 2* SinOsc.kr(4*~t * env1).range(1,2));
	sig = SelectX.ar(env2, [sig, sig1 * sig]);

	sig = DelayL.ar(sig, 0.1, (1..8)/80 * env2) + sig;
	sig = FreqShift.ar(sig, 100) * ( 1-env2 ) + sig;
	sig = sig / 2;
	sig = RLPF.ar(sig, SinOsc.kr(8*~t).range(80,8001));
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
