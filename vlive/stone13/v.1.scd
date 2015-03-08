
Ndef(~stylo+++\lpfreq, { 
	var sig;
	sig = SinOsc.kr(2) + 1 * 200;
	sig = 200 * 2 * Duty.kr(1/4/~t, 0, Dseq([
		1,12,0,24,
	],inf)).midiratio;
	sig = sig.lag( Duty.kr(1/~t, 0, Dseq([
		0,0.3,0,0,
		0.1,0.3,0,0,
		0.1,0.3,0,0.2,
	],inf)) );
	//sig = 10000;
	sig;
	
});
Ndef(~stylo+++\fx).map(\lpfreq, Ndef(~stylo+++\lpfreq));
