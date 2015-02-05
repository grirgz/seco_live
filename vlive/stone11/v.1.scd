
~toggle_fx.(~namex, ~albert+++\fx, \filter -> { arg in;
	var sig;
	sig = in;
	sig = sig * SinOsc.ar(Ndef(~albert+++\freq) * 2 * SinOsc.kr( Duty.kr(1/~t, 0, Dseq([
		2,8,4,3,
	],inf))).range(0.1,2));
	sig;

});
