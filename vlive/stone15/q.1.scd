
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = 60 *8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var trig1;

	freq = freq * [0,13].midiratio;

	trig1 = TDuty.kr(1/4/~t, 0, Dseq([
		1,0,1,0, 1,0,0,1,
		1,0,0,1, 0,0,0,1,
	],inf));
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.28]), trig1); 

	//sig = SinOsc.ar(freq!2 * (1 + (SinOsc.ar(100)* env1 ))); 
	sig = LFSaw.ar(freq * ( 1 + ( SinOsc.ar(freq * (1..8)/2*3) * env1 ))) ;
	sig1 = sig.abs < Duty.kr(1/16/~t, 0, Dseq([
		2.8,0.8,0.8,0.8,
		0.8,0.8,0.8,0.8,
		0.8,0.8,0.8,0.8,
		0.8,0.8,0.8,0.8,

		0.8,0.8,0.8,0.8,
		0.8,0.8,0.8,0.8,
		0.8,0.8,0.8,0.8,
		0.8,0.8,0.8,0.8,
	],inf)).lag(0.1) * sig;
	//sig = sig * sig1;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,4.1)), Trig1.kr(trig1, 0.1), doneAction:0);
	sig = CombL.ar(sig, 4/~t, 1/freq/2 * LFNoise1.kr(1).range(1.1,1.0),0.1/~t) + sig;
	sig = sig.tanh;
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
