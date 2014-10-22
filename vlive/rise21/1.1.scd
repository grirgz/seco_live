
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;

	sig = DynKlang.ar(Ref([\klangfreq.kr({700.rand+50}!32), \klangamp.kr({ 0.1 }!32), \klangphase.kr({ 0 }!32)]));
	//sig.postln;
	sig = sig / 1;
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});

(
Ndef(~name+++\fx).put(1, \set -> Pbind(
	\klangfreq, Pseq([
		Pfunc({
			[( {900.0.rand+450}!32 )];
		})
	],inf),
	\dur, 1,
));
);
