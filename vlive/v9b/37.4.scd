Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([150],inf) + Pwhite(0.0,700),
	\dur, (4 + Pwhite(0.0,4))/2,
	\isRest, \false,
	\sustain, 0.1,
	//\legato, 1,
));

(
Ndef(~name+++\fx, {
	var sig, sig2;
	var spread = 0.8, pan=0, amp=1;
	sig = InFeedback.ar(BusDef(~name+++\fx), 2);
	sig = CombL.ar(sig, 1,0.2,4)+sig;
	sig2 = sig;
	sig = 4.collect { arg i;
		//sig = CombL.ar(sig, 1,[0.01,0.012]+LFNoise1.kr(1).range(0.1,1.0),LFNoise1.kr(1).range(0.1,8)+[0.1,0.2])+sig;
		FreqShift.ar(sig, LFNoise1.kr(0.10 + i)*1000);
	};
	sig = sig.add(sig2);
	sig = sig;
	sig = Splay.ar(sig, spread, amp, pan);
	//sig = sig2;
	sig.postln;
	sig;
});
);
