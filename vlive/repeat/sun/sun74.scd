
~t = 164/4/60; TempoClock.default.tempo = ~t;

FileSystemProject.load("sun/fmgen.scd");
(
SynthDef(\harpsichord_pluck, {
	|amp=0.1, freq=440, pan=0, atk=0, rel=0, trig= 1, maxdelaytime= 0.2, decaytime= 7, coef= 0.1|
	var env, sig, delay;
	env = EnvGen.kr(Env.linen(atk, decaytime, rel), doneAction: Done.freeSelf);
	sig = PinkNoise.ar(amp); //Can use white noise here, but Pink is more realistic
	delay = freq.reciprocal;
	sig = Pluck.ar(sig, trig, maxdelaytime , delay , decaytime , coef ) //fundamental
	+ Pluck.ar(sig, trig, maxdelaytime , delay/2 , decaytime , coef ); //octave higher
	Out.ar(0, Pan2.ar(sig , pan));
//Harpsichord based on Pluck Ugen
//By Zé Craum

}).add;
)
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, ~fmgen_short.(73417,5),
			\instrument, ~fmgen_short.(73419,5),
			\instrument, \harpsichord_pluck,
			\note, Pseq([
				4,11,19,
				4,11,19,
				4,11,18,
				4,11,18,
				4,11,18,
				11,
				4,9,14,
				4,9,14,
				4,9,16,
				4,9,16,
				4,9,16,
				9,
				4,11,16,
				4,11,16,
				4,11,16,
				4,11,16,
				4,11,16,
				11,
				4,11,16,
				4,11,16,
				4,11,16,
				4,11,16,
				4,11,16,
				11,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.6) ],
			],inf),
			\dur, 1/8,
			\octave, 6,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\melo, 
	Pbind(
		\instrument, ~fmgen_short.(73418,5),
		\adsr, Pseq([
			[ Env.adsr(0.1,0.1,0.8,0.6) ],
		],inf),
		\amp, 0.1/2,
	)
)
);

ProtoDef(\piano).startControl(Pdef(\melo))

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('vipere/coyote.flac'),
				\speed, 0.8,
				\pos, 0,
				\legato, 1,
				\dur, Pn(1,1),
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('vipere/coyote.flac'),
				\speed, 0.8,
				\pos, 1/~t * Pkey(\speed),
				\legato, 1,
				\dur, Pn(1/16,64),
				\gain, 0.1 * Pseg(Pseq([1,0],1),64/16,-3),
			),
		],1),
		
	])
)).play;
);
