
~toggle_fx.(~namex, ~john+++\fx, \filter -> { arg in;
	var sig;
	var lpfreq;
	var rq;
	sig = in;
	lpfreq = SinOsc.kr( Duty.kr(1/~t, 0, Dseq([
		8,2,3,3,
		4,8,2,4,
	],inf)) ).range(70,1701);
	rq = 0.3;
	sig = RLPF.ar(sig, lpfreq, rq);
	sig;

});
