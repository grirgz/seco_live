
(
Ndef(~megandef1+++\fx).put(10, \filter -> { arg in;
	var sig = in;


	sig = DelayL.ar(sig, 0.01,[0,0.01]);
	
	sig;
});
);
