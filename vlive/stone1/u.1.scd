Pdef(~name +++ \pre, Pbind(
	\freq, Pwhite(100,800.0),
	\freq, 100 * Prand(Scale.minor.ratios, inf) * Prand([4,2,3,1],inf).stutter(4),
	\legato, 1,
	\fspread, Pseq([0,0.1],inf),
	\dur, Pwhite(0.3,1/16),
	\isRest, false,
));

Ndef(~name+++\fx).put(10, \filter -> { arg in, amp=0.1;
	var sig = in;

	sig = CombL.ar(sig, 4/~t, SinOsc.kr(1).range(0.8,1.2)*1/8/~t,1/~t) + sig;
	sig = CombL.ar(sig, 4/~t, SinOsc.kr(1/14).range(0.8,1.2)*1/8/~t,4/~t) + sig;
	sig = BPF.ar(sig, 400,0.1) + in;
	
	sig;
})

// END

Scale.minor.ratios
