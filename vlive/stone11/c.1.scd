
~toggle_fx.(~namex, ~albert+++\fx, \filter -> { arg in;
	var sig;
	sig = in;
	sig = sig * SinOsc.ar(780);
	sig;

});
