
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = 40.midicps;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * (1..8)/8;
	sig1 = Duty.kr(1/4/~t, 0, Dseq([
		1,1,1,1,
		1,1,0,0,
		0,8,1,1,
		0,0,0,8,

		1,1,1,1,
		1,0,2,0,
		1,1,1,0,
		8,8,8,8,

		1,1,0,1,
		1,1,0,0,
		0,8,1,1,
		8,8,0,8,

		1,1,1,1,
		1,8,1,1,
		4,1,1,4,
		8,8,8,8,

	],inf))*~t * 4;
	sig1 = 4-Sweep.ar(Impulse.kr(sig1*~t), 8) + 1;
	//freq = freq * LFSaw.kr(sig1).range(2,1);
	freq = freq * sig1;
	sig = LFSaw.ar(freq); 
	sig2 = Duty.kr(1/~t, 0, Dseq([
		1,1,1,1,
		1,1,1,1,
		1,1,1,1,
		1,1,1,1,

		1,1,1,1,
		1,1,1,1,
		1,1,1/2,1/2,
		1,1,1,1,
	],inf));
	sig = CombL.ar(sig, 0.1, 1/( 40.midicps * sig2  * LFPulse.kr(4).range(1,2) ), Duty.kr(1/4/~t, 0, Dseq([
		0,0,0,0,
		1,4,0,1,
	],inf))) + sig;
	sig = LPF.ar(sig, 1000 * Duty.kr(1/4/~t, 0, Dseq([
		1,1,1,1,
		1,1,1,1,
		1,1,1,1,
		1,2,4,2,
		
		2,2,2,2,
		2,2,2,2,
		2,2,2,2,
		2,4,4,2,
	],inf)));
	sig = sig * Duty.kr(1/8/~t, 0, Dseq([
		2,2,2,2,
		1,1,2,2,
		2,1,2,2,
		1,1,2,2,

		2,2,2,2,
		1,0,2,2,
		2,1,0,0,
		1,1,2,2,
	],inf))/2;
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
