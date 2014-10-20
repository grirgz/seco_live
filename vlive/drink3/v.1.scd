
(
	Ndef(~name+++\fx).put(0, { arg in, pan=0, amp=0.2;
		var sig;
		var sig1, sig2;
		var freq;
		var tfreq;
		var imp;

		sig= Dust.ar(10!3);
		imp = Impulse.kr([1,1.2,1.4]/2);
		sig= Ringz.ar(sig, TExpRand.kr([130,120,600], [5000,5000,5000], imp).lag(0.5), LFNoise1.kr(1.1!3).range(0.1,0.5));
		amp = Veco(~name).amp_level * amp / 2;

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
