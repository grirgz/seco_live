
Ndef(~stylo+++\freq, { 
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.kr(2) + 1 * 200;
	sig = 200 * Duty.kr(1/4/~t, 0, Dseq([
		1,12,0,0,
		24,12,0,0,
		6,12+6,0,2,
		24,1,0,12+3,
	],inf)).midiratio;
	sig1 = Latch.kr(sig, Impulse.kr(1*~t));
	sig = SelectX.kr( Duty.kr(1/2/~t, 0, Dseq([
		0,0,1,0,
		1,0,0,0,
	],inf)), [sig, sig1]);
	sig = sig.lag( Duty.kr(1/~t, 0, Dseq([
		0.1,0.3,0,0,
		0.1,0.3,0,0.2,
		0.1,0.3,0,0,
	],inf)) );
	sig;
	
});
