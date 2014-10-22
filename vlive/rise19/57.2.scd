
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	
	var delay = \delay.kr(1/2)/~t;
	sig = CombL.ar(sig, \maxdelay.kr(1), SinOsc.kr(\fm.kr(1)*~t).unipolar * \range.kr(1) + 1 * delay, \decay.kr(0));

	sig;
});
