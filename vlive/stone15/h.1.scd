
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = 60 *2* 1;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var trig1;
	var trig2;
	var seq1;
	var gate;

	var phase;
	var bufnum;
	bufnum = BufDef(\scream);
	phase = Phasor.ar(Impulse.kr(1/4*~t), 1,( 0.2 + LFNoise1.kr(1/2).range(0.0,0.01) ) *BufFrames.kr(bufnum) ,BufFrames.kr(bufnum));
	sig = BufRd.ar(2, bufnum, phase);
	sig = sig * 8;
	//sig = BPF.ar(sig, 1000 * (1..8)/2, 0.1);

	gate = TDuty.kr(1/4/~t, 0, Dseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,1/6,0,1/4,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,1/4,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 1/6,0,0,1/4,
	],inf));
	gate = Trig1.kr(gate,gate);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.5)), gate);

	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
