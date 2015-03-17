
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var imp;
	var rand;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = 52;
	imp = Impulse.ar(118);
	env1 = EnvGen.ar( Env([1,2,1],[1.4,0.8]),1,doneAction:0);
	env1 = Ndef.kr(~name+++\lfo1,1);
	freq = freq * [1,2,4]/4 * ( Duty.kr(1/4/~t, 0, Dseq([
		4,10,2,0,
	],inf))+ Duty.kr(8/~t, 0, Dseq([
		Dseq((40..4))
	],inf))/ Duty.kr(1/~t, 0, Dseq([
		Dseq(( 40..5 ))
	],inf)) );
	sig1 = LFNoise1.ar(1/9).range(1,2);
	//freq = freq * TRand.kr(1.01!48,sig1!48,imp).lag(1);
	freq = freq * sig1;
	sig1 = SinOsc.ar(LFNoise1.ar(12).range(400,140)) * LFNoise1.ar(412).range(0,10);
	sig1 = SinOsc.ar(freq) * TRand.kr(0.1,0.4!48,imp).lag(0.1);
	sig = LFSaw.ar(freq * ( 1 + ( sig1 * 1 ))); 
	//sig = sig.collect({ arg isig;
	//	var irand = TRand.kr(0.1,0.8,imp);
	//	//isig.abs > irand * isig
	//	isig.round(irand*0.01);
	//});
	sig = RLPF.ar(sig, 150 * 
		Duty.ar(1/88/~t, 0, Dseq([
			1,4,2,9,
		],inf))
		/
		Duty.kr(1/~t, 0, Dseq([
			1,1,1,1,
			1/8,1,1,1,
			1,1,1,1,
			1,4,2,9,
		],inf))
	,
		Duty.kr(1/2/~t, 0, Dseq([
			0.1,0.3,0.7
		],inf).lag(0.1)) /
		Duty.kr(2/~t, 0, Dseq([
			0.4,1,0.8,1.1,
		],inf)) 
	);
	sig2 = TRand.kr(0.1,0.8,imp);
	sig2 = 0.91 * SinOsc.kr(1/9).range(0.1,1);
	sig1 = HPF.ar(sig, 400 * SinOsc.kr(1/19).range(0.5,1));
	sig = sig.abs < sig2 * sig;
	sig1 = sig1.tanh;
	sig = sig + sig1;
	sig = sig / 2;
	sig = Limiter.ar(sig);
	sig = LeakDC.ar(sig);

	sig = sig * EnvGen.kr(Env([1,2,1]/2,[0.1,0.8]), Impulse.kr(1/2*~t));
	sig = sig / 1;
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});
