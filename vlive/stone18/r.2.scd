
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = 70.midicps;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	
	sig1 = Duty.kr(1/~t, 0, Dseq([
		0,0,0,
		1,1,1,1,
		0,
	],inf));
	sig3 = EnvGen.kr(Env([0.0001,2,1],[0.1,2.8]), sig1);
	sig2 = LagUD.kr(sig1 ,0.5,0);

	sig = SinOsc.ar(freq); 
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(444 * sig3 * (1..8)/8) * 100 * sig3))) ;
	sig = sig * sig2;

	//sig = DelayL.ar(sig, 0.1,0.1);
	sig = BRF.ar(sig, 7000 * SinOsc.kr(1/2).range(1,1/2));
	sig = LPF.ar(sig, 13000);

	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
