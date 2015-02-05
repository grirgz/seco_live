
~toggle_fx.(~namex, ~albert+++\fx, \filter -> { arg in;
	var sig;
	sig = in;
	sig = sig * Duty.kr(1/16/~t, 0, Dseq([
		Dseq( ~euclide.(32,12).collect(_.not.not),1),
	],inf));
	sig;

});
