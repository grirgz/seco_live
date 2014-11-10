(
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var dlag = \dlag.kr(0.4);
	
	//in = InFeedback.ar(BusDef(~name+++\fx), 2);
	sig = in;
	//sig = CombL.ar(sig, 4/~t, 1/8/~t,1/~t) + sig;
	sig1 = DelayL.ar(sig, 4/~t, \delay1.kr(1/8).lag(dlag)/~t);
	sig1 = HPF.ar(sig1, 300);
	//sig1 = Disintegrator.ar(sig1, 0.5,-1.0);
	sig1 = FreqShift.ar(sig1, 100);

	sig3 = DelayL.ar(sig1, 4/~t, \delay3.kr(1/8).lag(dlag)/~t);
	sig3 = HPF.ar(sig3, 300);
	//sig1 = Disintegrator.ar(sig1, 0.5,-1.0);
	sig3 = FreqShift.ar(sig3, -100);

	sig2 = DelayL.ar(sig, 4/~t, \delay2.kr(3/8).lag(dlag)/~t);
	sig2 = LPF.ar(sig2, 4100);
	sig2 = Disintegrator.ar(sig2, 0.5,-1.0);
	sig = sig1 + sig2 + sig3;
	sig = SelectX.ar(\mix.kr(0).lag(0.05), [in, sig]);

	sig;
});
);

(
Ndef(~name+++\fx).put(60, \pset -> Pbind(
	\delayfac, Pseq([1,1/2,1/4,1/8,0],inf).stutter(1),
	\dlag, Pseq([
		0.1,0.1,0.1,0.1,
		0.1,0.1,0.1,0.1,
		0.1,0.1,0.1,0.1,
		0.01,0.5,1,0,
	],inf),
	\delay1, Pseq([1,1],inf) * Pkey(\delayfac),
	\delay2, Pseq([2,5],inf) * Pkey(\delayfac),
	\delay3, Pseq([4,2],inf) * Pkey(\delayfac),
	\mix, Pseq([0,0.2,0.5,0.8],inf).stutter(2),
	\dur, 1/2,
));
)
