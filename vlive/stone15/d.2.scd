
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = 60 *2* 1;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var trig1;
	var trig2;
	var seq1;
	var lfo1;


	sig1 = Duty.kr(1/2/~t, 0, Dseq([
		2,2,2,8,
		Dseq([
			2,2,2,8,
		],1)*2,
		Dseq([
			2,4,2,8,
		],1)*2,
	],inf));

	sig = LFSaw.ar(freq * [1,1.0001,1/2]);
	sig = RLPF.ar(sig, SinOsc.ar(sig1*~t).exprange(80,1400) );
	lfo1 = SinOsc.ar(sig1*~t);
	sig = (sig*lfo1.exprange(1,100)).tanh;

	sig = DelayL.ar(sig, 0.1, 0.01 * (1..8)/8 * 0.1 * Duty.kr(1/~t, 0, Dseq([
		1,2,0,0,
		1,2,0,8,
	],inf))) + sig;

	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, \pan.kr(0));
	sig;
})
