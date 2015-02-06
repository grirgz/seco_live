
~toggle_fx.(~namex, ~albert+++\fx, \filter -> { arg in;
	var sig;
	sig = in;
	sig = sig * Duty.kr(1/16/~t, 0, Dseq([
		Dseq( ~euclide.(32,32-6).collect(_.not),1),
	],inf));
	sig;

});

// END

~euclide.(32,32-6).collect(_.not)
