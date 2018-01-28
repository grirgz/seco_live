
~t = 128/4/60; TempoClock.default.tempo = ~t; // regal


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 51], [0.035, 1.48], curve: \exp) ],
			\bodyenv, [ Env.linen(0.001,0.3,0.1) ],
			\clickrel, 0.01,
			\distpreamp, 2,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
Pdef(\bass, Pbind(
	\instrument, \basicbass,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1,
)).play;
);

ProtoDef(\piano).keyboard
ProtoDef(\piano).startControl(Pdef(\bass))
WindowDef(\PdefEditor).front(Pdef(\bass))


(
MIDIdef.cc(\track1, { arg ... args;
	args.postln;
	
}).learn;
)

Param(Pdef(\bass), \bla)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		);
	])
)).play;
)
