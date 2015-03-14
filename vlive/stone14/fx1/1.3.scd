
Veco(~namex).debug("namex");
~toggle_fx.(~namex, ~rabbit+++\fx, \filter -> { arg in;
	var sig;
	var spread;
	var delbase = \delbase.kr(0.1);
	var decay = \deldecay.kr(2);
	sig = in;
	spread = ((0..2)/2 - 0.5 * \fspread.kr(0.2) + 1);
	spread.do { arg fac;
		sig = sig + CombL.ar(sig, 0.5,delbase * fac/~t,decay);
	};
	sig = LeakDC.ar(sig);
	sig = sig / 6;
	sig;

});

// END

~set_macro.(\k1, Ndef(~rabbit+++\fx), \delbase, ControlSpec(0.0001,0.5,\exp,0,1));
~set_macro.(\k2, Ndef(~rabbit+++\fx), \fspread, ControlSpec(0.001,1,\exp,0,1));
~set_macro.(\k3, Ndef(~rabbit+++\fx), \deldecay, ControlSpec(0,8,\lin,0,1));
~set_macro.(\k4, Ndef(~rabbit+++\fx), \ringfreq, \freq);
