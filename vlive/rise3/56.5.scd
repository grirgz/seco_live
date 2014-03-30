
(
Ndef(~name+++\fx).put(10, \filter -> { arg in, freqshift=0;
	var sig;
	in.debug("FUICL");
	sig = in;
	sig = FreqShift.ar(sig, freqshift);
	sig;
});
Ndef(~name+++\fx).put(20, \filter -> {  arg in, ffreq=500, rq=0.5;
	var sig;
	sig = in;
	sig = RLPF.ar(sig, ffreq, rq);
	sig;
});
)
