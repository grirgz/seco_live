
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = 40.midicps;
	var fspread;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr(freq) * SinOsc.kr(1/8).range(0,5) ))); 
	fspread = 780.001 * SinOsc.kr(1/42).range(0,2) * SinOsc.kr(
		Duty.kr(1/~t, 0, Dseq([
			4,1,8,2,
		],inf))
		*~t).range(1,1.1);
	sig = FreqShift.ar(sig, ((0..7)/7 - 0.5 * fspread + 1));
	sig = sig * SinOsc.kr(1/4 * (1..8)/8).range(0,1);
	sig = sig * (1 + 
		RLPF.ar(
			(
			LFSaw.ar(8 * SinOsc.kr( (1..8)/8 / 41 ).range(1,41)) 
			* SinOsc.kr(1/8 * (1..8)/8).exprange(0.01,1)* SinOsc.kr(2*~t).range(1.1,1);
			),
			LFNoise1.kr(1/2).range(10.0,9000.0) * SinOsc.kr(4*~t).range(1.1,1)
		)
	);
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
