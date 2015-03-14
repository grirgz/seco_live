
Veco(~namex).debug("namex");
~toggle_fx.(~namex, ~rabbit+++\fx, \filter -> { arg in;
	var sig;
	var spread;
	var delbase = \delbase.kr(0.1);
	var decay = \deldecay.kr(2);
	var lpfreq = \lpfreq.kr(580);
	var lp, ap1, ap2, ap3, revout, fb=\fb.kr(0.1);
	var chan = 2;
	sig = in;


	// reverb predelay time :
z = DelayN.ar(sig, 0.068);
// 7 length modulated comb delays in parallel :
y = Mix.ar(CombL.ar(z, 0.1, LFNoise1.kr(Array.fill(5,{0.01.rand}), 0.04, 0.05), 4));
// chain of 4 allpass delays on each of two channels (8 total) :
4.do({ y = AllpassN.ar(y, 0.050, [0.050.rand,0.050.rand], 1/4) });

sig = sig + (y / 4);

sig = sig / 3;
	//sig = sig + in;
	sig = LeakDC.ar(sig);
	sig.debug("sig");



	sig;

});

// END

~set_macro.(\k1, Ndef(~rabbit+++\fx), \delbase, ControlSpec(0.0001,0.5,\exp,0,1));
~set_macro.(\k2, Ndef(~rabbit+++\fx), \fspread, ControlSpec(0.001,1,\exp,0,1));
~set_macro.(\k3, Ndef(~rabbit+++\fx), \deldecay, ControlSpec(0.00001,8,\exp,0,1));
~set_macro.(\k4, Ndef(~rabbit+++\fx), \ringfreq, \freq);
~set_macro.(\k5, Ndef(~rabbit+++\fx), \lpfreq, \freq);
~set_macro.(\k6, Ndef(~rabbit+++\fx), \fb, ControlSpec(0,4,\lin,0,1));

~set_macro.(\k3, Ndef(~rabbit+++\fx), \deldecay, ControlSpec(0,8,\lin,0,1));
