
~rabbit.debug("rabbit");
~namex.debug("namex");
Veco(~namex).debug("namex");
~toggle_fx.(~namex, ~rabbit+++\fx, \filter -> { arg in;
	var sig;
	sig = in;
	sig = sig * SinOsc.ar(\ringfreq.kr(780));
	sig;

});
