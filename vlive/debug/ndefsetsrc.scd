
(
Ndef(\bla).put(0, \mysetsrc -> Pbind(
	\source, Pseq([
		{ SinOsc.ar(100) ! 2 },
		{ LFSaw.ar(100 * [1,1.021,1.01,2]).clump(2) },

	],inf),
	\dur, 10,

)).play
)

(
Ndef(\bla).put(10, \mysetsrc -> Pbind(
	\source, Pseq([
		{ SinOsc.ar(200) ! 2 },
		{ LFSaw.ar(200 * [1,1.021,1.01,2]).clump(2) },

	],inf),
	\dur, 4,

)).play
)
(
	
	Ndef(\bla).put(10, nil);
	Ndef(\bla).put(10, nil);
)

(
Ndef(\bla).put(10, \qsetsrc -> Pbind(
	\source, Pseq([
		{ SinOsc.ar(200) ! 2 },
		{ LFSaw.ar(200) ! 2 },
	],inf),
	\dur, 4,

)).play
)

/////////////////////////////////:

(
// infinite loop bug
Ndef(\bla).put(10, \setsrc -> Pbind(
	\source, Pseq([
		// infinite loop bug
		//\filter -> { arg in; in * SinOsc.ar(200) ! 2 },
	],inf),
	\dur, 4,

)).play
)

/////////////////////////////////:


(
// two pattern running
Ndef(\bla).play;
Ndef(\bla).put(0, \mysetsrc -> Pbind(
	\source, Pseq([
		{ SinOsc.ar(200) ! 2 },
		{ LFSaw.ar(200) ! 2 },
	],inf),
	\dur, 2,

));
CmdPeriod.run;
Ndef(\bla).play;
Ndef(\bla).put(0, \mysetsrc -> Pbind(
	\source, Pseq([
		{ SinOsc.ar(200) ! 2 },
		{ LFSaw.ar(200) ! 2 },
	],inf),
	\dur, 2,

));
)
Ndef(\bla).clear
Ndef(\bla).stop

/////////////////////////////////:


(
{

	// two pattern running
	Ndef(\bla).play;
	Ndef(\bla).put(0, \mysetsrc -> Pbind(
		\source, Pseq([
			{ SinOsc.ar(200) ! 2 },
			{ LFSaw.ar(200) ! 2 },
		],inf),
		\dur, 2,

	));
	5.wait;
	CmdPeriod.run;
	5.wait;
	Ndef(\bla).play;
	Ndef(\bla).put(0, \mysetsrc -> Pbind(
		\source, Pseq([
			{ SinOsc.ar(200) ! 2 },
			{ LFSaw.ar(200) ! 2 },
		],inf),
		\dur, 2,

	));
}.fork
)
Ndef(\bla).clear
Ndef(\bla).stop
