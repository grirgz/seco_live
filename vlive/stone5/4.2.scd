
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	freq = 100;
	
	sig = SinOsc.ar(freq * (1 + SinOsc.kr(
		Duty.kr(1/~t, 0, Dseq([
			100,200,
		],inf))
		* (1+SinOsc.kr(4))*
		
			Duty.kr(1/4/~t, 0, Dseq([
				1,5,0,10,
			],inf))
	)));
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});
