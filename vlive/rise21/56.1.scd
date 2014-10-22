
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	
	sig = Greyhole.ar(sig, 
		\delay.kr(1/4),\damp.kr(0.1),\size.kr(1), \diff.kr(0.707) , \feedback.kr(0.8), \modDepth.kr(0.1), \modFreq.kr(2)
	);

	sig;
});
