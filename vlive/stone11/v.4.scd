
~toggle_fx.(~namex, ~albert+++\fx, \filter -> { arg in;
	var sig;
	sig = in;
	sig = sig * Duty.kr(1/4/~t, 0, Dseq([
		1,1,0,0,
	],inf));
	sig;

});
