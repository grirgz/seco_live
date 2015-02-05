
~toggle_fx.(~namex, ~hat+++\mixer, \filter -> { arg in;
	var sig;
	sig = in;
	sig = sig * SinOsc.ar(120);
	sig;

});
