TempoClock.default.tempo = 1;
(
SynthDef(\fx_freeverb2, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = FreeVerb2.ar(sig[0],sig[1], \verbmix.kr(1), \room.kr(0.5), \damp.kr(0.5));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0,1,0.01),gate,doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
~bus1 = ~bus1 ?? { Bus.audio(s,2) }
)


(
Pdef(\player1, { arg freq, amp;

	Ptpar([
		0, Pbind(
			\instrument, \default,
			\freq, freq * Pseq([0,7,2,1],inf).midiratio,
			\dur, 1/4,
			\amp, amp,
			\out, topEnvironment[\bus1], // we are in another Environment
		),
		0, Pmono(\fx_freeverb2,
			\inbus, topEnvironment[\bus1],
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),		
		1, Pbind(
			\instrument, \default,
			\freq, freq*2,
			\dur, 1,
			\amp, amp,
		),
	])
})
);

(
Pdef(\player2, { arg blast=1, note, amp;

	Ppar(
		blast.collect({ arg idx;
			Pbind(
				\instrument, \default,
				\note, Pseq([
					0,5,2,
				],inf) + note,
				\lag, 1/8/4 * idx,
				\dur, 1/8,
				\amp, amp,
			)
		})
	)
})
);


(
Pdef(\main, 
	Pseq([
		Pbind(
			\type, \phrase,
			\instrument, \player1,
			\freq, 400 * Pseq([1,1/2],1),
			\legato, 0.7,
			\dur, 4,
			\amp, 0.1,
		),
		Pbind(
			\type, \phrase,
			\instrument, \player2,
			\note, Pseq([0,6],2), 
			\blast, Pseq([
				1,2,3,4,
			],inf),
			\legato, 1,
			\dur, 1,
			\amp, 0.1,
		),
	],2),
).play;
);
