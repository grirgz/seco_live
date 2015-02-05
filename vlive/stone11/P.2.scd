
~toggle_fx.(~namex, ~hat+++\mixer, \filter -> { arg in;
	var sig;
	var del = [1,3,5];
	sig = in;
	sig = sig + ( del.collect { arg x; DelayL.ar(sig, x/8, x/8) }.sum * 2/3 );
	sig;

});
