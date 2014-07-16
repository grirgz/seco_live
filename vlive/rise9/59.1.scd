
~make_fx.();

(
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;

	var input, delayTime, laggedDelayTime, outDelay;
	// input from sound card
	input = sig;
	// delay time jumps every 4 seconds
	//delayTime = Demand.kr(Impulse.kr(1), 0, Dseq([1,1/2,1/4,1/8], inf));
	delayTime = \delay.kr(1/2);
	// lagged delay time - takes 3 seconds to reach new value
	laggedDelayTime = Lag.kr(delayTime, 0.4);
	// CombC - delay with feedback
	sig = CombC.ar(input, 2, laggedDelayTime, 6) + input;
	sig = sig / 1;
	
	sig;
});
);

// END
Ndef(~name+++\fx).quant = 1
(0-[1,2,3,4,5,6,7,8,9].scramble) *.t [1,1]
~set_macro.(\k9, Ndef(~name+++\fx), \fb, \unipolar.asSpec);
