
~toggle_fx.(~namex, ~john+++\fx, \filter -> { arg in;
	var sig;
	sig = in;
	sig = sig * Duty.kr(1/16/~t, 0, Dseq([
		1,1,0,0, 0,0,0,0,
	],inf));
	sig;

});
