Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([150],inf) + Pwhite(0.0,700),
	\dur, (4 + Pwhite(0.0,4)),
	\isRest, \false,
	\sustain, 0.1,
	//\legato, 1,
));

(
Ndef(~name+++\fx, {
	var sig, sig2;
	sig = InFeedback.ar(BusDef(~name+++\fx), 2);
	sig2 = sig;
	//sig = CombL.ar(sig, 1,0.1,4)+sig;
	4.do {
		sig = CombL.ar(sig, 1,[0.01,0.012]+LFNoise1.kr(1).range(0.1,1.0),LFNoise1.kr(1).range(0.1,8)+[0.1,0.2])+sig;
		sig = sig + FreqShift.ar(sig, LFNoise1.kr(1).range(-2,2));
		sig = sig;
	};
	sig = sig;
	//sig = sig2;
	sig.postln;
	sig;
});
);
