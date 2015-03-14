
Veco(~namex).debug("namex");
~toggle_fx.(~namex, ~rabbit+++\fx, \filter -> { arg in;
	var sig;
	var spread;
	var delbase = \delbase.kr(0.1);
	var decay = \deldecay.kr(2);
	var lpfreq = \lpfreq.kr(580);
	sig = in;
	spread = ((0..2)/2 - 0.5 * \fspread.kr(0.2) + 1);
	12.do { arg fac;
		sig = sig + AllpassL.ar(sig, 0.5, delbase + (Rand(0.00001,0.33)), decay);
		sig = FreqShift.ar(sig, LFNoise1.kr(42).range(-1.0,1.0) * 0.1);
	};
	sig = LPF.ar(sig, lpfreq, 0.3);
	sig = LeakDC.ar(sig);
	sig = sig / 1;
	sig = sig + in;
	sig = CompanderD.ar(sig, -3.dbamp, 1,0.3);
	sig;

});

// END

~set_macro.(\k1, Ndef(~rabbit+++\fx), \delbase, ControlSpec(0.0001,0.5,\exp,0,1));
~set_macro.(\k2, Ndef(~rabbit+++\fx), \fspread, ControlSpec(0.001,1,\exp,0,1));
~set_macro.(\k3, Ndef(~rabbit+++\fx), \deldecay, ControlSpec(0.00001,8,\exp,0,1));
~set_macro.(\k4, Ndef(~rabbit+++\fx), \ringfreq, \freq);
~set_macro.(\k5, Ndef(~rabbit+++\fx), \lpfreq, \freq);

~set_macro.(\k3, Ndef(~rabbit+++\fx), \deldecay, ControlSpec(0,8,\lin,0,1));
