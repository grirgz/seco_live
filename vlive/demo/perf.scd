
(
SynthDef(\milsin, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(( \freqfac.kr(1) * exprand(50!200,15000) ).clip(20,20000)).mean * 5 * 4;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Ppar([
			Pbind(
				\instrument, \default,
				\note, Pseq([
					0,2,3,4,
				],inf),
				\dur, 1/4,
				\amp, 0.1,
			),
			// with new computer, no unlimit, no lowlatency kernel
			// 13: no xrun
			// 14: first xrun
			// 15: 1 xrun/s
			// with new computer, with unlimit, lowlatency
			// same :(
			// with old computer, with unlimit, lowlatency
			// 6: no xrun
			// 7: unusable, 20 Xrun/s
			5.collect({ arg idx;
				Pbind(
					\instrument, \milsin,
					\freqfac, 1+(idx/4),
					\dur, 1,
					\amp, 0.1/8,
					\out, BusDef(\sendbus3),
				);
				
			})
		].flat),
	])
)).play;
)
