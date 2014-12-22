
(
Ndef(~megandef1+++\fx).put(10, \filter -> { arg in;
	var sig = in;


	sig = RLPF.ar(sig, \lpf.ar(100),0.3);
	
	sig;
});
);
