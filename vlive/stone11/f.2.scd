
Ndef(~roger+++\fx).put(1, \filter -> { arg in;
	var sig = in;
	sig = RLPF.ar(sig, Duty.kr(1/2/~t, 0, Dseq([
		1,3,2,4,
	],inf)) * 200 * SinOsc.kr(1).range(2,1));

});

// END

Ndef(~roger+++\fx).fadeTime=1
