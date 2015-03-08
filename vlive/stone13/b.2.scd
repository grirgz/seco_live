
Ndef(~stylo+++\rq, { 
	var sig;
	sig = Duty.kr(2/~t, 0, Dseq([
		0.8,0.1,
	],inf));
	sig = sig.lag( Duty.kr(1/2/~t, 0, Dseq([
		0,0,0.4,0,
		0,0,0,0.4,
	],inf)) );
	//sig = 10000;
	sig;
	
});
Ndef(~stylo+++\fx).map(\rq, Ndef(~stylo+++\rq));
