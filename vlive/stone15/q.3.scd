
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = 60 *16 * 1;
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
	seq1 = Duty.kr(1/~t, 0, Dseq([
		4,4,3,4,
		8,8,12,8,
	],inf));
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr( 8 * 1 ) * (1..8)/8)));
	sig1 = LFCub.ar(freq* ( 1 + ( SinOsc.kr( 8 * 1 ) * (1..8)/8)));
	sig = SelectX.ar( SinOsc.kr(1/2*~t).range(0,1), [sig, sig1]);
	//sig = sig * SinOsc.ar(seq1*~t).range(1,488);
	sig = sig.tanh;
	sig = sig * 1;
	sig = RLPF.ar(sig, SinOsc.kr(seq1*~t * [1,2]).range(180,14001));
	sig = sig * Duty.kr(1/4/~t, 0, Dseq([
		1,1,1,1, 1,1,1,0,
	],inf));
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
