
(
	Ndef(~name+++\fx).put(0, { arg in, pan=0, amp=0.2;
		var sig;
		var sig1, sig2;
		var freq;
		var tfreq;

		sig= Impulse.ar(1);
		sig = Decay.ar(sig,0.1);
		//sig= Ringz.ar(sig, TRand.kr([130,120,600], [5000,5000,5000], sig), LFNoise1.kr(1.1!3).range(0.1,0.5));
		sig= Ringz.ar(sig, [100,110,120,96]*1.12, LFNoise1.kr(1.1!3).range(0.3,0.5)/2);
		//sig= Ringz.ar(sig, [100,110,120]/2, LFNoise1.kr(1.1!3).range(0.3,0.5)/70);
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.4,0.1,0.8,0.1)), sig, doneAction:0);
		sig = sig / 3;

		Splay.ar(sig, \spread.kr(1), amp, pan);

	});
);

// END



Ndef(~name+++\fx).put(1, nil)

(
	Ndef(~name+++\fx).put(1, \set -> Pbind(
		\freq, Pseq([100,200,300],inf),
		\freq, 180,
		\freqtab, Pseq([
			(2**([ 0, 4, 7 ]/12)) *.t [1,1.00001],
			(2**([ -1, 3, 7 ]+6/12)) *.t [1,1.00001],
		],inf),
		\amp, 0.5,
		\dur, 2,

	)

)
);


2**((0..12)/12)
2**(4/12)
1, 4/3
